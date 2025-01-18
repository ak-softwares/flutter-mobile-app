import 'package:aramarket/common/widgets/custom_shape/containers/rounded_container.dart';
import 'package:aramarket/utils/constants/icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:iconsax/iconsax.dart';
import 'package:share_plus/share_plus.dart';

import '../../../../common/navigation_bar/appbar2.dart';
import '../../../../common/styles/spacing_style.dart';
import '../../../../common/text/section_heading.dart';
import '../../../../common/widgets/loaders/animation_loader.dart';
import '../../../../common/widgets/loaders/loader.dart';
import '../../../../common/widgets/product/quantity_add_buttons/quantity_add_buttons.dart';
import '../../../../common/widgets/shimmers/single_product_shimmer.dart';
import '../../../../utils/constants/colors.dart';
import '../../../../utils/constants/image_strings.dart';
import '../../../../utils/constants/sizes.dart';
import '../../../../utils/constants/text_strings.dart';
import '../../controllers/cart_controller/cart_controller.dart';
import '../../controllers/product/product_controller.dart';
import '../../controllers/recently_viewed_controller/recently_viewed_controller.dart';
import '../../models/product_model.dart';
import '../all_products/all_products.dart';
import '../category/category_tap_bar.dart';
import '../checkout/checkout.dart';
import '../home_page_section/products_carousal_by_categories/widgets/products_scrolling_by_category.dart';
import '../product_review/product_review.dart';
import 'products_widgets/bottom_add_to_cart.dart';
import 'products_widgets/in_stock_label.dart';
import 'products_widgets/product_image_slider.dart';
import 'products_widgets/product_star_rating.dart';
import 'products_widgets/product_price.dart';
import 'products_widgets/sale_label.dart';

class ProductDetailScreen1 extends StatefulWidget {
  const ProductDetailScreen1({super.key, this.product, this.slug, this.productId});

  final ProductModel? product;
  final String? productId;
  final String? slug;

  @override
  State<ProductDetailScreen1> createState() => _ProductDetailScreenState1();
}

class _ProductDetailScreenState1 extends State<ProductDetailScreen1> {
  final RxBool _isLoading = false.obs;
  RxInt quantityInCart = 1.obs;

  final Rx<ProductModel> _product = ProductModel.empty().obs;
  final cartController = Get.put(CartController());
  final productController = Get.put(ProductController());

  @override
  void initState() {
    super.initState();
    _fetchProduct(product: widget.product, slug: widget.slug, productId: widget.productId);
  }

  // @override
  // void didChangeDependencies() {
  //   super.didChangeDependencies();
  //   // Fetch product data when the screen is loaded
  //   WidgetsBinding.instance?.addPostFrameCallback((_) {
  //     quantityInCart.value = cartController.getCartQuantity(_product.value.id);
  //     // _refreshProduct(); // Call the method to set isLoading after the widget is built
  //   });
  // }

  Future<void> _fetchProduct({ProductModel? product, String? slug, String? productId}) async {
    try {
      _isLoading(true);
      // this.product.value = ProductModel.empty();
      if (product != null) {
        // If product is provided, set it directly
        _product.value = product;
      } else if (slug != null) {
        final fetchedProduct = await productController.getProductBySlug(slug);
        _product.value = fetchedProduct;
      } else if (productId != null) {
        final fetchedProduct = await productController.getProductById(productId);
        _product.value = fetchedProduct;
      } else {
        throw Exception('Either product or productId must be provided.');
      }
    } catch (e) {
      rethrow;
    } finally {
      quantityInCart.value = cartController.getCartQuantity(_product.value.id);
      _isLoading(false); // Set loading state to false
    }
  }

