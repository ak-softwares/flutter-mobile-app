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
    return AppBar(
      title: Text(titleText),
      actions: [
            showSearchIcon ? IconButton( icon: Icon(TIcons.search), onPressed: () => showSearch(context: context, delegate: TSearchDelegate())) : const SizedBox.shrink(),
            sharePageLink.isNotEmpty
                ? IconButton(
                    icon: Icon(TIcons.share),
                    onPressed: () => AppShare.shareUrl(
                        url: sharePageLink,
                        contentType: 'Category',
                        itemName: titleText,
                        itemId:  ''
                    ),
                  )
                : const SizedBox.shrink(),
            if(showCartIcon)
              TCartCounterIcon(),
            if(seeLogoutButton) ...[
                Obx(() => AuthenticationRepository.instance.isUserLogin.value
                    ? InkWell(
                          onTap: () => AuthenticationRepository.instance.logout(),
                          child: Row(
                            children: [
                              Text('Logout'),
                              const SizedBox(width: AppSizes.sm),
                              Icon(TIcons.logout, size: 20,),
                              const SizedBox(width: AppSizes.sm),
                            ],
                          )
                      )
                    : InkWell(
                          onTap: () => NavigationHelper.navigateToLoginScreen(),
                          child: Row(
                            children: [
                              Icon(Iconsax.user),
                              const SizedBox(width: AppSizes.sm),
                              Text('Login', style: TextStyle(fontSize: 15),),
                              const SizedBox(width: AppSizes.md),
                            ],
                          )
                      )
                ),
              ],
            seeSettingButton ? IconButton( icon: Icon(Icons.settings), onPressed: () => Get.to(() => SettingScreen())) : const SizedBox.shrink(),
            widget != null
                ? widget!
                : SizedBox.shrink()
      ],
      leading: showBackArrow ? IconButton(onPressed: () => Navigator.pop(context), icon: Icon(Iconsax.arrow_left)) :  null,
    );
  }
  @override
  // TODO: implement preferredSize
  Size get preferredSize => Size.fromHeight(TDeviceUtils.getAppBarHeight());
}