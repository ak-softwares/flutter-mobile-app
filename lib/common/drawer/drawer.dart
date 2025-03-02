import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../data/repositories/authentication/authentication_repository.dart';
import '../../features/personalization/controllers/user_controller.dart';
import '../../features/personalization/screens/user_menu/user_menu_screen.dart';
import '../../features/personalization/screens/user_menu/widgets/contact_widget.dart';
import '../../features/personalization/screens/user_menu/widgets/follow_us.dart';
import '../../features/personalization/screens/user_menu/widgets/menu.dart';
import '../../services/firebase_analytics/firebase_analytics.dart';
import '../../utils/constants/colors.dart';
import '../../utils/constants/sizes.dart';
import '../text/section_heading.dart';

class MyDrawer extends StatelessWidget {
  const MyDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    FBAnalytics.logPageView('drawer_menu_screen');
    final userController = Get.put(UserController());
    final authenticationRepository = Get.put(AuthenticationRepository());

    return Drawer(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(0),
      ),
      child: UserMenuScreen(),
    );
  }
}
