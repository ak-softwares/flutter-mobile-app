import 'package:flutter/material.dart';

import '../../../../../utils/constants/colors.dart';
class TSaleLabel extends StatelessWidget {
  const TSaleLabel({
    super.key, this.discount, this.size = 7,
  });
  final String? discount;
  final double? size;
  @override
  Widget build(BuildContext context) {
    return discount != null
        ? Container(
            padding: EdgeInsets.symmetric(horizontal: size!, vertical: size! / 2),
            decoration: BoxDecoration(
                color: TColors.primaryColor.withOpacity(0.8),
                borderRadius: BorderRadius.circular(0)
            ),
            child: Text("$discount%", style: Theme.of(context).textTheme.labelLarge!.apply(color: Colors.black),),
          )
        : const SizedBox.shrink();
  }
}