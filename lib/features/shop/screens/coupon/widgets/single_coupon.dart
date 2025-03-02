import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../../../common/styles/spacing_style.dart';
import '../../../../../utils/constants/colors.dart';
import '../../../../../utils/constants/sizes.dart';
import '../../../../../utils/constants/text_strings.dart';
import '../../../models/coupon_model.dart';

class SingleCouponItem extends StatelessWidget {
  const SingleCouponItem({super.key, required this.coupon});

  final CouponModel coupon;

  @override
  Widget build(BuildContext context) {
    return ListTile(
        minVerticalPadding: Sizes.md,
        tileColor: Theme.of(context).colorScheme.surface,
        onLongPress: () {
            Clipboard.setData(ClipboardData(text: coupon.code!.toUpperCase()));
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Coupon code ${coupon.code!.toUpperCase()} copied')),
            );
        },
        leading: Icon(Icons.local_offer_outlined, size: 20, color: TColors.offerColor),
        title: Text(coupon.code!.toUpperCase()),
        subtitle: Text(coupon.description?.isNotEmpty == true ? coupon.description! : 'Discount Offer',
            style: TextStyle(fontSize: 11),
        ),
        trailing: IconButton(
          onPressed: () {
            Clipboard.setData(ClipboardData(text: coupon.code!.toUpperCase()));
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Coupon code ${coupon.code!.toUpperCase()} copied')),
            );
          },
            icon: Icon(Icons.copy, size: 20)
        )
    );
  }
}
