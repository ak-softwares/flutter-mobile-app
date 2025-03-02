import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';

import '../../../../../utils/constants/colors.dart';
import '../../../controllers/coupon/coupon_controller.dart';
import '../../coupon/coupon_screen.dart';
class TCouponCode extends StatelessWidget {
  const TCouponCode({super.key});

  @override
  Widget build(BuildContext context) {
    final couponController = Get.put(CouponController());

    return Column(
      children: [
        TextFormField(
          controller: couponController.coupon,
          decoration: InputDecoration(
            hintText: 'Enter coupon code',
            hintStyle: TextStyle(color: Colors.grey[500]), // Ensure hint is visible
            isDense: true, // Prevent excessive padding
            contentPadding: EdgeInsets.symmetric(vertical: 12, horizontal: 12), // Prevent squeezing
            prefixIcon: Icon(Iconsax.discount_shape, size: 20),
            suffixIcon: TextButton(
              onPressed: () => couponController.applyCoupon(couponController.coupon.text.trim()),
              child: Obx(() => couponController.isCouponLoad.value
                  ? SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(strokeWidth: 2, color: TColors.linkColor),
                    )
                  : Text('Apply', style: TextStyle(color: Colors.blue, fontSize: 15, fontWeight: FontWeight.w500))),
            ),
          ),
        ),
        Align(
          alignment: Alignment.centerRight,
          child: TextButton(
              onPressed: () => Get.to(() => const CouponScreen()),
              child: Text('View All Coupons', style: TextStyle(fontSize: 14, color: TColors.linkColor)),
          ),
        )
      ],
    );
  }
}
