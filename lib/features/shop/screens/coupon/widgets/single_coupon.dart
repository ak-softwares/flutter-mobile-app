import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

import '../../../../../common/styles/spacing_style.dart';
import '../../../../../common/dialog_box_massages/massages.dart';
import '../../../../../utils/constants/colors.dart';
import '../../../../../utils/constants/sizes.dart';
import '../../../../../utils/constants/text_strings.dart';
import '../../../controllers/checkout_controller/checkout_controller.dart';
import '../../../controllers/coupon/coupon_controller.dart';
import '../../../models/coupon_model.dart';

class SingleCouponItem extends StatelessWidget {
  const SingleCouponItem({super.key, required this.coupon, this.applyButton = false});

  final CouponModel coupon;
  final bool applyButton;

  @override
  Widget build(BuildContext context) {
    final couponController = Get.put(CouponController());
    final checkoutController = Get.put(CheckoutController());

    return ListTile(
        minVerticalPadding: AppSizes.md,
        tileColor: Theme.of(context).colorScheme.surface,
        onLongPress: () {
            Clipboard.setData(ClipboardData(text: coupon.code!.toUpperCase()));
            AppMassages.showSnackBar(context: context, massage: 'Coupon code ${coupon.code!.toUpperCase()} copied');
        },
        leading: Icon(Icons.local_offer_outlined, size: 20, color: AppColors.offerColor),
        title: Text(coupon.code!.toUpperCase()),
        subtitle: Text(coupon.description?.isNotEmpty == true ? coupon.description! : 'Discount Offer',
            style: TextStyle(fontSize: 11),
        ),
        trailing: applyButton
            ? Obx(() => checkoutController.appliedCoupon.value.code == coupon.code
                ? TextButton(
                    onPressed: () {
                      checkoutController.appliedCoupon.value = CouponModel.empty();
                      checkoutController.updateCheckout();
                      Navigator.pop(context); // This closes the bottom sheet
                      AppMassages.showToastMessage(message: 'Coupon removed successfully');
                    },
                    child: Text('Remove', style: TextStyle(color: Colors.red))
                  )
                : TextButton(
                      onPressed: () {
                        couponController.applyCoupon(coupon.code ?? '');
                        Navigator.pop(context); // This closes the bottom sheet
                      },
                      child: Text('Apply', style: TextStyle(color: AppColors.linkColor))
                  ))
            : IconButton(
                onPressed: () {
                  Clipboard.setData(ClipboardData(text: coupon.code!.toUpperCase()));
                  AppMassages.showSnackBar(context: context, massage: 'Coupon code ${coupon.code!.toUpperCase()} copied');
                },
                  icon: Icon(Icons.copy, size: 20)
              )
    );
  }
}
