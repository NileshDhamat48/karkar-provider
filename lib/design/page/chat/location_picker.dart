import 'dart:async';
import 'dart:developer';

import 'package:flutter/services.dart';
import 'package:geocoding/geocoding.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:karkar_provider_app/constants/app_asstes.dart';
import 'package:karkar_provider_app/constants/app_strings.dart';
import 'package:karkar_provider_app/design/widget/text_field_widget.dart';
import 'package:karkar_provider_app/l10n/l10n.dart';
import 'package:karkar_provider_app/network/api_manager/api_manager.dart';
import 'package:karkar_provider_app/network/models/user_location.dart';
import 'package:karkar_provider_app/network/response/google_search_response.dart';
import 'package:location/location.dart' as location;
import 'package:permission_handler/permission_handler.dart';

import '../../../constants/all_imports.dart';
import '../../../constants/debouncer.dart';

class LocationPicker extends StatefulWidget {
  const LocationPicker({Key? key}) : super(key: key);

  @override
  _LocationPickerState createState() => _LocationPickerState();
}

class _LocationPickerState extends State<LocationPicker> {
  final Completer<GoogleMapController> _mapController = Completer();
  CameraPosition initialLocation = const CameraPosition(zoom: 18, target: LatLng(37.807438, -122.419924));
  final isLoading = ValueNotifier<bool>(false);
  UserLocation? currentLocation;

  final addressController = TextEditingController();
  final addressFn = FocusNode();
  final searchController = TextEditingController();
  final searchFn = FocusNode();
  final debouncer = Debouncer(milliseconds: 300);
  List<GoogleSearchResults> googleSearch = [];

  @override
  void initState() {
    super.initState();
    addressFn.addListener(() {
      _notify();
    });
    _loadMapStyles();
    getCurrentLocation(zoomToLocation: true);
  }

  Future _loadMapStyles() async {
    final _lightMapStyle = await rootBundle.loadString(AppAssets.darkMapStyle);
    final controller = await _mapController.future;
    controller.setMapStyle(_lightMapStyle);
  }

  getCurrentLocation({required bool zoomToLocation}) {
    try {
      isLoading.value = true;
      Utility.checkPermission(
        onSucess: () async {
          if (await location.Location().serviceEnabled()) {
            final locationData = await location.Location().getLocation();
            if (locationData.latitude != null && locationData.longitude != null) {
              await setAddress(latitude: locationData.latitude ?? 0, longitude: locationData.longitude ?? 0);
              isLoading.value = false;
              final controller = await _mapController.future;
              controller.animateCamera(
                CameraUpdate.newLatLng(
                  LatLng(
                    locationData.latitude ?? 0,
                    locationData.longitude ?? 0,
                  ),
                ),
              );
            }
          } else {
            location.Location().requestService().then(
              (value) async {
                if (value) {
                  Future.delayed(const Duration(seconds: 1)).then(
                    (value) async {
                      final locationData = await location.Location().getLocation();
                      if (locationData.latitude != null && locationData.longitude != null) {
                        await setAddress(latitude: locationData.latitude ?? 0, longitude: locationData.longitude ?? 0);
                        final controller = await _mapController.future;
                        controller.animateCamera(
                          CameraUpdate.newLatLng(
                            LatLng(
                              locationData.latitude ?? 0,
                              locationData.longitude ?? 0,
                            ),
                          ),
                        );
                        isLoading.value = false;
                      }
                    },
                  );
                }
              },
            );
          }
        },
        permission: Permission.location,
      );
      // isLoading.value = false;
    } catch (e) {
      isLoading.value = false;
      log(e.toString());
    }
  }

