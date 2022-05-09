import 'package:flutter/material.dart';
import 'package:karkar_provider_app/constants/all_imports.dart';
import 'package:karkar_provider_app/constants/app_asstes.dart';
import 'package:karkar_provider_app/design/widget/gradient_text.dart';
import 'package:karkar_provider_app/l10n/l10n.dart';

class ServicesCardWidget extends StatelessWidget {
  const ServicesCardWidget(
      {Key? key,
      t,
      required this.image,
      required this.title,
      required this.isSubCategory,
      this.isChecked,
      this.onChanged,
      this.onTap,
      this.isCheckBoxVisible = false,
      required this.price})
      : super(key: key);

  final String image, title, price;
  final bool isSubCategory;
  final bool? isChecked;
  final VoidCallback? onTap;
  final ValueChanged<bool?>? onChanged;

  final bool isCheckBoxVisible;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(top: 20, right: 16),
        color: AppColors.tranparentColor,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Container(
              width: 60,
              height: 60,
              decoration: BoxDecoration(
                  shape: BoxShape.circle, color: AppColors.greyText),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(300),
                child: Utility.imageLoader(
                  image,
                  AppAssets().logo,
                  BoxFit.cover,
                ),
              ),
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    margin: const EdgeInsets.only(left: 20.0),
                    child: Text(
                      title,
                      style: TextStyle(
                          fontSize: 18, color: AppColors.lightGreyColor),
                    ),
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  if (isSubCategory)
                    Container(
                      margin: const EdgeInsets.only(left: 20.0),
                      child: Text(
                        AppLocalizations.of(context).subCategories,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                            fontSize: 14, color: AppColors.greyColor),
                      ),
                    )
                ],
              ),
            ),
            // if (price.isNotEmpty)
            //   Text(
            //     '€ $price',
            //     style:
            //         const TextStyle(color: AppColors.whiteColor, fontSize: 18),
            //   ),
            if (isSubCategory)
              Text(
                price.isNotEmpty ? '€ $price' : '',
                style:
                    const TextStyle(color: AppColors.whiteColor, fontSize: 18),
              )
            else
              GradientText(
                text: price.isNotEmpty ? '€ $price' : '',
                style:
                    const TextStyle(color: AppColors.whiteColor, fontSize: 18),
              ),
            if (isCheckBoxVisible)
              Checkbox(
                value: isChecked,
                activeColor: AppColors.bookingDetailsIconcolor,
                side: const BorderSide(
                  color: AppColors.whiteColor,
                  width: 2,
                ),
                onChanged: onChanged,
              ),
          ],
        ),
      ),
    );
  }
}
