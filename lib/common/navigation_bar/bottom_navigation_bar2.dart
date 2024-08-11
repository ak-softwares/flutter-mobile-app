import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:google_nav_bar/google_nav_bar.dart';

import '../../features/personalization/screens/settings/settings_screen.dart';
import '../../features/shop/controllers/cart_controller/cart_controller.dart';
import '../../features/shop/screens/cart/cart.dart';
import '../../features/shop/screens/category/category_screen.dart';
import '../../features/shop/screens/home/home.dart';
import '../../utils/constants/colors.dart';
import '../../utils/constants/icons.dart';
import '../widgets/loaders/loader.dart';


class BottomNavigation2 extends StatefulWidget {
  const BottomNavigation2({super.key});

  @override
  State<BottomNavigation2> createState() => _BottomNavigation2State();
}

class _BottomNavigation2State extends State<BottomNavigation2> {
  final cartController = Get.put(CartController());

  DateTime? _lastBackPressedTime; // Variable to track the time of the last back button press
  int _currentIndex = 0;
  final screens = [
    const MyHomePage(),
    const CategoryScreen(),
    // const FavouriteScreen(),
    const CartScreen(),
    const SettingsScreen(),
  ];
  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false, // This property disables the system-level back navigation
      onPopInvoked: (didPop) {
        if (didPop) {
          return;
        }
        if(_currentIndex != 0){
          setState(() => _currentIndex = 0);
        } else {
          // Check if _lastBackPressedTime is not null and the difference between the current time
          // and the last back pressed time is less than 2 seconds
          if (_lastBackPressedTime != null &&
              DateTime.now().difference(_lastBackPressedTime!) <= const Duration(seconds: 2)) {
            // If the conditions are met, exit the app
            SystemNavigator.pop();
          } else {
            // If not, show a toast message and update _lastBackPressedTime
            TLoaders.customToast(message: "Press Back Again To Exit");
            _lastBackPressedTime = DateTime.now();
          }
        }
      },
      child: Scaffold(
        body: IndexedStack(
          index: _currentIndex,
          children: screens,
        ),
        bottomNavigationBar: GNav(
            selectedIndex: _currentIndex,
            onTabChange: (index) => setState(() => _currentIndex = index),
            tabMargin: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
            haptic: true, // haptic feedback
            tabBorderRadius: 5,
            tabActiveBorder: Border.all(color: TColors.primaryColor, width: 1), // tab button border
            curve: Curves.easeOutExpo, // tab animation curves
            duration: const Duration(milliseconds: 100), // tab animation duration
            gap: 8, // the tab button gap between icon and text
            // color: Colors.grey[800], // unselected icon color
            activeColor: Colors.black, // selected icon and text color
            iconSize: 25, // tab button icon size
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5), // navigation bar padding
            tabs: [
              GButton(
                icon: TIcons.home,
                text: 'Home',
              ),
              GButton(
                icon: TIcons.category,
                text: 'Category',
              ),
              // GButton(
              //   icon: LineIcons.heart,
              //   text: 'Likes',
              // ),
              GButton(
                icon: TIcons.bottomNavigationCart,
                text: 'Cart',
                leading: Obx(() => Badge(
                  backgroundColor: Colors.transparent,
                  textColor: TColors.secondaryColor,
                  textStyle: Theme.of(context).textTheme.labelSmall!.apply(
                      color: TColors.secondaryColor,
                      fontSizeFactor: 0.9,
                      fontWeightDelta: 2
                  ),
                  isLabelVisible: cartController.noOfCartItems.value > 0,
                  label: Container(
                      width: 16,
                      height: 20,
                      decoration: BoxDecoration(
                        // boxShadow: const [BoxShadow(
                        //   color: Color(0xFFAB7C00),
                        //   blurRadius: 1, // Adjust as needed
                        //   // spreadRadius: 5, // Adjust as needed
                        //   offset: Offset(0, 0), // Adjust as needed
                        // )],
                          color: TColors.primaryColor,
                          borderRadius: BorderRadius.circular(100)
                      ),
                      child: Obx(() => Center(child: Text(cartController.noOfCartItems.value.toString())))
                  ),
                  child: Icon(TIcons.bottomNavigationCart, size: 25),
                ))
              ),
              GButton(
                icon: TIcons.user,
                text: 'Profile',
              )
            ]
        ),
      ),
    );
  }
}