  Future<void> setAddress({required double latitude, required double longitude}) async {
    List<Placemark> placemarks = await placemarkFromCoordinates(latitude, longitude);
    List<String> addressList = [];
    if (placemarks.isNotEmpty) {
      if (placemarks.first.name != null) {
        addressList.add(placemarks.first.name!);
      }
      if (placemarks.first.subLocality != null) {
        addressList.add(placemarks.first.subLocality!);
      }
      if (placemarks.first.locality != null) {
        addressList.add(placemarks.first.locality!);
      }
      if (placemarks.first.administrativeArea != null) {
        addressList.add(placemarks.first.administrativeArea!);
      }
      if (placemarks.first.postalCode != null) {
        addressList.add(placemarks.first.postalCode!);
      }
      if (placemarks.first.country != null) {
        addressList.add(placemarks.first.country!);
      }
      currentLocation = UserLocation(
        address: addressList.join(', '),
        lat: latitude,
        lng: longitude,
      );
      _notify();
    }
  }

  Future<String> getAddress({required double latitude, required double longitude}) async {
    try {
      List<Placemark> placemarks = await placemarkFromCoordinates(latitude, longitude);
      List<String> addressList = [];
      if (placemarks.isNotEmpty) {
        if (placemarks.first.name != null) {
          addressList.add(placemarks.first.name!);
        }
        if (placemarks.first.subLocality != null) {
          addressList.add(placemarks.first.subLocality!);
        }
        if (placemarks.first.locality != null) {
          addressList.add(placemarks.first.locality!);
        }
        if (placemarks.first.administrativeArea != null) {
          addressList.add(placemarks.first.administrativeArea!);
        }
        if (placemarks.first.postalCode != null) {
          addressList.add(placemarks.first.postalCode!);
        }
        if (placemarks.first.country != null) {
          addressList.add(placemarks.first.country!);
        }
      }
      return addressList.join(', ');
    } catch (e) {
      log(e.toString());
      return 'Unnamed';
    }
  }

  searchLocation() async {
    try {
      if (await ApiManager.checkInternet()) {
        googleSearch.clear();
        isLoading.value = true;
        var request = <String, dynamic>{};

        GoogleSearchResponse googleSearchResponse = GoogleSearchResponse.fromJson(
          await ApiManager(context).postCall(
            AppStrings.googleSearch(searchController.text.trim()),
            request,
          ),
        );

        if (googleSearchResponse.status == 'OK' &&
            googleSearchResponse.results != null &&
            googleSearchResponse.results!.isNotEmpty) {
          googleSearch.addAll(googleSearchResponse.results!);
          _notify();
        }
        isLoading.value = false;
      } else {
        Utility.showToast(msg: AppLocalizations.of(context).noInternet);
      }
    } catch (e) {
      log(e.toString());
      isLoading.value = false;
    }
  }

