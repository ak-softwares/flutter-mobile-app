import 'package:flutter/material.dart';

import '../../../../common/layout_models/grid_layout.dart';
import '../../../../common/navigation_bar/appbar2.dart';
import '../../../../common/text/section_heading.dart';
import '../../../../common/widgets/brands/branditemcount.dart';
import '../../../../utils/constants/sizes.dart';
import 'brand_products.dart';

class AllBrandScreen extends StatelessWidget {
  const AllBrandScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: const TAppBar2(titleText: "Popular Products", showBackArrow: true),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(TSizes.defaultSpace),
          child: Column(
            children: [
              const TSectionHeading(title: 'All Brands'),
              const SizedBox(height: TSizes.spaceBtwItems,),

              ///
              TGridLayout(itemCount: 6, mainAxisExtent: 70,
                  itemBuilder: (context, index) =>
                      TBrandItemCount(
                        isBorderShow: true,
                        onTap: (){Navigator.push(context, MaterialPageRoute(builder: (context) => const TBrandProducts()));},
                      )
              ),
            ],
          )
        )
    );
  }
}
