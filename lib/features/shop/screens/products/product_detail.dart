import 'package:aramarket/common/widgets/custom_shape/containers/rounded_container.dart';
import 'package:aramarket/features/shop/screens/products/scrolling_products.dart';
import 'package:aramarket/utils/constants/icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';

import '../../../../common/navigation_bar/appbar2.dart';
import '../../../../common/styles/spacing_style.dart';
import '../../../../common/text/section_heading.dart';
import '../../../../common/widgets/loaders/animation_loader.dart';
import '../../../../common/widgets/loaders/loader.dart';
import '../../../../common/widgets/shimmers/single_product_shimmer.dart';
import '../../../../services/firebase_analytics/firebase_analytics.dart';
import '../../../../services/share/share.dart';
import '../../../../utils/constants/colors.dart';
import '../../../../utils/constants/image_strings.dart';
import '../../../../utils/constants/sizes.dart';
import '../../../settings/app_settings.dart';
import '../../controllers/cart_controller/cart_controller.dart';
import '../../controllers/product/product_controller.dart';
import '../../controllers/recently_viewed/recently_viewed_controller.dart';
import '../../models/product_model.dart';
import '../all_products/all_products.dart';
import 'scrolling_products_by_item_id.dart';
import '../review/product_review.dart';
import '../review/product_review_horizontal.dart';
import 'products_widgets/bottom_add_to_cart.dart';
import 'products_widgets/in_stock_label.dart';
import 'products_widgets/product_image_slider.dart';
import 'products_widgets/product_price.dart';
import 'products_widgets/sale_label.dart';

class ProductDetailScreen extends StatefulWidget {
  ProductDetailScreen({
    Key? key,
    this.product,
    this.slug,
    this.productId,
    this.pageSource = 'product_detail_screen',
  }) : super(key: key ?? UniqueKey());

  final ProductModel? product;
  final String? productId;
  final String? slug;
  final String pageSource;