  _notify() {
    if (mounted) setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final keyboardHidden = MediaQuery.of(context).viewInsets.bottom == 0;
    return Scaffold(
      resizeToAvoidBottomInset: addressFn.hasFocus,
      appBar: AppBar(
        backgroundColor: AppColors.userbgcolor,
        leading: BackArrowWidget(
          onTap: () {
            if (Navigator.canPop(context)) {
              Navigator.pop(context);
            }
          },
        ),
        title: const Text(
          'Location',
        ),
      ),
      body: Stack(
        children: [
          Column(
            children: [
              Flexible(
                child: Stack(
                  children: [
                    GestureDetector(
                      onTap: () {
                        FocusManager.instance.primaryFocus?.unfocus();
                      },
                      child: AbsorbPointer(
                        absorbing: !keyboardHidden,
                        child: Stack(
                          alignment: Alignment.center,
                          children: [
                            GoogleMap(
                              zoomControlsEnabled: false,
                              mapType: MapType.normal,
                              myLocationEnabled: true,
                              initialCameraPosition: initialLocation,
                              onMapCreated: (GoogleMapController controller) {
                                try {
                                  _mapController.complete(controller);
                                } catch (e) {
                                  log(e.toString());
                                }
                              },
                              myLocationButtonEnabled: false,
                              markers: const <Marker>{},
                              onCameraMove: (CameraPosition position) {
                                try {
                                  debouncer.run(() async {
                                    isLoading.value = true;
                                    final address = await getAddress(
                                      latitude: position.target.latitude,
                                      longitude: position.target.longitude,
                                    );
                                    await setLocation(
                                      UserLocation(
                                        address: address,
                                        lat: position.target.latitude,
                                        lng: position.target.longitude,
                                      ),
                                    );
                                    isLoading.value = false;
                                  });
                                } catch (e) {
                                  log(e.toString());
                                  isLoading.value = false;
                                }
                              },
                            ),
                            const Icon(
                              Icons.location_on,
                              color: AppColors.red,
                              size: 40,
                            )
                          ],
                        ),
                      ),
                    ),
                    Column(
                      children: [
                        const SizedBox(
                          height: 5,
                        ),
                        TextFormField(
                          controller: searchController,
                          onChanged: (value) {
                            debouncer.run(() {
                              if (searchController.text.trim() == '') {
                                googleSearch.clear();
                                _notify();
                                return;
                              }
                              searchLocation();
                            });
                          },
                          style: const TextStyle(
                            color: AppColors.whiteColor,
                          ),
                          decoration: InputDecoration(
                            filled: true,
                            fillColor: AppColors.bodybgcolor,
                            border: InputBorder.none,
                            hintText: 'Search Location',
                            hintStyle: TextStyle(
                              color: AppColors.greyBorder,
                            ),
                            prefixIcon: const Icon(
                              Icons.search,
                              color: AppColors.whiteColor,
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 5,
                        ),
                        if (googleSearch.isNotEmpty)
                          Flexible(
                            child: Container(
                              color: AppColors.glassEffact,
                              constraints: const BoxConstraints(
                                maxHeight: 200,
                              ),
                              child: ListView.separated(
                                shrinkWrap: true,
                                itemCount: googleSearch.length,
                                separatorBuilder: (context, index) => Divider(
                                  color: AppColors.whiteColor.withOpacity(0.3),
                                  height: 0,
                                ),
                                itemBuilder: (context, index) {
                                  return googleAddressItemView(index);
                                },
                              ),
                            ),
                          ),
                      ],
                    ),
                  ],
                ),
              ),
              Container(
                width: MediaQuery.of(context).size.width,
                padding: const EdgeInsets.all(10),
                color: AppColors.bodybgcolor,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TextFieldWidget(
                      padding: EdgeInsets.zero,
                      hintText: 'Address',
                      label: 'Enter Address Detail',
                      controller: addressController,
                      keyboardType: TextInputType.text,
                      focusNode: addressFn,
                      maxLines: 1,
                    ),
                    CommonButton(
                      text: AppLocalizations.of(context).save,
                      onpressed: () {
                        if (currentLocation == null) {
                          Utility.showToast(msg: AppLocalizations.of(context).selectAddress);
                        } else {
                          Navigator.pop(context, currentLocation);
                        }
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
          ValueListenableBuilder<bool>(
            valueListenable: isLoading,
            builder: (context, value, child) {
              if (value) {
                return Utility.progress(context);
              }
              return Container();
            },
          )
        ],
      ),
    );
  }

  googleAddressItemView(int index) {
    return InkWell(
      onTap: () {
        setLocation(
          UserLocation(
            address: googleSearch[index].formattedAddress,
            lat: googleSearch[index].geometry?.location?.lat,
            lng: googleSearch[index].geometry?.location?.lng,
          ),
        );
        searchController.clear();
        googleSearch.clear();
        _notify();
      },
      child: Container(
        margin: const EdgeInsets.all(10),
        child: Row(
          children: [
            const Icon(
              Icons.location_on,
              color: AppColors.whiteColor,
            ),
            Flexible(
              child: Text(
                googleSearch[index].formattedAddress ?? '',
                style: const TextStyle(
                  color: AppColors.whiteColor,
                  fontSize: 14,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  Future<void> setLocation(UserLocation location) async {
    currentLocation = location;
    addressController.text = location.address ?? '';
    _notify();
    final controller = await _mapController.future;
    controller.animateCamera(
      CameraUpdate.newLatLng(
        LatLng(
          location.lat ?? 0,
          location.lng ?? 0,
        ),
      ),
    );
  }
}
