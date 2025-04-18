import '../../../utils/constants/image_strings.dart';
import '../../styles/spacing_style.dart';
import '../../text/section_heading.dart';
import '../custom_shape/containers/rounded_container.dart';
import '../custom_shape/image/circular_image.dart';
import '/common/widgets/shimmers/shimmer_effect.dart';
import 'package:flutter/material.dart';

import '../../../utils/constants/sizes.dart';

class ReviewShimmerOnProduct extends StatelessWidget {
  const ReviewShimmerOnProduct({super.key, this.height = 50 });

  final double height;

  @override
  Widget build(BuildContext context) {
    return RoundedContainer(
      radius: 10,
      backgroundColor: Theme.of(context).colorScheme.surface,
      child: Padding(
        padding: const EdgeInsets.all(AppSizes.defaultSpace),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text('Reviews ', style: Theme.of(context).textTheme.bodyMedium!.copyWith(fontWeight: FontWeight.w600)),
                ShimmerEffect(width: 50, height: 13),
              ],
            ),
            const SizedBox(height: AppSizes.sm),
            SizedBox(
              height: height,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  RoundedImage(
                    image: Images.tProfileImage,
                    height: 40,
                    width: 40,
                    borderRadius: 50,
                    isNetworkImage: false,
                  ),
                  const SizedBox(width: AppSizes.spaceBtwItems,),
                  SizedBox(
                    width: 210,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ShimmerEffect(width: 200, height: 13),
                        const SizedBox(height: AppSizes.xs),
                        ShimmerEffect(width: 50, height: 13),
                      ],
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
