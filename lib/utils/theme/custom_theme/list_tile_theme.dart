import 'package:aramarket/features/settings/app_settings.dart';
import 'package:flutter/material.dart';

class TListTileTheme {
  TListTileTheme._(); // Private constructor to prevent instantiation

  static final lightListTileTheme = ListTileThemeData(
    titleTextStyle: TextStyle(
      fontSize: 16,
      fontWeight: FontWeight.w500,
      color: AppSettings.lightText,
    ),
    subtitleTextStyle: TextStyle(
      fontSize: 12,
      color: AppSettings.lightTextSofter,
    ),
  );


  static final darkListTileTheme = ListTileThemeData(
    titleTextStyle: TextStyle(
      fontSize: 16,
      fontWeight: FontWeight.w500,
    ),
    subtitleTextStyle: TextStyle(
      fontSize: 12,
    ),
  );
}
