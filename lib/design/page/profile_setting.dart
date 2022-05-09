import 'dart:convert';
import 'dart:io';

import 'package:google_map_location_picker/google_map_location_picker.dart';
import 'package:image_picker/image_picker.dart';
import 'package:karkar_provider_app/constants/all_imports.dart';
import 'package:karkar_provider_app/constants/app_asstes.dart';
import 'package:karkar_provider_app/constants/app_dimens.dart';
import 'package:karkar_provider_app/constants/app_strings.dart';
import 'package:karkar_provider_app/constants/formattor.dart';
import 'package:karkar_provider_app/design/page/around_me.dart';
import 'package:karkar_provider_app/design/widget/dialog.dart';
import 'package:karkar_provider_app/design/widget/text_field_widget.dart';
import 'package:karkar_provider_app/l10n/l10n.dart';
import 'package:karkar_provider_app/network/api_manager/api_manager.dart';
import 'package:karkar_provider_app/network/models/dayofweek.dart';
import 'package:karkar_provider_app/network/models/user_data.dart';
import 'package:karkar_provider_app/network/response/user_response.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfileSetting extends StatefulWidget {
  const ProfileSetting({Key? key}) : super(key: key);

  @override
  _ProfileSettingState createState() => _ProfileSettingState();
}

class _ProfileSettingState extends State<ProfileSetting> {
  TextEditingController providernameController = TextEditingController();
  FocusNode providernameFN = FocusNode();

  TextEditingController phonenumberController = TextEditingController();
  FocusNode phonenumberFN = FocusNode();

  TextEditingController aboutController = TextEditingController();
  TextEditingController openningTimeController = TextEditingController();
  TextEditingController closingTimeController = TextEditingController();
  TextEditingController locationAddressController = TextEditingController();
  FocusNode aboutFN = FocusNode();
  FocusNode openningFN = FocusNode();
  FocusNode closingFN = FocusNode();
  FocusNode locationAddressFN = FocusNode();
  UserResponse? userResponse, prefUserResponse;
  UserData? userData, prefUserData;
  File? pickImageFilePath;
  List<DaysOfWeek> listWeek = [
    DaysOfWeek(
      id: 0,
      days: 'Sunday',
      key: 'Sun',
    ),
    DaysOfWeek(
      id: 1,
      days: 'Monday',
      key: 'Mon',
    ),
    DaysOfWeek(
      id: 2,
      days: 'Tuesday',
      key: 'Tue',
    ),
    DaysOfWeek(
      id: 3,
      days: 'Wednesday',
      key: 'Wed',
    ),
    DaysOfWeek(
      id: 4,
      days: 'Thursay',
      key: 'Thu',
    ),
    DaysOfWeek(
      id: 5,
      days: 'Friday',
      key: 'Fri',
    ),
    DaysOfWeek(
      id: 6,
      days: 'Saturday',
      key: 'Sat',
    ),
  ];

  String apiOpenningTime = '';
  String apiClosingTime = '';

  double? lat, lng;

  bool isLoading = false;
  @override
  void initState() {
    super.initState();
    getPref();
  }

  getPref() async {
    prefUserResponse = await Utility.getUserPref();
    if (prefUserResponse != null && prefUserResponse?.data != null && prefUserResponse?.data?.id != null) {
      prefUserData = prefUserResponse?.data;

      await userDetailAPi(prefUserData?.id.toString() ?? '');
      _notify();
    }
  }

  Future userDetailAPi(String userId) async {
    if (await ApiManager.checkInternet()) {
      _changeLoadingState(true);
      var request = <String, dynamic>{};
      request['user_id'] = userId;
      UserResponse userResponse = UserResponse.fromJson(
        await ApiManager(context).getCall(
          AppStrings.usersDetails,
          request,
        ),
      );

      if (userResponse.status == '1' && userResponse.data != null) {
        userData = userResponse.data;
        providernameController.text = userData?.name ?? '';
        phonenumberController.text = userData?.mobileNumber ?? '';
        aboutController.text = userData?.about ?? '';
        locationAddressController.text = userData?.address ?? '';

        listWeek[0].isDaySelected = userData?.isOpenOnSun ?? false;
        listWeek[1].isDaySelected = userData?.isOpenOnMon ?? false;
        listWeek[2].isDaySelected = userData?.isOpenOnTue ?? false;
        listWeek[3].isDaySelected = userData?.isOpenOnWeb ?? false;
        listWeek[4].isDaySelected = userData?.isOpenOnThu ?? false;
        listWeek[5].isDaySelected = userData?.isOpenOnFri ?? false;
        listWeek[6].isDaySelected = userData?.isOpenOnSat ?? false;

        listWeek[0].days = AppLocalizations.of(context).sunday;
        listWeek[1].days = AppLocalizations.of(context).monday;
        listWeek[2].days = AppLocalizations.of(context).tuesday;
        listWeek[3].days = AppLocalizations.of(context).wednesday;
        listWeek[4].days = AppLocalizations.of(context).thursay;
        listWeek[5].days = AppLocalizations.of(context).friday;
        listWeek[6].days = AppLocalizations.of(context).saturday;

        if (userData?.latitude != null) {
          lat = double.parse(userData?.latitude ?? "");
          print(lat);
        }
        if (userData?.longitude != null) {
          lng = double.parse(userData?.longitude ?? "");
          print(lng);
        }

        if (userData?.openingTime != null && userData?.openingTime != '') {
          var x = Formatter().formatTimeG(time: userData?.openingTime ?? "", context: context);
          if (x != '') {
            openningTimeController.text = x;
          }
        }
        if (userData?.closingTime != null && userData?.closingTime != '') {
          var y = Formatter().formatTimeG(time: userData?.closingTime ?? "", context: context);
          if (y != '') {
            closingTimeController.text = y;
          }
        }
      } else {
        Utility.showToast(msg: userResponse.message);
      }

      _changeLoadingState(false);
    } else {
      Utility.showToast(msg: AppLocalizations.of(context).noInternet);
    }
  }

