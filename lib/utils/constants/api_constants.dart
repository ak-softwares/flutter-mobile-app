
import 'dart:convert';

import 'package:flutter_dotenv/flutter_dotenv.dart';

class APIConstant {

  //WooCommerce API Constant
  static final String wooBaseUrl            =  dotenv.get('WOO_API_URL', fallback: '');
  static final String authorization         = 'Basic ${base64Encode(utf8.encode('${dotenv.env['WOO_CONSUMER_KEY']}:${dotenv.env['WOO_CONSUMER_SECRET']}'))}';

  static const String itemsPerPage          = '10';
  static final String wooTrackingUrl        = '$wooBaseUrl/tracking/?order-id=';

  //Define urls
  static const String urlContainProduct         = '/product/';
  static const String urlContainProductCategory = '/product-category/';

  //Policy Urls
  static const String privacyPrivacy        = 'https://aramarket.in/privacy-policy/';
  static const String shippingPolicy        = 'https://aramarket.in/shipping-policy/';
  static const String termsAndConditions    = 'https://aramarket.in/terms-and-conditions/';
  static const String refundPolicy          = 'https://aramarket.in/refund_returns/';

  //Follow us link
  static const String facebook              = 'https://www.facebook.com/araMarket.in';
  static const String instagram             = 'https://www.instagram.com/aramarket.in/';
  static const String telegram              = 'https://www.instagram.com/aramarket.in/';
  static const String twitter               = 'https://twitter.com/aramarket_India';
  static const String youtube               = 'https://www.youtube.com/@aramarket';
  static const String playStore             = 'https://play.google.com/store/apps/details?id=com.company.aramarketin&hl=en_IN&gl=US';


  static const String wooProductsApiPath    = '/wp-json/wc/v3/products/';
  static const String wooCategoriesApiPath  = '/wp-json/wc/v3/products/categories/';
  static const String wooCouponsApiPath     = '/wp-json/wc/v3/coupons/';
  static const String wooOrdersApiPath      = '/wp-json/wc/v3/orders/';
  static const String wooCustomersApiPath   = '/wp-json/wc/v3/customers/';
  static const String wooProductsReview     = '/wp-json/wc/v3/products/reviews/';

  static const String wooCustomersPhonePath = '/wp-json/flutter-app/v1/customer-by-phone/';
  static const String wooAuthenticatePath   = '/wp-json/flutter-app/v1/authenticate/';
  static const String wooResetPassword      = '/wp-json/flutter-app/v1/reset-password/';
  static const String wooFBT                = '/wp-json/flutter-app/v1/products-sold-together/';

  //fast2sms url
  static final String fast2smsUrl           = dotenv.get('FAST2SMS_API_URL', fallback: '');
  static final String fast2smsToken         = dotenv.get('FAST2SMS_API_TOKEN', fallback: '');

}