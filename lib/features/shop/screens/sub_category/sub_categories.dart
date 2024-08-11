import 'package:flutter/material.dart';

import '../../../../common/layout_models/grid_layout.dart';
import '../../../../common/navigation_bar/appbar2.dart';
import '../../../../common/widgets/loaders/animation_loader.dart';
import '../../../../common/widgets/product/product_cards/product_card_vertical.dart';
import '../../../../common/widgets/shimmers/vertical_product_shimmer.dart';
import '../../../../utils/constants/image_strings.dart';
import '../../../../utils/helpers/cloud_helper_function.dart';
import '../../controllers/product/product_controller.dart';
import '../../models/category_model.dart';

class TSubCategoriesScreen extends StatelessWidget {
  const TSubCategoriesScreen({super.key, required this.category});

  final CategoryModel category;
  @override
  Widget build(BuildContext context) {
    final productController = ProductController.instance;
    return Scaffold(
      appBar: TAppBar2(titleText: category.name ?? '', showBackArrow: true),
      body: SingleChildScrollView(
        child: FutureBuilder(
            future: productController.getProductsByCategoryId(category.id ?? '', '1'),
            builder: (context, snapshot){
              //Nothing Found Widget
              const emptyWidget = TAnimationLoaderWidgets(
                text: 'Whoops! No product fount in this category',
                animation: TImages.pencilAnimation,
              );
              const loader = TVerticalProductsShimmer(itemCount: 4);
              final widget = TCloudHelperFunction.checkMultiRecodeState(snapshot: snapshot, loader: loader, nothingFound: emptyWidget);
              if(widget != null) return SizedBox(height: 600, child: widget);
              final products = snapshot.data!;
              return Column(
                children: [
                  TGridLayout(
                    itemCount: products.length,
                    itemBuilder: (_, index) => TProductCardVertical(product: products[index]),
                  ),
                ],
              );
            }
        ),
      )
    );
  }
}
