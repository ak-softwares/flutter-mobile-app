import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../../utils/constants/sizes.dart';
import '../../../controllers/cart_controller/cart_controller.dart';
import '../../../models/product_model.dart';
import '../../checkout/checkout.dart';

class TBottomAddToCart extends StatelessWidget {
  const TBottomAddToCart({super.key, this.quantity = 1, required this.product});

  final int quantity;
  final ProductModel product;

  @override
  Widget build(BuildContext context) {
    final cartController = CartController.instance;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: TSizes.defaultSpace, vertical: TSizes.defaultSpace),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: OutlinedButton(
              onPressed: () => cartController.addToCart(product, quantity),
              child: const Text('ADD TO CART'),
            ),
          ),
          const SizedBox(width: TSizes.spaceBtwInputFields),
          Expanded(
            child: ElevatedButton(
              onPressed: (){
                // Usage example
                try {
                  cartController.addToCart(product, quantity);
                  Get.to(() => const TCheckoutScreen());
                } catch (e) {
                  null;
                }
              },
              child: const Text('BUY NOW'),
            ),
          )
        ],
      ),
    );
  }
}
