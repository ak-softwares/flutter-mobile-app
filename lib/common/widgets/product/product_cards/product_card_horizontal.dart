import 'package:flutter/material.dart';
import 'package:get/get.dart';

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

class TProductCardHorizontal extends StatelessWidget {
  const TProductCardHorizontal({super.key, required this.product});

  final ProductModel product;

  @override
  Widget build(BuildContext context) {

    const double imageHeight = 115;
    const double cardRadius = TSizes.productImageRadius;
    final salePercentage = product.calculateSalePercentage();

    return GestureDetector(
      onTap: () => Get.to(() => ProductDetailScreen(product: product)),
      child: Container(
        width: 300, //280
        decoration: BoxDecoration(
          boxShadow: [TShadowStyle.verticalProductShadow],
          borderRadius: BorderRadius.circular(TSizes.productImageRadius),
          color: Colors.white,
        ),
        child: Row(
          children: [
            //Main Image
            Stack(
              children: [

                //Thumbnail Image
                Padding(
                  padding: const EdgeInsets.only(left: 0),
                  child: TRoundedImage(
                      image: product.mainImage ?? '',
                      height: imageHeight,
                      width: imageHeight,
                      borderRadius: cardRadius,
                      isNetworkImage: true,
                      padding: TSizes.sm
                  ),
                ),

                //Sale Percentage
                Positioned(
                  top: 5,
                  left: 3,
                  child: TSaleLabel(discount: salePercentage)
                ),

                // favourite icons
                Positioned(
                    top: -5,
                    right: -5,
                    child: TFavouriteIcon(productId: product.id.toString(), iconSize: 20)
                )
              ],
            ),

            //Title, Rating and price
            Expanded(
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: TSizes.sm, left: TSizes.sm),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        //Title
                        TProductTitleText(title: product.name ?? ''),
                        const SizedBox(height: TSizes.spaceBtwItems / 2),

                        //Star rating
                        ProductStarRating(averageRating: product.averageRating ?? 0.0, ratingCount: product.ratingCount ?? 0),

                        // const Spacer(),

                        //Price and Add to cart
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [

                            //Price
                            Container(
                              padding: const EdgeInsets.only(left: TSizes.sm, bottom: 5),
                              child: TProductPrice(salePrice: product.salePrice!, regularPrice: product.regularPrice ?? 0.0, priceInSeries: true, smallSize: true,),
                            ),

                            //Add to cart
                            Container(
                              width: 50,
                              height: 40,
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
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
