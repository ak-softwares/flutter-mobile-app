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
      padding: const EdgeInsets.symmetric(vertical: Sizes.buttonPadding),
      textStyle: const TextStyle(fontSize: Sizes.buttonTextSize, fontWeight: Sizes.buttonTextWeight),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(Sizes.buttonRadius)),
    )
  );
  static final darkElevatedButtonTheme = ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        elevation: 0,
        foregroundColor: AppColors.buttonTextColor,
        backgroundColor: AppColors.buttonBackgroundColor,
        disabledForegroundColor: Colors.grey,
        disabledBackgroundColor: Colors.grey,
        padding: const EdgeInsets.symmetric(vertical: Sizes.buttonPadding),
        textStyle: const TextStyle(fontSize: Sizes.buttonTextSize, fontWeight: Sizes.buttonTextWeight),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(Sizes.buttonRadius)),
      )
  );
}