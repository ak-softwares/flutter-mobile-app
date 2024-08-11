
import '../../../../common/styles/spacing_style.dart';
import '../../../../common/widgets/shimmers/horizontal_product_shimmer.dart';
import '../../../../utils/constants/colors.dart';
import '../../../../utils/constants/sizes.dart';
import '../../../../utils/helpers/navigation_helper.dart';
import '../../../authentication/screens/check_login_screen/check_login_screen.dart';
import '../../controllers/recently_viewed_controller/recently_viewed_controller.dart';
import '/common/widgets/product/product_cards/product_card_horizontal.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../common/layout_models/grid_layout.dart';
import '../../../../common/navigation_bar/appbar2.dart';
import '../../../../common/widgets/loaders/animation_loader.dart';
import '../../../../data/repositories/authentication/authentication_repository.dart';
import '../../../../utils/constants/image_strings.dart';

class RecentlyViewed extends StatelessWidget {
  const RecentlyViewed({super.key});

  @override
  Widget build(BuildContext context) {
    final ScrollController scrollController = ScrollController();
    final recentlyViewedController = Get.put(RecentlyViewedController());
    final authenticationRepository = Get.put(AuthenticationRepository());

    recentlyViewedController.refreshRecentProducts();

    scrollController.addListener(() async {
      if (scrollController.position.extentAfter < 0.2 * scrollController.position.maxScrollExtent) {
        if(!recentlyViewedController.isLoadingMore.value){
          // User has scrolled to 80% of the content's height
          const int itemsPerPage = 10; // Number of items per page
          if (recentlyViewedController.recentlyViewedProducts.length % itemsPerPage != 0) {
            // If the length of orders is not a multiple of itemsPerPage, it means all items have been fetched
            return; // Stop fetching
          }
          recentlyViewedController.isLoadingMore(true);
          recentlyViewedController.currentPage++; // Increment current page
          await recentlyViewedController.getRecentProducts();
          recentlyViewedController.isLoadingMore(false);
        }
      }
    });

    return Obx(() => Scaffold(
        appBar: const TAppBar2(titleText: 'Recently viewed', showCartIcon: true),
        body: !authenticationRepository.isUserLogin.value
            ? const CheckLoginScreen()
            : RefreshIndicator(
                color: TColors.refreshIndicator,
                onRefresh: () async => recentlyViewedController.refreshRecentProducts(),
                child: ListView(
                  controller: scrollController,
                  padding: TSpacingStyle.defaultPagePadding,
                  children: [
                    InkWell(
                      onTap: recentlyViewedController.clearHistory,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: TSizes.sm),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Text('Clear history', style: Theme.of(context).textTheme.bodyMedium!,),
                            const SizedBox(width: TSizes.sm),
                            const Icon(Icons.delete, size: 18, color: Colors.pink),
                          ],
                        ),
                      ),
                    ),
                    Obx(() {
                        if (recentlyViewedController.isLoading.value){
                          return const THorizontalProductsShimmer(itemCount: 4);
                        } else if(recentlyViewedController.recentlyViewedProducts.isEmpty) {
                          return TAnimationLoaderWidgets(
                            text: 'Whoops! No Recent Products...',
                            animation: TImages.pencilAnimation,
                            showAction: true,
                            actionText: 'Let\'s add some',
                            onActionPress: () => NavigationHelper.navigateToBottomNavigation(),
                          );
                        } else {
                          final products = recentlyViewedController.recentlyViewedProducts;
                          return TGridLayout(
                            mainAxisExtent: 110,
                            crossAxisCount: 1,
                            mainAxisSpacing: 5,
                            itemCount: recentlyViewedController.isLoadingMore.value ? products.length + 2 : products.length,
                            itemBuilder: (context, index) {
                              if (index < products.length) {
                                return TProductCardHorizontal(product: products[index]);
                              } else {
                                return const THorizontalProductsShimmer(itemCount: 4);
                              }
                            },
                          );
                        }
                    }),
                  ],
                ),
              )
    ));
  }
}


