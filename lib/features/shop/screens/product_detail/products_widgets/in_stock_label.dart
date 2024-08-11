import 'package:aramarket/utils/constants/colors.dart';
import 'package:flutter/material.dart';

import '../../../../../utils/constants/sizes.dart';

class InStock extends StatelessWidget {
  const InStock({super.key, required this.isProductAvailable});

  final bool isProductAvailable;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text('Status', style: Theme.of(context).textTheme.labelLarge),
        const SizedBox(width: TSizes.md),
        isProductAvailable
          ? Text('In Stock', style: Theme.of(context).textTheme.bodyLarge?.copyWith(color: TColors.offerColor, fontWeight: FontWeight.w600))
          : Text('Out of Stock', style: Theme.of(context).textTheme.bodyLarge?.copyWith(color: Colors.red, fontWeight: FontWeight.w600)),
      ],
    );
  }
}
