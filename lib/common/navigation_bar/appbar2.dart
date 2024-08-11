import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';

import '../../data/repositories/authentication/authentication_repository.dart';
import '../../features/shop/screens/search/search.dart';
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
  });

  final String titleText;
  final bool showBackArrow;
  final bool showCartIcon;
  final bool showSearchIcon;
  final bool seeLogoutButton;

  @override
  Widget build(BuildContext context) {
    const Color color = TColors.secondaryColor;
    const Color backgroundColor = TColors.primaryColor;
    return AppBar(
      centerTitle: false,
      backgroundColor: backgroundColor,
      title: Text(titleText, style: Theme.of(context).textTheme.titleSmall!.copyWith(color: color, fontWeight: FontWeight.w600)),
      actions: [
            showSearchIcon ? IconButton( icon: Icon(TIcons.search), color: color, onPressed: () => showSearch(context: context, delegate: TSearchDelegate())) : const SizedBox.shrink(),
            showCartIcon ? const TCartCounterIcon(iconColor: color) : const SizedBox.shrink(),
            seeLogoutButton ? InkWell(
                onTap: () => AuthenticationRepository.instance.logout(),
                child: Row(
                  children: [
                    const Text('Logout'),
                    const SizedBox(width: TSizes.sm),
                    Icon(TIcons.logout, size: 20),
                    const SizedBox(width: TSizes.sm),
                  ],
                )
              ) : const SizedBox.shrink(),
        ],
      leading: showBackArrow ? IconButton(onPressed: () => Navigator.pop(context), icon: const Icon(Iconsax.arrow_left, color: color)) :  null,
    );
  }
  @override
  // TODO: implement preferredSize
  Size get preferredSize => Size.fromHeight(TDeviceUtils.getAppBarHeight());
}