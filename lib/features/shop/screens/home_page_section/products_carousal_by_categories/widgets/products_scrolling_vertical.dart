import 'dart:isolate';

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

class ProductsScrollingVertical extends StatefulWidget {
  final String title;
  final Future<List<ProductModel>> Function(String) futureMethod;

  const ProductsScrollingVertical({
    super.key,
    required this.title,
    required this.futureMethod,
  });

  @override
  _ProductsScrollingVerticalState createState() => _ProductsScrollingVerticalState();

}

class _ProductsScrollingVerticalState extends State<ProductsScrollingVertical> {
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
    refreshAllProducts();
  }

  @override
  void dispose() {
    _scrollController.removeListener(_scrollListener);
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> _getAllProducts() async {
    try {
      // final List<ProductModel> newProducts = await Isolate.run(() => widget.futureMethod(_currentPage.toString()));
      final List<ProductModel> newProducts = await widget.futureMethod(_currentPage.toString());
      _products.addAll(newProducts);
    } catch (e) {
      throw TLoaders.errorSnackBar(title: 'Error', message: e.toString());
    }
  }

  Future<void> refreshAllProducts() async {
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
        return const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.only(left: TSizes.spaceBtwItems),
              child: TSectionHeading(title: 'Products Loading..'),
            ),
            Padding(
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
            Padding(
              padding: const EdgeInsets.only(left: TSizes.spaceBtwItems),
              child: TSectionHeading(
                title: widget.title,
                seeActionButton: true,
                verticalPadding: true,
                onPressed: () => Get.to(() => TAllProducts(title: widget.title, futureMethod: widget.futureMethod)),
              ),
            ),
            SizedBox(
              height: 300,
              child: ListView.builder(
                controller: _scrollController,
                scrollDirection: Axis.horizontal,
                physics: const BouncingScrollPhysics(),
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
