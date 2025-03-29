import 'package:aramarket/features/shop/screens/cart/cart.dart';
import 'package:aramarket/features/shop/screens/favourite/favourite.dart';
import 'package:aramarket/features/shop/screens/orders/orders.dart';
import 'package:aramarket/features/shop/screens/orders/single_order_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/src/routes/default_route.dart';

import '../common/web_view/my_web_view.dart';
import '../features/shop/controllers/product/product_controller.dart';
import '../features/shop/screens/all_products/all_products.dart';
import '../features/shop/screens/brands/all_brands.dart';
import '../features/shop/screens/category/all_category_screen.dart';
import '../features/shop/screens/products/product_detail.dart';
import '../features/shop/screens/store/my_store.dart';
import '../utils/constants/api_constants.dart';

class RoutesPath {
  static const home = '/';
  static const product = '/product/';
  static const category = '/product-category/';
  static const allCategories = '/product-categories';
  static const brand = '/brand/';
  static const allBrands = '/product-brands';
  static const orders = '/my-account/orders';
  static const singleOrder = '/my-account/view-order';
  static const tracking = '/tracking';
  static const settingsScreen = '/settings';
  static const wishlist = '/wishlist';
  static const cart = '/cart';
  static const store = '/store';
}



class AppRouter {

  static Route<dynamic>? handleRoute({required String route}) {

    // Product
    if (route.startsWith(RoutesPath.product)) {
      final slug = _extractSlug(route);
      return GetPageRoute(page: () => ProductScreen(slug: slug));
    }

    // Category
    if (route.startsWith(RoutesPath.category)) {
      final slug = _extractSlug(route);
      return GetPageRoute(
        page: () => TAllProducts(
          title: 'Products By Category',
          categoryId: slug,
          futureMethodTwoString: ProductController.instance.getProductsByCategorySlug,
        ),
      );
    }

    // All Categories
    if (route.startsWith(RoutesPath.allCategories)) {
      return GetPageRoute(page: () => CategoryScreen());
    }

    // Brand
    if (route.startsWith(RoutesPath.brand)) {
      final slug = _extractSlug(route);
      return GetPageRoute(
        page: () => TAllProducts(
          title: 'Products By Brand',
          categoryId: slug,
          futureMethodTwoString: ProductController.instance.getProductsByBrandSlug,
        ),
      );
    }

    // All Brands
    if (route.startsWith(RoutesPath.allBrands)) {
      return GetPageRoute(page: () => AllBrandScreen());
    }

    // All Orders
    if (route.startsWith(RoutesPath.orders)) {
      return GetPageRoute(page: () => OrderScreen());
    }

    // Single Order
    if (route.startsWith(RoutesPath.singleOrder)) {
      final slug = _extractSlug(route);
      return GetPageRoute(page: () => SingleOrderScreen(orderId: slug));
    }

    // Order tracking
    // if (route.startsWith(RoutesPath.tracking)) {
    //   return GetPageRoute(page: () => MyWebView(title: 'Track Order', url: APIConstant.wooBaseUrl + route));
    // }
    if (route.startsWith(RoutesPath.tracking)) {
      Get.to(() => MyWebView(title: 'Track Order', url: APIConstant.wooBaseUrl + route))!
          .then((_) => Get.to(() => OrderScreen())); // Navigate to OrderScreen after returning from MyWebView
      return null; // No need to return a route since we're handling navigation manually
    }

    // Wishlist
    if (route.startsWith(RoutesPath.wishlist)) {
      return GetPageRoute(page: () => FavouriteScreen());
    }

    // Cart
    if (route.startsWith(RoutesPath.cart)) {
      return GetPageRoute(page: () => CartScreen());
    }

    // Store
    if (route.startsWith(RoutesPath.store)) {
      return GetPageRoute(page: () => MyStoreScreen());
    }

    return null;
  }


  // Extracts slug from URL (e.g., "/product/one-stop-iron" → "one-stop-iron")
  static String _extractSlug(String path) {
    return path.split('/').lastWhere((e) => e.isNotEmpty, orElse: () => '');
  }

  // Normalizes deep links (e.g., "https://example.com/product/slug" → "/product/slug")
  static String normalizeRoute(String route) {
    const baseUrls = ['https://aramarket.in', 'http://aramarket.in', 'aramarket.in'];
    for (final baseUrl in baseUrls) {
      if (route.startsWith(baseUrl)) {
        return route.substring(baseUrl.length);
      }
    }
    return route;
  }

}