import 'package:karkar_provider_app/constants/all_imports.dart';
import 'package:karkar_provider_app/constants/app_asstes.dart';
import 'package:karkar_provider_app/design/widget/gradient_text.dart';
import 'package:karkar_provider_app/l10n/l10n.dart';

class MyBookingWidget extends StatefulWidget {
  final String images;
  final String name;
  final String pickuplocation;
  final String vehiclename;
  final String dateandtime;
  final String bookingfor;
  final VoidCallback? onTap;
  final String status;
  final String? paymentStatus;
  final Gradient? statusColor;
  final Gradient? paymentStatusColor;
  const MyBookingWidget(
      {Key? key,
      required this.images,
      required this.name,
      required this.status,
      required this.pickuplocation,
      required this.vehiclename,
      required this.dateandtime,
      this.paymentStatus,
      this.statusColor,
      this.paymentStatusColor,
      required this.onTap,
      required this.bookingfor})
      : super(key: key);

  @override
  State<MyBookingWidget> createState() => _MyBookingWidgetState();
}

class _MyBookingWidgetState extends State<MyBookingWidget> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onTap,
      child: Container(
        margin: const EdgeInsets.only(
          bottom: 10,
        ),
        padding: const EdgeInsets.only(top: 8, bottom: 8, left: 5),
        color: AppColors.glassEffact,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              margin: const EdgeInsets.only(left: 10, top: 16),
              height: 50,
              width: 50,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(300),
                color: AppColors.appbarBgColor,
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(300),
                child: Utility.imageLoader(
                  widget.images,
                  AppAssets().logo,
                  BoxFit.cover,
                ),
              ),
            ),
            const SizedBox(
              width: 8,
            ),
            Flexible(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(
                    height: 16,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        widget.name,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          color: AppColors.whiteColor,
                          fontSize: 16,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(right: 16),
                        child: GradientText(
                          text: widget.status,
                          gradient: widget.statusColor,
                          style: const TextStyle(
                            fontSize: 16,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 3,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        widget.pickuplocation,
                        style: const TextStyle(
                          fontSize: 16,
                          color: AppColors.greyColor,
                        ),
                      ),
                      if (widget.paymentStatus != null)
                        Container(
                          height: 5,
                          width: 5,
                          alignment: Alignment.center,
                          margin: const EdgeInsets.symmetric(horizontal: 8),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            gradient: widget.paymentStatusColor ??
                                AppColors.greyGradient,
                          ),
                        ),
                      if (widget.paymentStatus != null &&
                          widget.paymentStatus != null &&
                          widget.paymentStatus != '')
                        GradientText(
                          text: widget.paymentStatus ?? '',
                          gradient: widget.paymentStatusColor ??
                              AppColors.greyGradient,
                          style: const TextStyle(
                            fontSize: 16,
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  SizedBox(
                    // color: Colors.amber,
                    height: 90,
                    width: 300,

                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Text(
                              AppLocalizations.of(context).vehicle,
                              style: TextStyle(
                                  color: AppColors.greyText, fontSize: 16),
                            ),
                            const SizedBox(
                              width: 47,
                            ),
                            Flexible(
                              child: Text(
                                widget.vehiclename,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                    color: AppColors.whiteColor, fontSize: 16),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Text(
                              AppLocalizations.of(context).dateandTime,
                              style: TextStyle(
                                  color: AppColors.greyText, fontSize: 16),
                            ),
                            const SizedBox(
                              width: 13,
                            ),
                            Flexible(
                              child: Text(
                                widget.dateandtime,
                                maxLines: 1,
                                overflow: TextOverflow.visible,
                                style: const TextStyle(
                                    color: AppColors.whiteColor, fontSize: 16),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Text(
                              AppLocalizations.of(context).bookingfor,
                              style: TextStyle(
                                  color: AppColors.greyText, fontSize: 16),
                            ),
                            const SizedBox(
                              width: 18,
                            ),
                            Flexible(
                              child: Text(
                                widget.bookingfor,
                                maxLines: 1,
                                style: const TextStyle(
                                    color: AppColors.whiteColor, fontSize: 16),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
