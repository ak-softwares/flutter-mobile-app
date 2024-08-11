import '/common/widgets/shimmers/shimmer_effect.dart';
import 'package:flutter/material.dart';

import '../../../utils/constants/sizes.dart';

class TVerticalProductsShimmer extends StatelessWidget {
  const TVerticalProductsShimmer({super.key, this.itemCount = 4, this.crossAxisCount = 2, this.isLoading = false});

  final int itemCount;
  final int crossAxisCount;
  final bool isLoading;


  @override
  Widget build(BuildContext context) {
    return isLoading
        ? SizedBox(
          height: 290,
          width: 160,
          child: GridView.builder(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: crossAxisCount,
                  mainAxisExtent: 290,
                  mainAxisSpacing: TSizes.spaceBtwItems,
                  crossAxisSpacing: TSizes.spaceBtwItems,
                ),
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: itemCount,
                itemBuilder: (_, __) => const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    //Image
                    TShimmerEffect(width: 180, height: 180),
                    SizedBox(height: TSizes.spaceBtwItems,),

                    //text
                    TShimmerEffect(width: 160, height: 15),
                    SizedBox(height: TSizes.spaceBtwItems / 2),
                    TShimmerEffect(width: 110, height: 15)
                  ],
                )
            ),
        )
        : GridView.builder(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: crossAxisCount,
                mainAxisExtent: 290,
                crossAxisSpacing: TSizes.md,
              ),
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: itemCount,
              itemBuilder: (_, __) => const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  //Image
                  TShimmerEffect(width: 180, height: 180),
                  SizedBox(height: TSizes.spaceBtwItems,),

                  //text
                  TShimmerEffect(width: 160, height: 15),
                  SizedBox(height: TSizes.spaceBtwItems / 2),
                  TShimmerEffect(width: 110, height: 15)
                ],
              )
          );
  }
}
