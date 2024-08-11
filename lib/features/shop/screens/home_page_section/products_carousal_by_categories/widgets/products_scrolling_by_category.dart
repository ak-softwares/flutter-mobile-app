import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../../../common/text/section_heading.dart';
import '../../../../../../common/widgets/loaders/loader.dart';
import '../../../../../../common/widgets/product/product_cards/product_card_vertical.dart';
import '../../../../../../common/widgets/shimmers/vertical_product_shimmer.dart';
import '../../../../../../utils/constants/api_constants.dart';
import '../../../../../../utils/constants/sizes.dart';
import '../../../../models/product_model.dart';
import '../../../all_products/all_products.dart';

class ProductsScrollingByCategory extends StatefulWidget {
  final String? title;
  final dynamic parameter;
  final Future<List<ProductModel>> Function(String, String) futureMethod;

  const ProductsScrollingByCategory({
    super.key,
    this.title,
    required this.futureMethod,
    required this.parameter,
  });

  @override
  _ProductsScrollingByCategoryState createState() => _ProductsScrollingByCategoryState();
}

class _ProductsScrollingByCategoryState extends State<ProductsScrollingByCategory> {
  late final ScrollController _scrollController;
  final RxInt _currentPage = 1.obs;
  final RxBool _isLoading = false.obs;
  final RxBool _isLoadingMore = false.obs;
  final RxList<ProductModel> _products = <ProductModel>[].obs;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    _scrollController.addListener(_scrollListener);
    _refreshAllProducts();
  }

  @override
  void dispose() {
    _scrollController.removeListener(_scrollListener);
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> _getAllProducts() async {
    try {
      final List<ProductModel> newProducts = await widget.futureMethod(widget.parameter, _currentPage.toString());
      _products.addAll(newProducts);
    } catch (e) {
      throw TLoaders.errorSnackBar(title: 'Error', message: e.toString());
    }
  }

  Future<void> _refreshAllProducts() async {
    try {
      _isLoading(true);
      _currentPage.value = 1; // Reset page number
      _products.clear(); // Clear existing orders
      await _getAllProducts();
    } catch (error) {
      TLoaders.warningSnackBar(title: 'Error', message: error.toString());
    } finally {
      _isLoading(false);
    }
  }

  void _scrollListener() async {
    if (_scrollController.position.extentAfter < 0.2 * _scrollController.position.maxScrollExtent) {
      if (!_isLoadingMore.value) {
        _isLoadingMore(true);
        final int itemsPerPage = int.parse(APIConstant.itemsPerPage); // Number of items per page
        if (_products.length % itemsPerPage != 0) {
          _isLoadingMore(false);
          return; // Stop fetching
        }
        _currentPage.value++; // Increment current page
        await _getAllProducts();
        _isLoadingMore(false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (_isLoading.value){
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(left: TSizes.spaceBtwItems),
              child: widget.title != null ? const TSectionHeading(title: 'Products Loading..') : const SizedBox.shrink(),
            ),
            const Padding(
              padding: EdgeInsets.all(TSizes.spaceBtwItems),
              child: TVerticalProductsShimmer(itemCount: 2),
            ),
          ],
        );
      } else if (_products.isEmpty) {
        return const SizedBox.shrink();
      } else {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            widget.title != null
              ? Padding(
                padding: const EdgeInsets.only(left: TSizes.spaceBtwItems),
                child: TSectionHeading(
                    title: widget.title!,
                    seeActionButton: true,
                    verticalPadding: true,
                    onPressed: () => Get.to(() => TAllProducts(title: widget.title ?? 'Products', categoryId: widget.parameter, futureMethodTwoString: widget.futureMethod)),
                ),
              )
              : const SizedBox.shrink(),
            SizedBox(
              height: 300,
              child: ListView.builder(
                controller: _scrollController,
                scrollDirection: Axis.horizontal,
                physics: const BouncingScrollPhysics(),
                // separatorBuilder: (_, __) => const SizedBox(width: TSizes.spaceBtwItems),
                itemCount: _isLoadingMore.value ? _products.length + 1 : _products.length,
                itemBuilder: (context, index) {
                  if (index < _products.length) {
                    return Padding(
                      padding: const EdgeInsets.all(TSizes.spaceBtwItems),
                      child: TProductCardVertical(product: _products[index]),
                    );
                  } else {
                    return const Padding(
                      padding: EdgeInsets.all(TSizes.spaceBtwItems),
                      child: TVerticalProductsShimmer(itemCount: 1, crossAxisCount: 1, isLoading: true,),
                    );
                  }
                },
              ),
            ),
          ],
        );
      }
    });
  }
}
