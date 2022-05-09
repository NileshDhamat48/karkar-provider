import 'package:intl/intl.dart';
import 'package:karkar_provider_app/constants/all_imports.dart';
import 'package:karkar_provider_app/design/page/add_offer_page.dart';
import 'package:karkar_provider_app/design/widget/icon_button.dart';
import 'package:karkar_provider_app/network/response/common_response.dart';
import 'package:visibility_detector/visibility_detector.dart';

import '../../constants/app_strings.dart';
import '../../l10n/l10n.dart';
import '../../network/api_manager/api_manager.dart';
import '../../network/models/providers_offer_model.dart';

class MyOfferPage extends StatefulWidget {
  const MyOfferPage({Key? key}) : super(key: key);

  @override
  State<MyOfferPage> createState() => _MyOfferPageState();
}

class _MyOfferPageState extends State<MyOfferPage> {
  List<OfferModel> offerList = [];

  bool isLoading = false;
  bool isLoadingPage = false;

  int page = 0;
  bool stop = false;
  @override
  void initState() {
    super.initState();
    getprovidersOffers(true);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor: AppColors.appbarBgColor,
      backgroundColor: AppColors.scaffoldbgcolor,
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
          AppLocalizations.of(context).myOffers,
          style: const TextStyle(
            fontSize: 18,
          ),
        ),
      ),
      body: Stack(
        children: [
          RefreshIndicator(
            onRefresh: () async => _refresh(),
            child: Column(
              children: [
                if (offerList.isNotEmpty)
                  Flexible(
                    child: ListView.builder(
                      itemCount: offerList.length,
                      itemBuilder: (context, index) {
                        return (offerList.length - 1) == index
                            ? VisibilityDetector(
                                key: Key(index.toString()),
                                child: itemview(index),
                                onVisibilityChanged: (val) {
                                  if (!stop && index == offerList.length - 1) {
                                    getprovidersOffers(false);
                                  }
                                },
                              )
                            : itemview(index);
                      },
                    ),
                  ),
                if (offerList.isEmpty && !isLoading && !isLoadingPage)
                  Flexible(
                    child: ListView(
                      children: [
                        SizedBox(
                          height: (MediaQuery.of(context).size.height / 2) -
                              AppBar().preferredSize.height -
                              MediaQuery.of(context).padding.top,
                        ),
                        Center(
                          child: Text(
                            AppLocalizations.of(context).noData,
                            style: const TextStyle(color: AppColors.whiteColor),
                          ),
                        )
                      ],
                    ),
                  ),
                if (isLoadingPage) ...[
                  const SizedBox(height: 8),
                  Utility.progress(context),
                  const SizedBox(height: 20),
                ]
              ],
            ),
          ),
          if (isLoading) Utility.progress(context)
        ],
      ),
      floatingActionButton: IconButton1(
          icon: Icons.add,
          height: 70,
          width: 70,
          onpressed: () async {
            final refresh = await Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => const AddOfferPage(),
              ),
            );
            if (refresh != null) {
              _refresh();
            }
          },
          iconsize: 40),
    );
  }

  String getDateItem(int index) {
    var inputFormat = DateFormat("yyyy-MM-dd");
    var outputDateFormate = DateFormat('dd MMM');

    var startDate = inputFormat.parse(offerList[index].startDate ?? "");
    var finalStartDate = outputDateFormate.format(startDate);

    var endDate = inputFormat.parse(offerList[index].endDate ?? "");

    var finalEndDate = outputDateFormate.format(endDate);

    if (startDate.compareTo(endDate) == 0) {
      return finalStartDate;
    } else {
      return '${AppLocalizations.of(context).from} ' +
          finalStartDate +
          ' ${AppLocalizations.of(context).to} ' +
          finalEndDate;
    }
  }

  itemview(int index) {
    return Container(
      decoration: BoxDecoration(color: AppColors.userbgcolor, borderRadius: BorderRadius.circular(10)),
      // height: MediaQuery.of(context).size.height / 4.5,
      margin: const EdgeInsets.all(12),
      padding: const EdgeInsets.all(12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Flexible(
                child: Text(
                  offerList[index].description ?? '',
                  maxLines: 5,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(color: AppColors.whiteColor, fontSize: 16),
                ),
              ),
              PopupMenuButton(
                color: AppColors.appbarBgColor,
                onSelected: (value) {},
                icon: const Icon(
                  Icons.more_vert_rounded,
                  color: AppColors.whiteColor,
                  size: 35,
                ),
                itemBuilder: (context) => [
                  // PopupMenuItem(
                  //   child: Text(
                  //     AppLocalizations.of(context).edit,
                  //     style: const TextStyle(color: AppColors.whiteColor),
                  //   ),
                  //   value: 0,
                  //   // onTap: onEditTap,
                  // ),
                  // PopupMenuItem(
                  //   child: Text(
                  //     AppLocalizations.of(context).delete,
                  //     style: const TextStyle(color: AppColors.whiteColor),
                  //   ),
                  //   value: 1,
                  //   // onTap: onEditTap,
                  // ),
                  PopupMenuItem(
                    child: Text(
                      AppLocalizations.of(context).cancel,
                      style: const TextStyle(color: AppColors.whiteColor),
                    ),
                    value: 1,
                    onTap: () {
                      calcelOffer(index);
                    },
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(
            height: 10,
          ),
          Text(
            getDateItem(index),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(color: AppColors.greyText, fontSize: 15),
          ),
          const SizedBox(
            height: 10,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '${AppLocalizations.of(context).paid} € ${offerList[index].price}',
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(color: AppColors.greyText, fontSize: 15),
              ),
              if (offerList[index].isActive == true)
                ClipRRect(
                  borderRadius: BorderRadius.circular(40),
                  child: Container(
                    color: AppColors.gradientOne,
                    height: 10,
                    width: 10,
                  ),
                )
            ],
          ),
        ],
      ),
    );
  }

  calcelOffer(int index) async {
    if (await ApiManager.checkInternet()) {
      _changeLoadingState(true);

      var request = <String, dynamic>{};

      CommonResponse commonResponse = CommonResponse.fromJson(
        await ApiManager(context).postCall(
          AppStrings.cancelOffer(offerList[index].id ?? 0),
          request,
        ),
      );
      if (commonResponse.status == "1") {
        offerList.removeAt(index);
        _notify();
      }

      _changeLoadingState(false);
    } else {
      Utility.showToast(msg: AppLocalizations.of(context).noInternet);
    }
  }

  getprovidersOffers(bool isfirst) async {
    if (await ApiManager.checkInternet()) {
      if (isfirst == true) {
        _changeLoadingState(true);
      } else {
        _changePageLoadingState(true, isfirst);
      }
      var request = <String, dynamic>{};

      page = page + 1;
      request['page'] = page.toString();
      request['own'] = '1';
      if (mounted) {
        ResOffer offerResponce = ResOffer.fromJson(
          await ApiManager(context).getCall(
            AppStrings.providersOffers,
            request,
          ),
        );
        if (offerResponce.status == "1" && offerResponce.data != null && offerResponce.data!.isNotEmpty) {
          offerList.addAll(offerResponce.data!);
        } else {
          nodatalogic(page);
        }
      }
      if (isfirst == true) {
        _changeLoadingState(false);
      } else {
        _changePageLoadingState(false, isfirst);
      }
    } else {
      Utility.showToast(msg: AppLocalizations.of(context).noInternet);
    }
  }

  _refresh() {
    page = 0;
    stop = false;
    offerList.clear();
    getprovidersOffers(true);
  }

  _changeLoadingState(bool _isLoading) {
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

  _notify() {
    if (mounted) setState(() {});
  }
}
