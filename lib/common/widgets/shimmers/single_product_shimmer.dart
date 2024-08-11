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
          child: Center(child: TShimmerEffect(height: mainImageHeight, width: mainImageHeight, radius: TSizes.productImageRadius,)),
        ),
        const SizedBox(height: TSizes.spaceBtwItems),
        SizedBox(
          height: galleryImageHeight,
          child: ListView.separated(
            itemCount: 5,
            shrinkWrap: true,
            scrollDirection: Axis.horizontal,
            physics: const AlwaysScrollableScrollPhysics(),
            separatorBuilder: (_,__) => const SizedBox(width: TSizes.spaceBtwItems),
            itemBuilder: (_, index) => const TShimmerEffect(height: galleryImageHeight, width: galleryImageHeight, radius: TSizes.productImageRadius,)
          )
        ),
        const SizedBox(height: TSizes.spaceBtwSection),
        const TShimmerEffect(width: 100, height: 10, radius: 0,),
        const SizedBox(height: TSizes.spaceBtwInputFields),
        const TShimmerEffect(width: double.infinity, height: 25, radius: 0,),
        const SizedBox(height: TSizes.spaceBtwItems),
        const TShimmerEffect(width: 300, height: 25, radius: 0,),
        const SizedBox(height: TSizes.spaceBtwSection),
        const TShimmerEffect(width: 150, height: 15),
        const SizedBox(height: TSizes.spaceBtwItems),
        const TShimmerEffect(width: 100, height: 15),
      ],
    );
  }
}
