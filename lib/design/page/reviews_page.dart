import 'package:karkar_provider_app/constants/all_imports.dart';
import 'package:karkar_provider_app/constants/app_strings.dart';
import 'package:karkar_provider_app/constants/formattor.dart';
import 'package:karkar_provider_app/design/widget/reviews_box.dart';
import 'package:karkar_provider_app/l10n/l10n.dart';
import 'package:karkar_provider_app/network/api_manager/api_manager.dart';
import 'package:karkar_provider_app/network/models/review_model.dart';
import 'package:karkar_provider_app/network/models/user_data.dart';
import 'package:karkar_provider_app/network/response/review_response.dart';
import 'package:karkar_provider_app/network/response/user_response.dart';
import 'package:visibility_detector/visibility_detector.dart';

class ReviewPage extends StatefulWidget {
  const ReviewPage({Key? key}) : super(key: key);

  @override
  State<ReviewPage> createState() => _ReviewPageState();
}

class _ReviewPageState extends State<ReviewPage> {
  List<ReviewModel> listData = [];

  ReviewResponse? reviewResponse;
  bool isLoading = false;
  bool isLoadingPage = false;
  String dateApi = '';
  String count = '0';
  String averageRAting = '0';

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

      await reviewListDataApi(true);
    }
  }

  Future reviewListDataApi(bool isfirst) async {
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

      ReviewResponse reviewResponse = ReviewResponse.fromJson(
        await ApiManager(context).getCall(
          AppStrings.reviewList,
          request,
        ),
      );

      if (reviewResponse.status == '1' &&
          reviewResponse.data != null &&
          reviewResponse.data!.isNotEmpty) {
        listData.addAll(reviewResponse.data!);

        if (reviewResponse.totalCount != null) {
          count = reviewResponse.totalCount.toString();
        }
        if (reviewResponse.avgRating != null) {
          averageRAting = reviewResponse.avgRating.toString();
        }
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
    listData.clear();
    page = 0;
    stop = false;
    reviewListDataApi(true);
  }

  _notify() {
    if (mounted) setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.scaffoldbgcolor,
      body: Stack(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Stack(
                // alignment: Alignment.bottomLeft,
                children: [
                  Container(
                    color: AppColors.glassEffact,
                    margin: const EdgeInsets.only(top: 40, bottom: 20),
                    padding: const EdgeInsets.only(left: 20, top: 20),
                    height: 150,
                    width: MediaQuery.of(context).size.width * 4,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          prefUserData?.name ?? '',
                          style: const TextStyle(
                              color: AppColors.whiteColor, fontSize: 25),
                        ),
                        const SizedBox(
                          height: 5,
                        ),
                        Text(
                          prefUserData?.address ?? '',
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                              color: AppColors.greyColor, fontSize: 16),
                        ),
                      ],
                    ),
                  ),
                  Positioned(
                    // top: MediaQuery.of(context).size.height / 2,
                    bottom: -10,
                    child: button(context),
                  ),
                ],
              ),
              Flexible(
                child: RefreshIndicator(
                  onRefresh: () async {
                    _refresh();
                  },
                  child: listData.isNotEmpty
                      ? Column(
                          children: [
                            Flexible(
                              child: ListView.builder(
                                itemCount: listData.length,
                                shrinkWrap: false,
                                physics: const AlwaysScrollableScrollPhysics(),
                                itemBuilder: (context, index) {
                                  return (listData.length - 1) == index
                                      ? VisibilityDetector(
                                          key: Key(index.toString()),
                                          child: itemView(index),
                                          onVisibilityChanged: (val) {
                                            if (!stop &&
                                                index == listData.length - 1) {
                                              reviewListDataApi(false);
                                            }
                                          },
                                        )
                                      : Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            if (index == 0)
                                              Container(
                                                margin: const EdgeInsets.only(
                                                  left: 20.0,
                                                  bottom: 10.0,
                                                ),
                                                child: RichText(
                                                  text: TextSpan(
                                                    style: const TextStyle(
                                                      fontSize: 16,
                                                      color:
                                                          AppColors.greyColor,
                                                    ),
                                                    children: [
                                                      TextSpan(
                                                        text:
                                                            AppLocalizations.of(
                                                                    context)
                                                                .total,
                                                        style: const TextStyle(
                                                          fontWeight:
                                                              FontWeight.bold,
                                                        ),
                                                      ),
                                                      TextSpan(
                                                        text: count,
                                                        style: const TextStyle(
                                                          fontWeight:
                                                              FontWeight.bold,
                                                        ),
                                                      ),
                                                      TextSpan(
                                                        text:
                                                            AppLocalizations.of(
                                                                    context)
                                                                .peopleRated,
                                                        style: const TextStyle(
                                                          fontWeight:
                                                              FontWeight.bold,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            itemView(index),
                                          ],
                                        );
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
              ),
            ],
          ),
          if (isLoading) Utility.progress(context)
        ],
      ),
    );
  }

  Widget button(BuildContext context) {
    return GestureDetector(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 8),
        // height: 50,
        // width: 100,
        // margin: EdgeInsets.all(16.0),
        margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(50),
            gradient: AppColors.lineargradient),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              averageRAting,
              style: const TextStyle(fontSize: 25, color: Colors.white),
            ),
            const SizedBox(
              width: 15,
            ),
            Icon(
              Formatter().ratingG(rating: averageRAting),
              color: AppColors.whiteColor,
            )
          ],
        ),
      ),
      // onTap: onpressed,
    );
  }

  Widget itemView(int index) {
    return ReviewsBox(
      images: listData[index].user?.imageUrl ?? '',
      name: listData[index].user?.name ?? '',
      date: Formatter()
          .dateformatG(date: listData[index].createdAt?.split('T').first ?? ""),
      description: listData[index].review ?? '',
      reviewCount: listData[index].rating ?? '0.0',
    );
  }
}
