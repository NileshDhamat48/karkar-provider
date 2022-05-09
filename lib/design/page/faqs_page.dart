import 'package:flutter_html/flutter_html.dart';
import 'package:karkar_provider_app/constants/all_imports.dart';
import 'package:karkar_provider_app/constants/app_strings.dart';
import 'package:karkar_provider_app/l10n/l10n.dart';
import 'package:karkar_provider_app/network/api_manager/api_manager.dart';
import 'package:karkar_provider_app/network/models/faqs_model.dart';
import 'package:karkar_provider_app/network/response/faqs_page_response.dart';
import 'package:visibility_detector/visibility_detector.dart';
import 'package:flutter_html/style.dart';

class FaqsPage extends StatefulWidget {
  const FaqsPage({Key? key}) : super(key: key);

  @override
  _FaqsPageState createState() => _FaqsPageState();
}

class _FaqsPageState extends State<FaqsPage> {
  List<FaqsData> faqList = [];

  bool isLoading = false;
  bool isLoadingPage = false;

  int page = 0;
  bool stop = false;
  @override
  void initState() {
    super.initState();
    getFaqs(true);
  }

  getFaqs(bool isfirst) async {
    if (await ApiManager.checkInternet()) {
      if (isfirst == true) {
        _changeLoadingState(true, isfirst);
      } else {
        _changePageLoadingState(true, isfirst);
      }
      var request = <String, dynamic>{};

      page = page + 1;
      request['page'] = page.toString();
      if (mounted) {
        FaqsResponce faqsResponce = FaqsResponce.fromJson(
          await ApiManager(context).getCall(
            AppStrings.faqs,
            request,
          ),
        );
        if (faqsResponce.status == "1" && faqsResponce.data != null) {
          faqList.addAll(faqsResponce.data!);
        } else {
          nodatalogic(page);
        }
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

  _notify() {
    if (mounted) setState(() {});
  }

  _refresh() {
    faqList.clear();
    isLoading = false;
    isLoadingPage = false;
    page = 0;
    stop = false;
    getFaqs(true);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.scaffoldbgcolor,
      appBar: AppBar(
        automaticallyImplyLeading: true,
        backgroundColor: AppColors.appbarBgColor,
        leading: BackArrowWidget(
          onTap: () {
            Navigator.pop(context);
          },
        ),
        title: Text(
          AppLocalizations.of(context).faqs,
          style: const TextStyle(
            fontSize: 18,
          ),
        ),
      ),
      // body: Container(
      //   margin: EdgeInsets.all(16.0),
      //   color: AppColors.greyColor,
      // child: ExpansionTile,
      // ),
      body: Stack(
        children: [
          RefreshIndicator(
            onRefresh: () async {
              _refresh();
            },
            child: Column(
              children: [
                Flexible(
                  child: ListView.builder(
                    itemCount: faqList.length,
                    itemBuilder: (context, index) {
                      return (faqList.length - 1) == index
                          ? VisibilityDetector(
                              key: Key(index.toString()),
                              child: itemView(index),
                              onVisibilityChanged: (val) {
                                if (!stop && index == faqList.length - 1) {
                                  getFaqs(false);
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
            ),
          ),
          isLoading ? Utility.progress(context) : Container()
        ],
      ),
    );
  }

  itemView(int index) {
    return Theme(
      data: Theme.of(context).copyWith(dividerColor: AppColors.tranparentColor),
      child: ExpansionTile(
        collapsedIconColor: AppColors.whiteColor,
        iconColor: AppColors.whiteColor,
        expandedAlignment: Alignment.topLeft,
        expandedCrossAxisAlignment: CrossAxisAlignment.start,
        title: Text(
          faqList[index].title ?? '',
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(
            letterSpacing: 0.6,
            color: AppColors.whiteColor,
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
        ),
        childrenPadding: const EdgeInsets.only(left: 16.0),
        children: [
          Text(
            faqList[index].shortDescription ?? '',
            maxLines: 5,
            textAlign: TextAlign.start,
            overflow: TextOverflow.ellipsis,
            style: Theme.of(context).textTheme.bodyText1!.copyWith(
                fontWeight: FontWeight.normal,
                fontSize: 16,
                color: AppColors.whiteColor),
          ),
          Html(
            shrinkWrap: true,
            data: faqList[index].description ?? '',
            style: {
              'body': Style(
                maxLines: 8,
                textOverflow: TextOverflow.ellipsis,
                color: AppColors.whiteColor,
                fontSize: const FontSize(14),
                fontWeight: FontWeight.normal,
                padding: EdgeInsets.zero,
              ),
            },
          )
        ],
      ),
    );
  }
}
