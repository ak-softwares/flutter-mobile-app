import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';

import '../../utils/constants/sizes.dart';

class TScrollableListView extends StatelessWidget {
  const TScrollableListView({super.key, required this.itemCount, this.height, required this.itemBuilder, this.controller,});

  final int itemCount;
  final double? height;
  final ScrollController? controller;
  final Widget? Function(BuildContext, int) itemBuilder;

  @override
  Widget build(BuildContext context) {
    return Stack(
        children: [
          SizedBox(
            height: height,
            width: double.infinity,
            child: ListView.separated(
              controller: controller,
              itemCount: itemCount,
              // physics: const BouncingScrollPhysics(),
              separatorBuilder: (_, __) => const SizedBox(width: TSizes.spaceBtwItems),
              scrollDirection: Axis.horizontal,
              itemBuilder: itemBuilder,
            ),
          ),
          Positioned(
              left: 7,
              height: height,
              child: Icon(Iconsax.arrow_left_2, color: Colors.grey[400], size: 22)
          ),
          Positioned(
              right: 7,
              height: height,
              child: Icon(Iconsax.arrow_right_34, color: Colors.grey[400], size: 22)
          )
        ],
    );
  }
}

