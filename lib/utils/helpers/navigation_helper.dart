
import 'package:get/get.dart';

import '../../common/navigation_bar/bottom_navigation_bar2.dart';
import '../../features/authentication/screens/phone_otp_login/mobile_no_screen.dart';

class NavigationHelper {
  static void navigateToBottomNavigation() {
    Get.offAll(const BottomNavigation2());
  }

  static void navigateToLoginScreen() {
      Get.offAll(const MobileLoginScreen());
    // Get.offAll(const LoginScreen());
  }
  static void navigateToMobileLogin() {
    Get.offAll(const MobileLoginScreen());
    // Get.offAll(const LoginScreen());
  }
}
