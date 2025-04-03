import 'package:flutter/material.dart';
import 'package:flex_color_scheme/flex_color_scheme.dart';

import '../../features/settings/app_settings.dart';
import '../constants/colors.dart';
import 'custom_theme/appbar_theme.dart';
import 'custom_theme/bottom_sheet_theme.dart';
import 'custom_theme/checkbox_theme.dart';
import 'custom_theme/chip_theme.dart';
import 'custom_theme/elevated_button_theme.dart';
import 'custom_theme/icon_theme.dart';
import 'custom_theme/list_tile_theme.dart';
import 'custom_theme/outlined_button_theme.dart';
import 'custom_theme/switch_theme.dart';
import 'custom_theme/tapbar_theme.dart';
import 'custom_theme/text_field_theme.dart';
import 'custom_theme/text_theme.dart';

class TAppTheme {
  TAppTheme._();

  // Theme.of(context).colorScheme.surface
  static ThemeData lightTheme = FlexThemeData.light(
    scheme: FlexScheme.blueM3,
  ).copyWith(
    appBarTheme: AppAppBarTheme.lightAppBarTheme,
    tabBarTheme: AppTabBarTheme.lightTabBarTheme,
    iconTheme: TIconTheme.lightIconTheme,
    listTileTheme: TListTileTheme.lightListTileTheme,
    bottomSheetTheme: TBottomSheetTheme.lightBottomSheetTheme,
    elevatedButtonTheme: TElevatedButtonTheme.lightElevatedButtonTheme,
    outlinedButtonTheme: TOutlinedButtonTheme.lightOutlinedButtonTheme,
    checkboxTheme: TCheckBoxTheme.lightCheckBoxTheme,
    switchTheme: TSwitchTheme.lightSwitchTheme,
    colorScheme: ThemeData.light().colorScheme.copyWith(
      surface: AppColors.backgroundLight, // Background for cards, dialogs, etc.
      onSurface: AppColors.textLight,
      onSurfaceVariant: AppColors.onSurfaceVariantLight, // Softer text color for better contrast
    ),
    // scaffoldBackgroundColor: AppSettings.lightBackground, // Ensures the scaffold uses the new background
  );

  static ThemeData darkTheme = FlexThemeData.dark(
    scheme: FlexScheme.blueM3,
  ).copyWith(
    appBarTheme: AppAppBarTheme.darkAppBarTheme,
    tabBarTheme: AppTabBarTheme.darkTabBarTheme,
    iconTheme: TIconTheme.darkIconTheme,
    listTileTheme: TListTileTheme.darkListTileTheme,
    bottomSheetTheme: TBottomSheetTheme.darkBottomSheetTheme,
    elevatedButtonTheme: TElevatedButtonTheme.darkElevatedButtonTheme,
    outlinedButtonTheme: TOutlinedButtonTheme.darkOutlinedButtonTheme,
    checkboxTheme: TCheckBoxTheme.darkCheckBoxTheme,
    switchTheme: TSwitchTheme.darkSwitchTheme,
    colorScheme: ThemeData.dark().colorScheme.copyWith(
      surface: AppColors.backgroundDark, // Background for cards, dialogs, etc.
      onSurface: AppColors.textDark,
      onSurfaceVariant: AppColors.onSurfaceVariantDark, // Softer text color for better contrast
    ),
    scaffoldBackgroundColor: AppSettings.darkBackground, // Ensures the scaffold uses the new background
  );
}