import 'package:flutter/material.dart';

import '../../../features/settings/app_settings.dart';
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
        padding: const EdgeInsets.all(Sizes.sm),
        decoration: BoxDecoration(
          border: isBorderShow! ? Border.all(color: Colors.grey) : null,
          borderRadius: BorderRadius.circular(Sizes.productImageRadius),
          // color: Colors.yellow,
        ),
        child: const Column(
          mainAxisAlignment: MainAxisAlignment.center,
          // verticalDirection: VerticalDirection.up,
          // crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Image(
                image: AssetImage(AppSettings.lightAppLogo),
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