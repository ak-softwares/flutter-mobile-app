import 'package:flutter/material.dart';

import '../../constants/colors.dart';

class AppAppBarTheme{
  AppAppBarTheme._();

  static const lightAppBarTheme = AppBarTheme(
    centerTitle: false,
    backgroundColor: Colors.transparent,
    surfaceTintColor: Colors.transparent,
    iconTheme: IconThemeData(size: 22),
    actionsIconTheme: IconThemeData(size: 22),
    titleTextStyle: TextStyle(
      fontSize: 18.0,
      fontWeight: FontWeight.w600,
      color: AppColors.appBarTextLight
    ),
  );

  static const darkAppBarTheme = AppBarTheme(
    centerTitle: false,
    backgroundColor: Colors.transparent,
    surfaceTintColor: Colors.transparent,
    iconTheme: IconThemeData(size: 22),
    actionsIconTheme: IconThemeData(size: 22),
    titleTextStyle: TextStyle(
      fontSize: 18.0,
      fontWeight: FontWeight.w600,
      color: AppColors.appBarTextDark
    ),
  );
}