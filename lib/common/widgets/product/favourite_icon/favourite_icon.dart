import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';

import '../../../../features/shop/controllers/favorite/favorite_controller.dart';
import '../../../../features/shop/models/product_model.dart';
import '../../../../features/shop/screens/favourite/favourite.dart';
import '../../../../utils/constants/colors.dart';

class WishlistIcon extends StatelessWidget {
  const WishlistIcon({
    super.key,
    this.iconSize, required this.product,
  });

  final double? iconSize;
  final ProductModel product;
  
  @override
  Widget build(BuildContext context) {
    final controller = Get.put(FavoriteController());
    final String productId = product.id.toString();

    return Obx(() => IconButton(
      enableFeedback: true,
      onPressed: () => controller.toggleFavoriteProduct(product: product),
      onLongPress: () => Get.to(const FavouriteScreen()),
      iconSize: iconSize,
      icon: controller.isFavorite(productId) ? const Icon(Iconsax.heart5) : const Icon(Iconsax.heart),
      color: controller.isFavorite(productId) ? AppColors.error : null,
    ));
  }
}
