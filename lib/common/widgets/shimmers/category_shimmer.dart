import '../../../features/shop/screens/home_page_section/scrolling_products/widgets/scrolling_products.dart';
import '../../layout_models/product_grid_layout.dart';
import '/common/widgets/shimmers/shimmer_effect.dart';
import 'package:flutter/material.dart';

import '../../../utils/constants/sizes.dart';

class CategoryTileShimmer extends StatelessWidget {

  const CategoryTileShimmer({
    super.key,
    this.itemCount = 2,
    this.crossAxisCount = 1,
    this.orientation = OrientationType.vertical
  });

  final int itemCount, crossAxisCount;
  final OrientationType orientation;

  @override
  Widget build(BuildContext context) {
    final double categoryImageHeight = Sizes.categoryImageHeight;
    final double categoryImageWidth  = Sizes.categoryImageWidth;
    final double categoryTileRadius  = Sizes.categoryTileRadius;
    final double categoryTileHeight  = Sizes.categoryTileHeight;
    final double categoryTileWidth  = Sizes.categoryTileWidth;

    return orientation == OrientationType.vertical
        ? GridLayout(
            crossAxisCount: crossAxisCount,
            mainAxisExtent: categoryTileHeight,
            itemCount: itemCount,
            itemBuilder: (_, __) {
              return  Column(
                spacing: Sizes.spaceBtwItems,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // Image
                  ShimmerEffect(height: categoryImageHeight, width: categoryImageWidth, radius: categoryTileRadius),
                  // Text
                  ShimmerEffect(height: 10, width: categoryTileWidth),
                ],
              );
            },
          )
        : SizedBox(
            height: categoryTileHeight,
            child: ListView.separated(
                shrinkWrap: true,
                itemCount: itemCount,
                scrollDirection: Axis.horizontal,
                separatorBuilder: (_, __) => const SizedBox(width: 0),
                itemBuilder: (_, __) {
                  return  Padding(
                    padding: const EdgeInsets.only(left: Sizes.defaultBtwTiles, top: Sizes.defaultBtwTiles),
                    child: Column(
                      spacing: Sizes.spaceBtwItems,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Image
                        ShimmerEffect(height: categoryImageHeight, width: categoryImageWidth, radius: categoryTileRadius),
                        // Text
                        ShimmerEffect(height: 10, width: categoryTileWidth),
                      ],
                    ),
                  );
                }
            ),
          );
  }
}
