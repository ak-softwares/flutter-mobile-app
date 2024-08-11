import 'dart:math';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';

import '../../../../features/shop/models/product_model.dart';
import '../../../../features/shop/screens/product_detail/product_detail.dart';
import '../../../../features/shop/screens/product_detail/products_widgets/product_price.dart';
import '../../../../features/shop/screens/product_detail/products_widgets/product_star_rating.dart';
import '../../../../features/shop/screens/product_detail/products_widgets/product_title_text.dart';
import '../../../../features/shop/screens/product_detail/products_widgets/sale_label.dart';
import '../../../../utils/constants/colors.dart';
import '../../../../utils/constants/sizes.dart';
import '../../../styles/shadows.dart';
import '../../custom_shape/image/circular_image.dart';
import '../cart/cart_card_icon.dart';
import '../favourite_icon/favourite_icon.dart';

class TProductCardVertical extends StatelessWidget {
  const TProductCardVertical({super.key, required this.product});

  final ProductModel product;

  @override
  Widget build(BuildContext context) {
    const double imageHeight = 160;
    const double cardRadius = TSizes.productImageRadius;
    final salePercentage = product.calculateSalePercentage();
    return GestureDetector(
      onTap: () => Navigator.of(context).push(MaterialPageRoute(builder: (context) => ProductDetailScreen(product: product))),
      // onTap: () => Get.to(ProductDetailScreen(product: product)),
      child: Container(
        width: 180,
        // padding: const EdgeInsets.all(1),
        decoration: BoxDecoration(
          boxShadow: const [TShadowStyle.horizontalProductShadow],
          color: Colors.white,
          borderRadius: BorderRadius.circular(cardRadius),
          // border: Border.all(color: TColors.borderSecondary.withOpacity(0.5)),
        ),
        child: Column(
          children: [
            // Main Image
            Stack(
              children: [
                // Carousel for images
                CarouselSlider(
                  options: CarouselOptions(
                    height: imageHeight,
                    aspectRatio: 1.0,
                    enlargeCenterPage: true,
                    autoPlay: true,
                    autoPlayInterval: Duration(seconds: Random().nextInt(6) + 3),
                    // enableInfiniteScroll: false, // Disable infinite scrolling
                    viewportFraction: 1.0,
                    scrollPhysics: const NeverScrollableScrollPhysics(), // Disable touch scroll

                  ),
                  items: product.imageUrlList.map((imageUrl) {
                    return Builder(
                      builder: (BuildContext context) {
                        return TRoundedImage(
                          image: imageUrl,
                          height: imageHeight,
                          width: imageHeight,
                          borderRadius: cardRadius,
                          isNetworkImage: true,
                          padding: 3,
                          backgroundColor: Colors.white,
                        );
                      },
                    );
                  }).toList(),
                ),

                //sale tag
                Positioned(
                  top: 10,
                  left: 3,
                  child: TSaleLabel(discount: salePercentage),
                ),

                // favourite icons
                Positioned(
                  top: 0,
                  right: 0,
                  child: TFavouriteIcon(productId: product.id.toString(), iconSize: 20)
                ),

                // Out of stock
                Positioned(
                    bottom: 5,
                    right: 5,
                    child: product.isProductAvailable()
                        ? const SizedBox.shrink()
                        : Container(
                              padding: const EdgeInsets.symmetric(vertical: 2, horizontal: TSizes.sm),
                              // color: Colors.grey.withOpacity(0.6),
                              color: Colors.transparent,
                              child: const Text('Out of Stock',
                                style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 16,
                                    fontWeight: FontWeight.w500,
                                    shadows: [
                                      Shadow(
                                        offset: Offset(0, 0),
                                        blurRadius: 5,
                                        color: Color.fromARGB(255, 255, 255, 255), // White color shadow
                                      ),
                                    ],
                                ),),
                          ),
                )
              ],
            ),

            // Details like title and price

            //Title
            const SizedBox(height: 5),
            Padding(
              padding: const EdgeInsets.only(left: TSizes.sm),
              child: TProductTitleText(title: product.name ?? '')
            ),
            const SizedBox(height: TSizes.spaceBtwItems / 2),

            //Star rating
            Padding(
              padding: const EdgeInsets.only(left: 4),
              child: ProductStarRating(averageRating: product.averageRating ?? 0.0, ratingCount: product.ratingCount ?? 0),
            ),

            const Spacer(),

            //Price and Add to cart
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [

                //Price
                Container(
                  padding: const EdgeInsets.only(left: TSizes.sm, bottom: 5),
                  child: TProductPrice(salePrice: product.salePrice, regularPrice: product.regularPrice ?? 0.0),
                ),

                //Add to cart
                Container(
                    width: 50,
                    height: 43,
                    decoration: const BoxDecoration(
                        color: TColors.primaryColor,
                        borderRadius: BorderRadius.only(
                          // topLeft: Radius.circular(TSizes.cardRadiusMd),
                          bottomRight: Radius.circular(cardRadius),
                        )
                    ),
                    child: SizedBox(
                        width: TSizes.iconLg * 1.2,
                        height: TSizes.iconLg * 1.2,
                        child: Center(child: TCartIcon(product: product))
                    ),
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}










