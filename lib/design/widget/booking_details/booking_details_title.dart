import 'package:karkar_provider_app/constants/all_imports.dart';

class BookingDetailsTitle extends StatelessWidget {
  final String detailsTitle;
  const BookingDetailsTitle({
    Key? key,
    required this.detailsTitle,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 10),
      child: Text(
        detailsTitle,
        style: const TextStyle(
          color: AppColors.bookingDetailscolor,
          fontSize: 16,
        ),
      ),
    );
  }
}
