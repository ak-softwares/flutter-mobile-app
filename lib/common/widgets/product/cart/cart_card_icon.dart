import 'package:aramarket/features/shop/screens/cart/cart.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../features/shop/controllers/cart_controller/cart_controller.dart';
import '../../../../features/shop/models/product_model.dart';
import '../../../../utils/constants/colors.dart';
import '../../../../utils/constants/db_constants.dart';
import '../../../../utils/constants/icons.dart';
import '../../../../utils/constants/sizes.dart';
class CartIcon extends StatelessWidget {
  const CartIcon({super.key, this.iconSize, required this.sourcePage, required this.product});

  final double? iconSize;
  final String sourcePage;
  final ProductModel product;

  @override
  Widget build(BuildContext context) {
    final cartController = CartController.instance;
    return product.type == ProductFieldName.typeVariable
        ? Icon(AppIcons.cartVariation, size: 20,)
        : InkWell(
            onTap: () => cartController.toggleCartProduct(product: product, sourcePage: sourcePage),
            onLongPress: () => Get.to(() => CartScreen()),
            splashColor: Colors.transparent,
            child: Obx(() {
                return Padding(
                  padding: const EdgeInsets.only(left: AppSizes.sm),
                  child: Icon(cartController.isInCart(product.id) ? AppIcons.cartFull : AppIcons.cartEmpty, size: iconSize),
                );
              }
            ),
        );
  }
}
