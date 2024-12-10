import 'package:aramarket/features/shop/models/category_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:share_plus/share_plus.dart';
import '../../../../../../common/widgets/loaders/loader.dart';
import '../../../../../../common/widgets/product/product_cards/product_card_vertical.dart';
import '../../../../../../common/widgets/shimmers/vertical_product_shimmer.dart';
import '../../../../../../utils/constants/api_constants.dart';
import '../../../../../common/layout_models/grid_layout.dart';
import '../../../../../common/styles/spacing_style.dart';
import '../../../../../common/widgets/loaders/animation_loader.dart';
import '../../../../../utils/constants/colors.dart';
import '../../../../../utils/constants/icons.dart';
import '../../../../../utils/constants/image_strings.dart';
import '../../../../../utils/constants/sizes.dart';
import '../../../../../utils/constants/text_strings.dart';
import '../../../models/product_model.dart';

class TabviewProductsByCategory extends StatefulWidget {
  final CategoryModel category;
  final Future<List<ProductModel>> Function(String, String) futureMethod;

  const TabviewProductsByCategory({
    super.key,
    required this.category,
    required this.futureMethod,
  });

  @override
  _TabviewProductsByCategoryState createState() => _TabviewProductsByCategoryState();
}

class _TabviewProductsByCategoryState extends State<TabviewProductsByCategory> {
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
      final List<ProductModel> newProducts = await widget.futureMethod(widget.category.id ?? '', _currentPage.toString());
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
    return RefreshIndicator(
      color: TColors.refreshIndicator,
      onRefresh: () async => _refreshAllProducts(),
      child: SingleChildScrollView(
        controller: _scrollController,
        padding: TSpacingStyle.defaultPagePadding,
        child: Obx(() {
          if (_isLoading.value){
            return const TVerticalProductsShimmer(itemCount: 6);
          } else if (_products.isEmpty) {
            return const TAnimationLoaderWidgets(
              text: 'Whoops! No products found...',
              animation: TImages.pencilAnimation,
            );
          } else {
            return Column(
              children: [
                Align(
                  alignment: Alignment.centerRight, // Float the InkWell to the left
                  child: InkWell(
                    onTap: () => Share.share('${TTexts.appName} - ${widget.category.permalink}'),
                    child: Row(
                      mainAxisSize: MainAxisSize.min, // Shrink-wrap the Row's width to its content
                      children: [
                        Text('Share',
                            style: Theme.of(context).textTheme.labelLarge!.copyWith(color: TColors.linkColor)
                        ),
                        SizedBox(width: TSizes.sm),
                        Icon(
                          TIcons.share,
                          size: TSizes.md,
                          color: TColors.linkColor,
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: TSizes.sm),
                TGridLayout(
                  crossAxisCount: 2,
                  // mainAxisExtent: 130,
                  itemCount: _isLoadingMore.value ? _products.length + 2 : _products.length,
                  itemBuilder: (context, index) {
                    if (index < _products.length) {
                      return TProductCardVertical(product: _products[index]);
                    } else {
                      return const TVerticalProductsShimmer(itemCount: 1, crossAxisCount: 1,);
                    }
                  },
                ),
              ],
            );
          }
        }),
      ),
    );
  }
}
