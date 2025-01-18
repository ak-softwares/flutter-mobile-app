import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';

import '../../../../features/shop/controllers/favorite/favorite_controller.dart';
import '../../../../features/shop/screens/wishlist/wishlist.dart';
import '../../../../utils/constants/colors.dart';

class TFavouriteIcon extends StatelessWidget {
  const TFavouriteIcon({
    super.key,
    this.iconSize, required this.productId,
  });

  final double? iconSize;
  final String productId;
  
  @override
  Widget build(BuildContext context) {
    final controller = Get.put(FavoriteController());
    return Obx(
        () => GestureDetector(
          onLongPress: () => Get.to(const FavouriteScreen()),
          child: IconButton(
            onPressed: () => controller.toggleFavoriteProduct(productId),
            iconSize: iconSize,
            // splashRadius: 50,
            icon: controller.isFavorite(productId) ? const Icon(Iconsax.heart5) : const Icon(Iconsax.heart),
            color: controller.isFavorite(productId) ? TColors.error : null,
                ),
        ),
    );
  }
}
