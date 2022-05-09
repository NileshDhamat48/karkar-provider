import 'package:karkar_provider_app/constants/all_imports.dart';
import 'package:responsive_builder/responsive_builder.dart';

import '../../constants/app_asstes.dart';

class ChatImageMessageView extends StatelessWidget {
  const ChatImageMessageView({
    Key? key,
    required this.isOtherUser,
    required this.image,
    required this.time,
    required this.onTap,
  }) : super(key: key);

  final bool isOtherUser;
  final String image;
  final String time;
  final Function() onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        alignment: isOtherUser ? Alignment.centerLeft : Alignment.centerRight,
        child: Material(
          color: AppColors.bodybgcolor,
          child: Stack(
            children: [
              SizedBox(
                height: getValueForScreenType(
                  context: context,
                  mobile: 230,
                  tablet: 300,
                ),
                width: getValueForScreenType(
                  context: context,
                  mobile: 230,
                  tablet: 300,
                ),
                child: Utility.imageLoader(
                  image,
                  AppAssets().logo,
                  BoxFit.cover,
                ),
              ),
              Positioned(
                bottom: 3,
                right: 3,
                child: Container(
                  padding: const EdgeInsets.all(2),
                  decoration: BoxDecoration(
                    color: AppColors.whiteColor.withOpacity(0.4),
                    borderRadius: BorderRadius.circular(5),
                  ),
                  child: Text(
                    time,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      color: AppColors.blackColor,
                      fontSize: 12,
                    ),
                  ),
                ),
              ),
            ],
          ),
          borderRadius: const BorderRadius.all(Radius.circular(8.0)),
          clipBehavior: Clip.hardEdge,
        ),
        margin: const EdgeInsets.only(bottom: 10),
      ),
    );
  }
}
