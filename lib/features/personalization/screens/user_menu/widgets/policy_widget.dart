import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:url_launcher/url_launcher_string.dart';

import '../../../../../common/styles/spacing_style.dart';
import '../../../../../common/text/section_heading.dart';
import '../../../../../common/web_view/my_web_view.dart';
import '../../../../../utils/constants/api_constants.dart';
import '../../../../../utils/constants/colors.dart';
import '../../../../../utils/constants/icons.dart';
import '../../../../settings/app_settings.dart';

class PolicyWidget extends StatelessWidget {
  const PolicyWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ListTile(
          onTap: () => Get.to(() => const MyWebView(title: 'Privacy Policy', url: AppSettings.privacyPrivacy)),
          leading: Icon(AppIcons.privacyPolicy, size: 18),
          title: Text('Privacy Policy'),
          subtitle: Text('Your data, secured.'),
          trailing: Icon(Icons.open_in_new, size: 20, color: Colors.blue),
        ),
        ListTile(
          onTap: () => Get.to(() => const MyWebView(title: 'Shipping Policy', url: AppSettings.shippingPolicy)),
          leading: Icon(AppIcons.shippingPolicy, size: 18),
          title: Text('Shipping Policy'),
          subtitle: Text('Fast, reliable delivery.'),
          trailing: Icon(Icons.open_in_new, size: 20, color: Colors.blue),
        ),
        ListTile(
          onTap: () => Get.to(() => const MyWebView(title: 'Terms and Conditions', url: AppSettings.termsAndConditions)),
          leading: Icon(AppIcons.termsAndConditions, size: 18),
          title: Text('Terms and Conditions'),
          subtitle: Text('Your rights, clarified.'),
          trailing: Icon(Icons.open_in_new, size: 20, color: Colors.blue),
        ),
        ListTile(
          onTap: () => Get.to(() =>  const MyWebView(title: 'Return Policy', url: AppSettings.refundPolicy)),
          leading: Icon(AppIcons.returnPolicy, size: 18),
          title: Text('Return Policy'),
          subtitle: Text('Easy returns, guaranteed.'),
          trailing: Icon(Icons.open_in_new, size: 20, color: Colors.blue),
        ),
      ],
    );
  }
}
