import 'package:flutter/material.dart';
import 'package:get/get_navigation/src/routes/default_route.dart';

import '../common/navigation_bar/bottom_navigation_bar1.dart';
import 'routes.dart';

class ExternalAppRoutes {

  static Route<dynamic>? handleDeepLink({required RouteSettings settings}) {
    final route = AppRouter.normalizeRoute(settings.name ?? '/');
    if (_isDeepLink(settings.name ?? '')) {
      return GetPageRoute(page: () => BottomNavigation1(route: route));
    }
    return AppRouter.handleRoute(route: route);
  }

  // Helper functions
  static bool _isDeepLink(String route) {
    const baseUrls = ['https://aramarket.in', 'http://aramarket.in', 'aramarket.in'];
    return baseUrls.any((baseUrl) => route.contains(baseUrl));
  }

}