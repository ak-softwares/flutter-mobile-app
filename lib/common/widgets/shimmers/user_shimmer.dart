
import '/common/widgets/shimmers/shimmer_effect.dart';
import 'package:flutter/material.dart';


class UserTileShimmer extends StatelessWidget {
   const UserTileShimmer({super.key,});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: ClipRRect(borderRadius: BorderRadius.circular(200), child: const ShimmerEffect(width: 40, height: 40)),
      title: const ShimmerEffect(width: 150, height: 20),
      subtitle: const ShimmerEffect(width: 100, height: 15),
      trailing: Icon(Icons.arrow_forward_ios, size: 20,),
    );
  }
}
