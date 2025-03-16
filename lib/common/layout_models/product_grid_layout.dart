import 'package:flutter/material.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';

import '../../features/shop/screens/products/scrolling_products.dart';
import '../../utils/constants/image_strings.dart';
import '../../utils/constants/sizes.dart';
import '../../utils/helpers/navigation_helper.dart';
import '../widgets/loaders/animation_loader.dart';
import '../widgets/product/product_cards/product_card.dart';
import '../widgets/shimmers/product_shimmer.dart';

class ProductGridLayout extends StatelessWidget {
  const ProductGridLayout({
    super.key,
    required this.controller,
    required this.sourcePage,
    this.isDismissible = false,
    this.orientation = OrientationType.vertical,
    this.emptyWidget = const TAnimationLoaderWidgets(text: 'Whoops! No products found...', animation: Images.pencilAnimation),
  });

  final dynamic controller;
  final String sourcePage;
  final bool isDismissible;
  final OrientationType orientation;
  final Widget emptyWidget;

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (controller.isLoading.value) {
        return ProductShimmer(
          itemCount: orientation == OrientationType.vertical ? 4 : 2,
          crossAxisCount: orientation == OrientationType.vertical ? 2 : 1,
          orientation: orientation,
        );
      } else if(controller.products.isEmpty) {
        return emptyWidget;
      } else {
        final products = controller.products;
        return GridLayout(
          itemCount: controller.isLoadingMore.value ? products.length + 2 : products.length,
          crossAxisCount: orientation == OrientationType.vertical ? 2 : 1,
          mainAxisExtent: orientation == OrientationType.vertical ? Sizes.productCardVerticalHeight : Sizes.productCardHorizontalHeight,
          itemBuilder: (context, index) {
            if (index < products.length) {
              return orientation == OrientationType.horizontal && isDismissible
                  ? Dismissible(
                        key: Key(controller.products[index].id.toString()), // Unique key for each item
                        direction: DismissDirection.endToStart, // Swipe left to remove
                        onDismissed: (direction) {
                          controller.removeProduct(productID: products[index].id.toString());
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Item removed")),);
                        },
                        background: Container(
                          color: Colors.red,
                          alignment: Alignment.centerRight,
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          child: const Icon(Icons.delete, color: Colors.white),
                        ),
                        child: SizedBox(width: double.infinity, child: ProductCard(product: products[index], orientation: orientation, pageSource: sourcePage))
                    )
                  : ProductCard(product: products[index], orientation: orientation, pageSource: sourcePage);
            } else {
              return ProductShimmer(
                itemCount: 1,
                crossAxisCount: 1,
                orientation: orientation,
              );
            }
          }
        );
      }
    });
  }
}

class GridLayout extends StatelessWidget {
  const GridLayout({
    super.key,
    required this.itemCount,
    this.crossAxisCount = 1,
    this.crossAxisSpacing = Sizes.defaultSpaceBWTCard,
    this.mainAxisSpacing = Sizes.defaultSpaceBWTCard,
    required this.mainAxisExtent,
    required this.itemBuilder,
  });

  final int itemCount, crossAxisCount;
  final double mainAxisExtent, crossAxisSpacing, mainAxisSpacing;
  final Widget? Function(BuildContext, int) itemBuilder;

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      shrinkWrap: true,
      cacheExtent: 50, // Keeps items in memory
      padding: EdgeInsets.zero,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: crossAxisCount,
          crossAxisSpacing: crossAxisSpacing,
          mainAxisSpacing: mainAxisSpacing,
          mainAxisExtent: mainAxisExtent
      ),
      itemCount: itemCount,
      itemBuilder: itemBuilder,
    );
  }
}