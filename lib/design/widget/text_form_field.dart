import 'package:karkar_provider_app/constants/all_imports.dart';

class TextFormFieldWidget extends StatefulWidget {
  final String textfieldname;
  final TextInputType keyboardtype;

  const TextFormFieldWidget({
    Key? key,
    required this.textfieldname,
    required this.keyboardtype,
  }) : super(key: key);

  @override
  State<TextFormFieldWidget> createState() => _TextFormFieldWidgetState();
}

class _TextFormFieldWidgetState extends State<TextFormFieldWidget> {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(left: 35, right: 35),
      child: TextFormField(
        style: const TextStyle(color: AppColors.whiteColor),
        decoration: InputDecoration(
          label: Text(
            widget.textfieldname,
            style: const TextStyle(color: AppColors.greyColor, fontSize: 18),
          ),
        ),
        keyboardType: widget.keyboardtype,
      ),
    );
  }
}
