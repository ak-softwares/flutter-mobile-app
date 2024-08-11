import 'package:flutter/material.dart';

import '../../../../../utils/constants/sizes.dart';
import '../../../../../utils/constants/text_strings.dart';
class TProductPrice extends StatelessWidget {
  const TProductPrice({
    super.key, required this.regularPrice , this.salePrice = 0, this.smallSize = false, this.priceInSeries = false,
  });
  final double regularPrice;
  final double? salePrice;
  final bool smallSize;
  final bool priceInSeries;

  @override
  Widget build(BuildContext context) {
    if(salePrice == 0) {
      return Text(TTexts.currencySymbol + regularPrice.toStringAsFixed(0),
        style: Theme.of(context).textTheme.headlineMedium!.copyWith(fontSize: smallSize ? 18 : 20),
        overflow: TextOverflow.ellipsis,
        maxLines: 1,
      );
    }
    return priceInSeries
        ? Row(
          mainAxisAlignment: MainAxisAlignment.start,
          // crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              TTexts.currencySymbol + regularPrice.toStringAsFixed(0),
              style: smallSize
                  ? Theme.of(context).textTheme.bodySmall!.copyWith(decoration: TextDecoration.lineThrough)
                  : Theme.of(context).textTheme.bodyLarge!.copyWith(decoration: TextDecoration.lineThrough),
              overflow: TextOverflow.ellipsis,
              maxLines: 1,
            ),
            const SizedBox(width: TSizes.spaceBtwItems),
            Text(
              TTexts.currencySymbol + salePrice!.toStringAsFixed(0),
              style: smallSize
                  ? Theme.of(context).textTheme.titleSmall!.copyWith(fontWeight: FontWeight.w600)
                  : Theme.of(context).textTheme.titleLarge!.copyWith(fontWeight: FontWeight.w600),
              overflow: TextOverflow.ellipsis,
              maxLines: 1,
              )
            ],
          )
        : Column(
          // mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              TTexts.currencySymbol + regularPrice.toStringAsFixed(0),
              style: smallSize
                  ? Theme.of(context).textTheme.bodySmall!.copyWith(decoration: TextDecoration.lineThrough)
                  : Theme.of(context).textTheme.bodyMedium!.copyWith(decoration: TextDecoration.lineThrough),
              overflow: TextOverflow.ellipsis,
              maxLines: 1,
            ),
            // const SizedBox(height: TSizes.xs),
            Text(
              TTexts.currencySymbol + salePrice!.toStringAsFixed(0),
              style: smallSize
                  ? Theme.of(context).textTheme.titleSmall!.copyWith(fontWeight: FontWeight.w600)
                  : Theme.of(context).textTheme.titleMedium!.copyWith(fontWeight: FontWeight.w600),
              overflow: TextOverflow.ellipsis,
              maxLines: 1,
            )
          ],
        );
  }
}

