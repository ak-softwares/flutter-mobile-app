import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../../utils/constants/sizes.dart';
import '../../../../../utils/constants/text_strings.dart';
import '../../../controllers/checkout_controller/checkout_controller.dart';
import '../../../models/coupon_model.dart';

class TBillingAmountSection extends StatelessWidget {
  const TBillingAmountSection({super.key});

  @override
  Widget build(BuildContext context) {
    final checkoutController = Get.put(CheckoutController());

    return Obx(() => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          //SubTotal
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Subtotal', style: Theme.of(context).textTheme.bodyMedium,),
              Text(TTexts.currencySymbol + checkoutController.subTotal.value.toStringAsFixed(0),
                style: Theme.of(context).textTheme.bodyMedium,),
            ],
          ),
          const SizedBox(height: TSizes.spaceBtwItems / 2),

          //Discount
          if (checkoutController.discount.value != 0) ...[
            Column(
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Discount (${checkoutController.coupon.value.code}) ',
                      style: Theme.of(context).textTheme.bodyMedium,),
                    Row(
                      children: [
                        Text('- ${TTexts.currencySymbol}${checkoutController.discount.value.toStringAsFixed(0)}',
                          style: Theme.of(context).textTheme.bodyMedium,),
                        const SizedBox(width: 5,),
                        InkWell(
                            onTap: () {
                              checkoutController.coupon.value = CouponModel.empty();
                              checkoutController.updateTotal();
                            },
                            child: const Icon(Icons.close, color: Colors.red, size: 20,)),
                      ],
                    )
                  ],
                ),
                const SizedBox(height: TSizes.spaceBtwItems / 2),
              ],
            ),
          ],

          //Shipping
          if ((checkoutController.shipping.value != 0) || checkoutController.isFreeShipping.value) ...[
            Column(
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Shipping', style: Theme.of(context).textTheme.bodyMedium,),
                    !checkoutController.isFreeShipping.value
                        ? Text(TTexts.currencySymbol + checkoutController.shipping.value.toStringAsFixed(0),
                      style: Theme.of(context).textTheme.bodyMedium,)
                        : Row(
                      children: [
                        Text('Free Shipping',
                          style: Theme.of(context).textTheme.bodyMedium,),
                        const SizedBox(width: 5,),
                        InkWell(
                            onTap: () {
                              checkoutController.coupon.value = CouponModel.empty();
                              checkoutController.updateTotal();
                            },
                            child: const Icon(Icons.close, color: Colors.red, size: 20,)
                        ),
                      ],
                    )
                  ],
                ),
                const SizedBox(height: TSizes.spaceBtwItems / 2),
              ],
            ),
          ],

          //Tax
          if (checkoutController.tax.value != 0) ...[
            Column(
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Tax', style: Theme.of(context).textTheme.bodyMedium,),
                    Text(TTexts.currencySymbol + checkoutController.tax.value.toStringAsFixed(0),
                      style: Theme.of(context).textTheme.bodyMedium,)
                  ],
                ),
                const SizedBox(height: TSizes.spaceBtwItems / 2),
              ],
            ),
          ],

          //Order Total
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Total', style: Theme.of(context).textTheme.titleSmall,),
              Text(TTexts.currencySymbol + checkoutController.total.value.toStringAsFixed(0),
                style: Theme.of(context).textTheme.titleSmall,)
            ],
          ),
          const SizedBox(height: TSizes.spaceBtwItems / 2),
        ],
      ),
    );
  }
}