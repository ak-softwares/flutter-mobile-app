import 'package:flutter/material.dart';

import '../../../../../../common/styles/shadows.dart';
import '../../../../../../common/widgets/custom_shape/image/circular_image.dart';
import '../../../../../../utils/constants/image_strings.dart';
import '../../../../../../utils/constants/sizes.dart';



class SingleCategoryItem extends StatelessWidget {
  const SingleCategoryItem({
    super.key, // Use 'Key?' instead of 'super.key'
    this.image = TImages.defaultCategoryIcon,
    required this.title,
    this.textColor = Colors.black,
    this.backgroundColor = Colors.white,
    this.onTap,
    this.isNetworkImage = true,
    this.imageDimension = 85,
    this.imageRadius = 5,
  });

  final double imageDimension;
  final double imageRadius;
  final String title;
  final String image;
  final Color textColor;
  final Color? backgroundColor;
  final bool isNetworkImage;
  final void Function()? onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: SizedBox(
        height: 150,
        child: Column(
          children: [
            //image
            Container(
              width: imageDimension,
              height: imageDimension,
              // padding: const EdgeInsets.all(TSizes.sm),
              decoration: BoxDecoration(
                color: backgroundColor,
                // borderRadius: BorderRadius.circular(15),
                borderRadius: BorderRadius.circular(5),
                // border: Border.all(color: TColors.borderSecondary),
                boxShadow: const [TShadowStyle.horizontalProductShadow],
              ),
              child: TRoundedImage(
                height: imageDimension,
                width: imageDimension,
                borderRadius: 5,
                padding: 5,
                image: image,
                isNetworkImage: true,
                // onTap: () => Get.toNamed(banner.targetScreen),
              ),
            ),
            const SizedBox(height: TSizes.spaceBtwItems),

            //Category Name
            SizedBox(
              width: imageDimension,
              child: Text(
                title,
                style: Theme.of(context).textTheme.titleMedium!.copyWith(fontSize: 12),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
