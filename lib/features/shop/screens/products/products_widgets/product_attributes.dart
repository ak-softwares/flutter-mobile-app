import 'package:flutter/material.dart';

import '../../../../../common/text/section_heading.dart';
import '../../../../../common/widgets/chips/choice_chip.dart';
import '../../../../../common/widgets/custom_shape/containers/rounded_container.dart';
import '../../../../../utils/constants/sizes.dart';
import 'in_stock_label.dart';
import 'product_price.dart';

class TProductAttributes extends StatelessWidget {
  const TProductAttributes({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        RoundedContainer(
          padding: const EdgeInsets.all(AppSizes.sm),
          backgroundColor: Colors.grey.shade300,
          child: const Column(
            children: [
              Row(
                children: [
                  SectionHeading(title: 'Variation'),
                  SizedBox(width: AppSizes.spaceBtwItems),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text('Price'),
                          SizedBox(width: AppSizes.spaceBtwItems),
                          ProductPrice(salePrice: 449, regularPrice: 999, size: 20),
                        ],
                      ),
                      InStock(isProductAvailable: true),
                    ],
                  ),
                ],
              ),
              Text(
                'this is variation description it could be a max 2 line description',
                style: TextStyle(color: Colors.grey),
              )
            ],
          ),
        ),
        const SizedBox(height: AppSizes.spaceBtwItems),

        ///attributes
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SectionHeading(title: 'Colors'),
            const SizedBox(height: AppSizes.sm),
            Wrap(
              spacing: 10,
              children: [
                TChoiceChip(color: Colors.red, selected: true, onSelected: (value){},),
                TChoiceChip(color: Colors.green, onSelected: (value){}),
                TChoiceChip(color: Colors.blue, onSelected: (value){}),
              ],
            )
          ],
        ),
        const SizedBox(height: AppSizes.sm),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SectionHeading(title: 'Size'),
            const SizedBox(height: AppSizes.sm),
            Wrap(
              spacing: 10,
              children: [
                TChoiceChip(text: 'EU 34', selected: true, onSelected: (value){}),
                TChoiceChip(text: 'EU 36', onSelected: (value){}),
                TChoiceChip(text: 'EU 38', onSelected: (value){}),
              ],
            )
          ],
        ),
      ],
    );
  }
}
