import 'package:aramarket/utils/helpers/navigation_helper.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';

import '../../data/repositories/authentication/authentication_repository.dart';
import '../../features/settings/setting_screen.dart';
import '../../features/shop/screens/search/search.dart';
import '../../services/share/share.dart';
import '../../utils/constants/colors.dart';
import '../../utils/constants/icons.dart';
import '../../utils/constants/sizes.dart';
import '../../utils/device/device_utility.dart';
import '../widgets/product/cart/cart_counter_icon.dart';

class TAppBar2 extends StatelessWidget implements PreferredSizeWidget{
  const TAppBar2({
    super.key,
    required this.titleText,
    this.showBackArrow = false,
    this.showCartIcon = false,
    this.showSearchIcon = false,
    this.seeLogoutButton = false,
    this.seeSettingButton = false,
    this.sharePageLink = "",
    this.widget, // If null, search icon won't be shown
  });

  final String titleText;
  final bool showBackArrow;
  final bool showCartIcon;
  final bool showSearchIcon;
  final bool seeLogoutButton;
  final bool seeSettingButton;
  final String sharePageLink;
  final Widget? widget; // Nullable search type

  @override
  Widget build(BuildContext context) {
    final Color color = Theme.of(context).colorScheme.onSurface;
    final Color iconColors = Theme.of(context).colorScheme.onSurfaceVariant;
    final Color backgroundColor = Colors.transparent;
    return AppBar(
      centerTitle: false,
      backgroundColor: backgroundColor,
      iconTheme: IconThemeData(color: iconColors), // Change back arrow color
      title: Text(titleText, style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600, color: color)),
      actions: [
            showSearchIcon ? IconButton( icon: Icon(TIcons.search), color: color, onPressed: () => showSearch(context: context, delegate: TSearchDelegate())) : const SizedBox.shrink(),
            sharePageLink.isNotEmpty
                ? IconButton(
                    icon: Icon(TIcons.share),
                    color: iconColors,
                    onPressed: () => AppShare.shareUrl(
                        url: sharePageLink,
                        contentType: 'Category',
                        itemName: titleText,
                        itemId:  ''
                    ),
                  )
                : const SizedBox.shrink(),
            showCartIcon ? TCartCounterIcon(iconColor: color) : const SizedBox.shrink(),
            if(seeLogoutButton) ...[
                Obx(() => AuthenticationRepository.instance.isUserLogin.value
                    ? InkWell(
                          onTap: () => AuthenticationRepository.instance.logout(),
                          child: Row(
                            children: [
                              Text('Logout', style: TextStyle(color: color),),
                              const SizedBox(width: Sizes.sm),
                              Icon(TIcons.logout, color: iconColors, size: 20),
                              const SizedBox(width: Sizes.sm),
                            ],
                          )
                      )
                    : InkWell(
                          onTap: () => NavigationHelper.navigateToLoginScreen(),
                          child: Row(
                            children: [
                              Icon(Iconsax.user, color: iconColors, size: 17),
                              const SizedBox(width: Sizes.sm),
                              Text('Login', style: TextStyle(color: color, fontWeight: FontWeight.w500, fontSize: 15),),
                              const SizedBox(width: Sizes.md),
                            ],
                          )
                      )
                ),
              ],
            seeSettingButton ? IconButton( icon: Icon(Icons.settings), color: color, onPressed: () => Get.to(() => SettingScreen())) : const SizedBox.shrink(),
            widget != null
                ? widget!
                : SizedBox.shrink()
      ],
      leading: showBackArrow ? IconButton(onPressed: () => Navigator.pop(context), icon: Icon(Iconsax.arrow_left, color: iconColors)) :  null,
    );
  }
  @override
  // TODO: implement preferredSize
  Size get preferredSize => Size.fromHeight(TDeviceUtils.getAppBarHeight());
}