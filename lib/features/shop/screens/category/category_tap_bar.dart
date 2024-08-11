import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../utils/constants/colors.dart';
import '../../controllers/category_controller/category_controller.dart';
import '../../controllers/product/product_controller.dart';
import 'widgets/tabview_products_by_category.dart';

class CategoryTapBarScreen extends StatelessWidget {
  const CategoryTapBarScreen({super.key, this.initialIndex = 0});

  final int initialIndex;
  @override
  Widget build(BuildContext context) {
    final categoryController = Get.put(CategoryController());
    final productController = Get.put(ProductController());

    final categories = categoryController.categories;


    return DefaultTabController(
          initialIndex: initialIndex,
          length: categories.length,
          child: Scaffold(
            appBar: AppBar(
              centerTitle: false,
              backgroundColor: TColors.primaryColor,
              title: Text('Products by categories', style: Theme.of(context).textTheme.titleSmall!.copyWith(fontWeight: FontWeight.w600)),
              bottom: TabBar(
                unselectedLabelColor: Colors.black87,
                indicatorColor: TColors.secondaryColor,
                isScrollable: true,
                labelStyle: Theme.of(context).textTheme.bodyLarge!.copyWith(fontWeight: FontWeight.w500),
                tabs: categories.map((category) {
                  return Tab(
                    text: category.name,
                  );
                }).toList(),
              ),
            ),
            body: TabBarView(
              children: categories.map((category) {
                return TabviewProductsByCategory(futureMethod: productController.getProductsByCategoryId, categoryId: category.id.toString());
              }).toList(),
            ),
          ),
        );
  }
}
