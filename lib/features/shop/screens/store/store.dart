import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../common/layout_models/grid_layout.dart';
import '../../../../common/navigation_bar/appbar2.dart';
import '../../../../common/navigation_bar/tabbar.dart';
import '../../../../common/text/section_heading.dart';
import '../../../../common/widgets/brands/branditemcount.dart';
import '../../../../common/widgets/brands/brandshowcase.dart';
import '../../../../common/widgets/product/product_cards/product_card_vertical.dart';
import '../../../../utils/constants/image_strings.dart';
import '../../../../utils/constants/sizes.dart';
import '../../controllers/product/product_controller.dart';
import '../Brand/all_brand.dart';
import '../home_page_section/search/search_input_field.dart';


class StoreScreen extends StatelessWidget {
  const StoreScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(ProductController());

    return DefaultTabController(
      length: 5,
      child: Scaffold(
        appBar: const TAppBar2(titleText: "Store", showCartIcon: true),
        body: NestedScrollView(
          headerSliverBuilder: (context, innerBoxIsScrolled) {
            return [
              SliverAppBar(
                automaticallyImplyLeading: false,
                pinned: true,
                floating: true,
                backgroundColor: Colors.white,
                expandedHeight: 440,
                flexibleSpace: Container(
                  padding: const EdgeInsets.all(TSizes.defaultSpace / 2),
                  child: ListView(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    children: [
                      // Searchbar
                      const TSearchBar(
                        searchText: "Search in Store",
                      ),
                      // Heading featured brand
                      TSectionHeading(
                        title: 'Featured Brands',
                        seeActionButton: true,
                        onPressed: (){Navigator.push(context, MaterialPageRoute(builder: (context) => const AllBrandScreen()));},
                      ),
                      // Featured brand container
                      TGridLayout(
                          itemCount: 4,
                          mainAxisExtent: 70,
                          itemBuilder: (context, index) {
                            return const TBrandItemCount();
                          }),
                    ],
                  ),
                ),
                /// tab bar design
                bottom: const TTabbar(
                  tabs: [
                    Tab(child: Text('Soldering Iron')),
                    Tab(child: Text('Screwdriver')),
                    Tab(child: Text('Stands')),
                    Tab(child: Text('Flux')),
                    Tab(child: Text('Rosin')),
                  ],
                )
              )
            ];
          },
          body:  TabBarView(children: [
            ListView(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              children: [
                Padding(
                  padding: const EdgeInsets.all(TSizes.md),
                  child: Column(
                    children: [
                      ///-Brands
                      const TBrandShowcase(images: [TImages.defaultWooPlaceholder, TImages.defaultWooPlaceholder, TImages.defaultWooPlaceholder],),
                      ///-Products
                      const TSectionHeading(title: 'You might like'),
                      const SizedBox(height: TSizes.spaceBtwItems,),
                      TGridLayout(itemCount: 6, itemBuilder: (context, index) => TProductCardVertical(product: controller.featuredProducts[index]))
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(TSizes.md),
                  child: Column(
                    children: [
                      ///-Brands
                      const TBrandShowcase(images: [TImages.defaultWooPlaceholder, TImages.defaultWooPlaceholder, TImages.defaultWooPlaceholder],),
                      ///-Products
                      const TSectionHeading(title: 'You might like'),
                      const SizedBox(height: TSizes.spaceBtwItems,),
                      TGridLayout(itemCount: 6, itemBuilder: (context, index) => TProductCardVertical(product: controller.featuredProducts[index]))
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(TSizes.md),
                  child: Column(
                    children: [
                      ///-Brands
                      const TBrandShowcase(images: [TImages.defaultWooPlaceholder, TImages.defaultWooPlaceholder, TImages.defaultWooPlaceholder],),
                      ///-Products
                      const TSectionHeading(title: 'You might like'),
                      const SizedBox(height: TSizes.spaceBtwItems,),
                      TGridLayout(itemCount: 6, itemBuilder: (context, index) => TProductCardVertical(product: controller.featuredProducts[index]))
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(TSizes.md),
                  child: Column(
                    children: [
                      ///-Brands
                      const TBrandShowcase(images: [TImages.defaultWooPlaceholder, TImages.defaultWooPlaceholder, TImages.defaultWooPlaceholder],),
                      ///-Products
                      const TSectionHeading(title: 'You might like'),
                      const SizedBox(height: TSizes.spaceBtwItems,),
                      TGridLayout(itemCount: 6, itemBuilder: (context, index) => TProductCardVertical(product: controller.featuredProducts[index]))
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(TSizes.md),
                  child: Column(
                    children: [
                      ///-Brands
                      const TBrandShowcase(images: [TImages.defaultWooPlaceholder, TImages.defaultWooPlaceholder, TImages.defaultWooPlaceholder],),
                      ///-Products
                      const TSectionHeading(title: 'You might like'),
                      const SizedBox(height: TSizes.spaceBtwItems,),
                      TGridLayout(itemCount: 6, itemBuilder: (context, index) => TProductCardVertical(product: controller.featuredProducts[index]))
                    ],
                  ),
                ),
              ],
            )
          ],
          ),
        ),
      ),
    );
  }
}




