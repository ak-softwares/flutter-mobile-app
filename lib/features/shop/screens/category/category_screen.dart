import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../common/layout_models/grid_layout.dart';
import '../../../../common/navigation_bar/appbar2.dart';
import '../../../../common/styles/spacing_style.dart';
import '../../../../common/widgets/loaders/animation_loader.dart';
import '../../../../common/widgets/shimmers/category_shimmer.dart';
import '../../../../services/firebase_analytics/firebase_analytics.dart';
import '../../../../utils/constants/colors.dart';
import '../../../../utils/constants/image_strings.dart';
import '../../../../utils/constants/sizes.dart';
import '../../controllers/category_controller/category_controller.dart';
import '../home_page_section/category/widgets/single_category_item.dart';
import 'category_tap_bar.dart';

class CategoryScreen extends StatelessWidget {
  const CategoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    FBAnalytics.logPageView('Category');
    final categoryController = Get.put(CategoryController());
    final ScrollController scrollController = ScrollController();
    const double imageDimension = 80;
    const double imageRadius = TSizes.productImageRadius;

    scrollController.addListener(() async {
      if (scrollController.position.extentAfter < 0.2 * scrollController.position.maxScrollExtent) {
        if(!categoryController.isLoadingMore.value){
          // User has scrolled to 80% of the content's height
          const int itemsPerPage = 10; // Number of items per page
          if (categoryController.categories.length % itemsPerPage != 0) {
            // If the length of orders is not a multiple of itemsPerPage, it means all items have been fetched
            return; // Stop fetching
          }
          categoryController.isLoadingMore(true);
          categoryController.currentPage++; // Increment current page
          await categoryController.getAllCategory();
          categoryController.isLoadingMore(false);
        }
      }
    });

    return Scaffold(
      appBar: const TAppBar2(titleText: 'Categories', showCartIcon: true),
      body: RefreshIndicator(
        color: TColors.refreshIndicator,
        onRefresh: () async => categoryController.refreshCategories(),
        child: ListView(
          controller: scrollController,
          padding: TSpacingStyle.defaultPagePadding,
          children: [
            Obx(() {
              if (categoryController.isLoading.value){
                return const TCategoryShimmer(imageDimension: imageDimension, imageRadius: imageRadius, isCategoryScreenTrue: true, itemCount: 20,);
              } else if(categoryController.categories.isEmpty) {
                return const TAnimationLoaderWidgets(
                  text: 'Whoops! Categories is Empty...',
                  animation: TImages.pencilAnimation,
                );
              } else {
                final categories = categoryController.categories;
                return TGridLayout(
                  crossAxisCount: 4,
                  mainAxisExtent: 130,
                  itemCount: categoryController.isLoadingMore.value ? categories.length + 4 : categories.length,
                  itemBuilder: (context, index) {
                    if (index < categories.length) {
                      final category = categories[index];
                      return SingleCategoryItem(
                          imageDimension: imageDimension,
                          imageRadius: 5,
                          title: category.name ?? '',
                          image: category.image ?? '',
                          onTap: () =>
                              Get.to(CategoryTapBarScreen(initialIndex: index))
                      );
                    } else {
                      return const TCategoryShimmer(imageDimension: imageDimension, imageRadius: imageRadius, isCategoryScreenTrue: true, itemCount: 1,);
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