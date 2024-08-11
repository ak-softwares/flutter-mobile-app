import 'package:flutter/material.dart';

import '../../../utils/constants/image_strings.dart';
import '../../../utils/constants/sizes.dart';

class TBrandItemCount extends StatelessWidget {
  const TBrandItemCount({
    super.key,
    this.isBorderShow = true, this.onTap,
  });
  final bool? isBorderShow;
  final void Function()? onTap;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(TSizes.sm),
        decoration: BoxDecoration(
          border: isBorderShow! ? Border.all(color: Colors.grey) : null,
          borderRadius: BorderRadius.circular(TSizes.productImageRadius),
          // color: Colors.yellow,
        ),
        child: const Column(
          mainAxisAlignment: MainAxisAlignment.center,
          // verticalDirection: VerticalDirection.up,
          // crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Image(
                image: AssetImage(TImages.brandLogo),
                width: 120),
            Text(
              "25 Products",
              maxLines: 1,
            )
          ],
        ),
      ),
    );
  }
}