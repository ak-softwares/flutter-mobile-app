import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../common/layout_models/grid_layout.dart';
import '../../../../common/navigation_bar/appbar2.dart';
import '../../../../common/styles/spacing_style.dart';
import '../../../../common/text/section_heading.dart';
import '../../../../common/widgets/loaders/animation_loader.dart';
import '../../../../common/widgets/product/product_cards/product_card_vertical.dart';
import '../../../../common/widgets/shimmers/vertical_product_shimmer.dart';
import '../../../../data/repositories/authentication/authentication_repository.dart';
import '../../../../utils/constants/colors.dart';
import '../../../../utils/constants/image_strings.dart';
import '../../../../utils/helpers/navigation_helper.dart';
import '../../../authentication/screens/check_login_screen/check_login_screen.dart';
import '../../controllers/favorite/favorite_controller.dart';

class FavouriteScreen extends StatelessWidget {
  const FavouriteScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final ScrollController scrollController = ScrollController();
    final favoriteController = Get.put(FavoriteController());
    final authenticationRepository = Get.put(AuthenticationRepository());

    favoriteController.refreshFavorites();

    scrollController.addListener(() async {
      if (scrollController.position.extentAfter < 0.2 * scrollController.position.maxScrollExtent) {
        if(!favoriteController.isLoadingMore.value){
          // User has scrolled to 80% of the content's height
          const int itemsPerPage = 10; // Number of items per page
          if (favoriteController.favoritesProducts.length % itemsPerPage != 0) {
            // If the length of orders is not a multiple of itemsPerPage, it means all items have been fetched
            return; // Stop fetching
          }
          favoriteController.isLoadingMore(true);
          favoriteController.currentPage++; // Increment current page
          await favoriteController.getFavoriteProducts();
          favoriteController.isLoadingMore(false);
        }
      }
    });

    return Obx(() => Scaffold(
          appBar: const TAppBar2(titleText: 'Wishlist', showCartIcon: true,),
          body: !authenticationRepository.isUserLogin.value
            ? const CheckLoginScreen(text: 'Please Login! before Add to ❤️ favorite!')
            : RefreshIndicator(
              color: TColors.refreshIndicator,
              onRefresh: () async => favoriteController.refreshFavorites(),
              child: ListView(
                controller: scrollController,
                padding: TSpacingStyle.defaultPagePadding,
                children: [
                  const TSectionHeading(title: 'Favourite Products'),
                  Obx(() {
                    if (favoriteController.isLoading.value){
                      return const TVerticalProductsShimmer(itemCount: 6);
                    } else if(favoriteController.favoritesProducts.isEmpty) {
                      return TAnimationLoaderWidgets(
                        text: 'Whoops! Wishlist is Empty...',
                        animation: TImages.pencilAnimation,
                        showAction: true,
                        actionText: 'Let\'s add some',
                        onActionPress: () => NavigationHelper.navigateToBottomNavigation(),
                      );
                    } else {
                      final products = favoriteController.favoritesProducts;
                      return TGridLayout(
                        crossAxisCount: 2,
                        // mainAxisExtent: 130,
                        itemCount: favoriteController.isLoadingMore.value ? products.length + 2 : products.length,
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
            )
        ),
    );
  }
}


