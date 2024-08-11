import 'package:aramarket/features/personalization/controllers/user_controller.dart';
import 'package:get/get.dart';

import '../common/widgets/network_manager/network_manager.dart';
import '../data/repositories/user/user_repository.dart';
import '../data/repositories/woocommerce_repositories/authentication/woo_authentication.dart';
import '../data/repositories/woocommerce_repositories/customers/woo_customer_repository.dart';
import '../features/personalization/controllers/address_controller.dart';
import '../features/shop/controllers/cart_controller/cart_controller.dart';
import '../features/shop/controllers/checkout_controller/checkout_controller.dart';
import '../features/shop/controllers/favorite/favorite_controller.dart';
import '../features/shop/controllers/product/product_controller.dart';
import '../features/shop/controllers/recently_viewed_controller/recently_viewed_controller.dart';

class GeneralBindings extends Bindings {
  @override
  void dependencies() {
    Get.put(NetworkManager());
    Get.put(AddressController());
    Get.put(FavoriteController());
    Get.put(CheckoutController());
    Get.put(ProductController());
    Get.put(CartController());
    Get.put(RecentlyViewedController());
    Get.put(UserRepository());
    Get.put(UserController());

    Get.put(WooAuthenticationRepository());
    Get.put(WooCustomersRepository());
  }
}