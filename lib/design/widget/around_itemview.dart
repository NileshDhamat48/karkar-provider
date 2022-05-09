import 'package:karkar_provider_app/constants/all_imports.dart';

class AroundItemView extends StatefulWidget {
  const AroundItemView({
    Key? key,
    required this.isChecked,
    required this.title,
    this.onTap,
    this.onChanged,
  }) : super(key: key);

  final String title;
  final bool isChecked;
  final VoidCallback? onTap;
  final ValueChanged<bool?>? onChanged;

  @override
  _AroundItemViewState createState() => _AroundItemViewState();
}

class _AroundItemViewState extends State<AroundItemView> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onTap,
      child: Container(
        color: AppColors.tranparentColor,
        padding: const EdgeInsets.only(left: 16, top: 8, right: 16, bottom: 8),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              widget.title,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(fontSize: 18, color: AppColors.lightGreyColor),
            ),
            Checkbox(
              value: widget.isChecked,
              activeColor: AppColors.bookingDetailsIconcolor,
              side: const BorderSide(
                color: AppColors.whiteColor,
                width: 2,
              ),
              onChanged: widget.onChanged,
            ),
          ],
        ),
      ),
    );
  }
}
