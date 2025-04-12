import 'package:aramarket/features/shop/screens/brands/all_brands.dart';
import 'package:aramarket/features/shop/screens/store/my_store.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher_string.dart';

import '../../../../../utils/constants/icons.dart';
import '../../../../settings/app_settings.dart';
import '../../../../shop/screens/category/all_category_screen.dart';
import '../../../../shop/screens/review/review_your_purchases.dart';

class OtherMenu extends StatelessWidget {
  const OtherMenu({super.key,});


  @override
  Widget build(BuildContext context) {

    return Column(
      children: [
        ListTile(
          onTap: () => Get.to(() => CategoryScreen()),
          leading: Icon(AppIcons.category1, size: 20),
          title: Text('All Categories'),
          subtitle: Text('All categories list and their products.'),
          trailing: Icon(Icons.arrow_forward_ios, size: 20,),
        ),
        ListTile(
          onTap: () => Get.to(() => AllBrandScreen()),
          leading: Icon(AppIcons.brand, size: 20),
          title: Text('All Brands'),
          subtitle: Text('All brands list and their products.'),
          trailing: Icon(Icons.arrow_forward_ios, size: 20,),
        ),
        ListTile(
          onTap: () => Get.to(() => MyStoreScreen()),
          leading: Icon(AppIcons.store, size: 20),
          title: Text('My Store'),
          subtitle: Text('All products list.'),
          trailing: Icon(Icons.arrow_forward_ios, size: 20,),
        ),
        ListTile(
          onTap: () => Get.to(() => ReviewYourPurchases()),
          leading: Icon(AppIcons.starRating, size: 20),
          title: Text('Review Your Purchases'),
          subtitle: Text('Review Your All Purchases.'),
          trailing: Icon(Icons.arrow_forward_ios, size: 20,),
        ),
        ListTile(
          onTap: () => launchUrlString(AppSettings.playStore),
          leading: Icon(AppIcons.rateUs, size: 20),
          title: Text('Rate us'),
          subtitle: Text('Rate us on play store'),
          trailing: Icon(Icons.arrow_forward_ios, size: 20,),
        ),
      ],
    );
  }
}
