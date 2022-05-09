import 'package:karkar_provider_app/constants/all_imports.dart';
import 'package:karkar_provider_app/constants/app_strings.dart';
import 'package:karkar_provider_app/design/widget/dialog.dart';
import 'package:karkar_provider_app/design/widget/my_services_card_widget.dart';
import 'package:karkar_provider_app/l10n/l10n.dart';
import 'package:karkar_provider_app/network/api_manager/api_manager.dart';
import 'package:karkar_provider_app/network/models/services_model.dart';
import 'package:karkar_provider_app/network/models/services_pivot.dart';
import 'package:karkar_provider_app/network/models/user_data.dart';
import 'package:karkar_provider_app/network/response/common_response.dart';
import 'package:karkar_provider_app/network/response/services_list_response.dart';
import 'package:karkar_provider_app/network/response/user_response.dart';
import 'package:visibility_detector/visibility_detector.dart';

class SelectServices extends StatefulWidget {
  const SelectServices({Key? key}) : super(key: key);

  @override
  _SelectServicesState createState() => _SelectServicesState();
}

class _SelectServicesState extends State<SelectServices> {
  bool checkBox = true;
  List<ServicesModel> listData = [];
  List<ServicesModel> userPriceListData = [];
  ServicesListResponse? servicesListResponse;
  bool isLoading = false;
  bool isdataLoaded = false;
  bool isLoadingPage = false;
  bool ispreviousLoading = false;
  String dateApi = '';
  String count = '0';

  int page = 0;
  bool stop = false;
  UserResponse? userResponse, prefUserResponse;
  UserData? userData, prefUserData;

  TextEditingController priceController = TextEditingController();
  FocusNode priceFn = FocusNode();

  List<Map<String, dynamic>> addedList = [];

  @override
  void initState() {
    super.initState();
    getPref();
  }

  getPref() async {
    prefUserResponse = await Utility.getUserPref();
    if (prefUserResponse != null &&
        prefUserResponse?.data != null &&
        prefUserResponse?.data?.id != null) {
      prefUserData = prefUserResponse?.data;

      await previousservicesListDataApi();
    }
  }

  Future previousservicesListDataApi() async {
    if (await ApiManager.checkInternet()) {
      _previouschangeLoadingState(true);
      var request = <String, dynamic>{};

      request['user_id'] = prefUserData!.id.toString();

      ServicesListResponse previousServicesListResponse =
          ServicesListResponse.fromJson(
        await ApiManager(context).getCall(
          AppStrings.userServicesList,
          request,
        ),
      );

      if (previousServicesListResponse.status == '1' &&
          previousServicesListResponse.data != null &&
          previousServicesListResponse.data!.isNotEmpty) {
        userPriceListData.addAll(previousServicesListResponse.data!);
      }
      servicesListDataApi(true);
      _previouschangeLoadingState(false);
    } else {
      Utility.showToast(msg: AppLocalizations.of(context).noInternet);
    }
  }

  Future servicesListDataApi(bool isfirst) async {
    if (await ApiManager.checkInternet()) {
      if (isfirst == true) {
        _changeLoadingState(true, isfirst);
      } else {
        _changePageLoadingState(true, isfirst);
      }
      var request = <String, dynamic>{};

      page = page + 1;
      request['page'] = page.toString();
      request['with_sub_services'] = '1';

      ServicesListResponse servicesListResponse = ServicesListResponse.fromJson(
        await ApiManager(context).getCall(
          AppStrings.servicesList,
          request,
        ),
      );

      if (servicesListResponse.status == '1' &&
          servicesListResponse.data != null &&
          servicesListResponse.data!.isNotEmpty) {
        listData.addAll(servicesListResponse.data!);

        for (var i = 0; i < listData.length; i++) {
          for (var n = 0; n < userPriceListData.length; n++) {
            if (listData[i].id == userPriceListData[n].id) {
              listData[i].pivot = userPriceListData[n].pivot;

              if (listData[i].subServices != null &&
                  listData[i].subServices!.isNotEmpty) {
                for (var subIndex = 0;
                    subIndex < listData[i].subServices!.length;
                    subIndex++) {
                  for (var v = 0;
                      v < userPriceListData[n].subServices!.length;
                      v++) {
                    if (listData[i].subServices![subIndex].id != null &&
                        listData[i].subServices![subIndex].id ==
                            userPriceListData[n].subServices![v].id) {
                      listData[i].subServices![subIndex].pivot =
                          userPriceListData[n].subServices![v].pivot;
                      listData[i].subServices![subIndex].pivot!.isSelected =
                          true;
                    }
                  }
                }
              }
            }
          }
        }
      } else {
        nodatalogic(page);
      }
      isdataLoaded = true;
      if (isfirst == true) {
        _changeLoadingState(false, isfirst);
      } else {
        _changePageLoadingState(false, isfirst);
      }
    } else {
      Utility.showToast(msg: AppLocalizations.of(context).noInternet);
    }
  }

