import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher_string.dart';

import '../../../../../common/styles/spacing_style.dart';
import '../../../../../common/text/section_heading.dart';
import '../../../../../utils/constants/api_constants.dart';
import '../../../../../utils/constants/colors.dart';
import '../../../../../utils/constants/icons.dart';
import '../../../../../utils/constants/sizes.dart';
import '../../../../settings/app_settings.dart';
import '../../../../shop/controllers/cart_controller/cart_controller.dart';
import '../../../../shop/controllers/favorite/favorite_controller.dart';
import '../../../../shop/controllers/product/product_controller.dart';
import '../../../../shop/controllers/recently_viewed/recently_viewed_controller.dart';
import '../../../../shop/screens/all_products/all_products.dart';
import '../../../../shop/screens/cart/cart.dart';
import '../../../../shop/screens/category/all_category_screen.dart';
import '../../../../shop/screens/coupon/coupon_screen.dart';
import '../../../../shop/screens/favourite/favourite.dart';
import '../../../../shop/screens/orders/order.dart';
import '../../../../shop/screens/recently_viewed/recently_viewed.dart';
import '../../../../shop/screens/store/my_store.dart';
import '../../../../shop/screens/store/store.dart';
import '../../user_address/user_address.dart';
class Menu extends StatelessWidget {
  const Menu({super.key,});


  @override
  Widget build(BuildContext context) {

    return Column(
      children: [
        ListTile(
          onTap: () => Get.to(() => const OrderScreen()),
          leading: Icon(TIcons.order, size: 20),
          title: Text('My Orders'),
          subtitle: Text('Track and repeat orders'),
          trailing: Icon(Icons.arrow_forward_ios, size: 20,),
        ),
        ListTile(
          onTap: () => Get.to(() => const CartScreen()),
          leading: Icon(TIcons.bottomNavigationCart,size: 25),
          title: Text('Cart'),
          subtitle: Text('All cart items'),
          trailing: Row(
            spacing: Sizes.xs,
            mainAxisSize: MainAxisSize.min, // Fix: Prevents Row from taking full width
            children: [
              Get.put(CartController()).cartItems.isNotEmpty
                  ? Icon(Icons.circle, size: 8, color: Colors.blue)
                  : SizedBox.shrink(),
              Icon(Icons.arrow_forward_ios, size: 20,),
            ],
          ),
        ),
        ListTile(
          onTap: () => Get.to(() => CategoryScreen()),
          leading: Icon(TIcons.category1, size: 20),
          title: Text('All Categories'),
          subtitle: Text('Experience shopping like never before.'),
          trailing: Icon(Icons.arrow_forward_ios, size: 20,),
        ),
        ListTile(
          onTap: () => Get.to(() => const FavouriteScreen()),
          leading: Icon(TIcons.favorite,size: 20),
          title: Text('Wishlist'),
          subtitle: Text('All wishlist items'),
          trailing: Row(
            spacing: Sizes.xs,
            mainAxisSize: MainAxisSize.min, // Fix: Prevents Row from taking full width
            children: [
              Get.put(FavoriteController()).favorites.isNotEmpty
                  ? Icon(Icons.circle, size: 8, color: Colors.blue)
                  : SizedBox.shrink(),
              Icon(Icons.arrow_forward_ios, size: 20,),
            ],
          ),
        ),
        ListTile(
          onTap: () => Get.to(() => const UserAddressScreen()),
          leading: Icon(TIcons.location, size: 20),
          title: Text('My Addresses'),
          subtitle: Text('Set shopping delivery address.'),
          trailing: Icon(Icons.arrow_forward_ios, size: 20,),
        ),
        ListTile(
          onTap: () => Get.to(() => const CouponScreen()),
          leading: Icon(TIcons.coupons, size: 20),
          title: Text('My Coupons'),
          subtitle: Text('List of all the discounted coupons.'),
          trailing: Icon(Icons.arrow_forward_ios, size: 20,),
        ),
        ListTile(
          onTap: () => launchUrlString(AppSettings.playStore),
          leading: Icon(TIcons.rateUs, size: 20),
          title: Text('Rate us'),
          subtitle: Text('Rate us on play store'),
          trailing: Icon(Icons.arrow_forward_ios, size: 20,),
        ),
        ListTile(
          onTap: () => Get.to(() => const RecentlyViewed()),
          leading: Icon(TIcons.recentlyView,size: 20),
          title: Text('Recently Viewed'),
          subtitle: Text('All your recently viewed products.'),
          trailing: Row(
            spacing: Sizes.xs,
            mainAxisSize: MainAxisSize.min, // Fix: Prevents Row from taking full width
            children: [
              Get.put(RecentlyViewedController()).recentlyViewed.isNotEmpty
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
