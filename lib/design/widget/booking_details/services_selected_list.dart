import 'package:karkar_provider_app/constants/all_imports.dart';

class ServiceSelectedList extends StatelessWidget {
  final String serviceSelectedName;
  final String serviceSelectedPrice;
  const ServiceSelectedList({
    Key? key,
    required this.serviceSelectedName,
    required this.serviceSelectedPrice,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          serviceSelectedName,
          style: const TextStyle(color: AppColors.whiteColor, fontSize: 16),
        ),
        Text(
          serviceSelectedPrice,
          style: const TextStyle(color: AppColors.whiteColor, fontSize: 16),
        ),
      ],
    );
  }
}
