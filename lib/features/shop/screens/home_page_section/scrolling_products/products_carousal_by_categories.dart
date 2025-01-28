import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../../common/text/section_heading.dart';
import '../../../../../common/widgets/shimmers/product_shimmer.dart';
import '../../../../../utils/constants/sizes.dart';
import '../../../controllers/category_controller/category_controller.dart';
import '../../../controllers/product/product_controller.dart';
import '../../all_products/all_products.dart';
import 'widgets/products_scrolling_by_category.dart';


class ProductCarousalByCategory extends StatelessWidget {
  const ProductCarousalByCategory({super.key});

  @override
  Widget build(BuildContext context) {
    final categoryController = Get.put(CategoryController());
    final productController = Get.put(ProductController());

    return Obx(() {
      if (categoryController.isLoading.value){
        return const Column(
          children: [
            TSectionHeading(title: 'Products Loading..'),
            ProductShimmer(itemCount: 2),
          ],
        );
      } else if(categoryController.categories.isEmpty) {
        return const SizedBox.shrink();
      } else {
        final categories = categoryController.categories;
        return ListView.separated(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: categoryController.isLoadingMore.value ? categories.length + 1 : categories.length,
          separatorBuilder: (_, __) => const SizedBox(width: Sizes.spaceBtwItems),
          itemBuilder: (context, index) {
            if (index < categories.length) {
              final category = categories[index];
              return Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: Sizes.spaceBtwItems),
                    child: TSectionHeading(
                      title: category.name ?? '',
                      seeActionButton: true,
                      verticalPadding: true,
                      onPressed: () => Get.to(() => TAllProducts(title: category.name ?? '', categoryId: category.id, futureMethodTwoString: productController.getProductsByCategoryId)),
                    ),
                  ),
                  ProductsScrollingByItemID(
                    futureMethod: productController.getProductsByCategoryId,
                    itemID: category.id.toString(),
                  ),
                ],
              );
            } else {
              // Return your loading indicator widget here
              return const Column(
                children: [
                  SizedBox(height: Sizes.sm,),
                  TSectionHeading(title: 'Products Loading..'),
                  ProductShimmer(itemCount: 2),
                ],
              );
            }
          },
        );
      }
    });
  }
}
