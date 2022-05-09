import 'package:karkar_provider_app/constants/all_imports.dart';
import 'package:karkar_provider_app/constants/app_strings.dart';
import 'package:karkar_provider_app/constants/formattor.dart';
import 'package:karkar_provider_app/constants/style.dart';
import 'package:karkar_provider_app/design/page/booking_details.dart';
import 'package:karkar_provider_app/design/page/booking_history.dart';
import 'package:karkar_provider_app/design/widget/my_booking_widget.dart';
import 'package:karkar_provider_app/l10n/l10n.dart';
import 'package:karkar_provider_app/network/api_manager/api_manager.dart';
import 'package:karkar_provider_app/network/models/booking_model.dart';
import 'package:karkar_provider_app/network/response/booking_response.dart';
import 'package:visibility_detector/visibility_detector.dart';

class MyBookingPage extends StatefulWidget {
  const MyBookingPage({Key? key}) : super(key: key);
  static const String _title = '';

  Widget build(BuildContext context) {
    return const MaterialApp(
      title: _title,
    );
  }

  @override
  _MyBookingPageState createState() => _MyBookingPageState();
}

class _MyBookingPageState extends State<MyBookingPage> {
  List<BookingModel> upcommingListData = [];
  BookingResponse? bookingResponse;
  bool isLoading = false;
  bool isLoadingPage = false;

  int page = 0;
  bool stop = false;

  @override
  void initState() {
    super.initState();

    reviewListDataApi(true);
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
      request['type'] = "UPCOMING";

      BookingResponse bookingResponse = BookingResponse.fromJson(
        await ApiManager(context).getCall(
          AppStrings.bookingList,
          request,
        ),
      );

      if (bookingResponse.status == '1' &&
          bookingResponse.data != null &&
          bookingResponse.data!.isNotEmpty) {
        upcommingListData.addAll(bookingResponse.data!);
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
    upcommingListData.clear();
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
      backgroundColor: AppColors.appbarBgColor,
      appBar: AppBar(
        automaticallyImplyLeading: true,
        backgroundColor: AppColors.appbarBgColor,
        centerTitle: true,
        title: Text(
          AppLocalizations.of(context).myBookings,
          style: TextStyle(
            color: AppColors.whiteColor,
            fontWeight: FontWeight.w500,
            fontSize: Style().tStyle15(context),
          ),
        ),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const BookingHistorypage(),
                ),
              );
            },
            icon: const Icon(
              Icons.history,
              color: AppColors.greyColor,
              size: 25,
            ),
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          _refresh();
        },
        child: Stack(
          children: [
            upcommingListData.isNotEmpty
                ? Column(
                    children: [
                      Flexible(
                        child: ListView.builder(
                          itemCount: upcommingListData.length,
                          shrinkWrap: false,
                          padding: const EdgeInsets.only(
                              bottom: 10, left: 10, right: 10),
                          itemBuilder: (context, index) {
                            return (upcommingListData.length - 1) == index
                                ? VisibilityDetector(
                                    key: Key(index.toString()),
                                    child: itemView(index),
                                    onVisibilityChanged: (val) {
                                      if (!stop &&
                                          index ==
                                              upcommingListData.length - 1) {
                                        reviewListDataApi(false);
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
                : !isLoading
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
    return MyBookingWidget(
      onTap: () async {
        var referesh = await Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => BookingDetails(
              bookingModel: upcommingListData[index],
            ),
          ),
        );
        if (referesh != null) {
          _refresh();
        }
      },
      images: upcommingListData[index].user?.imageUrl ?? '',
      name: upcommingListData[index].user?.name ?? '',
      pickuplocation: upcommingListData[index].isPickupDropIncluded != null &&
              upcommingListData[index].isPickupDropIncluded == 1
          ? AppLocalizations.of(context).pickup
          : upcommingListData[index].isPickupDropIncluded == 0
              ? AppLocalizations.of(context).drivein
              : '',
      vehiclename: upcommingListData[index].vehicle != null &&
              upcommingListData[index].vehicle?.brand != null &&
              upcommingListData[index].vehicle?.brand?.title != null
          ? "${upcommingListData[index].vehicle?.brand?.title ?? ''} ${upcommingListData[index].vehicle?.model ?? ''}"
          : '',
      dateandtime: Formatter().dateTImeformatG(
          date: upcommingListData[index].date ?? '',
          time: upcommingListData[index].timeFrom ?? ""),
      bookingfor: upcommingListData[index].services != null
          ? upcommingListData[index].services!.map((e) => e.title).join(' ')
          : '',
      status: Formatter.statusString(
          text: upcommingListData[index].status ?? '', context: context),
      paymentStatus: Formatter.paymentStatusString(
          text: upcommingListData[index].paymentStatus ?? '', context: context),
      statusColor:
          Formatter.statusColor(text: upcommingListData[index].status ?? ""),
      paymentStatusColor: Formatter.paymentStatusColor(
          text: upcommingListData[index].paymentStatus ?? ""),
    );
  }
}
