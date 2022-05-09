import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:karkar_provider_app/constants/all_imports.dart';
import 'package:karkar_provider_app/constants/app_asstes.dart';

class ReviewsBox extends StatelessWidget {
  final String name;
  final String images;
  final String date;
  final String reviewCount;
  final String description;
  const ReviewsBox({
    Key? key,
    required this.images,
    required this.name,
    required this.date,
    required this.description,
    required this.reviewCount,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 1),
      color: AppColors.glassEffact,
      // margin: EdgeInsets.only(top: 10),
      padding: const EdgeInsets.only(left: 16, right: 16, bottom: 16),
      // padding: EdgeInsets.only(top: 5, left: 0),
      // decoration: BoxDecoration(
      //   borderRadius: BorderRadius.all(
      //     Radius.circular(10),
      //   ),
      //   color: Colors.amber,
      // ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                margin: const EdgeInsets.only(left: 10, top: 20),
                height: 55,
                width: 55,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(100),
                  child: Utility.imageLoader(
                    images,
                    AppAssets().logo,
                    BoxFit.cover,
                  ),
                ),
              ),
              const SizedBox(
                width: 12,
              ),
              Flexible(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(
                      height: 20,
                    ),
                    Text(
                      name,
                      style: const TextStyle(
                        letterSpacing: 0.6,
                        color: AppColors.whiteColor,
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          date,
                          style: const TextStyle(
                            letterSpacing: 0.6,
                            color: AppColors.greyColor,
                            fontSize: 13,
                            fontWeight: FontWeight.normal,
                          ),
                        ),
                        RatingBar.builder(
                          updateOnDrag: false,
                          initialRating: double.parse(reviewCount),
                          minRating: 1,
                          direction: Axis.horizontal,
                          allowHalfRating: true,
                          ignoreGestures: true,
                          unratedColor: AppColors.whiteColor,
                          itemCount: 5,
                          itemSize: 20,
                          itemPadding:
                              const EdgeInsets.symmetric(horizontal: 0),
                          itemBuilder: (context, _) => const Icon(
                            Icons.star,
                            color: AppColors.reviewwIconColor,
                          ),
                          onRatingUpdate: (rating) {},
                        )
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(
            height: 16,
          ),
          Text(
            description,
            style: const TextStyle(
              letterSpacing: 0.6,
              color: AppColors.whiteColor,
              fontSize: 13,
              fontWeight: FontWeight.normal,
            ),
          ),
        ],
      ),
    );
  }
}
