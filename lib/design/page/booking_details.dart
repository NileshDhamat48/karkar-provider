import 'package:karkar_provider_app/constants/all_imports.dart';
import 'package:karkar_provider_app/constants/app_strings.dart';
import 'package:karkar_provider_app/constants/formattor.dart';
import 'package:karkar_provider_app/design/widget/booking_details/booking_details_title.dart';
import 'package:karkar_provider_app/design/widget/booking_details/services_selected_list.dart';
import 'package:karkar_provider_app/design/widget/dialog.dart';
import 'package:karkar_provider_app/l10n/l10n.dart';
import 'package:karkar_provider_app/network/api_manager/api_manager.dart';
import 'package:karkar_provider_app/network/models/booking_model.dart';
import 'package:karkar_provider_app/network/response/booking_details_response.dart';
import 'package:karkar_provider_app/network/response/common_response.dart';
import 'package:url_launcher/url_launcher.dart';

class BookingDetails extends StatefulWidget {
  const BookingDetails({Key? key, required this.bookingModel})
      : super(key: key);
  final BookingModel bookingModel;

  @override
  _BookingDetailsState createState() => _BookingDetailsState();
}

class _BookingDetailsState extends State<BookingDetails> {
  bool isLoading = false;

  BookingDetailsResponse? bookingDetailsResponse;
  BookingModel? detailsData;

  @override
  void initState() {
    super.initState();

    if (widget.bookingModel.id != null) {
      bookingDetailAPi(widget.bookingModel.id!);
    }
  }

