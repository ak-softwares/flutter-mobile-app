import 'package:flutter/material.dart';

import '../../constants/colors.dart';
import '../../constants/sizes.dart';

class TOutlinedButtonTheme {
  TOutlinedButtonTheme._();

  static final lightOutlinedButtonTheme = OutlinedButtonThemeData(
    style: OutlinedButton.styleFrom(
      elevation: 0,
      foregroundColor: AppColors.buttonTextColor,
      side: const BorderSide(color: AppColors.buttonBorder),
      alignment: Alignment.center,
      textStyle: const TextStyle(fontSize: Sizes.buttonTextSize, fontWeight: FontWeight.w500),
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(Sizes.buttonRadius)),
    )
  );

  static final darkOutlinedButtonTheme = OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        elevation: 0,
        foregroundColor: Colors.white,
        side: const BorderSide(color: Colors.blue),
        textStyle: const TextStyle(fontSize: Sizes.buttonTextSize, fontWeight: FontWeight.w500),
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(Sizes.buttonRadius)),
      )
  );
}