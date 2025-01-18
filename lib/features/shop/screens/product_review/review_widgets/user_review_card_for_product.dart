import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:get/get.dart';
import 'package:readmore/readmore.dart';

import '../../../../../common/widgets/custom_shape/image/circular_image.dart';
import '../../../../../utils/constants/colors.dart';
import '../../../../../utils/constants/icons.dart';
import '../../../../../utils/constants/image_strings.dart';
import '../../../../../utils/constants/sizes.dart';
import '../../../../../utils/formatters/formatters.dart';
import '../../../../../utils/validators/validation.dart';
import '../../../../personalization/controllers/user_controller.dart';
import '../../../controllers/product/image_controller.dart';
import '../../../controllers/product/product_review_controller.dart';
import '../../../models/product_review_model.dart';
import '../../product_detail/products_widgets/product_title_text.dart';
import '../update_product_review.dart';

class SingleReviewCard extends StatelessWidget {
  SingleReviewCard({super.key, required this.review});

  ReviewModel review;
  @override
  Widget build(BuildContext context) {
    final imagesController = Get.put(ImagesController());

    final imageSize = 40.0;
    // Using Html widget to parse HTML text
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TRoundedImage(
              image: review.reviewerAvatarUrl ?? TImages.tProfileImage,
              height: imageSize,
              width: imageSize,
              borderRadius: 50,
              isNetworkImage: true,
            ),
            const SizedBox(width: TSizes.spaceBtwItems,),
            SizedBox(
              width: 210,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                      review.review!.replaceAll('<p>', '').replaceAll('</p>', '').replaceAll('<br />', ''),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context).textTheme.bodySmall
                  ),
                  const SizedBox(height: TSizes.xs),
                  Flexible(
                    child: RatingBarIndicator(
                      rating: review.rating!.toDouble(),
                      itemSize: 12,
                      unratedColor: Colors.grey[300],
                      itemBuilder: (_, __) =>  Icon(TIcons.starRating, color: TColors.ratingStar),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        review.image != ''
            ? GestureDetector(
              onTap: () => imagesController.showEnlargedImage(review.image ?? ""),
              child: TRoundedImage(
                image: review.image ?? "",
                height: 60,
                width: 50,
                backgroundColor: Colors.transparent,
                borderRadius: 0,
                isNetworkImage: true,
              ),
            )
            : SizedBox.shrink(),
      ],
    );
  }
}
