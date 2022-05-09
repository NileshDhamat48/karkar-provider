import 'package:karkar_provider_app/constants/all_imports.dart';

class ChatPaymentMessageView extends StatefulWidget {
  final String message;
  final String time;
  final bool isOtherUser;
  final String paymentStatus;
  final String price;
  const ChatPaymentMessageView(
      {Key? key,
      required this.message,
      required this.time,
      required this.isOtherUser,
      required this.paymentStatus,
      required this.price})
      : super(key: key);

  @override
  _ChatPaymentMessageViewState createState() => _ChatPaymentMessageViewState();
}

class _ChatPaymentMessageViewState extends State<ChatPaymentMessageView> {
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: widget.isOtherUser ? MainAxisAlignment.start : MainAxisAlignment.end,
      children: [
        Container(
          padding: const EdgeInsets.only(
            left: 16,
            right: 10,
            top: 16,
            bottom: 16,
          ),
          constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.7),
          decoration: const BoxDecoration(
            color: AppColors.bookingDetailscolor,
            borderRadius: BorderRadius.all(
              Radius.circular(20),
            ),
          ),
          margin: const EdgeInsets.only(
            top: 8,
            bottom: 8,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                widget.message,
                style: TextStyle(
                  color: widget.isOtherUser ? AppColors.blackColor : AppColors.whiteColor,
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              ),
              // const SizedBox(
              //   height: 4,
              // ),
              Text(
                '${widget.price} €',
                style: TextStyle(
                  color: widget.isOtherUser ? AppColors.blackColor : AppColors.whiteColor,
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(
                height: 4,
              ),
              Text(
                widget.paymentStatus,
                style: TextStyle(
                  color: widget.isOtherUser ? AppColors.blackColor : AppColors.whiteColor,
                  fontSize: 14,
                ),
              ),
              const SizedBox(
                height: 4,
              ),
              Row(
                mainAxisAlignment: widget.isOtherUser ? MainAxisAlignment.end : MainAxisAlignment.end,
                children: [
                  Flexible(
                    child: Text(
                      widget.time,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: AppColors.greyText,
                        fontSize: 12,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}
