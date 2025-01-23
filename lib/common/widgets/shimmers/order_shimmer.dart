import '../../styles/spacing_style.dart';
import '../../text/section_heading.dart';
import '../custom_shape/containers/rounded_container.dart';
import '/common/widgets/shimmers/shimmer_effect.dart';
import 'package:flutter/material.dart';

import '../../../utils/constants/sizes.dart';

class OrderShimmer extends StatelessWidget {
  const OrderShimmer({super.key, this.itemCount = 4, this.title = '', this.height = 600 });

  final String title;
  final int itemCount;
  final double height;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        title.isNotEmpty ? TSectionHeading(title: title) : const SizedBox.shrink(),
        SizedBox(
          height: height,
          child: ListView.separated(
            itemCount: itemCount,
            separatorBuilder: (context, index) => const SizedBox(height: Sizes.defaultSpace),
            itemBuilder: (_, __) => TRoundedContainer(
                height: 120,
                showBorder: true,
                padding: TSpacingStyle.defaultPagePadding,
                borderColor: Colors.grey.withOpacity(0.2),
                child: const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ShimmerEffect(width: 300, height: 15),
                    SizedBox(height: Sizes.spaceBtwItems),
                    ShimmerEffect(width: 200, height: 15),
                    SizedBox(height: Sizes.spaceBtwItems),
                    ShimmerEffect(width: 250, height: 15),
                    SizedBox(height: Sizes.spaceBtwItems),
                    ShimmerEffect(width: 110, height: 15),
                  ],
                ),
              ),
          ),
        ),
      ],
    );
  }
}
