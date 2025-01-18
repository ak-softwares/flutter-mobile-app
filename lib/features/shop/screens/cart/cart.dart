import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../common/layout_models/grid_layout.dart';
import '../../../../common/navigation_bar/appbar2.dart';
import '../../../../common/widgets/loaders/animation_loader.dart';
import '../../../../common/widgets/product/product_cards/product_card_cart_items.dart';
import '../../../../data/repositories/authentication/authentication_repository.dart';
import '../../../../services/firebase_analytics/firebase_analytics.dart';
import '../../../../utils/constants/image_strings.dart';
import '../../../../utils/constants/sizes.dart';
import '../../../../utils/constants/text_strings.dart';
import '../../../../utils/helpers/navigation_helper.dart';
import '../../../authentication/screens/check_login_screen/check_login_screen.dart';
import '../../controllers/cart_controller/cart_controller.dart';
import '../../controllers/checkout_controller/checkout_controller.dart';
import '../checkout/checkout.dart';


class CartScreen extends StatelessWidget {
  const CartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    FBAnalytics.logPageView('Cart');
    final controller = CartController.instance;
    final checkoutController = Get.put(CheckoutController());

    return Scaffold(
        appBar: const TAppBar2(titleText: "Cart"),
        bottomNavigationBar: Obx((){
          if (AuthenticationRepository.instance.isUserLogin.value && controller.cartItems.isNotEmpty){
            return Padding(
              padding: const EdgeInsets.all(TSizes.defaultSpace),
              child: ElevatedButton(
                  onPressed: () {
                    checkoutController.updateCheckout();
                    Get.to(const TCheckoutScreen());
                  },
                  child: Obx(() => Text('Buy Now (${TTexts.currencySymbol + (controller.totalCartPrice.value).toStringAsFixed(0)})'))
              ),
            );
          } else {
            return const SizedBox.shrink();
          }
        }),
        body: Obx(() {
          //check user login_controller
          if(!AuthenticationRepository.instance.isUserLogin.value){
            return const CheckLoginScreen(text: 'Please Login! before Add to Cart!', animation: TImages.addToCartAnimation);
          }

          //make empty cart animation
          final emptyWidget = TAnimationLoaderWidgets(
            text: 'Whoops! Cart is Empty...',
            animation: TImages.addToCartAnimation,
            showAction: true,
            actionText: 'Let\'s add some',
            onActionPress: () => NavigationHelper.navigateToBottomNavigation(),
          );

          // check empty cart
          if(controller.cartItems.isEmpty) {
            return emptyWidget;
          } else{
            return SingleChildScrollView(
              // padding: const EdgeInsets.all(TSizes.defaultSpace),
              child: TGridLayout(
                crossAxisCount: 1,
                mainAxisExtent: 120,
                mainAxisSpacing: 0,
                itemCount: controller.cartItems.length,
                itemBuilder: (_, index) => Stack(
                  children:[
                    TProductCardForCart(cartItem: controller.cartItems[index], showBottomBar: true),
                  ]
                ),
              ),
            );
          }
        }
      ),
    );
  }
}


