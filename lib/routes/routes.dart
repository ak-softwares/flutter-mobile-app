import 'package:aramarket/features/shop/screens/cart/cart.dart';
import 'package:aramarket/features/shop/screens/favourite/favourite.dart';
import 'package:aramarket/features/shop/screens/orders/orders.dart';
import 'package:aramarket/features/shop/screens/orders/single_order_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/src/routes/default_route.dart';
import 'package:package_info_plus/package_info_plus.dart';

import '../common/web_view/my_web_view.dart';
import '../data/repositories/authentication/authentication_repository.dart';
import '../features/shop/controllers/checkout_controller/checkout_controller.dart';
import '../features/shop/controllers/product/product_controller.dart';
import '../features/shop/models/order_model.dart';
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
  final checkoutController = Get.put(CheckoutController());

  static Route<dynamic>? handleRoute({required String route}) {

    parseOrderAttribution(route);

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
  static String _extractSlug(String url) {
    // Extract only the path part from the URL
    Uri uri = Uri.parse(url);
    String path = uri.path;
    // Remove leading and trailing slashes
    path = path.trim().replaceAll(RegExp(r'^/+|/+$'), '');

    // Split the path into segments and return the last valid segment
    List<String> segments = path.split('/');
    return segments.isNotEmpty ? segments.last : '';
  }

  // Normalizes deep links (e.g., "https://example.com/product/slug" → "/product/slug")
  static String normalizeRoute(String route) {
    final domain = APIConstant.wooBaseDomain;
    final baseUrls = ['https://$domain', 'http://$domain', domain, 'www.$domain'];
    for (final baseUrl in baseUrls) {
      if (route.startsWith(baseUrl)) {
        return route.substring(baseUrl.length);
      }
    }
    return route;
  }

  static bool checkIsDomainContain(String route) {
    final domain = APIConstant.wooBaseDomain;
    return route.contains(domain);
  }

  static void parseOrderAttribution(String url) {
    final domain = APIConstant.wooBaseDomain;
    Uri uri = Uri.parse(url);
    final queryParams = uri.queryParameters;

    // Default values
    String sourceType = 'direct';
    String campaign = '';
    String medium = '';
    final referrer = 'https://$domain$uri';

    // Check for Google Ads (gclid parameter)
    if (queryParams.containsKey('gclid')) {
      sourceType = 'referral';
      campaign = 'google_ads';
    }

    // Check for Google Organic (srsltid parameter)
    else if (queryParams.containsKey('srsltid')) {
      sourceType = 'organic';
      campaign = 'google';
    }

    // Check for Facebook/Instagram Ads (fbclid parameter)
    else if (queryParams.containsKey('fbclid')) {
      sourceType = 'referral';

      // Check if it's Instagram
      if (queryParams['utm_source'] == 'ig') {
        campaign = 'instagram_ads';
        medium = queryParams['utm_campaign'] ?? '';
      }

      // Otherwise treat as Facebook
      else {
        campaign = 'facebook_ads';
        medium = queryParams['utm_campaign'] ?? '';
      }
    }

    // Check for custom UTM parameters
    else if (queryParams.containsKey('utm_source') || queryParams.containsKey('utm_medium') || queryParams.containsKey('utm_campaign')) {
      sourceType = 'utm';
      campaign = queryParams['utm_campaign'] ?? 'unknown_campaign';
      medium = queryParams['utm_medium'] ?? 'unknown';
    }

    // Get the controller instance in a static context
    final controller = Get.find<CheckoutController>();

    // Construct the order attribution model
    controller.orderAttribution = OrderAttributionModel(
      sourceType: sourceType,
      campaign: campaign.isNotEmpty ? campaign : null,
      medium: medium.isNotEmpty ? medium : null,
      referrer: referrer,
    );
  }

}