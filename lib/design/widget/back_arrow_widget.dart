import 'package:karkar_provider_app/constants/all_imports.dart';

class BackArrowWidget extends StatelessWidget {
  const BackArrowWidget({
    Key? key,
    required this.onTap,
  }) : super(key: key);

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: const Icon(
        Icons.arrow_back_ios_new_outlined,
      ),
      // iconSize: RSize().backArrowIconSize(context),
      iconSize: 22,
      color: const Color(0xff56a6a1),
      onPressed: onTap,
      tooltip: MaterialLocalizations.of(context).openAppDrawerTooltip,
    );
  }
}
