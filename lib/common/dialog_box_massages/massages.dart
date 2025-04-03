import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';

import '../../utils/constants/colors.dart';
import '../../utils/constants/sizes.dart';
class AppMassages  extends GetxController {
  static OverlayEntry? _overlayEntry;
  static bool _isToastVisible = false;
  static int massagesDuration = 1500;

  static void showSnackBar({required BuildContext context, required String massage}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(massage)),
    );
  }

  static void showToastMessage({required String message}) {
    if (_isToastVisible) return; // Prevent showing multiple toasts

    hideToastMessage(); // Remove any existing toast before showing a new one

    _overlayEntry = OverlayEntry(
      builder: (context) => Positioned(
        bottom: Get.height * 0.1,
        left: 50,
        right: 50,
        child: IgnorePointer(
          ignoring: true,
          child: Material(
            color: Colors.transparent,
            child: Container(
              padding: const EdgeInsets.all(12.0),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(AppSizes.defaultRadius),
                color: Theme.of(context).colorScheme.surface,
                // boxShadow: [
                //   BoxShadow(
                //     color: Colors.grey.withOpacity(0.1), // Very light shadow
                //     blurRadius: 4, // Small blur radius for less depth
                //     spreadRadius: 1, // Minimal spread
                //     offset: const Offset(0, 2), // Slight downward shadow
                //   ),
                // ],
              ),
              child: Center(
                child: Text(
                  message,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.onSurface,
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );

    // Use Get.overlayContext! instead of Get.context!
    if (Get.overlayContext != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Overlay.of(Get.overlayContext!).insert(_overlayEntry!);
        _isToastVisible = true;
      });

      // Automatically remove toast after 1.5 seconds
      Future.delayed(Duration(milliseconds: massagesDuration), hideToastMessage);
    }
  }

  static successSnackBar({required String title, String message = ''}) {
    // Remove any existing snackbar before showing a new one
    hideSnackBar();
    // Show the new snackbar with custom design
    ScaffoldMessenger.of(Get.context!).showSnackBar(
      SnackBar(
        elevation: 0,
        duration: const Duration(milliseconds: 2000),
        backgroundColor: Colors.transparent,
        content: Container(
          padding: const EdgeInsets.all(12.0),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(AppSizes.defaultRadius),
            color: Colors.green.shade600,
          ),
          child: Column(
            children: [
              Text(title, style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w500)),
              Text(message, style: const TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.w400))
            ],
          ),

        ),
      ),
    );
  }

  static warningSnackBar({required String title, String message = ''}) {
    // Remove any existing snackbar before showing a new one
    hideSnackBar();
    // Show the new snackbar with custom design
    ScaffoldMessenger.of(Get.context!).showSnackBar(
      SnackBar(
        elevation: 0,
        duration: Duration(milliseconds: massagesDuration),
        backgroundColor: Colors.transparent,
        content: Container(
          padding: const EdgeInsets.all(12.0),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(AppSizes.defaultRadius),
            color: Colors.orange.shade600,
          ),
          child: Column(
            children: [
              Text(title, style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w500)),
              Text(message, style: const TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.w400))
            ],
          ),

        ),
      ),
    );
  }

  static errorSnackBar({required String title, String message = ''}) {
    // Remove any existing snackbar before showing a new one
    hideSnackBar();
    // Show the new snackbar with custom design
    ScaffoldMessenger.of(Get.context!).showSnackBar(
      SnackBar(
        elevation: 0,
        duration: const Duration(milliseconds: 5000),
        backgroundColor: Colors.transparent,
        content: Container(
          padding: const EdgeInsets.all(12.0),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(AppSizes.defaultRadius),
            color: Colors.red.shade600,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w500)),
              Text(message, style: const TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.w400))
            ],
          ),

        ),
      ),
    );
  }

  static hideSnackBar() => ScaffoldMessenger.of(Get.context!).hideCurrentSnackBar();

  static void hideToastMessage() {
    if (_overlayEntry != null) {
      _overlayEntry!.remove();
      _overlayEntry = null;
      _isToastVisible = false;
    }
  }
}