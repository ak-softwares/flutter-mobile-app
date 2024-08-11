import 'package:flutter/material.dart';

import '../../utils/constants/sizes.dart';

class TGridLayout extends StatelessWidget {
  const TGridLayout({
    super.key,
    required this.itemCount,
    this.mainAxisExtent = 290,
    required this.itemBuilder,
    this.crossAxisCount = 2,
    this.mainAxisSpacing = TSizes.gridViewSpacing,
    this.crossAxisSpacing = TSizes.gridViewSpacing,
  });

  final int itemCount;
  final double mainAxisExtent, mainAxisSpacing, crossAxisSpacing;
  final Widget? Function(BuildContext, int) itemBuilder;
  final int crossAxisCount;

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      itemCount: itemCount,
      shrinkWrap: true,
      padding: EdgeInsets.zero,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: crossAxisCount,
          crossAxisSpacing: crossAxisSpacing,
          mainAxisSpacing: mainAxisSpacing,
          mainAxisExtent: mainAxisExtent
      ),
      itemBuilder: itemBuilder,
    );
  }
}