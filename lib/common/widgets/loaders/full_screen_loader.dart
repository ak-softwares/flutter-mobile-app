import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../utils/constants/colors.dart';
import 'animation_loader.dart';

class TFullScreenLoader {
  static void openLoadingDialog(String text, String animation) {
    showDialog(
        context: Get.overlayContext!,  //use get.overlayContext for overlay dialog
        barrierDismissible: false,
        builder: (BuildContext context) => PopScope(
          canPop: false, //disable popping with the back button
          child: Container(
            width: double.infinity,
            height: double.infinity,
            color: Theme.of(context).colorScheme.surface,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                TAnimationLoaderWidgets(text: text, animation: animation,),
              ],
            ),
          )
        )
    );
  }
  static void onlyCircularProgressDialog(String text) {
    showDialog(
        context: Get.overlayContext!,  //use get.overlayContext for overlay dialog
        barrierDismissible: false,
        builder: (BuildContext context) => PopScope(
            canPop: false, // disable popping with the back button
            child: Container(
              width: double.infinity,
              height: double.infinity,
              color: Theme.of(context).colorScheme.surface.withOpacity(0.5),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(
                      height: 25,
                      width: 25,
                      child: CircularProgressIndicator(color: AppColors.linkColor, strokeWidth: 2,)
                  ),
                  SizedBox(height: 25),
                  Material(color: Colors.transparent, child: Text(text, style: TextStyle(fontSize: 14)))
                ],
              ),
            )
        )
    );
  }
  static stopLoading() {
    Navigator.of(Get.overlayContext!).pop(); // close the dialog using the navigator
  }
}
