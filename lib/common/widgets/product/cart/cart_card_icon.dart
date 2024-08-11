import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../features/shop/controllers/cart_controller/cart_controller.dart';
import '../../../../features/shop/models/product_model.dart';
import '../../../../utils/constants/colors.dart';
import '../../../../utils/constants/icons.dart';
class TCartIcon extends StatelessWidget {
  const TCartIcon({super.key, this.iconSize, required this.product});

  final double? iconSize;
  final ProductModel product;

  @override
  Widget build(BuildContext context) {
    final cartController = CartController.instance;
    return IconButton(
        onPressed: () => cartController.toggleCartProduct(product),
        iconSize: iconSize,
        color: TColors.secondaryColor,
        icon: Obx(() {
            final productQuantityInCart = cartController.isInCart(product.id);
            return Icon(productQuantityInCart ? TIcons.cartFull : TIcons.cartEmpty, size: 20,);
          }
        ),
    );
  }
}
