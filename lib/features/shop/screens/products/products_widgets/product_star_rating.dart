import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';

import '../../../../../utils/constants/colors.dart';
import '../../../../../utils/constants/sizes.dart';

class ProductStarRating extends StatelessWidget {
  const ProductStarRating({
    super.key, required this.averageRating, required this.ratingCount, this.size = 12, this.onTap,
  });
  final double averageRating;
  final int ratingCount;
  final double size;
  final VoidCallback? onTap;
  @override
  Widget build(BuildContext context) {

    return InkWell(
      onTap: onTap,
      child: Row(
          children: [
            RatingBarIndicator(
              rating: averageRating,
              itemSize: size*1.3,
              unratedColor: Colors.grey[300],
              itemBuilder: (_, __) => const Icon(Iconsax.star1, color: AppColors.ratingStar),
            ),
            Text(
              ' ${averageRating.toStringAsFixed(1)}($ratingCount)',
              style: TextStyle(fontSize: size, color: Theme.of(context).colorScheme.onSurface, fontWeight: FontWeight.w500)),
            const SizedBox(width: Sizes.spaceBtwItems / 2),
          ],
        ),
    );
  }
}
