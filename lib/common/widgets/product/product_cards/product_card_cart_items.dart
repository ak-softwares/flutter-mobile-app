import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../features/shop/controllers/cart_controller/cart_controller.dart';
import '../../../../features/shop/models/cart_item_model.dart';
import '../../../../features/shop/screens/product_detail/product_detail.dart';
import '../../../../features/shop/screens/product_detail/products_widgets/product_title_text.dart';
import '../../../../utils/constants/sizes.dart';
import '../../../../utils/constants/text_strings.dart';
import '../../../styles/shadows.dart';
import '../../custom_shape/containers/rounded_container.dart';
import '../../custom_shape/image/circular_image.dart';
import '../quantity_add_buttons/quantity_add_buttons.dart';

class TProductCardForCart extends StatelessWidget {
  const TProductCardForCart({super.key, required this.cartItem, this.showBottomBar = false});

  final CartItemModel cartItem;
  final bool showBottomBar;
  @override
  Widget build(BuildContext context) {

    const double imageHeight = 80;
    const double cardRadius = TSizes.productImageRadius;
    final cartController = CartController.instance;

    return InkWell(
      onTap: () => Get.to(() => ProductDetailScreen(productId: cartItem.productId.toString())),
      child: Stack(
        children: [
          Container(
            // width: 300, //280+
            padding: showBottomBar
                ? const EdgeInsets.only(top: TSizes.defaultSpace, left: TSizes.defaultSpace,right: TSizes.defaultSpace)
                : const EdgeInsets.all(0),
            child: Container(
              decoration: BoxDecoration(
                boxShadow: [TShadowStyle.verticalProductShadow],
                borderRadius: BorderRadius.circular(TSizes.productImageRadius),
                color: Colors.white,
              ),
              child: Column(
                children: [
                  Row(
                    children: [
                      //Main Image
                      Padding(
                        padding: const EdgeInsets.only(left: 0),
                        child: TRoundedImage(
                            image: cartItem.image ?? '',
                            height: imageHeight,
                            width: imageHeight,
                            borderRadius: cardRadius,
                            isNetworkImage: true,
                            padding: TSizes.sm
                        ),
                      ),

                      //Title, Rating and price
                      Expanded(
                        child: Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(TSizes.sm,),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  //Title
                                  TProductTitleText(title: cartItem.name ?? ''),
                                  const SizedBox(height: TSizes.spaceBtwItems),

                                  //Star rating
                                  // ProductStarRating(averageRating: product.averageRating ?? 0.0, ratingCount: product.ratingCount ?? 0),

                                  //Price
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: [
                                      Text(
                                          '${cartItem.quantity}x${TTexts.currencySymbol}${cartItem.price!.toStringAsFixed(0)}',
                                          style: Theme.of(context).textTheme.bodyLarge
                                      ),
                                      // Text('Subtotal ', style: Theme.of(context).textTheme.labelLarge),
                                      Text(TTexts.currencySymbol + cartItem.subtotal!, style: Theme.of(context).textTheme.bodyLarge!.copyWith(fontWeight: FontWeight.w600)),
                                      if (showBottomBar)
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [
                                            QuantityAddButtons(
                                              quantity: cartItem.quantity, // Accessing value of RxInt
                                              add: () => cartController.addOneToCart(cartItem), // Incrementing value
                                              remove: () => cartController.removeOneToCart(cartItem),
                                              size: 30,
                                            ),
                                          ],
                                        )
                                    ],
                                  )
                                ],
                              ),
                            )
                          ],
                        ),
                      )
                    ],
                  ),
                ],
              ),
            ),
          ),
          showBottomBar
              ? Positioned(
                  top: 3,
                  left: 3,
                  child: TRoundedContainer(
                    width: 25,
                    height: 25,
                    radius: 25,
                    padding: const EdgeInsets.all(0),
                    backgroundColor: Colors.grey.withOpacity(0.2),
                    child: IconButton(
                      color: Colors.grey,
                      padding: EdgeInsets.zero,
                      onPressed: () => cartController.removeFromCartDialog(cartItem),
                      icon: const Icon(Icons.close, size: 15),
                    ),
                  ),
                )
              : const SizedBox.shrink()
        ],
      ),
    );
  }
}