  _previouschangeLoadingState(bool _isLoading) {
    ispreviousLoading = _isLoading;
    _notify();
  }

  _changeLoadingState(bool _isLoading, bool time) {
    isLoading = _isLoading;
    _notify();
  }

  _changePageLoadingState(bool _isLoading, bool time) {
    isLoadingPage = _isLoading;
    _notify();
  }

  nodatalogic(int pagenum) {
    page = pagenum - 1;
    stop = true;
    _notify();
  }

  void _refresh() {
    listData.clear();
    page = 0;
    stop = false;
    servicesListDataApi(true);
  }

  _notify() {
    if (mounted) setState(() {});
  }

  acceptDialogPopup() {
    DailogBox.logoutDialog(
      title: AppLocalizations.of(context).updateServices,
      message: AppLocalizations.of(context).updatethisservices,
      context: context,
      onNoTap: () {
        Navigator.pop(context);
      },
      onYesTap: () {
        Navigator.pop(context);
        addadoundapi();
      },
    );
  }

  Future addadoundapi() async {
    if (await ApiManager.checkInternet()) {
      _changeAddLoadingState(true);

      var request = <String, dynamic>{};
      var b = 0;
      for (var a = 0; a < listData.length; a++) {
        for (var i = 0; i < listData[a].subServices!.length; i++) {
          if (listData[a].subServices![i].pivot != null &&
              listData[a].subServices![i].pivot?.isSelected == true) {
            request["services[$b][id]"] =
                listData[a].subServices![i].id.toString();
            request["services[$b][price]"] =
                listData[a].subServices![i].pivot?.price;
            b = b + 1;
          }
        }
      }

      CommonResponse commonResponse = CommonResponse.fromJson(
        await ApiManager(context).postCall(AppStrings.addservices, request),
      );

      if (commonResponse.status == '1') {
        Navigator.pop(context, 'refresh');

        Utility.showToast(msg: commonResponse.message);

        // ---Navigation ----

      } else {
        Utility.showToast(msg: commonResponse.message);
      }
      _changeAddLoadingState(false);
    } else {
      Utility.showToast(msg: AppLocalizations.of(context).noInternet);
    }
  }

