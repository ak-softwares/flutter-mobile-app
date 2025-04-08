import 'package:aramarket/features/settings/app_settings.dart';
import 'package:flutter/material.dart';

import '../../constants/colors.dart';

class AppListTileTheme {
  AppListTileTheme._(); // Private constructor to prevent instantiation

  static final lightListTileTheme = ListTileThemeData(
    titleTextStyle: TextStyle(
      fontSize: 16,
      fontWeight: FontWeight.w500,
      color: AppColors.onSurfaceLight,
    ),
    subtitleTextStyle: TextStyle(
      fontSize: 12,
      color: AppColors.onSurfaceVariantLight,
    ),
    iconColor: AppColors.iconLight, // Icon color for light theme
  );


  static final darkListTileTheme = ListTileThemeData(
    titleTextStyle: TextStyle(
      fontSize: 16,
      fontWeight: FontWeight.w500,
      color: AppColors.onSurfaceDark,
    ),
    subtitleTextStyle: TextStyle(
      fontSize: 12,
      color: AppColors.onSurfaceVariantDark,
    ),
    iconColor: AppColors.iconDark, // Icon color for light theme
  );
}
