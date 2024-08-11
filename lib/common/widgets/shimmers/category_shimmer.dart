import '/common/widgets/shimmers/shimmer_effect.dart';
import 'package:flutter/material.dart';

import '../../../utils/constants/sizes.dart';

class TCategoryShimmer extends StatelessWidget {

  const TCategoryShimmer({
    super.key,
    this.imageDimension = 85,
    this.imageRadius = TSizes.defaultRadius,
    this.isCategoryScreenTrue = false,
    this.itemCount = 4,
  });

  final double imageDimension;
  final double imageRadius;
  final bool isCategoryScreenTrue;
  final int itemCount;

  @override
  Widget build(BuildContext context) {
    return isCategoryScreenTrue
        ? GridView.builder(
            gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
              maxCrossAxisExtent: 100,
              mainAxisExtent: 130,
              crossAxisSpacing: TSizes.spaceBtwItems,
            ),
            shrinkWrap: true,
            itemCount: itemCount,
            itemBuilder: (_, __) {
              return  Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  //Image
                  TShimmerEffect(width: imageDimension, height: imageDimension, radius: imageRadius),

                  const SizedBox(height: TSizes.spaceBtwItems),

                  //Text
                  TShimmerEffect(width: imageDimension, height: 10),
                ],
              );
            },
          )
        : SizedBox(
            height: imageDimension + imageDimension/2,
            child: ListView.separated(
                shrinkWrap: true,
                itemCount: itemCount,
                scrollDirection: Axis.horizontal,
                separatorBuilder: (_, __) => const SizedBox(width: TSizes.spaceBtwItems + TSizes.spaceBtwItems),
                itemBuilder: (_, __) {
                  return  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      //Image
                      TShimmerEffect(width: imageDimension, height: imageDimension, radius: imageRadius),

                      const SizedBox(height: TSizes.spaceBtwItems),

                      //Text
                      TShimmerEffect(width: imageDimension, height: 10),
                    ],
                  );
                }
            ),
          );
  }
}