  dynamic _changeAddLoadingState(bool _isLoading) {
    isLoading = _isLoading;
    _notify();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bodybgcolor,
      appBar: AppBar(
        automaticallyImplyLeading: true,
        backgroundColor: AppColors.appbarBgColor,
        leading: BackArrowWidget(
          onTap: () {
            Navigator.pop(context, 'refresh');
          },
        ),
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              AppLocalizations.of(context).selectServices,
              style: const TextStyle(fontSize: 18),
            ),
            GestureDetector(
              onTap: () {
                acceptDialogPopup();
              },
              child: Text(
                AppLocalizations.of(context).dONE,
                style: const TextStyle(
                    color: AppColors.bookingDetailsIconcolor, fontSize: 16),
              ),
            )
          ],
        ),
      ),
      body: Stack(
        children: [
          RefreshIndicator(
            onRefresh: () async {
              _refresh();
            },
            child: listData.isNotEmpty
                ? Column(
                    children: [
                      Flexible(
                        child: ListView.builder(
                          shrinkWrap: false,
                          itemCount: listData.length,
                          padding: const EdgeInsets.only(
                            top: 16.0,
                            left: 16.0,
                            right: 16.0,
                            bottom: 100.0,
                          ),
                          physics: const AlwaysScrollableScrollPhysics(),
                          itemBuilder: (context, index) {
                            return (listData.length - 1) == index
                                ? VisibilityDetector(
                                    key: Key(index.toString()),
                                    child: itemview(index),
                                    onVisibilityChanged: (val) {
                                      if (!stop &&
                                          index == listData.length - 1) {
                                        servicesListDataApi(false);
                                      }
                                    },
                                  )
                                : itemview(index);
                          },
                        ),
                      ),
                      if (isLoadingPage) ...[
                        const SizedBox(height: 8),
                        Utility.progress(context),
                        const SizedBox(height: 20),
                      ]
                    ],
                  )
                : !isLoading && isdataLoaded
                    ? Container(
                        alignment: Alignment.center,
                        height: MediaQuery.of(context).size.height / 2.35,
                        child: Text(
                          AppLocalizations.of(context).noData,
                          style: const TextStyle(
                            letterSpacing: 0.6,
                            color: AppColors.whiteColor,
                            fontSize: 14.0,
                            fontWeight: FontWeight.normal,
                          ),
                        ),
                      )
                    : const SizedBox(),
          ),
          if (isLoading) Utility.progress(context)
        ],
      ),
    );
  }

  itemview(int index) {
    return Column(
      children: [
        ServicesCardWidget(
          image: listData[index].imageUrl ?? "",
          price: listData[index].pivot?.price ?? '',
          title: listData[index].title ?? '',
          isSubCategory: false,
          isCheckBoxVisible: false,
        ),
        if (listData[index].subServices != null &&
            listData[index].subServices!.isNotEmpty)
          ListView.builder(
            shrinkWrap: true, // 1st add
            physics: const ClampingScrollPhysics(), // 2nd add
            itemCount: listData[index].subServices!.length,
            itemBuilder: (_, index1) {
              return ServicesCardWidget(
                isCheckBoxVisible: true,
                isSubCategory: true,
                isChecked:
                    listData[index].subServices![index1].pivot?.isSelected ??
                        false,
                image: listData[index].subServices![index1].imageUrl != null
                    ? listData[index].subServices![index1].imageUrl ?? ""
                    : '',
                price:
                    //  listData[index].subServices![index1].price != null &&
                    //         listData[index].subServices![index1].price != ''
                    //     ? listData[index].subServices![index1].price ?? ''

                    //     :
                    listData[index].subServices![index1].pivot?.price ?? '',
                title: listData[index].subServices![index1].title != null
                    ? listData[index].subServices![index1].title ?? ''
                    : '',
                onTap: () {
                  if (listData[index].subServices![index1].pivot?.isSelected !=
                      true) {
                    rejectDialogPopup(
                      index1: index1,
                      index: index,
                    );

                    // listData[index].subServices![index1].isSelected = true;
                  } else {
                    if (listData[index].pivot?.price != null &&
                        listData[index].pivot?.price != '') {
                      var oldTotal =
                          int.parse(listData[index].pivot?.price ?? '');
                      var addNewVal = int.parse(
                          listData[index].subServices![index1].pivot?.price ??
                              "");

                      var newVal = oldTotal - addNewVal;

                      listData[index].pivot =
                          ServicesPivot(price: newVal.toString());

                      if (listData[index].pivot?.price == '0') {
                        listData[index].pivot = ServicesPivot(price: '');
                      }
                    }
                    listData[index].subServices![index1].pivot = ServicesPivot(
                      isSelected: false,
                      price: '',
                    );
                  }
                  _notify();
                },
                onChanged: (val) {
                  // listData[index].subServices![index1].isSelected = val;
                  if (listData[index].subServices![index1].pivot?.isSelected !=
                      true) {
                    rejectDialogPopup(
                      index1: index1,
                      index: index,
                    );

                    // listData[index].subServices![index1].isSelected = true;
                  } else {
                    if (listData[index].pivot?.price != null &&
                        listData[index].pivot?.price != '') {
                      var oldTotal =
                          int.parse(listData[index].pivot?.price ?? '');
                      var addNewVal = int.parse(
                          listData[index].subServices![index1].pivot?.price ??
                              "");

                      var newVal = oldTotal - addNewVal;

                      listData[index].pivot =
                          ServicesPivot(price: newVal.toString());

                      if (listData[index].pivot?.price == '0') {
                        listData[index].pivot = ServicesPivot(price: '');
                      }
                    }
                    listData[index].subServices![index1].pivot = ServicesPivot(
                      isSelected: false,
                      price: '',
                    );
                  }

                  _notify();
                },
              );
            },
          ),
      ],
    );
  }

  rejectDialogPopup({required int index, required int index1}) {
    DailogBox.addPrice(
      context: context,
      controller: priceController,
      focusNode: priceFn,
      onNoTap: () {
        priceController.clear();
        Navigator.pop(context);
      },
      onYesTap: () {
        if (priceController.text.isNotEmpty) {
          listData[index].subServices![index1].pivot = ServicesPivot(
            isSelected: true,
            price: priceController.text,
          );

          if (listData[index].pivot?.price != null) {
            var oldTotal = int.parse(listData[index].pivot?.price ?? '');
            var addNewVal = int.parse(priceController.text.trim());

            var newVal = oldTotal + addNewVal;

            listData[index].pivot = ServicesPivot(price: newVal.toString());
          } else {
            listData[index].pivot =
                ServicesPivot(price: priceController.text.trim());
          }

          _notify();
          Navigator.pop(context);
          priceController.clear();
        } else {
          Navigator.pop(context);
          Utility.showToast(msg: AppLocalizations.of(context).amountidrequired);
        }
      },
    );
  }
}
