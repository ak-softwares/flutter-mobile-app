import '../../../utils/constants/colors.dart';
import '../../../utils/helpers/order_helper.dart';
import '../../layout_models/product_grid_layout.dart';
import '../../styles/shadows.dart';
import '../../styles/spacing_style.dart';
import '/common/widgets/shimmers/shimmer_effect.dart';
import 'package:flutter/material.dart';

import '../../../utils/constants/sizes.dart';

class CouponShimmer extends StatelessWidget {
  const CouponShimmer({super.key });


  @override
  Widget build(BuildContext context) {

    return SizedBox(
      height: 80,
      child: ListTile(
          minVerticalPadding: Sizes.md,
          tileColor: Theme.of(context).colorScheme.surface,
          leading: Icon(Icons.local_offer_outlined, size: 20, color: AppColors.offerColor),
          title: ShimmerEffect(width: 100, height: 25),
          subtitle: Padding(
            padding: const EdgeInsets.only(top: 9),
            child: ShimmerEffect(width: 50, height: 11),
          ),
          trailing: IconButton(
              onPressed: () {},
              icon: Icon(Icons.copy, size: 20)
          )
      ),
    );
  }
}