  Future bookingDetailAPi(int id) async {
    if (await ApiManager.checkInternet()) {
      _changeLoadingState(true);
      var request = <String, dynamic>{};
      BookingDetailsResponse bookingDetailsResponse =
          BookingDetailsResponse.fromJson(
        await ApiManager(context).getCall(
          AppStrings.bookingDetials(id),
          request,
        ),
      );

      if (bookingDetailsResponse.status == '1' &&
          bookingDetailsResponse.data != null) {
        detailsData = bookingDetailsResponse.data!;
      } else {
        Utility.showToast(msg: bookingDetailsResponse.message);
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.appbarBgColor,
      appBar: AppBar(
        automaticallyImplyLeading: true,
        backgroundColor: AppColors.appbarBgColor,
        leading: BackArrowWidget(
          onTap: () {
            Navigator.pop(context);
          },
        ),
        title: Text(
          AppLocalizations.of(context).bookingDetails,
          style: const TextStyle(fontSize: 20),
        ),
      ),
      body: Stack(
        children: [
          ListView(
            children: [
              Container(
                margin:
                    const EdgeInsets.symmetric(horizontal: 30, vertical: 30),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    bookedby(),
                    const Divider(
                      height: 20,
                      thickness: 1.5,
                      color: AppColors.blackColor,
                    ),
                    vehicle(),
                    const Divider(
                      height: 20,
                      thickness: 1.5,
                      color: AppColors.blackColor,
                    ),
                    detailsData?.isPickupDropIncluded != null &&
                            detailsData?.isPickupDropIncluded == 1
                        ? pickanddrop()
                        : BookingDetailsTitle(
                            detailsTitle: AppLocalizations.of(context).driveIn),
                    const SizedBox(
                      height: 5,
                    ),
                    const Divider(
                      height: 20,
                      thickness: 1.5,
                      color: AppColors.blackColor,
                    ),
                    dateandtime(),
                    const Divider(
                      height: 20,
                      thickness: 1.5,
                      color: AppColors.blackColor,
                    ),
                    paymentStatus(),
                    const Divider(
                      height: 20,
                      thickness: 1.5,
                      color: AppColors.blackColor,
                    ),
                    if (detailsData?.description != null) desc(),
                    if (detailsData?.description != null)
                      const Divider(
                        height: 20,
                        thickness: 1.5,
                        color: AppColors.blackColor,
                      ),
                    servicesSelected(),
                  ],
                ),
              ),
            ],
          ),
          isLoading ? Utility.progress(context) : const SizedBox(),
        ],
      ),
      bottomNavigationBar: detailsData?.status == 'REQUESTED' &&
              detailsData?.paymentStatus == 'UNPAID'
          ? Padding(
              padding: const EdgeInsets.only(
                left: 20.0,
                right: 20.0,
                bottom: 16.0,
                top: 8.0,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  button1(context),
                  const SizedBox(
                    width: 15,
                  ),
                  button2(context)
                ],
              ),
            )
          : detailsData?.paymentStatus == 'PAID' &&
                  detailsData?.status == 'ACCEPTED'
              ? cbutton(
                  text: AppLocalizations.of(context).finisheds,
                  onTap: () {
                    finishedDialogPopup();
                  },
                )
              : const SizedBox(),
    );
  }

  Column dateandtime() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        BookingDetailsTitle(
            detailsTitle: AppLocalizations.of(context).dateandTime),
        const SizedBox(
          height: 12,
        ),
        Text(
          Formatter().dateformatG(date: detailsData?.date ?? ''),
          style: const TextStyle(color: AppColors.whiteColor, fontSize: 16),
        ),
        const SizedBox(
          height: 5,
        ),
        Text(
          Formatter()
              .formatTimeG(time: detailsData?.timeFrom ?? '', context: context),
          style: const TextStyle(color: AppColors.greyColor, fontSize: 14),
        )
      ],
    );
  }

  desc() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        BookingDetailsTitle(detailsTitle: AppLocalizations.of(context).desc),
        const SizedBox(
          height: 12,
        ),
        Text(
          detailsData?.description ?? "",
          style: const TextStyle(
            color: AppColors.whiteColor,
            fontSize: 20,
          ),
        ),
      ],
    );
  }

  Widget servicesSelected() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        BookingDetailsTitle(
            detailsTitle: AppLocalizations.of(context).servicesSelected),
        const SizedBox(
          height: 8,
        ),

        detailsData?.services != null
            ? ListView.builder(
                shrinkWrap: true,
                itemCount: detailsData?.services?.length,
                physics: const NeverScrollableScrollPhysics(),
                itemBuilder: (context, index) {
                  return ServiceSelectedList(
                    serviceSelectedName:
                        detailsData!.services![index].title ?? "",
                    serviceSelectedPrice:
                        '€ ${detailsData!.services![index].pivot?.price ?? ""}',
                  );
                },
              )
            : const SizedBox(),
        const SizedBox(
          height: 8,
        ),

        if (detailsData?.isPickupDropIncluded == 1)
          ServiceSelectedList(
            serviceSelectedName: AppLocalizations.of(context).pickupDropCharge,
            serviceSelectedPrice: '€ 10',
          ),
        const SizedBox(
          height: 20,
        ),
        const Divider(
          height: 20,
          thickness: 1.5,
          color: AppColors.blackColor,
        ),
        // const SizedBox(
        //   height: 20,
        // ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              AppLocalizations.of(context).totalAmount,
              style: const TextStyle(color: AppColors.whiteColor, fontSize: 16),
            ),
            Text(
              '€ ${detailsData?.totalPrice ?? ""} ',
              style: const TextStyle(
                  color: AppColors.bookingDetailsIconcolor, fontSize: 18),
            ),
          ],
        ),
        const SizedBox(
          height: 20,
        ),
      ],
    );
  }

  Widget pickanddrop() {
    return GestureDetector(
      onTap: () {
        if (detailsData?.address?.latitude != null &&
            detailsData?.address?.latitude != '' &&
            detailsData?.address?.longitude != null &&
            detailsData?.address?.longitude != '') {
          Utility.urlLauncher(
            'https://www.google.com/maps/search/?api=1&query=${detailsData?.address?.latitude},${detailsData?.address?.longitude}',
          );
        } else {
          Utility.showToast(msg: AppLocalizations.of(context).noLocationFound);
        }
      },
      child: Container(
        color: AppColors.tranparentColor,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            BookingDetailsTitle(
                detailsTitle: AppLocalizations.of(context).pickupDrop),
            const SizedBox(
              height: 12,
            ),
            Text(
              AppLocalizations.of(context).arrangepickupanddropformthecustomer,
              style: const TextStyle(color: AppColors.greyColor, fontSize: 14),
            ),
            const SizedBox(
              height: 15,
            ),
            Text(
              AppLocalizations.of(context).pickupDeliveryAddress,
              style: const TextStyle(color: AppColors.whiteColor, fontSize: 14),
            ),
            Row(
              children: [
                Flexible(
                  child: Row(
                    children: [
                      Text(
                        "(${detailsData?.address?.title ?? ''})",
                        style: const TextStyle(
                            color: AppColors.whiteColor, fontSize: 12),
                      ),
                      Flexible(
                        child: Text(
                          detailsData?.address?.address ?? '',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                              color: AppColors.greyColor, fontSize: 12),
                        ),
                      ),
                    ],
                  ),
                ),
                const Icon(
                  Icons.navigation_sharp,
                  color: AppColors.bookingDetailsIconcolor,
                )
              ],
            ),
          ],
        ),
      ),
    );
  }

  vehicle() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        BookingDetailsTitle(detailsTitle: AppLocalizations.of(context).vehicle),
        const SizedBox(
          height: 12,
        ),
        if (detailsData?.vehicle != null)
          Text(
            "${detailsData?.vehicle?.brand?.title ?? ''} ${detailsData?.vehicle?.model ?? ''}",
            style: const TextStyle(color: AppColors.whiteColor, fontSize: 16),
          ),
        const SizedBox(
          height: 5,
        ),
        Text(
          detailsData?.vehicle?.carNumber ?? "",
          style: const TextStyle(color: AppColors.greyColor, fontSize: 14),
        )
      ],
    );
  }

  paymentStatus() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        BookingDetailsTitle(
            detailsTitle: AppLocalizations.of(context).paymentStatus),
        const SizedBox(
          height: 12,
        ),
        if (detailsData?.vehicle != null)
          Row(
            children: [
              Text(
                Formatter.paymentStatusDetailsString(
                  text: detailsData?.paymentStatus ?? '',
                  context: context,
                ),
                style:
                    const TextStyle(color: AppColors.whiteColor, fontSize: 16),
              ),
              if (detailsData?.paymentMethod != null)
                Text(
                  " (${Formatter.paymentMethodDetailsString(
                    text: detailsData?.paymentMethod ?? '',
                    context: context,
                  )})",
                  style: const TextStyle(
                      color: AppColors.whiteColor, fontSize: 16),
                ),
            ],
          ),
        const SizedBox(
          height: 8,
        ),
        Text(
          '€ ${detailsData?.totalPrice ?? ""}',
          style: const TextStyle(color: AppColors.greyColor, fontSize: 14),
        )
      ],
    );
  }

  bookedby() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            BookingDetailsTitle(
                detailsTitle: AppLocalizations.of(context).bookedBy),
            const SizedBox(
              height: 12,
            ),
            Text(
              detailsData?.user?.name ?? "",
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(color: AppColors.whiteColor, fontSize: 18),
            ),
            const SizedBox(
              height: 5,
            ),
            Text(
              detailsData?.user?.mobileNumber ?? '',
              style: const TextStyle(color: AppColors.greyColor, fontSize: 14),
            )
          ],
        ),
        Row(
          children: [
            GestureDetector(
              onTap: () {
                // if (detailsData?.user?.mobileNumber != '') {
                //   final Uri phoneLaunchUri = Uri(
                //     scheme: 'tel',
                //     path: detailsData?.user?.mobileNumber,
                //   );

                //   launch(phoneLaunchUri.toString());
                // } else {
                //   Utility.showToast(
                //       msg: AppLocalizations.of(context).nophonenumberfound);
                // }
              },
              child: Container(
                margin: const EdgeInsets.only(top: 40),
                child: const Icon(
                  Icons.message,
                  color: AppColors.bookingDetailsIconcolor,
                ),
              ),
            ),
            const SizedBox(
              width: 20,
            ),
            GestureDetector(
              onTap: () {
                if (detailsData?.user?.mobileNumber != '') {
                  final Uri phoneLaunchUri = Uri(
                    scheme: 'tel',
                    path: detailsData?.user?.mobileNumber,
                  );

                  launch(phoneLaunchUri.toString());
                } else {
                  Utility.showToast(
                      msg: AppLocalizations.of(context).nophonenumberfound);
                }
              },
              child: Container(
                margin: const EdgeInsets.only(top: 40),
                child: const Icon(
                  Icons.phone,
                  color: AppColors.bookingDetailsIconcolor,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget button1(BuildContext context) {
    return GestureDetector(
      onTap: () {
        acceptDialogPopup();
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
        // margin: EdgeInsets.all(16.0),
        // margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(50),
            gradient: AppColors.lineargradient),
        child: Text(
          AppLocalizations.of(context).accept,
          style: const TextStyle(color: AppColors.whiteColor, fontSize: 18),
        ),
      ),
      // onTap: onpressed,
    );
  }

  Widget button2(BuildContext context) {
    return GestureDetector(
      onTap: () {
        rejectDialogPopup();
      },
      child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
          // margin: EdgeInsets.all(16.0),
          // margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(50),
              gradient: AppColors.lineargradient),
          child: Text(
            AppLocalizations.of(context).reject,
            style: const TextStyle(color: AppColors.whiteColor, fontSize: 18),
          )),
      // onTap: onpressed,
    );
  }

  Widget cbutton({
    VoidCallback? onTap,
    required String text,
    EdgeInsetsGeometry? margin,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
        margin: margin ?? const EdgeInsets.all(16),
        // margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(50),
          gradient: const LinearGradient(
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
            colors: [Colors.green, Colors.blue],
          ),
        ),
        child: Text(
          text,
          textAlign: TextAlign.center,
          style: const TextStyle(color: AppColors.whiteColor, fontSize: 22),
        ),
      ),
      // onTap: onpressed,
    );
  }

  rejectDialogPopup() {
    DailogBox.logoutDialog(
      title: AppLocalizations.of(context).reject,
      message:
          AppLocalizations.of(context).areyousureyouwanttorejectthisrequest,
      context: context,
      onNoTap: () {
        Navigator.pop(context);
      },
      onYesTap: () {
        Navigator.pop(context);
        deleterequestAPI(widget.bookingModel.id!);
      },
    );
  }

  finishedDialogPopup() {
    DailogBox.logoutDialog(
      title: AppLocalizations.of(context).finished,
      message:
          AppLocalizations.of(context).areyousureyouwanttofinishthisrequest,
      context: context,
      onNoTap: () {
        Navigator.pop(context);
      },
      onYesTap: () {
        Navigator.pop(context);
        finisedrequestAPI(widget.bookingModel.id!);
      },
    );
  }

  Future finisedrequestAPI(int id) async {
    if (await ApiManager.checkInternet()) {
      _changeLoadingState(true);

      var request = <String, dynamic>{};

      CommonResponse commonResponse = CommonResponse.fromJson(
        await ApiManager(context)
            .postCall(AppStrings.finisedBooking(id), request),
      );

      if (commonResponse.status == '1') {
        Navigator.pop(context, 'refresh');

        Utility.showToast(msg: commonResponse.message);
      } else {
        Utility.showToast(msg: commonResponse.message);
      }
      _changeLoadingState(false);
    } else {
      Utility.showToast(msg: AppLocalizations.of(context).noInternet);
    }
  }

  acceptDialogPopup() {
    DailogBox.logoutDialog(
      title: AppLocalizations.of(context).accept,
      message:
          AppLocalizations.of(context).areyousureyouwanttoacceptthisrequest,
      context: context,
      onNoTap: () {
        Navigator.pop(context);
      },
      onYesTap: () {
        Navigator.pop(context);
        acceptRequestAPI(widget.bookingModel.id!);
      },
    );
  }

  Future deleterequestAPI(int id) async {
    if (await ApiManager.checkInternet()) {
      _changeLoadingState(true);

      var request = <String, dynamic>{};

      CommonResponse commonResponse = CommonResponse.fromJson(
        await ApiManager(context)
            .postCall(AppStrings.deleteBooking(id), request),
      );

      if (commonResponse.status == '1') {
        Navigator.pop(context, 'refresh');

        Utility.showToast(msg: commonResponse.message);
      } else {
        Utility.showToast(msg: commonResponse.message);
      }
      _changeLoadingState(false);
    } else {
      Utility.showToast(msg: AppLocalizations.of(context).noInternet);
    }
  }

  Future acceptRequestAPI(int id) async {
    if (await ApiManager.checkInternet()) {
      _changeLoadingState(true);

      var request = <String, dynamic>{};

      CommonResponse commonResponse = CommonResponse.fromJson(
        await ApiManager(context)
            .postCall(AppStrings.acceptBooking(id), request),
      );

      if (commonResponse.status == '1') {
        Navigator.pop(context, 'refresh');

        Utility.showToast(msg: commonResponse.message);
      } else {
        Utility.showToast(msg: commonResponse.message);
      }
      _changeLoadingState(false);
    } else {
      Utility.showToast(msg: AppLocalizations.of(context).noInternet);
    }
  }
}