  //Get products by Refresh page
  Future<void> _refreshProduct() async {
    final productId = _product.value.id;
    try {
      _product.value = ProductModel.empty();
      await _fetchProduct(productId: productId.toString());
    } catch (error) {
      TLoaders.warningSnackBar(title: 'Error', message: error.toString());
    }
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: TAppBar2(titleText: widget.product?.name ?? 'Product Details', showCartIcon: true),
      bottomNavigationBar: Obx(() => TBottomAddToCart(product: _product.value, quantity: quantityInCart.value)),
      body: RefreshIndicator(
        color: TColors.refreshIndicator,
        onRefresh: () async => _refreshProduct(),
        child: SingleChildScrollView(
          padding: TSpacingStyle.defaultPagePadding,
          child: Obx(() {
            if (_isLoading.value){
              return const SingleProductShimmer();
            }
            if(_product.value.id == 0) {
              return const TAnimationLoaderWidgets(
                text: 'Whoops! No Product Found...',
                animation: TImages.pencilAnimation,
              );
            }
            RecentlyViewedController.instance.addRecentProduct(_product.value.id.toString());
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // //search bar
                // const TSearchBar(searchText: TTexts.search),
                // const Divider(),

                //product images
                TProductImageSlider(product: _product.value),
                const SizedBox(height: TSizes.sm),
                const Divider(),

                //Breadcrumb
                InkWell(onTap: () =>
                    Get.to(() => TAllProducts(
                        title: _product.value.categories?[0].name ?? '',
                        categoryId: _product.value.categories?[0].id ?? '',
                        sharePageLink: '${TTexts.appName} - ${_product.value.categories?[0].permalink}',
                        futureMethodTwoString: productController.getProductsByCategoryId)
                    ),
                    child: Row(
                      children: [
                        Text(_product.value.categories?[0].name ?? '',
                            style: Theme.of(context).textTheme.labelLarge!.copyWith(color: TColors.linkColor)
                        ),
                        SizedBox(width: TSizes.sm,),

                        GestureDetector(
                          onTap: () => Share.share('${TTexts.appName} - ${_product.value.categories?[0].permalink}'),
                          child: Icon(
                            TIcons.share,
                            size: TSizes.md,
                            color: TColors.linkColor,
                          ),
                        )
                      ],
                    )
                ),

                //Product detail page Title description
                const SizedBox(height: TSizes.sm),
                Text(_product.value.name ?? '', style: Theme.of(context).textTheme.titleMedium!.copyWith(fontWeight: FontWeight.w500),),

                //Star Rating
                const SizedBox(height: TSizes.sm),
                ProductStarRating(
                    averageRating: _product.value.averageRating ?? 0.0,
                    ratingCount: _product.value.ratingCount ?? 0,
                    onTap: () => Get.to(() => ProductReviewScreen(product: _product.value)),
                    bigSize: true
                ),

                //Price
                const SizedBox(height: TSizes.sm),
                Row(
                  children: [
                    TOfferWidget(label: '${_product.value.calculateSalePercentage()}% off'),
                    const SizedBox(width: TSizes.spaceBtwItems),
                    TProductPrice(salePrice: _product.value.salePrice,
                        regularPrice: _product.value.regularPrice ?? 0.0,
                        priceInSeries: true),
                    // const SizedBox(width: TSizes.spaceBtwItems),
                    // TSaleLabel(discount: salePercentage),
                  ],
                ),

                //Free Delivery
                _product.value.getPrice() >= 999
                    ? TRoundedContainer(
                        radius: TSizes.productImageRadius,
                        backgroundColor: Colors.blue.shade50,
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text('Free Delivery', style: Theme.of(context).textTheme.bodySmall!.copyWith(color: TColors.linkColor)),
                            const SizedBox(width: TSizes.spaceBtwItems),
                            Icon(TIcons.truck, color: TColors.linkColor, size: 15),
                            const SizedBox(width: 5),
                          ],
                        )
                      )
                    : TRoundedContainer(
                          radius: TSizes.productImageRadius,
                          backgroundColor: Colors.blue.shade50,
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text('Free delivery over ₹999', style: Theme.of(context).textTheme.bodySmall!.copyWith(color: TColors.linkColor)),
                              const SizedBox(width: TSizes.spaceBtwItems),
                              Icon(TIcons.truck, color: TColors.linkColor, size: 15),
                              const SizedBox(width: 5),
                            ],
                          )
                      ),

                //Stock Status
                const SizedBox(height: TSizes.spaceBtwItems),
                InStock(isProductAvailable: _product.value.isProductAvailable()),

                // const SizedBox(height: TSizes.sm),
                const TSectionHeading(title: 'Select Quantity'),
                Obx(() {
                  return QuantityAddButtons(
                        size: 35,
                        quantity: quantityInCart.value,
                        // Accessing value of RxInt
                        add: () => quantityInCart.value += 1,
                        // Incrementing value
                        remove: () => quantityInCart.value <= 1
                            ? null
                            : quantityInCart.value -= 1,
                      );
                }),

                const SizedBox(height: TSizes.sm),
                ProductsScrollingByCategory(
                    title: 'Frequently Bought together',
                    parameter: _product.value.id.toString(),
                    futureMethod: productController.getFBTProducts
                ),

                const SizedBox(height: TSizes.spaceBtwSection),
                _product.value.description != ''
                    ? Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const TSectionHeading(title: 'Description'),
                          const SizedBox(height: TSizes.sm),
                          // Text(product.description ?? ''),
                          Html(data: _product.value.description)
                        ],
                      )
                    : const SizedBox.shrink(),

                //Shown products by category
                ProductsScrollingByCategory(
                    title: _product.value.categories?[0].name ?? '',
                    parameter: _product.value.categories?[0].id ?? '',
                    futureMethod: productController.getProductsByCategoryId
                ),
                const SizedBox(height: TSizes.sm),

                //Shown products by related products, up sale,cross sale
                ProductsScrollingByCategory(
                    title: 'Related Products',
                    parameter: _product.value.getAllRelatedProductsIdsAsString(),
                    futureMethod: productController.getProductsByIds
                ),
                const SizedBox(height: TSizes.sm),
                const Divider(),

                //Review
                const SizedBox(height: TSizes.spaceBtwItems),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    SizedBox(width: 250,
                        child: TSectionHeading(title: 'Reviews(${_product.value.ratingCount})')),
                    IconButton(
                        onPressed: () => Get.to(() => ProductReviewScreen(product: _product.value)),
                        icon: const Icon(Iconsax.arrow_right_3, size: 18)
                    )
                  ],
                ),
              ],
            );
          }),
        ),
      ),
    );
  }
}

class TOfferWidget extends StatelessWidget {
  const TOfferWidget({
    super.key,
    required this.label,
  });

  final String label;

  @override
  Widget build(BuildContext context) {
    return Text(label,
        style: Theme.of(context).textTheme.bodyLarge?.copyWith(color: TColors.offerColor, fontWeight: FontWeight.w600));
  }
}