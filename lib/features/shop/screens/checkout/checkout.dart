import 'package:aramarket/features/personalization/controllers/user_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../common/layout_models/grid_layout.dart';
import '../../../../common/navigation_bar/appbar2.dart';
import '../../../../common/widgets/custom_shape/containers/rounded_container.dart';
import '../../../../common/widgets/product/product_cards/product_card_cart_items.dart';
import '../../../../data/repositories/authentication/authentication_repository.dart';
import '../../../../utils/constants/sizes.dart';
import '../../../../utils/constants/text_strings.dart';
import '../../../authentication/screens/check_login_screen/check_login_screen.dart';
import '../../controllers/cart_controller/cart_controller.dart';
import '../../controllers/checkout_controller/checkout_controller.dart';
import '../../controllers/product/order_controller.dart';
import 'widgets/billing_address_section.dart';
import 'widgets/billing_amount_section.dart';
import 'widgets/billing_payment_section.dart';
import 'widgets/coupon_section.dart';

class TCheckoutScreen extends StatelessWidget {
  const TCheckoutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final cartController = Get.put(CartController());
    final orderController = Get.put(OrderController());
    final checkoutController = Get.put(CheckoutController());
    final authenticationRepository = Get.put(AuthenticationRepository());

    return Scaffold(
      appBar: const TAppBar2(titleText: "Order summery", showBackArrow: true),
      bottomNavigationBar: Obx((){
        if (AuthenticationRepository.instance.isUserLogin.value && cartController.cartItems.isNotEmpty){
          return Padding(
              padding: const EdgeInsets.all(TSizes.defaultSpace),
              child: ElevatedButton(
                  onPressed: () => checkoutController.initiateCheckout(),
                  // onPressed: () {},
                  child: Obx(() => Text('Place Order (${TTexts.currencySymbol +
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
            padding: const EdgeInsets.all(TSizes.defaultSpace),
            child: Column(
              children: [
                Obx(
                  () => TGridLayout(
                    crossAxisCount: 1,
                    mainAxisExtent: 90,
                    mainAxisSpacing: 5,
                    itemCount: cartController.cartItems.length,
                    itemBuilder: (_, index) => Stack(
                        children:[
                          TProductCardForCart(cartItem: cartController.cartItems[index]),
                        ]
                    ),
                  ),
                ),
                const SizedBox(height: TSizes.spaceBtwSection,),

                /// -- coupon TextField
                const TCouponCode(),
                const SizedBox(height: TSizes.spaceBtwSection,),

                /// -- Billing Sections
                const TRoundedContainer(
                  showBorder: true,
                  padding: EdgeInsets.all(TSizes.md),
                  child: Column(
                    children: [
                      /// pricing
                      TBillingAmountSection(),
                      SizedBox(height: TSizes.spaceBtwItems,),

                      /// Divider
                      Divider(),
                      SizedBox(height: TSizes.spaceBtwItems),

                      /// payment method
                      TBillingPaymentSection(),
                      SizedBox(height: TSizes.spaceBtwItems),

                      /// Divider
                      Divider(),
                      SizedBox(height: TSizes.spaceBtwItems),

                      /// address
                      TBillingAddressSection(),
                      SizedBox(height: TSizes.spaceBtwItems),
                    ],
                  ),
                ),///
              ],
            ),
          ),
    );
  }
}
