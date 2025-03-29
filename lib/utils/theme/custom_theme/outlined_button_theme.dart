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
      textStyle: const TextStyle(fontSize: Sizes.buttonTextSize, fontWeight: Sizes.buttonTextWeight),
      padding: const EdgeInsets.symmetric(vertical: Sizes.buttonPadding),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(Sizes.buttonRadius)),
    )
  );

  static final darkOutlinedButtonTheme = OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        elevation: 0,
        foregroundColor: Colors.white,
        side: const BorderSide(color: AppColors.buttonBorder),
        textStyle: const TextStyle(fontSize: Sizes.buttonTextSize, fontWeight: Sizes.buttonTextWeight),
        padding: const EdgeInsets.symmetric(vertical: Sizes.buttonPadding),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(Sizes.buttonRadius)),
      )
  );
}