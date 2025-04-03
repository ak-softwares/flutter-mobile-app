import 'package:flutter/material.dart';

import '../../constants/colors.dart';
import '../../constants/sizes.dart';
class TElevatedButtonTheme {
  TElevatedButtonTheme._();
  static final lightElevatedButtonTheme = ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      elevation: 0,
      foregroundColor: AppColors.buttonTextColor,
      backgroundColor: AppColors.buttonBackgroundColor,
      disabledForegroundColor: Colors.grey,
      disabledBackgroundColor: Colors.grey,
      padding: const EdgeInsets.symmetric(vertical: AppSizes.buttonPadding),
      textStyle: const TextStyle(fontSize: AppSizes.buttonTextSize, fontWeight: AppSizes.buttonTextWeight),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppSizes.buttonRadius)),
    )
  );
  static final darkElevatedButtonTheme = ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        elevation: 0,
        foregroundColor: AppColors.buttonTextColor,
        backgroundColor: AppColors.buttonBackgroundColor,
        disabledForegroundColor: Colors.grey,
        disabledBackgroundColor: Colors.grey,
        padding: const EdgeInsets.symmetric(vertical: AppSizes.buttonPadding),
        textStyle: const TextStyle(fontSize: AppSizes.buttonTextSize, fontWeight: AppSizes.buttonTextWeight),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppSizes.buttonRadius)),
      )
  );
}