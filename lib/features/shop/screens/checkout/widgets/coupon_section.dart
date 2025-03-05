import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';

import '../../../../../common/layout_models/product_grid_layout.dart';
import '../../../../../common/styles/spacing_style.dart';
import '../../../../../common/text/section_heading.dart';
import '../../../../../common/widgets/loaders/animation_loader.dart';
import '../../../../../common/widgets/loaders/loader.dart';
import '../../../../../common/widgets/shimmers/coupon_shimmer.dart';
import '../../../../../utils/constants/colors.dart';
import '../../../../../utils/constants/image_strings.dart';
import '../../../../../utils/constants/sizes.dart';
import '../../../controllers/checkout_controller/checkout_controller.dart';
import '../../../controllers/coupon/coupon_controller.dart';
import '../../coupon/coupon_screen.dart';
import '../../coupon/widgets/single_coupon.dart';
class TCouponCode extends StatelessWidget {
  const TCouponCode({super.key});

  @override
  Widget build(BuildContext context) {
    final couponController = Get.put(CouponController());
    final checkoutController = Get.put(CheckoutController());

    return Column(
      children: [
        TextFormField(
          controller: couponController.couponTextEditingController,
          // initialValue: checkoutController.appliedCoupon.value.code?.toUpperCase() ?? '',
          decoration: InputDecoration(
            hintText: 'Enter coupon code',
            hintStyle: TextStyle(color: Theme.of(context).colorScheme.onSurfaceVariant), // Ensure hint is visible
            isDense: true, // Prevent excessive padding
            contentPadding: EdgeInsets.symmetric(vertical: 12, horizontal: 12), // Prevent squeezing

            prefixIcon: Icon(Iconsax.discount_shape, size: 20),
            suffixIcon: TextButton(
              onPressed: () {
                couponController.applyCoupon(couponController.couponTextEditingController.text.trim());
              },
              child: Obx(() => couponController.isCouponLoad.value
                  ? SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(strokeWidth: 2, color: TColors.linkColor),
                    )
                  : Text('Apply', style: TextStyle(color: Colors.blue, fontSize: 15, fontWeight: FontWeight.w500))
              ),
            ),
          ),
        ),
        Align(
          alignment: Alignment.centerRight,
          child: TextButton(
              onPressed: () => showCouponsInBottomSheet(context: context),
              // onPressed: () => Get.to(() => const CouponScreen()),
              child: Text('View All Coupons', style: TextStyle(fontSize: 14, color: TColors.linkColor)),
          ),
        )
      ],
    );
  }

  void showCouponsInBottomSheet({required BuildContext context}) {
    final couponController = Get.find<CouponController>();
    couponController.refreshCoupons(); // Refresh only when the bottom sheet opens

    showModalBottomSheet(
      context: context,
      backgroundColor: Theme.of(context).brightness == Brightness.dark
          ? Colors.grey.shade900  // Dark mode background
          : Colors.white,          // Light mode background
      builder: (context) {
        // return CouponListLayout();
        return customList(couponController);
      },
    );
  }

  Widget customList(CouponController couponController) {
    return Column(
      // crossAxisAlignment: CrossAxisAlignment.start,
      // padding: TSpacingStyle.defaultPageVertical,
      children: [
        Heading(title: 'Coupons'),
        SizedBox(height: Sizes.spaceBtwItems),
        Obx(() {
          if (couponController.isLoading.value) {
            return const CouponShimmer();
          } else if (couponController.coupons.isEmpty) {
            return const TAnimationLoaderWidgets(
              text: 'Whoops! Order is Empty...',
              animation: Images.pencilAnimation,
            );
          } else {
            return GridLayout(
              mainAxisExtent: 80,
              itemCount: couponController.isLoadingMore.value
                  ? couponController.coupons.length + 1
                  : couponController.coupons.length,
              itemBuilder: (context, index) {
                if (index < couponController.coupons.length) {
                  return SingleCouponItem(coupon: couponController.coupons[index], applyButton: true);
                } else {
                  return const CouponShimmer();
                }
              },
            );
          }
        }),

      ],
    );
  }
}
