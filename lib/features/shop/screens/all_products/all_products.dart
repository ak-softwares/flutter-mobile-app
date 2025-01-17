import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';

import '../../../../common/layout_models/grid_layout.dart';
import '../../../../common/navigation_bar/appbar2.dart';
import '../../../../common/styles/spacing_style.dart';
import '../../../../common/widgets/loaders/animation_loader.dart';
import '../../../../common/widgets/product/product_cards/product_card_vertical.dart';
import '../../../../common/widgets/shimmers/vertical_product_shimmer.dart';
import '../../../../utils/constants/colors.dart';
import '../../../../utils/constants/image_strings.dart';
import '../../../../utils/constants/sizes.dart';
import '../../controllers/product/all_product_controller.dart';
import '../../models/product_model.dart';

class TAllProducts extends StatelessWidget {
  const TAllProducts({super.key, required this.title, this.futureMethod, this.futureMethodTwoString, this.categoryId, this.sharePageLink});

  final String title;
  final String? categoryId;
  final String? sharePageLink;
  final Future<List<ProductModel>> Function(String)? futureMethod;
  final Future<List<ProductModel>> Function(String, String)? futureMethodTwoString;

  @override
  Widget build(BuildContext context) {
    
    final allProductController = Get.put(AllProductController());
    final ScrollController scrollController = ScrollController();

    if(futureMethod != null) {
      allProductController.refreshAllProducts(futureMethod!);
    } else {
      allProductController.refreshAllProductsTwoSting(futureMethodTwoString!, categoryId!);
    }

    scrollController.addListener(() async {
      if (scrollController.position.extentAfter < 0.2 * scrollController.position.maxScrollExtent) {
        if(!allProductController.isLoadingMore.value){
          // User has scrolled to 80% of the content's height
          const int itemsPerPage = 10; // Number of items per page
          if (allProductController.products.length % itemsPerPage != 0) {
            // If the length of orders is not a multiple of itemsPerPage, it means all items have been fetched
            return; // Stop fetching
          }
          allProductController.isLoadingMore(true);
          allProductController.currentPage++; // Increment current page
          if(futureMethod != null) {
            await allProductController.getAllProducts(futureMethod!);
          } else {
            await allProductController.getAllProductsTwoSting(futureMethodTwoString!, categoryId!);
          }
          allProductController.isLoadingMore(false);
        }
      }
    });

    return Scaffold(
        appBar: TAppBar2(titleText: title, showBackArrow: true, showCartIcon: true, sharePageLink: sharePageLink ?? "",),
        body: RefreshIndicator(
          color: TColors.refreshIndicator,
          onRefresh: () async {
            if(futureMethod != null) {
              allProductController.refreshAllProducts(futureMethod!);
            } else {
              allProductController.refreshAllProductsTwoSting(futureMethodTwoString!, categoryId!);
            }
          },
          child: ListView(
            controller: scrollController,
            padding: TSpacingStyle.defaultPagePadding,
            children: [
              DropdownButtonFormField(
                decoration: const InputDecoration(prefixIcon: Icon(Iconsax.sort)),
                value: allProductController.selectedSortOption.value,
                onChanged: (value){
                  //sort products based on the selected value
                  allProductController.sortProducts(value!);
                },
                items: ['Name', 'Higher Price', 'Lower Price', 'Sale', 'Newest', 'Popular']
                    .map((option) => DropdownMenuItem(value: option, child: Text(option)))
                    .toList(),
              ),
              const SizedBox(height: TSizes.defaultSpace),
              Obx(() {
                if (allProductController.isLoading.value){
                  return const TVerticalProductsShimmer(itemCount: 6);
                } else if(allProductController.products.isEmpty) {
                  return const TAnimationLoaderWidgets(
                    text: 'Whoops! No products fount...',
                    animation: TImages.pencilAnimation,
                  );
                }else {
                  //Product found!
                  final products = allProductController.products;
                  return TGridLayout(
                    crossAxisCount: 2,
                    // mainAxisExtent: 130,
                    itemCount: allProductController.isLoadingMore.value ? products.length + 2 : products.length,
                    itemBuilder: (context, index) {
                      if (index < products.length) {
                        return TProductCardVertical(product: products[index]);
                      } else {
                        return const TVerticalProductsShimmer(itemCount: 1, crossAxisCount: 1,);
                      }
                    },
                  );
                }
              }),
            ],
          ),
        ),
      );
    }
}
