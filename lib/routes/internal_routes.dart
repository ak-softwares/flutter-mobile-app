import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher_string.dart';

import '../common/web_view/my_web_view.dart';
import '../features/shop/controllers/product/product_controller.dart';
import '../features/shop/screens/all_products/all_products.dart';
import '../features/shop/screens/orders/orders.dart';
import '../features/shop/screens/products/product_detail.dart';
import '../utils/constants/api_constants.dart';
import 'routes.dart';

class InternalAppRoutes {
  static final productController = Get.put(ProductController());

  static void handleInternalRoute({required String url}) {
    final normalizeRoute = AppRouter.normalizeRoute(url);
    if (!isValidWooCommerceUrl(url)) return;
    final route = AppRouter.handleRoute(route: normalizeRoute);
    // if (route != null) Get.to(route);
    if(route != null) Navigator.push(Get.context!, route);
  }

  static bool isValidWooCommerceUrl(String url) {
    final domain = APIConstant.wooBaseDomain;
    RegExp regExp = RegExp(r"^https?:\/\/" + domain + r"\/.*$", caseSensitive: false);
    return regExp.hasMatch(url);
  }
}
