import 'package:flutter/material.dart';

import '../../utils/constants/sizes.dart';

class TSpacingStyle {
  static const EdgeInsetsGeometry paddingWidthAppbarHeight = EdgeInsets.only(
    top: TSizes.appBarHeight,
    left: TSizes.defaultSpace,
    bottom: TSizes.defaultSpace,
    right: TSizes.defaultSpace,
  );
  static const EdgeInsetsGeometry defaultPagePadding = EdgeInsets.all(TSizes.defaultSpace);
  static const EdgeInsetsGeometry defaultSpaceLg = EdgeInsets.all(TSizes.defaultSpaceLg);
}