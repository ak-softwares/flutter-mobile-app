import 'package:flutter/material.dart';
import 'package:auto_size_text/auto_size_text.dart';

import '../../../../../utils/constants/colors.dart';
import '../../../../../utils/constants/sizes.dart';
import '../../../../settings/app_settings.dart';
import '../scrolling_products.dart';

class ProductPrice extends StatelessWidget {
  const ProductPrice({
    super.key,
    required this.regularPrice,
    this.salePrice = 0,
    this.size = 18,
    this.orientationType = OrientationType.vertical,
  });

  final double regularPrice;
  final double? salePrice;
  final double size;
  final OrientationType orientationType;

  @override
  Widget build(BuildContext context) {
    final currencySymbol = AppSettings.appCurrencySymbol;

    //-- Calculate Discount Percentage
    String salePercentage() {
      if (salePrice == null || salePrice! <= 0.0 || regularPrice <= 0.0) {
        return '';
      }

      double percentage = ((regularPrice - salePrice!) / regularPrice) * 100;
      return percentage.toStringAsFixed(0);
    }

    final regularPriceText = Flexible(
      child: Text(
        '$currencySymbol${regularPrice.toStringAsFixed(0)}',
        style: TextStyle(color: Theme.of(context).colorScheme.onSurfaceVariant,).copyWith(
          decoration: salePrice != 0 ? TextDecoration.lineThrough : null,
          fontSize: salePrice != 0 ? size * 0.7 : size,
        ),
        overflow: TextOverflow.ellipsis,
        maxLines: 1,
      ),
    );

    if (salePrice == null && salePrice == 0) return regularPriceText;

    final salePriceText = Text(
      '$currencySymbol${salePrice?.toStringAsFixed(0)}',
      style: TextStyle(color: Theme.of(context).colorScheme.onSurface, fontSize: size, fontWeight: FontWeight.w600),
      overflow: TextOverflow.ellipsis,
      maxLines: 1,
    );

    return orientationType == OrientationType.vertical
        ? Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min, // Ensures it takes only the needed space
            children: [
              regularPriceText,
              Row(
                spacing: AppSizes.xs,
                  mainAxisSize: MainAxisSize.min, // Ensures it takes only the needed space
                  children: [
                  Text('-${salePercentage()}%', style: TextStyle(color: Color(0xFFD32F2F), fontSize: 15)),
                  salePriceText
                ]
              ),
            ],
          )
        : Row(
            spacing: AppSizes.xs,
            mainAxisSize: MainAxisSize.min, // Ensures it takes only the needed space
            children: [
              regularPriceText,
              Text('-${salePercentage()}%', style: TextStyle(color: Color(0xFFD32F2F), fontSize: 15)),
              salePriceText
            ]
          );
  }
}


