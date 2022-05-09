import 'package:karkar_provider_app/constants/all_imports.dart';
import 'package:karkar_provider_app/constants/app_strings.dart';
import 'package:karkar_provider_app/design/widget/around_itemview.dart';
import 'package:karkar_provider_app/design/widget/dialog.dart';
import 'package:karkar_provider_app/l10n/l10n.dart';
import 'package:karkar_provider_app/network/api_manager/api_manager.dart';
import 'package:karkar_provider_app/network/models/around.dart';
import 'package:karkar_provider_app/network/models/user_data.dart';
import 'package:karkar_provider_app/network/response/around_response.dart';
import 'package:karkar_provider_app/network/response/common_response.dart';
import 'package:visibility_detector/visibility_detector.dart';

class AroundMeScreen extends StatefulWidget {
  const AroundMeScreen({Key? key, required this.userData}) : super(key: key);

  final UserData userData;

  @override
  _AroundMeScreenState createState() => _AroundMeScreenState();
}

class _AroundMeScreenState extends State<AroundMeScreen> {
  bool checkBox = false;
  List<AroundModel> listData = [];
  List<AroundModel> userAroundlistData = [];
  AroundResponse? aroundResponse, userAroundResponse;
  bool isLoading = false;
  bool isDataLoaded = false;
  bool isLoadingUser = false;
  bool isLoadingPage = false;
  List<int> selectedCategory = [];

  int page = 0;
  bool stop = false;

  @override
  void initState() {
    super.initState();
    useraroundListDataApi();
  }

  // --- User around list ---

  Future useraroundListDataApi() async {
    if (await ApiManager.checkInternet()) {
      _userchangeLoadingState(false);

      var request = <String, dynamic>{};

      request['user_id'] = widget.userData.id.toString();

      AroundResponse userAroundResponse = AroundResponse.fromJson(
        await ApiManager(context).getCall(
          AppStrings.useraroundList,
          request,
        ),
      );

      if (userAroundResponse.status == '1' &&
          userAroundResponse.data != null &&
          userAroundResponse.data!.isNotEmpty) {
        userAroundlistData.addAll(userAroundResponse.data!);
      }
      aroundListDataApi(true);

      _userchangeLoadingState(false);
    } else {
      Utility.showToast(msg: AppLocalizations.of(context).noInternet);
    }
  }
  // ---

  Future aroundListDataApi(bool isfirst) async {
    if (await ApiManager.checkInternet()) {
      if (isfirst == true) {
        _changeLoadingState(true, isfirst);
      } else {
        _changePageLoadingState(true, isfirst);
      }
      var request = <String, dynamic>{};

      page = page + 1;
      request['page'] = page.toString();

      AroundResponse aroundResponse = AroundResponse.fromJson(
        await ApiManager(context).getCall(
          AppStrings.aroundList,
          request,
        ),
      );

      if (aroundResponse.status == '1' &&
          aroundResponse.data != null &&
          aroundResponse.data!.isNotEmpty) {
        listData.addAll(aroundResponse.data!);

        for (var i = 0; i < listData.length; i++) {
          for (var n = 0; n < userAroundlistData.length; n++) {
            if (listData[i].id == userAroundlistData[n].id) {
              listData[i].isCheckedApi = true;
            }
          }
        }
      } else {
        nodatalogic(page);
      }
      isDataLoaded = true;
      if (isfirst == true) {
        _changeLoadingState(false, isfirst);
      } else {
        _changePageLoadingState(false, isfirst);
      }
    } else {
      Utility.showToast(msg: AppLocalizations.of(context).noInternet);
    }
  }

  _userchangeLoadingState(bool _isLoading) {
    isLoading = _isLoading;
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
    aroundListDataApi(true);
  }

  _notify() {
    if (mounted) setState(() {});
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
            Navigator.pop(context);
          },
        ),
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              AppLocalizations.of(context).aroundMe,
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
      body: RefreshIndicator(
        onRefresh: () async {
          _refresh();
        },
        child: Stack(
          children: [
            listData.isNotEmpty
                ? Column(
                    children: [
                      Flexible(
                        child: ListView.builder(
                          itemCount: listData.length,
                          shrinkWrap: false,
                          padding: const EdgeInsets.only(
                            bottom: 16,
                            top: 16,
                          ),
                          itemBuilder: (context, index) {
                            return (listData.length - 1) == index
                                ? VisibilityDetector(
                                    key: Key(index.toString()),
                                    child: itemView(index),
                                    onVisibilityChanged: (val) {
                                      if (!stop &&
                                          index == listData.length - 1) {
                                        aroundListDataApi(false);
                                      }
                                    },
                                  )
                                : itemView(index);
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
                : !isLoading && isDataLoaded
                    ? Container(
                        alignment: Alignment.center,
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
            if (isLoading) Utility.progress(context)
          ],
        ),
      ),
    );
  }

  itemView(int index) {
    return AroundItemView(
      onTap: () {
        if (listData[index].isCheckedApi != true) {
          listData[index].isCheckedApi = true;
        } else {
          listData[index].isCheckedApi = false;
        }
        _notify();
      },
      isChecked: listData[index].isCheckedApi ?? false,
      title: listData[index].title ?? '',
      onChanged: (val) {
        listData[index].isCheckedApi = val;
        _notify();
      },
    );
  }

  acceptDialogPopup() {
    DailogBox.logoutDialog(
      title: AppLocalizations.of(context).addAround,
      message: AppLocalizations.of(context).aroundmsg,
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
        if (listData[a].isCheckedApi == true) {
          request["around_ids[$b]"] = listData[a].id.toString();
          b = b + 1;
        }
      }

      CommonResponse commonResponse = CommonResponse.fromJson(
        await ApiManager(context).postCall(AppStrings.addaroundList, request),
      );

      if (commonResponse.status == '1') {
        Navigator.pop(context, 'refresh');

        Utility.showToast(msg: commonResponse.message);
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
}
