import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../../utils/constants/sizes.dart';
import '../../../controllers/product/product_controller.dart';
import '../../category/widgets/scrolling_category_name.dart';
import '../../home_page_section/products_carousal_by_categories/widgets/products_scrolling_by_category.dart';
import '../../home_page_section/products_carousal_by_categories/widgets/products_scrolling_vertical.dart';
class EmptySearchScreen extends StatelessWidget {
  const EmptySearchScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final productController = Get.put(ProductController());

    return SingleChildScrollView(
      padding: const EdgeInsets.only(top: TSizes.lg),
      child: Column(
        children: [
          const ScrollingCategoryName(),
          const SizedBox(height: TSizes.sm),
          ProductsScrollingVertical(title: 'Popular Products',  futureMethod: productController.getAllProducts),
          // const SizedBox(height: TSizes.sm),
          // ProductsScrollingByCategory(title: 'Soldering Irons', parameter: '61', futureMethod: productController.getProductsByCategoryId,),
        ],
      ),
    );
  }
}
