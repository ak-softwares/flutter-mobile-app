import 'package:aramarket/features/shop/models/category_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:share_plus/share_plus.dart';
import '../../../../../../common/widgets/loaders/loader.dart';
import '../../../../../../common/widgets/product/product_cards/product_card.dart';
import '../../../../../../common/widgets/shimmers/product_shimmer.dart';
import '../../../../../../utils/constants/api_constants.dart';
import '../../../../../common/layout_models/product_grid_layout.dart';
import '../../../../../common/styles/spacing_style.dart';
import '../../../../../common/widgets/loaders/animation_loader.dart';
import '../../../../../services/share/share.dart';
import '../../../../../utils/constants/colors.dart';
import '../../../../../utils/constants/icons.dart';
import '../../../../../utils/constants/image_strings.dart';
import '../../../../../utils/constants/sizes.dart';
import '../../../../../utils/constants/text_strings.dart';
import '../../../../settings/app_settings.dart';
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
  final RxInt currentPage = 1.obs;
  final RxBool isLoading = false.obs;
  final RxBool isLoadingMore = false.obs;
  final RxList<ProductModel> products = <ProductModel>[].obs;

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
      final List<ProductModel> newProducts = await widget.futureMethod(widget.category.id ?? '', currentPage.toString());
      products.addAll(newProducts);
    } catch (e) {
      throw TLoaders.errorSnackBar(title: 'Error', message: e.toString());
    }
  }

  Future<void> _refreshAllProducts() async {
    try {
      isLoading(true);
      currentPage.value = 1; // Reset page number
      products.clear(); // Clear existing orders
      await _getAllProducts();
    } catch (error) {
      TLoaders.warningSnackBar(title: 'Error', message: error.toString());
    } finally {
      isLoading(false);
    }
  }

  void _scrollListener() async {
    if (_scrollController.position.extentAfter < 0.2 * _scrollController.position.maxScrollExtent) {
      if (!isLoadingMore.value) {
        isLoadingMore(true);
        final int itemsPerPage = int.parse(APIConstant.itemsPerPage); // Number of items per page
        if (products.length % itemsPerPage != 0) {
          isLoadingMore(false);
          return; // Stop fetching
        }
        currentPage.value++; // Increment current page
        await _getAllProducts();
        isLoadingMore(false);
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
        child: Column(
          children: [
            Align(
              alignment: Alignment.centerRight, // Float the InkWell to the left
              child: InkWell(
                onTap: () => AppShare.shareUrl(
                    url: widget.category.permalink ?? '',
                    contentType: 'Category',
                    itemName: widget.category.name ?? '',
                    itemId:  widget.category.id.toString()
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min, // Shrink-wrap the Row's width to its content
                  children: [
                    Text('Share',
                        style: Theme.of(context).textTheme.labelLarge!.copyWith(color: TColors.linkColor)
                    ),
                    SizedBox(width: Sizes.sm),
                    Icon(
                      TIcons.share,
                      size: Sizes.md,
                      color: TColors.linkColor,
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: Sizes.sm),
            ProductGridLayout(controller: this),
          ],
        ),
      ),
    );
  }
}
