import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import '../../../../utils/constants/image_strings.dart';
import '../../../../utils/constants/sizes.dart';
import '../../shimmers/shimmer_effect.dart';

class RoundedImage extends StatelessWidget {
  const RoundedImage({
    super.key,
    this.width = 56,
    this.height = 56,
    this.overlayColor,
    required this.image,
    this.backgroundColor,
    this.fit = BoxFit.contain,
    this.padding = 0,
    this.isNetworkImage = false,
    this.borderRadius = 100,
    this.onTap,
    this.border,
  });

  final BoxFit? fit;
  final String image;
  final bool isNetworkImage;
  final Color? overlayColor;
  final Color? backgroundColor;
  final double width, height, padding, borderRadius;
  final BoxBorder? border;
  final void Function()? onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        width: width,
        height: height,
        padding: EdgeInsets.all(padding),
        decoration: BoxDecoration(
          border: border,
          color: backgroundColor ?? Colors.white,
          borderRadius: BorderRadius.circular(borderRadius),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(borderRadius),
          child: isNetworkImage
              ? CachedNetworkImage(
                  fit: fit,
                  color: overlayColor,
                  imageUrl: image != '' ? image : Images.defaultWooPlaceholder,
                  progressIndicatorBuilder: (context, url, downloadProgress) => ShimmerEffect(width: width, height: height, radius: 0),
                  errorWidget: (context, url, error) => const Icon(Icons.error),
                )
              : Image(
                  fit: fit,
                  color: overlayColor,
                  image:AssetImage(image),
                ),
        ),
      ),
    );
  }
}
