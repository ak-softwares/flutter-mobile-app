import 'package:firebase_analytics/firebase_analytics.dart';

class FBAnalytics {
  static final FirebaseAnalytics _analytics = FirebaseAnalytics.instance;
  static FirebaseAnalyticsObserver observer = FirebaseAnalyticsObserver(analytics: _analytics);

  static void logLogin(String loginMethod) async {
    return _analytics.logLogin(loginMethod: loginMethod);
  }

  static void logPageView(String pageName) async {
    _analytics.logEvent(name: 'page_view', parameters: {'page_name': pageName});
  }

  static void logAddToCart(String itemId) {
    _analytics.logAddToCart(items: [AnalyticsEventItem(itemId: itemId)],);
  }


}