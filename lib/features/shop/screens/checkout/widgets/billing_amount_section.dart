import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../../common/styles/spacing_style.dart';
import '../../../../../common/text/section_heading.dart';
import '../../../../../utils/constants/colors.dart';
import '../../../../../utils/constants/sizes.dart';
import '../../../../../utils/constants/text_strings.dart';
import '../../../../settings/app_settings.dart';
import '../../../controllers/checkout_controller/checkout_controller.dart';
import '../../../models/coupon_model.dart';

class TBillingAmountSection extends StatelessWidget {
  const TBillingAmountSection({super.key});

  @override
  Widget build(BuildContext context) {
    final checkoutController = Get.put(CheckoutController());

    return Obx(() => Column(
        spacing:  AppSizes.spaceBtwItems / 2,
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          // SubTotal
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Subtotal', style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500),),
              Text(AppSettings.appCurrencySymbol + checkoutController.subTotal.value.toStringAsFixed(0),
                style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
              ),
            ],
          ),

          // Discount
          if (checkoutController.discount.value != 0) ...[
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Text(
                      'Discount ',
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                    Icon(
                      Icons.discount, // Using discount icon
                      color: AppColors.offerColor, // Green color for the icon
                      size: 20, // Adjust the size as needed
                    ),
                    Text(
                      ' ${checkoutController.appliedCoupon.value.code!.toUpperCase().toString()}',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: AppColors.offerColor),
                    ),
                  ],
                ),
                Row(
                  children: [
                    Text(
                      '- ${AppSettings.appCurrencySymbol}${checkoutController.discount.value.toStringAsFixed(0)}',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: AppColors.offerColor)
                    ),
                    const SizedBox(width: 5,),
                    InkWell(
                        onTap: () {
                          checkoutController.appliedCoupon.value = CouponModel.empty();
                          checkoutController.updateCheckout();
                        },
                        child: const Icon(Icons.close, color: Colors.red, size: 20,)),
                  ],
                )
              ],
            ),
          ],

          // Shipping
          if ((checkoutController.shipping.value != 0) || checkoutController.isFreeShipping.value) ...[
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Shipping', style: Theme.of(context).textTheme.bodyMedium,),
                !checkoutController.isFreeShipping.value
                    ? Text(AppSettings.appCurrencySymbol + checkoutController.shipping.value.toStringAsFixed(0),
                  style: Theme.of(context).textTheme.bodyMedium,)
                    : Row(
                  children: [
                    Text('Free Shipping',
                      style: Theme.of(context).textTheme.bodyMedium,),
                    const SizedBox(width: 5,),
                    InkWell(
                        onTap: () {
                          checkoutController.appliedCoupon.value = CouponModel.empty();
                          checkoutController.updateTotal();
                        },
                        child: const Icon(Icons.close, color: Colors.red, size: 20,)
                    ),
                  ],
                )
              ],
            ),
          ],

          // Tax
          if (checkoutController.tax.value != 0) ...[
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Tax', style: Theme.of(context).textTheme.bodyMedium,),
                Text(AppSettings.appCurrencySymbol + checkoutController.tax.value.toStringAsFixed(0),
                  style: Theme.of(context).textTheme.bodyMedium,)
              ],
            ),
          ],

          // Order Total
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Total',  style: TextStyle(fontSize: 17, fontWeight: FontWeight.w500),),
              Text(AppSettings.appCurrencySymbol + checkoutController.total.value.toStringAsFixed(0),
                style: TextStyle(fontSize: 17, fontWeight: FontWeight.w500),)
            ],
          ),
        ],
      ),
    );
  }
}
