import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../common/layout_models/product_grid_layout.dart';
import '../../../../common/navigation_bar/appbar2.dart';
import '../../../../common/styles/spacing_style.dart';
import '../../../../common/text/section_heading.dart';
import '../../../../common/widgets/custom_shape/containers/rounded_container.dart';
import '../../../../common/widgets/product/product_cards/product_card_cart_items.dart';
import '../../../../data/repositories/authentication/authentication_repository.dart';
import '../../../../services/firebase_analytics/firebase_analytics.dart';
import '../../../../utils/constants/sizes.dart';
import '../../../../utils/constants/text_strings.dart';
import '../../../authentication/screens/check_login_screen/check_login_screen.dart';
import '../../../settings/app_settings.dart';
import '../../controllers/cart_controller/cart_controller.dart';
import '../../controllers/checkout_controller/checkout_controller.dart';
import '../../controllers/order/order_controller.dart';
import 'widgets/billing_address_section.dart';
import 'widgets/billing_amount_section.dart';
import 'widgets/billing_payment_section.dart';
import 'widgets/coupon_section.dart';

class CheckoutScreen extends StatelessWidget {
  const CheckoutScreen({super.key});

  @override
  Widget build(BuildContext context) {

    final cartController = Get.put(CartController());
    final checkoutController = Get.put(CheckoutController());
    final authenticationRepository = Get.put(AuthenticationRepository());
    FBAnalytics.logPageView('checkout_screen');
    FBAnalytics.logBeginCheckout(cartItems: cartController.cartItems);
    // Trigger updateCheckout on widget initialization
    Future.microtask(() => checkoutController.updateCheckout());

    return Scaffold(
      appBar: const TAppBar2(titleText: "Order summery", showBackArrow: true),
      bottomNavigationBar: Obx((){
        if (authenticationRepository.isUserLogin.value && cartController.cartItems.isNotEmpty){
          return Padding(
              padding: const EdgeInsets.all(Sizes.defaultSpace),
              child: ElevatedButton(
                  onPressed: () => checkoutController.initiateCheckout(),
                  // onPressed: () {},
                  child: Obx(() => Text('Place Order (${AppSettings.appCurrencySymbol +
                      checkoutController.total.value.toStringAsFixed(0)})'))
              ),
            );
        } else {
          return const SizedBox.shrink();
        }
      }),
      body: !authenticationRepository.isUserLogin.value
          ? const CheckLoginScreen(text: 'Please Login! before Checkout!')
          : SingleChildScrollView(
            child: Column(
              children: [
                // Cart Items
                Obx(() => Column(
                  children: [
                    Padding(
                      padding: TSpacingStyle.defaultPageHorizontal,
                      child: const TSectionHeading(title: 'Cart Items'),
                    ),
                    GridLayout(
                        crossAxisCount: 1,
                        mainAxisExtent: 90,
                        itemCount: cartController.cartItems.length,
                        itemBuilder: (_, index) => ProductCardForCart(cartItem: cartController.cartItems[index]),
                      ),
                  ],
                )),
                const SizedBox(height: Sizes.spaceBtwSection,),

                // Billing Sections
                Container(
                  padding: TSpacingStyle.defaultPagePadding,
                  child: Column(
                    children: [
                      // coupon TextField
                      const TCouponCode(),
                      const SizedBox(height: Sizes.spaceBtwSection,),

                      // pricing
                      Divider(),
                      TBillingAmountSection(),

                      // payment method
                      Divider(),
                      TBillingPaymentSection(),

                      // address
                      Divider(),
                      TBillingAddressSection(),
                      SizedBox(height: Sizes.spaceBtwItems),
                    ],
                  ),
                ),///
              ],
            ),
          ),
    );
  }
}