  validateData() {
    if (providernameController.text.trim().isEmpty) {
      Utility.showToast(msg: AppLocalizations.of(context).entertheprovidername);
    } else if (openningTimeController.text.trim().isEmpty) {
      Utility.showToast(msg: AppLocalizations.of(context).openningtimeisrequired);
    } else if (closingTimeController.text.trim().isEmpty) {
      Utility.showToast(msg: AppLocalizations.of(context).clossingtimeisrequired);
    } else if (locationAddressController.text.trim() == '' || lat == null || lng == null) {
      Utility.showToast(msg: AppLocalizations.of(context).selectLocation);
    } else if (aboutController.text.trim().isEmpty) {
      Utility.showToast(msg: AppLocalizations.of(context).aboutisrequired);
    } else if (userData?.imageUrl == null && userData?.imageUrl == '' && pickImageFilePath == null) {
      Utility.showToast(msg: AppLocalizations.of(context).pleaseaddaImage);
    } else {
      editProfileApi();
    }
  }

  Future editProfileApi() async {
    if (await ApiManager.checkInternet()) {
      _changeLoadingState(true);

      UserResponse userResponse = UserResponse.fromJson(
        await ApiManager(context).multipartRequest(
          url: AppStrings.usersEdit,
          files: [if (pickImageFilePath != null) MapEntry('image', pickImageFilePath!)],
          request: {
            "name": providernameController.text.trim(),
            if (aboutController.text.isNotEmpty) "about": aboutController.text.trim(),
            if (locationAddressController.text.isNotEmpty) "address": locationAddressController.text.trim(),
            if (locationAddressController.text.isNotEmpty && lat != null) "latitude": lat.toString(),
            if (locationAddressController.text.isNotEmpty && lng != null) "longitude": lng.toString(),
            if (openningTimeController.text.isNotEmpty && apiOpenningTime != '') "opening_time": apiOpenningTime,
            if (closingTimeController.text.isNotEmpty && apiClosingTime != '') "closing_time": apiClosingTime,
            "is_open_on_mon": listWeek[0].isDaySelected != null && listWeek[0].isDaySelected == true ? '1' : '0',
            "is_open_on_tue": listWeek[1].isDaySelected != null && listWeek[1].isDaySelected == true ? '1' : '0',
            "is_open_on_web": listWeek[2].isDaySelected != null && listWeek[2].isDaySelected == true ? '1' : '0',
            "is_open_on_thu": listWeek[3].isDaySelected != null && listWeek[3].isDaySelected == true ? '1' : '0',
            "is_open_on_fri": listWeek[4].isDaySelected != null && listWeek[4].isDaySelected == true ? '1' : '0',
            "is_open_on_sat": listWeek[5].isDaySelected != null && listWeek[5].isDaySelected == true ? '1' : '0',
            "is_open_on_sun": listWeek[6].isDaySelected != null && listWeek[6].isDaySelected == true ? '1' : '0',
          },
        ),
      );

      if (userResponse.status == '1') {
        final pref = await SharedPreferences.getInstance();
        userResponse.token = prefUserResponse!.token;
        await pref.setString(AppStrings.userPrefKey, jsonEncode(userResponse.toJson()));

        Navigator.pop(context, 'refresh');
        Utility.showToast(msg: userResponse.message);
      } else {
        Utility.showToast(msg: userResponse.message);
      }
      _changeLoadingState(false);
    } else {
      Utility.showToast(msg: AppLocalizations.of(context).noInternet);
    }
  }

  dynamic _changeLoadingState(bool _isLoading) {
    isLoading = _isLoading;
    _notify();
  }

