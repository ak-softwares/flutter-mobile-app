import 'package:aramarket/features/shop/models/product_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

import '../../../../../utils/constants/colors.dart';
import '../../../../../utils/constants/sizes.dart';
import '../../../../settings/app_settings.dart';
import '../../../controllers/product/product_controller.dart';
import '../../../models/brand_model.dart';
import '../../all_products/all_products.dart';

class ProductBrand extends StatelessWidget {
  const ProductBrand({super.key, required this.brands, this.size = 15});

  final List<BrandModel> brands;
  final double? size;
  @override
  Widget build(BuildContext context) {
    final productController = Get.put(ProductController(), permanent: true);

    return brands.isNotEmpty
        ? Column(
            children: [
              InkWell(
                onTap: () => Get.to(() => TAllProducts(
                    title: brands[0].name ?? '',
                    categoryId: brands[0].id.toString() ?? '',
                    sharePageLink: '${AppSettings.appName} - ${brands[0].permalink}',
                    futureMethodTwoString: productController.getProductsByBrandId
                )),
                child: Row(
                  spacing: Sizes.sm,
                  children: [
                    Text(
                      brands.map((brand) => brand.name).join(', ') ?? '', // Join brand names with commas
                      style: TextStyle(color: AppColors.linkColor, fontSize: size, fontWeight: FontWeight.w600),
                    ),
                    Icon(Icons.verified, color: Colors.blue, size: size! + 3.0,)
                  ],
                ),
              ),
              const SizedBox(height: Sizes.sm),
            ],
          )
        : SizedBox.shrink();
  }
}
