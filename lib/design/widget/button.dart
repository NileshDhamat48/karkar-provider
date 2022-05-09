import 'package:karkar_provider_app/constants/all_imports.dart';
import 'package:karkar_provider_app/constants/app_dimens.dart';

class CommonButton extends StatelessWidget {
  Gradient? gradient;
  String text;
  VoidCallback onpressed;

  CommonButton({
    Key? key,
    required this.text,
    required this.onpressed,
    this.gradient,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: Container(
        height: AppDimens.buttonHeight,
        width: MediaQuery.of(context).size.width * 4,
        // margin: EdgeInsets.all(16.0),
        margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(50),
            gradient: gradient ?? AppColors.lineargradientGreenfirst
            // gradient:  LinearGradient(
            //     begin: Alignment.centerLeft,
            //     end: Alignment.centerRight,
            //     colors: [Colors.green, Colors.blue]),
            ),
        child: Center(
          child: Text(
            text,
            style: const TextStyle(fontSize: 18, color: Colors.white),
          ),
        ),
      ),
      onTap: onpressed,
    );
  }
}