  _notify() {
    if (mounted) setState(() {});
  }

  uploadDialogPopup() {
    DailogBox.cameraAndImagePickerDialog(
      context: context,
      onCameraTap: () {
        Navigator.pop(context);
        getImageFromCamera();
      },
      onGalleryTap: () async {
        Navigator.pop(context);
        pickImageFilePath = await Utility.pickImageFromStorage();
        if (pickImageFilePath == null) {
          Utility.showToast(msg: AppLocalizations.of(context).unabletoPickImage);
        }
        _notify();
      },
    );
  }

  Future getImageFromCamera() async {
    final pickedImage = await ImagePicker().pickImage(source: ImageSource.camera);

    pickImageFilePath = pickedImage != null ? File(pickedImage.path) : null;
    if (pickImageFilePath == null) {
      Utility.showToast(msg: AppLocalizations.of(context).unabletoPickImage);
    }
    _notify();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bodybgcolor,
      appBar: AppBar(
        backgroundColor: AppColors.bodybgcolor,
        automaticallyImplyLeading: true,
        leading: BackArrowWidget(
          onTap: () {
            Navigator.pop(context);
          },
        ),
        title: Text(
          AppLocalizations.of(context).profileSetting,
          style: const TextStyle(fontSize: 20),
        ),
      ),
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Container(
              margin: const EdgeInsets.all(10.0),
              child: Column(
                children: [
                  GestureDetector(
                    onTap: () {
                      uploadDialogPopup();
                    },
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        Container(
                          margin: const EdgeInsets.all(20.0),
                          height: 200,
                          width: MediaQuery.of(context).size.width * 4,
                          color: AppColors.tranparentColor,
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child: pickImageFilePath == null
                                ? Utility.imageLoader(
                                    userData?.imageUrl ?? '',
                                    AppAssets().logo,
                                    BoxFit.cover,
                                  )
                                : Image.file(
                                    pickImageFilePath!,
                                    fit: BoxFit.cover,
                                  ),
                          ),
                        ),
                        if (pickImageFilePath == null)
                          GestureDetector(
                            onTap: () {
                              uploadDialogPopup();
                            },
                            child: Container(
                              height: 80,
                              width: 80,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(50),
                                gradient: const LinearGradient(
                                    begin: Alignment.centerLeft,
                                    end: Alignment.centerRight,
                                    colors: [Colors.green, Colors.blue]),
                              ),
                              child: MaterialButton(
                                onPressed: () {
                                  uploadDialogPopup();
                                },
                                textColor: Colors.white,
                                child: const Icon(
                                  Icons.camera_alt,
                                  size: 50,
                                ),
                                padding: const EdgeInsets.all(16),
                                shape: const CircleBorder(),
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                  Column(
                    children: [
                      TextFieldWidget(
                        padding: const EdgeInsets.only(left: 20, right: 20, top: 10),
                        hintText: AppLocalizations.of(context).enterProviderName,
                        label: AppLocalizations.of(context).providerName,
                        controller: providernameController,
                        keyboardType: TextInputType.text,
                        focusNode: providernameFN,
                        maxLines: 1,
                      ),
                      TextFieldWidget(
                        padding: const EdgeInsets.only(left: 20, right: 20, top: 20),
                        enabled: false,
                        hintText: AppLocalizations.of(context).enterPhonenumber,
                        label: AppLocalizations.of(context).phoneNumber,
                        controller: phonenumberController,
                        keyboardType: TextInputType.number,
                        focusNode: phonenumberFN,
                        maxLines: 1,
                      ),
                      Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          SizedBox(
                            height: 110,
                            child: ListView.builder(
                              scrollDirection: Axis.horizontal,
                              padding: const EdgeInsets.only(
                                left: 16,
                                top: 16,
                                right: 16,
                              ),
                              itemCount: listWeek.length,
                              itemBuilder: (context, index) {
                                return itemView(index);
                              },
                            ),
                          ),
                        ],
                      ),
                      TextFieldWidget(
                        onTap: () async {
                          var pickedTime = await showTimePicker(
                            context: context,
                            initialTime: TimeOfDay.now(),
                          );

                          if (pickedTime != null) {
                            var formatTime = pickedTime.format(context);

                            if (formatTime != '') {
                              apiOpenningTime = pickedTime.toString().split('(').last.split(')').first;

                              openningTimeController.text = Formatter().formatTimeG(time: formatTime, context: context);
                            }
                          }
                        },
                        enabled: false,
                        padding: const EdgeInsets.only(left: 20, top: 20, right: 8),
                        hintText: AppLocalizations.of(context).enterOpenningTime,
                        label: AppLocalizations.of(context).openningTime,
                        controller: openningTimeController,
                        keyboardType: TextInputType.name,
                        focusNode: openningFN,
                        maxLines: 1,
                        suffixIcon: const Icon(
                          Icons.arrow_drop_down,
                          color: AppColors.primaryColor,
                        ),
                      ),
                      TextFieldWidget(
                        onTap: () async {
                          var pickedTime = await showTimePicker(
                            context: context,
                            initialTime: TimeOfDay.now(),
                          );

                          if (pickedTime != null) {
                            var cformatTime = pickedTime.format(context);

                            if (cformatTime != '') {
                              apiClosingTime = cformatTime.toString().split('(').last.split(')').first;

                              closingTimeController.text = Formatter().formatTimeG(time: cformatTime, context: context);
                            }
                          }
                        },
                        enabled: false,
                        padding: const EdgeInsets.only(left: 20, top: 20, right: 8),
                        hintText: AppLocalizations.of(context).enterClosingTime,
                        label: AppLocalizations.of(context).closingTime,
                        controller: closingTimeController,
                        keyboardType: TextInputType.name,
                        focusNode: closingFN,
                        maxLines: 1,
                        suffixIcon: const Icon(
                          Icons.arrow_drop_down,
                          color: AppColors.primaryColor,
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          setLocation();
                        },
                        child: TextFieldWidget(
                          enabled: false,
                          padding: const EdgeInsets.only(left: 20, right: 20, top: 20),
                          hintText: AppLocalizations.of(context).enterLocation,
                          label: AppLocalizations.of(context).location,
                          controller: locationAddressController,
                          keyboardType: TextInputType.text,
                          focusNode: locationAddressFN,
                          minLines: 1,
                          maxLines: 5,
                          suffixIcon: const Icon(
                            Icons.chevron_right,
                            color: AppColors.primaryColor,
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 15,
                      ),
                      TextFieldWidget(
                        padding: const EdgeInsets.only(left: 20, right: 20, top: 10),
                        hintText: AppLocalizations.of(context).enterAbout,
                        label: AppLocalizations.of(context).about,
                        controller: aboutController,
                        keyboardType: TextInputType.text,
                        focusNode: aboutFN,
                        minLines: 1,
                        maxLines: 5,
                      ),
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => AroundMeScreen(
                                userData: prefUserData!,
                              ),
                            ),
                          );
                        },
                        child: Container(
                          margin: const EdgeInsets.only(
                            left: 20,
                            right: 20,
                            bottom: 20,
                            top: 16,
                          ),
                          child: TextFormField(
                            enabled: false,
                            style: const TextStyle(color: AppColors.whiteColor),
                            decoration: InputDecoration(
                              label: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    AppLocalizations.of(context).aroundme,
                                    style: const TextStyle(color: AppColors.greyColor, fontSize: 18),
                                  ),
                                  const Icon(
                                    Icons.chevron_right_sharp,
                                    color: AppColors.bookingDetailsIconcolor,
                                  )
                                ],
                              ),
                            ),
                            keyboardType: TextInputType.text,
                          ),
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ),
          ),
          if (isLoading) Utility.progress(context)
        ],
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.only(
          left: 16,
          right: 16,
        ),
        child: CommonButton(
          text: AppLocalizations.of(context).updateinfo,
          onpressed: () {
            validateData();
          },
        ),
      ),
    );
  }

  void setLocation() {
    Utility.checkPermission(
      onSucess: () async {
        final locationResult = await showLocationPicker(
          context,
          AppStrings.MAP_API_KEY,
          myLocationButtonEnabled: false,
          layersButtonEnabled: true,
        );
        if (locationResult != null) {
          locationAddressController.text = locationResult.address ?? '';
          lat = locationResult.latLng?.latitude;
          lng = locationResult.latLng?.longitude;
          _notify();
        }
      },
      permission: Permission.location,
    );
  }

  itemView(int index) {
    return Padding(
      padding: const EdgeInsets.only(
        right: 16.0,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          GestureDetector(
            onTap: () {
              if (listWeek[index].isDaySelected == null || listWeek[index].isDaySelected == false) {
                listWeek[index].isDaySelected = true;
                _notify();
              } else {
                listWeek[index].isDaySelected = false;
                _notify();
              }
            },
            child: Container(
              width: 50,
              height: 50,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(AppDimens.borderRadiusCard),
                color: AppColors.greyColor,
                gradient: listWeek[index].isDaySelected == true ? AppColors.appGradient : AppColors.greyGradient,
              ),
              child: Text(
                listWeek[index].key?.substring(0, 1) ?? '',
                style: const TextStyle(
                  color: AppColors.whiteColor,
                  fontSize: 20,
                ),
              ),
            ),
          ),
          const SizedBox(
            height: 16,
          ),
          Text(
            listWeek[index].days ?? '',
            style: const TextStyle(
              color: AppColors.whiteColor,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }
}
