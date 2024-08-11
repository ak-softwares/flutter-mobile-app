import 'package:flutter/material.dart';

import '../../../../common/navigation_bar/appbar2.dart';
import '../../../../common/widgets/brands/branditemcount.dart';
import '../../../../utils/constants/sizes.dart';

class TBrandProducts extends StatelessWidget {
  const TBrandProducts({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      appBar: TAppBar2(titleText: "Baku", showBackArrow: true),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(TSizes.defaultSpace),
        child: Column(
          children: [
            SizedBox(width: double.infinity ,child: TBrandItemCount(isBorderShow: true)),
            SizedBox(height: TSizes.spaceBtwSection,),
          ],
        ),
      ),
    );
  }
}
