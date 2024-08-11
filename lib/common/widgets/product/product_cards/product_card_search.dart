import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../features/shop/models/product_model.dart';
import '../../../../features/shop/screens/product_detail/product_detail.dart';
import '../../../../features/shop/screens/product_detail/products_widgets/product_price.dart';
import '../../../../features/shop/screens/product_detail/products_widgets/product_title_text.dart';
import '../../../../utils/constants/sizes.dart';
import '../../../styles/shadows.dart';
import '../../custom_shape/image/circular_image.dart';

class TProductCardSearch extends StatelessWidget {
  const TProductCardSearch({super.key, required this.product});

  final ProductModel product;

  @override
  Widget build(BuildContext context) {

    const double imageHeight = 80;
    const double cardRadius = TSizes.productImageRadius;

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
                        // const SizedBox(height: TSizes.spaceBtwItems / 2),

                        //Star rating
                        // ProductStarRating(averageRating: product.averageRating ?? 0.0, ratingCount: product.ratingCount ?? 0),

                        // const Spacer(),

                        //Price and Add to cart
                        TProductPrice(salePrice: product.salePrice!, regularPrice: product.regularPrice ?? 0.0, priceInSeries: true, smallSize: true,)
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
