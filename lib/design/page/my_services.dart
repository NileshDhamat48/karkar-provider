import 'package:karkar_provider_app/constants/all_imports.dart';
import 'package:karkar_provider_app/constants/app_strings.dart';
import 'package:karkar_provider_app/design/page/select_services.dart';
import 'package:karkar_provider_app/design/widget/button.dart';
import 'package:karkar_provider_app/design/widget/gradient_text.dart';
import 'package:karkar_provider_app/design/widget/my_services_card_widget.dart';
import 'package:karkar_provider_app/l10n/l10n.dart';
import 'package:karkar_provider_app/network/api_manager/api_manager.dart';
import 'package:karkar_provider_app/network/models/services_model.dart';
import 'package:karkar_provider_app/network/models/user_data.dart';
import 'package:karkar_provider_app/network/response/services_list_response.dart';
import 'package:karkar_provider_app/network/response/user_response.dart';
import 'package:visibility_detector/visibility_detector.dart';

class MyServices extends StatefulWidget {
  const MyServices({Key? key}) : super(key: key);

  @override
  _MyServicesState createState() => _MyServicesState();
}

class _MyServicesState extends State<MyServices> {
  List<ServicesModel> listData = [];
  ServicesListResponse? servicesListResponse;
  bool isLoading = false;
  bool isLoadingPage = false;
  String dateApi = '';
  String count = '0';

  int page = 0;
  bool stop = false;
  UserResponse? userResponse, prefUserResponse;
  UserData? userData, prefUserData;

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

      await servicesListDataApi(true);
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
      request['user_id'] = prefUserData?.id.toString();

      ServicesListResponse servicesListResponse = ServicesListResponse.fromJson(
        await ApiManager(context).getCall(
          AppStrings.userServicesList,
          request,
        ),
      );

      if (servicesListResponse.status == '1' &&
          servicesListResponse.data != null &&
          servicesListResponse.data!.isNotEmpty) {
        listData.addAll(servicesListResponse.data!);
      } else {
        nodatalogic(page);
      }
      if (isfirst == true) {
        _changeLoadingState(false, isfirst);
      } else {
        _changePageLoadingState(false, isfirst);
      }
    } else {
      Utility.showToast(msg: AppLocalizations.of(context).noInternet);
    }
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
    isLoading = false;
    isLoadingPage = false;
    listData.clear();
    page = 0;
    stop = false;
    servicesListDataApi(true);
  }

  _notify() {
    if (mounted) setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bodybgcolor,
      appBar: AppBar(
        elevation: 0,
        automaticallyImplyLeading: true,
        backgroundColor: AppColors.appbarBgColor,
        leading: BackArrowWidget(
          onTap: () {
            Navigator.pop(context);
          },
        ),
        title: Text(
          AppLocalizations.of(context).myServices,
          style: const TextStyle(fontSize: 18),
        ),
      ),
      body: Stack(
        children: [
          GestureDetector(
            onTap: () async {
              var refresh = await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const SelectServices(),
                ),
              );
              _refresh();
            },
            child: Container(
              color: AppColors.tranparentColor,
              margin: const EdgeInsets.only(top: 30, left: 20),
              child: Column(
                children: [
                  Container(
                    margin: const EdgeInsets.only(bottom: 10, left: 10),
                    child: Row(
                      children: [
                        Container(
                          width: 60,
                          height: 60,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(60),
                              gradient: AppColors.lineargradient),
                          child: const Icon(
                            Icons.add,
                            color: AppColors.whiteColor,
                            size: 30,
                          ),
                        ),
                        const SizedBox(
                          width: 20,
                        ),
                        GradientText(
                          text: AppLocalizations.of(context).addServices,
                          style: const TextStyle(
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.only(
                        left: 2, top: 25, right: 16, bottom: 10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          AppLocalizations.of(context).myServices,
                          style: TextStyle(
                              color: AppColors.greyText, fontSize: 14),
                        ),
                        Text(
                          AppLocalizations.of(context).addServicePrice,
                          style: TextStyle(color: AppColors.greyText),
                        )
                      ],
                    ),
                  ),
                  Expanded(
                    child: RefreshIndicator(
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
                                      bottom: 100.0,
                                    ),
                                    physics:
                                        const AlwaysScrollableScrollPhysics(),
                                    itemBuilder: (context, index) {
                                      return (listData.length - 1) == index
                                          ? VisibilityDetector(
                                              key: Key(index.toString()),
                                              child: itemview(index),
                                              onVisibilityChanged: (val) {
                                                if (!stop &&
                                                    index ==
                                                        listData.length - 1) {
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
                          : !isLoading
                              ? Container(
                                  alignment: Alignment.center,
                                  height:
                                      MediaQuery.of(context).size.height / 2.35,
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
                  )
                ],
              ),
            ),
          ),
          isLoading ? Utility.progress(context) : const SizedBox()
        ],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: CommonButton(
        text: AppLocalizations.of(context).updateinfo,
        onpressed: () async {
          var refresh = await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const SelectServices(),
            ),
          );
          _refresh();
        },
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
        ),
        if (listData[index].subServices != null &&
            listData[index].subServices!.isNotEmpty)
          ListView.builder(
            shrinkWrap: true, // 1st add
            physics: const ClampingScrollPhysics(), // 2nd add
            itemCount: listData[index].subServices!.length,
            itemBuilder: (_, index1) {
              return ServicesCardWidget(
                image: listData[index].subServices![index1].imageUrl != null
                    ? listData[index].subServices![index1].imageUrl ?? ""
                    : '',
                price: listData[index].subServices![index1].pivot != null &&
                        listData[index].subServices![index1].pivot?.price !=
                            null &&
                        listData[index].subServices![index1].pivot?.price != ''
                    ? listData[index].subServices![index1].pivot?.price ?? ''
                    : '',
                title: listData[index].subServices![index1].title != null
                    ? listData[index].subServices![index1].title ?? ''
                    : '',
                isSubCategory: true,
              );
            },
          ),
      ],
    );
  }
}
