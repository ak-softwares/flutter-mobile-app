import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';

import '../../features/shop/screens/search/search.dart';
import '../../utils/constants/colors.dart';
import '../../utils/device/device_utility.dart';
import '../widgets/product/cart/cart_counter_icon.dart';

class TAppBar3 extends StatelessWidget implements PreferredSizeWidget{
  const TAppBar3({
    super.key,
    required this.titleText,
    this.showBackArrow = false,
    this.showCartIcon = false,
  });

  final String titleText;
  final bool? showBackArrow;
  final bool? showCartIcon;

  @override
  Widget build(BuildContext context) {
    final Color color = Theme.of(context).colorScheme.onSurface;
    final Color iconColors = Theme.of(context).colorScheme.onSurfaceVariant;
    final Color backgroundColor = AppColors.primaryColor;

    return AppBar(
      centerTitle: false,
      backgroundColor: backgroundColor,
      // title: Text(titleText, style: Theme.of(context).textTheme.titleSmall!.copyWith(color: color, fontWeight: FontWeight.w600)),
      actions: showCartIcon!
          ? [
            IconButton( icon: const Icon(Icons.search), color: color, onPressed: () => showSearch(context: context, delegate: TSearchDelegate())),
            TCartCounterIcon(),
            ]
          : null,
      leading: showBackArrow! ? IconButton(onPressed: () => Navigator.pop(context), icon: Icon(Iconsax.arrow_left, color: color)) :  null,
    );
  }
  @override
  // TODO: implement preferredSize
  Size get preferredSize => Size.fromHeight(TDeviceUtils.getAppBarHeight());
}