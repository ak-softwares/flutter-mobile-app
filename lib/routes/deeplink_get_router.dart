import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher_string.dart';

import '../common/navigation_bar/bottom_navigation_bar.dart';
import '../common/navigation_bar/bottom_navigation_bar1.dart';
import '../features/personalization/screens/user_menu/user_menu_screen.dart';
import '../features/shop/controllers/product/product_controller.dart';
import '../features/shop/screens/all_products/all_products.dart';
import '../features/shop/screens/cart/cart.dart';
import '../features/shop/screens/category/all_category_screen.dart';
import '../features/shop/screens/checkout/checkout.dart';
import '../features/shop/screens/favourite/favourite.dart';
import '../features/shop/screens/home/home.dart';
import '../features/shop/screens/orders/orders.dart';
import '../features/shop/screens/products/product_detail.dart';
import '../features/shop/screens/store/store.dart';
import '../utils/constants/api_constants.dart';

class MyMiddleware extends GetMiddleware {
  @override
  GetPage? onPageCalled(GetPage? page) {
    if (page?.name != RoutesPath.home) {
      // Navigate to home first, then after a delay, navigate to the deep-linked page
      Future.delayed(Duration.zero, () {
        Get.offAllNamed(RoutesPath.home); // Force home screen first
        Future.delayed(Duration(milliseconds: 500), () {
          Get.toNamed(page!.name); // Navigate to deep-linked page
        });
      });

      return GetPage(name: RoutesPath.home, page: () => BottomNavigation1()); // Return Home page
    }

    return super.onPageCalled(page);
  }
}


class AppGetRoutes {
  static final pages = [
    GetPage(name: RoutesPath.home, page: () => const BottomNavigation1(),),
    GetPage(name: RoutesPath.product, page: () => ProductScreen(slug: Get.parameters['slug']),),
    GetPage(name: RoutesPath.category, page: () => const CategoryScreen(), middlewares: [MyMiddleware()],),
    GetPage(name: RoutesPath.category, page: () => TAllProducts(title: 'Products', categoryId: Get.parameters['slug'], futureMethodTwoString: ProductController.instance.getProductsByCategorySlug)),
    GetPage(name: RoutesPath.tracking, page: () => const OrderScreen(),),
    GetPage(name: RoutesPath.settingsScreen, page: () => const UserMenuScreen()),
    GetPage(name: RoutesPath.favouritesScreen, page: () => const FavouriteScreen(), transition: Transition.rightToLeft,),
    GetPage(name: RoutesPath.cart, page: () => const CartScreen(), transition: Transition.rightToLeft),
    GetPage(name: RoutesPath.checkout, page: () => const CheckoutScreen(), transition: Transition.rightToLeft),
    GetPage(name: RoutesPath.store, page: () => const StoreScreen()),
    GetPage(name: RoutesPath.orders, page: () => const OrderScreen(),),

  ];

  // Define a default route
  static final defaultRoute = GetPage(
    name: '/:route', // Matches any route
    page: () => const Material(child: OrderScreen()), // Display a "Page Not Found" screen
    middlewares: [MyMiddleware()],
  );

  static void pageRouteHandle({required String routeName}) {
    if (isValidUrl(routeName)) {
      // Extract the slug from the URL and navigate to the product detail screen
      String slug = extractSlugFromUrl(routeName);
      Get.to(() => ProductScreen(slug: slug));
      // Get.toNamed('${CustomRoutes.product}/$slug');
    } else {
      launchUrlString(routeName);
    }
  }

  // Function to extract the slug from the full URL
  static String extractSlugFromUrl(String url) {
    // Remove any trailing slashes from the URL
    url = url.replaceAll(RegExp(r'/$'), '');

    // Split the URL by '/' and get the last part
    List<String> urlParts = url.split('/');
    String slug = urlParts.last;

    return slug;
  }

  static bool isValidUrl(String url) {
    final domain = APIConstant.wooBaseDomain;
    RegExp regExp = RegExp(
      r"^https?:\/\/" + domain + r"\/.*$",
      caseSensitive: false,
    );
    return regExp.hasMatch(url);
  }

}

class RoutesPath {
  static const home = '/';
  static const product = '/product/:slug';
  static const category = '/product-category/:slug';
  static const orders = '/my-account/orders';
  static const tracking = '/tracking';
  static const settingsScreen = '/my-account';
  static const store = '/store';
  static const favouritesScreen = '/wishlist';
  static const cart = '/cart';
  static const checkout = '/checkout';

  static const subCategories = '/sub-categories';
  static const search = '/search';
  static const productReview = '/product-review';
  static const brand = '/brand';
  static const allProducts = '/all-products';
  static const userProfile = '/user-profile';
  static const userAddress = '/user-address';
  static const signup = '/signup';
  static const signupSuccess = '/signup-success';
  static const verifyEmail = '/verify-email';
  static const signIn = '/sign-in';
  static const resetPassword = '/reset-password';
  static const forgetPassword = '/forget-password';
  static const onBoarding = '/on-boarding';
}

class RoutesName {
  static const home = 'home';
}