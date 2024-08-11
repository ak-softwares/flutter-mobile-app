import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../../common/layout_models/grid_layout.dart';
import '../../../../../common/styles/spacing_style.dart';
import '../../../../../common/text/section_heading.dart';
import '../../../../../common/widgets/loaders/animation_loader.dart';
import '../../../../../common/widgets/product/product_cards/product_card_search.dart';
import '../../../../../common/widgets/product/product_cards/product_card_vertical.dart';
import '../../../../../common/widgets/shimmers/horizontal_product_shimmer.dart';
import '../../../../../common/widgets/shimmers/vertical_product_shimmer.dart';
import '../../../../../utils/constants/colors.dart';
import '../../../../../utils/constants/image_strings.dart';
import '../../../controllers/search_controller/search_controller.dart';

class SearchProductScreen extends StatelessWidget {
  const SearchProductScreen({super.key, required this.title, required this.searchQuery, this.verticalOrientation = true});

  final bool verticalOrientation;
  final String title;
  final String searchQuery;

  @override
  Widget build(BuildContext context) {

    final ScrollController scrollController = ScrollController();
    final searchController = Get.put(SearchQueryController());
    // searchController.searchQuery.value = searchQuery;

    // Schedule the search refresh to occur after the current frame.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!searchController.isLoading.value) {
        searchController.refreshSearch(searchQuery);
      }
    });

    scrollController.addListener(() async {
      if (scrollController.position.extentAfter < 0.2 * scrollController.position.maxScrollExtent) {
        if(!searchController.isLoadingMore.value){
          // User has scrolled to 80% of the content's height
          const int itemsPerPage = 10; // Number of items per page
          if (searchController.searchProducts.length % itemsPerPage != 0) {
            // If the length of orders is not a multiple of itemsPerPage, it means all items have been fetched
            return; // Stop fetching
          }
          searchController.isLoadingMore(true);
          searchController.currentPage++; // Increment current page
          await searchController.getProductsBySearchQuery(searchQuery);
          searchController.isLoadingMore(false);
        }
      }
    });

    return RefreshIndicator(
      color: TColors.refreshIndicator,
      onRefresh: () async => searchController.refreshSearch(searchQuery),
      child: ListView(
        controller: scrollController,
        padding: TSpacingStyle.defaultPagePadding,
        children: [
          TSectionHeading(title: title),
          Obx(() {
            if (searchController.isLoading.value){
              return verticalOrientation ? const TVerticalProductsShimmer(itemCount: 6) : const THorizontalProductsShimmer(itemCount: 4);
            } else if(searchController.searchProducts.isEmpty) {
              return const TAnimationLoaderWidgets(
                text: 'Whoops! No Product Found...',
                animation: TImages.pencilAnimation,
              );
            } else {
              final products = searchController.searchProducts;
              return verticalOrientation
                ? TGridLayout(
                    itemCount: searchController.isLoadingMore.value ? products.length + 2 : products.length,
                    itemBuilder: (context, index) {
                      if (index < products.length) {
                        return TProductCardVertical(product: products[index]);
                      } else {
                        return const TVerticalProductsShimmer(itemCount: 1, crossAxisCount: 1,);
                      }
                    },
                  )
                : TGridLayout(
                    crossAxisCount: 1,
                    mainAxisExtent: 85,
                    mainAxisSpacing: 7,
                    itemCount: searchController.isLoadingMore.value ? products.length + 2 : products.length,
                    itemBuilder: (context, index) {
                      if (index < products.length) {
                        return TProductCardSearch(product: products[index]);
                      } else {
                        return const THorizontalProductsShimmer(itemCount: 2);
                      }
                    },
                  );
            }
          }),
        ],
      ),
    );
  }
}
