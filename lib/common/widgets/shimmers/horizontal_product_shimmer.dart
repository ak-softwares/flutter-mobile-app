import '/common/widgets/shimmers/shimmer_effect.dart';
import 'package:flutter/material.dart';

import '../../../utils/constants/sizes.dart';
import '../../layout_models/grid_layout.dart';

class THorizontalProductsShimmer extends StatelessWidget {
  const THorizontalProductsShimmer({super.key, this.itemCount = 2});

  final int itemCount;

  @override
  Widget build(BuildContext context) {
    const double imageHeight = 80;
    const double cardRadius = TSizes.productImageRadius;
    return TGridLayout(
        crossAxisCount: 1,
        mainAxisExtent: 100,
        mainAxisSpacing: TSizes.gridViewSpacing,
        itemCount: itemCount,
        itemBuilder: (_, __) => const SizedBox(
          width: 300,
          height: 120,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              //Image
              TShimmerEffect(width: imageHeight, height: imageHeight, radius: cardRadius),
              SizedBox(width: TSizes.spaceBtwItems),

              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  //text
                  SizedBox(height: TSizes.spaceBtwItems),
                  TShimmerEffect(width: 200, height: 15),
                  SizedBox(height: TSizes.spaceBtwItems / 2),
                  TShimmerEffect(width: 110, height: 15),
                ],
              )
            ],
          ),
        )
    );
  }
}
