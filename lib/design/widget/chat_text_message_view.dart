import 'package:karkar_provider_app/constants/all_imports.dart';

class ChatTextMessageView extends StatefulWidget {
  final String message;
  final String time;
  final bool isOtherUser;
  const ChatTextMessageView({
    Key? key,
    required this.message,
    required this.time,
    required this.isOtherUser,
  }) : super(key: key);

  @override
  _ChatTextMessageViewState createState() => _ChatTextMessageViewState();
}

class _ChatTextMessageViewState extends State<ChatTextMessageView> {
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
          decoration: BoxDecoration(
            color: widget.isOtherUser ? AppColors.whiteColor : AppColors.bodybgcolor,
            borderRadius: const BorderRadius.all(
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
