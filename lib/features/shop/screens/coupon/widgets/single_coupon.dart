import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../../../common/styles/spacing_style.dart';
import '../../../../../utils/constants/text_strings.dart';
import '../../../models/coupon_model.dart';
class SingleCouponItem extends StatelessWidget {
  const SingleCouponItem({super.key, required this.coupon});

  final CouponModel coupon;
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 125,
      padding: TSpacingStyle.defaultPagePadding,
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(10), // Adjust the value as needed
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5), // Shadow color
            spreadRadius: 2, // Spread radius
            blurRadius: 3, // Blur radius
            offset: const Offset(0, 2), // Offset
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          coupon.discountType == 'percent'
              ? Text('Get Flat ${coupon.amount!.replaceAll(RegExp(r'\.0+$'), '')}% Off', style: Theme.of(context).textTheme.bodyMedium)
              : Text('Get Flat ${TTexts.currencySymbol+coupon.amount!.replaceAll(RegExp(r'\.0+$'), '')} Off', style: Theme.of(context).textTheme.bodyMedium),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(vertical: 3, horizontal: 10),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10), // Adjust the value as needed
                    border: Border.all(
                      color: Colors.grey.withOpacity(0.5), // Border color
                      width: 1, // Border width
                    ),
                  ),
                  child: Text(coupon.code!.toUpperCase(),
                      style: Theme.of(context).textTheme.titleLarge!.copyWith(fontSize: 20, color: Colors.black.withOpacity(0.8)))
              ),
              IconButton(onPressed: () {
                  Clipboard.setData(ClipboardData(text: coupon.code!));
                  // You might want to show a snackbar or toast to indicate successful copy
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Coupon code copied')),
                  );
                },
                icon: const Icon(Icons.copy, size: 20,)
              )
            ],
          ),
          Text(coupon.description!, style: Theme.of(context).textTheme.labelMedium),
        ],
      ),
    );
  }
}

