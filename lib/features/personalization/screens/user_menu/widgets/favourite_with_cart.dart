import 'package:aramarket/features/shop/controllers/cart_controller/cart_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../../common/styles/spacing_style.dart';
import '../../../../../common/text/section_heading.dart';
import '../../../../../common/widgets/product/cart/cart_counter_icon.dart';
import '../../../../../utils/constants/colors.dart';
import '../../../../../utils/constants/icons.dart';
import '../../../../../utils/constants/sizes.dart';
import '../../../../shop/controllers/favorite/favorite_controller.dart';
import '../../../../shop/screens/cart/cart.dart';
import '../../../../shop/screens/favourite/favourite.dart';
class FavouriteWithCart extends StatelessWidget {
  const FavouriteWithCart({
    super.key,
  });

  // TSectionHeading(title: 'Your profile', verticalPadding: false, seeActionButton: true, buttonTitle: '', onPressed: () => Get.to(() => const UserProfileScreen()),),
  // const Divider(color: TColors.primaryColor, thickness: 2,),
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ListTile(
          onTap: () => Get.to(() => const CartScreen()),
          leading: Icon(TIcons.bottomNavigationCart,size: 25),
          title: Text('Cart', style: Theme.of(context).textTheme.bodyLarge!.copyWith(fontWeight: FontWeight.w500),),
          subtitle: Text('All cart items', style: Theme.of(context).textTheme.bodySmall),
          trailing: Row(
            spacing: AppSizes.xs,
            mainAxisSize: MainAxisSize.min, // Fix: Prevents Row from taking full width
            children: [
              CartController.instance.cartItems.isNotEmpty
                  ? Icon(Icons.circle, size: 8, color: Colors.blue)
                  : SizedBox.shrink(),
              Icon(Icons.arrow_forward_ios, size: 20,),
            ],
          ),
        ),
        ListTile(
          onTap: () => Get.to(() => const FavouriteScreen()),
          leading: Icon(TIcons.favorite,size: 20),
          title: Text('Wishlist', style: Theme.of(context).textTheme.bodyLarge!.copyWith(fontWeight: FontWeight.w500),),
          subtitle: Text('All wishlist items', style: Theme.of(context).textTheme.bodySmall),
          trailing: Row(
            spacing: AppSizes.xs,
            mainAxisSize: MainAxisSize.min, // Fix: Prevents Row from taking full width
            children: [
              FavoriteController.instance.products.isNotEmpty
                  ? Icon(Icons.circle, size: 8, color: Colors.blue)
                  : SizedBox.shrink(),
              Icon(Icons.arrow_forward_ios, size: 20,),
            ],
          ),
        ),
      ],
    );
  }
}
