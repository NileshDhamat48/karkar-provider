import 'package:karkar_provider_app/constants/all_imports.dart';

class LanguageWidget extends StatelessWidget {
  final String title;
  final num value;
  LanguageWidget({Key? key, required this.title, required this.value})
      : super(key: key);

  String? radio;
  @override
  Widget build(BuildContext context) {
    return Theme(
      data: ThemeData(unselectedWidgetColor: AppColors.whiteColor),
      child: Container(
        color: const Color(0xff232732),
        child: RadioListTile(
          activeColor: AppColors.whiteColor,
          title: const Text(
            'English',
            style: TextStyle(fontSize: 18, color: AppColors.whiteColor),
          ),
          value: "1",
          groupValue: radio,
          onChanged: (val) {
            setState(
              () {
                radio = val.toString();
              },
            );
          },
        ),
      ),
    );
  }

  void setState(Null Function() param0) {}
}