  @override
  State<ProductDetailScreen> createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen> {
  final RxBool _isLoading = false.obs;
  RxInt quantityInCart = 1.obs;

  final Rx<ProductModel> _product = ProductModel.empty().obs;
  final cartController = Get.put(CartController(), permanent: true);
  final productController = Get.put(ProductController(), permanent: true);

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
    FBAnalytics.logPageView('product_screen');

    // Adding the product to recently viewed outside Obx's reactive context
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_product.value.id != 0) {
        RecentlyViewedController.instance.addRecentProduct(_product.value.id.toString());
      }
    });

    return Scaffold(
      appBar: TAppBar2(titleText: widget.product?.name ?? 'Product Details', showCartIcon: true),
      bottomNavigationBar: Obx(() => TBottomAddToCart(product: _product.value, quantity: quantityInCart.value, pageSource: widget.pageSource)),
      body: RefreshIndicator(
        color: TColors.refreshIndicator,
        onRefresh: () async => _refreshProduct(),
        child: ListView(
          padding: TSpacingStyle.defaultPagePadding,
          physics: const AlwaysScrollableScrollPhysics(),
          children: [
            Obx(() {
              if (_isLoading.value){
                return const SingleProductShimmer();
              }
              if(_product.value.id == 0) {
                return const TAnimationLoaderWidgets(
                  text: 'Whoops! No Product Found...',
                  animation: Images.pencilAnimation,
                );
              }
              FBAnalytics.logViewItem(product: _product.value);
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  //search bar
                  // const TSearchBar(searchText: TTexts.search),
                  // const Divider(),

                  // Product images
                  TProductImageSlider(product: _product.value),
                  const SizedBox(height: Sizes.sm),
                  const Divider(),

                  // Title
                  Text(_product.value.name ?? '', style: Theme.of(context).textTheme.bodyLarge!.copyWith(fontWeight: FontWeight.w500),),
                  // const SizedBox(height: TSizes.sm),

                  // Category
                  InkWell(
                      onTap: () => Get.to(() => TAllProducts(
                              title: _product.value.categories?[0].name ?? '',
                              categoryId: _product.value.categories?[0].id ?? '',
                              sharePageLink: '${AppSettings.appName} - ${_product.value.categories?[0].permalink}',
                              futureMethodTwoString: productController.getProductsByCategoryId)
                          ),
                      // onTap: () => Get.to(CategoryTapBarScreen(categoryId: _product.value.categories?[0].id ?? '')),
                      child: Row(
                        children: [
                          Text(_product.value.categories?[0].name ?? '',
                              style: Theme.of(context).textTheme.labelLarge!.copyWith(color: TColors.linkColor)
                          ),
                          SizedBox(width: Sizes.sm,),
                          GestureDetector(
                            onTap: () => AppShare.shareUrl(
                                url: '${_product.value.categories?[0].permalink}',
                                contentType: 'Category',
                                itemName: _product.value.categories?[0].name ?? '',
                                itemId: _product.value.categories?[0].id ?? ''
                            ),
                            child: Icon(
                              TIcons.share,
                              size: Sizes.md,
                              color: TColors.linkColor,
                            ),
                          )
                        ],
                      )
                  ),
                  const SizedBox(height: Sizes.sm),

                  // Brands
                  _product.value.brands != null && _product.value.brands!.isNotEmpty
                      ? Column(
                          children: [
                            Text(
                              _product.value.brands?.map((brand) => brand.name).join(', ') ?? '', // Join brand names with commas
                              style: Theme.of(context)
                              .textTheme
                              .labelLarge!
                              .copyWith(color: TColors.linkColor),
                            ),
                            const SizedBox(height: Sizes.sm),
                          ],
                        )
                      : SizedBox.shrink(),

                  // Star Rating
                  // const SizedBox(height: TSizes.sm),
                  // ProductStarRating(
                  //     averageRating: _product.value.averageRating ?? 0.0,
                  //     ratingCount: _product.value.ratingCount ?? 0,
                  //     onTap: () => Get.to(() => ProductReviewScreen(product: _product.value)),
                  //     bigSize: true
                  // ),

                  // Price
                  Row(
                    children: [
                      TSaleLabel(discount: _product.value.calculateSalePercentage(), size: 13,),
                      // TOfferWidget(label: '${_product.value.calculateSalePercentage()}% off'),
                      const SizedBox(width: Sizes.spaceBtwItems),
                      ProductPrice(salePrice: _product.value.salePrice,
                          regularPrice: _product.value.regularPrice ?? 0.0,
                          orientation: OrientationType.horizontal
                      ),
                      // const SizedBox(width: TSizes.spaceBtwItems),
                      // TSaleLabel(discount: salePercentage),
                    ],
                  ),
                  const SizedBox(height: Sizes.sm /2 ),

                  // Free Delivery Label
                  _product.value.getPrice() >= AppSettings.freeShippingOver
                      ? TRoundedContainer(
                          radius: Sizes.productImageRadius,
                          backgroundColor: Colors.blue.shade50,
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text('Free Delivery', style: Theme.of(context).textTheme.bodySmall!.copyWith(color: TColors.linkColor, fontSize: 10)),
                              const SizedBox(width: Sizes.spaceBtwItems),
                              Icon(TIcons.truck, color: TColors.linkColor, size: 10),
                              const SizedBox(width: 5),
                            ],
                          )
                        )
                      : TRoundedContainer(
                            radius: Sizes.productImageRadius,
                            backgroundColor: Colors.blue.shade50,
                            padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 1),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text('Free delivery over ₹999', style: Theme.of(context).textTheme.bodySmall!.copyWith(color: TColors.linkColor, fontSize: 10)),
                                const SizedBox(width: Sizes.spaceBtwItems),
                                Icon(TIcons.truck, color: TColors.linkColor, size: 10),
                                const SizedBox(width: 5),
                              ],
                            )
                        ),
                  const SizedBox(height: Sizes.spaceBtwItems),


                  // In Stock
                  InStock(isProductAvailable: _product.value.isProductAvailable()),
                  const SizedBox(height: Sizes.sm),

                  // const TSectionHeading(title: 'Select Quantity'),
                  // Obx(() {
                  //   return QuantityAddButtons(
                  //         size: 35,
                  //         quantity: quantityInCart.value,
                  //         // Accessing value of RxInt
                  //         add: () => quantityInCart.value += 1,
                  //         // Incrementing value
                  //         remove: () => quantityInCart.value <= 1
                  //             ? null
                  //             : quantityInCart.value -= 1,
                  //       );
                  // }),
                  // const SizedBox(height: TSizes.defaultSpace),

                  // Product review
                  _product.value.averageRating != 0
                      ? Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            ProductReviewHorizontal(product: _product.value),
                            const SizedBox(height: Sizes.sm),
                          ],
                        )
                      : const SizedBox.shrink(),

                  // Frequently Bought together
                  ProductsScrollingByItemID(
                      itemName: 'Frequently Bought together',
                      itemID: _product.value.id.toString(),
                      futureMethod: productController.getFBTProducts
                  ),

                  const SizedBox(height: Sizes.spaceBtwSection),
                  _product.value.description != ''
                      ? Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const TSectionHeading(title: 'Description'),
                            const SizedBox(height: Sizes.sm),
                            // Text(product.description ?? ''),
                            Html(data: _product.value.description)
                          ],
                        )
                      : const SizedBox.shrink(),

                  //Shown products by category
                  ProductsScrollingByItemID(
                      itemName: _product.value.categories?[0].name ?? '',
                      itemID: _product.value.categories?[0].id ?? '',
                      futureMethod: productController.getProductsByCategoryId
                  ),
                  const SizedBox(height: Sizes.sm),

                  //Shown products by related products, up sale,cross sale
                  ProductsScrollingByItemID(
                      itemName: 'Related Products',
                      itemID: _product.value.getAllRelatedProductsIdsAsString(),
                      futureMethod: productController.getProductsByIds
                  ),
                  const SizedBox(height: Sizes.sm),
                  const Divider(),

                  //Review
                  const SizedBox(height: Sizes.spaceBtwItems),
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
          ],
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