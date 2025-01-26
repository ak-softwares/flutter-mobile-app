import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../../common/layout_models/product_list_layout.dart';
import '../../../../../common/text/section_heading.dart';
import '../../../../../common/widgets/shimmers/category_shimmer.dart';
import '../../../../../utils/constants/api_constants.dart';
import '../../../../../utils/constants/sizes.dart';
import '../../../controllers/category_controller/category_controller.dart';
import '../../category/category_screen.dart';
import '../../category/category_tap_bar.dart';
import 'widgets/single_category_item.dart';


class ScrollingCategoriesImage extends StatelessWidget {
  const ScrollingCategoriesImage({super.key});

  @override
  Widget build(BuildContext context) {
    final ScrollController scrollController = ScrollController();
    final categoryController = Get.put(CategoryController());
    const double imageDimension = Sizes.categoryImageSize;
    const double imageRadius = Sizes.categoryImageRadius;

    scrollController.addListener(() async {
      if (scrollController.position.extentAfter < 0.2 * scrollController.position.maxScrollExtent) {
        if(!categoryController.isLoadingMore.value){
          // User has scrolled to 80% of the content's height
          int itemsPerPage = int.parse(APIConstant.itemsPerPage); // Number of items per page
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

    return Obx(() {
      if (categoryController.isLoading.value){
        return Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(left: Sizes.spaceBtwItems),
              child: TSectionHeading(title: 'Popular Categories', seeActionButton: true, onPressed: () => Get.to(() => const CategoryScreen())),
            ),
            const Padding(
              padding: EdgeInsets.only(top: Sizes.spaceBtwItems, left: Sizes.spaceBtwItems),
              child: TCategoryShimmer(imageDimension: imageDimension, imageRadius: imageRadius),
            ),
          ],
        );
      } else if(categoryController.categories.isEmpty) {
        return const SizedBox.shrink();
      } else {
        final categories = categoryController.categories;
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(left: Sizes.spaceBtwItems),
              child: TSectionHeading(title: 'Popular Categories', seeActionButton: true, onPressed: () => Get.to(() => const CategoryScreen())),
            ),
            ListLayout(
              height: imageDimension + 60,
              controller: scrollController,
              itemCount: categoryController.isLoadingMore.value ? categories.length + 3 : categories.length,
              itemBuilder: (context, index) {
                if (index < categories.length) {
                  final category = categories[index];
                  return Padding(
                    padding: const EdgeInsets.only(top: Sizes.spaceBtwItems, left: Sizes.spaceBtwItems),
                    child: SingleCategoryItem(
                        imageDimension: imageDimension,
                        imageRadius: imageRadius,
                        title: category.name ?? '',
                        image: category.image ?? '',
                        onTap: () => Get.to(CategoryTapBarScreen(categoryId: category.id ?? ''))),
                  );
                } else {
                  return const Padding(
                    padding: EdgeInsets.only(top: Sizes.spaceBtwItems, left: Sizes.spaceBtwItems),
                    child: TCategoryShimmer(imageDimension: imageDimension, imageRadius: imageRadius, itemCount: 1),
                  );
                }
              },
            ),
          ],
        );          }
    });
  }
}
