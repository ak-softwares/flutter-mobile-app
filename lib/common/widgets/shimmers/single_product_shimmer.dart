import 'package:flutter/material.dart';

import '../../../utils/constants/sizes.dart';
import 'shimmer_effect.dart';
class SingleProductShimmer extends StatelessWidget {
  const SingleProductShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    const double mainImageHeight = 340;
    const double galleryImageHeight = 80;
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(
          height: mainImageHeight, //Main image height
          width: double.infinity,
          child: Center(child: ShimmerEffect(height: mainImageHeight, width: mainImageHeight, radius: Sizes.productImageRadius,)),
        ),
        const SizedBox(height: Sizes.spaceBtwItems),
        SizedBox(
          height: galleryImageHeight,
          child: ListView.separated(
            itemCount: 5,
            shrinkWrap: true,
            scrollDirection: Axis.horizontal,
            physics: const AlwaysScrollableScrollPhysics(),
            separatorBuilder: (_,__) => const SizedBox(width: Sizes.spaceBtwItems),
            itemBuilder: (_, index) => const ShimmerEffect(height: galleryImageHeight, width: galleryImageHeight, radius: Sizes.productImageRadius,)
          )
        ),
        const SizedBox(height: Sizes.spaceBtwSection),
        const ShimmerEffect(width: 100, height: 10, radius: 0,),
        const SizedBox(height: Sizes.spaceBtwInputFields),
        const ShimmerEffect(width: double.infinity, height: 25, radius: 0,),
        const SizedBox(height: Sizes.spaceBtwItems),
        const ShimmerEffect(width: 300, height: 25, radius: 0,),
        const SizedBox(height: Sizes.spaceBtwSection),
        const ShimmerEffect(width: 150, height: 15),
        const SizedBox(height: Sizes.spaceBtwItems),
        const ShimmerEffect(width: 100, height: 15),
      ],
    );
  }
}
