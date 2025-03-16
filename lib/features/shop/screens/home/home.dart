import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../common/drawer/drawer.dart';
import '../../../../common/navigation_bar/appbar.dart';
import '../../../../common/widgets/send_whatsapp_msg/send_whatsapp_msg.dart';
import '../../../../services/firebase_analytics/firebase_analytics.dart';
import '../../../../utils/constants/api_constants.dart';
import '../../../../utils/constants/colors.dart';
import '../../../../utils/constants/sizes.dart';
import '../../../../utils/constants/text_strings.dart';
import '../../controllers/banner_controller/banner_controller.dart';
import '../../controllers/brand_controller/brand_controller.dart';
import '../../controllers/category_controller/category_controller.dart';
import '../../controllers/home/home_controller.dart';
import '../../controllers/product/product_controller.dart';
import '../brands/scrolling_brand.dart';
import '../category/scrolling_categories_image.dart';
import '../products/products_carousal_by_categories.dart';
import '../products/scrolling_products_by_item_id.dart';
import '../products/scrolling_products.dart';
import '../search/search_input_field.dart';
import 'widget/banner/banner_layout.dart';
import 'widget/youtuber_banner/youtuber_banner.dart';

class MyHomePage extends StatelessWidget {
  const MyHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    FBAnalytics.logPageView('home_screen');
    final ScrollController scrollController = ScrollController();
    final homeController = Get.put(HomeController());
    final productController = Get.put(ProductController());
    final categoryController = Get.put(CategoryController());
    final bannerController = Get.put(BannerController());
    final brandController = Get.put(BrandController());

    scrollController.addListener(() async {
      if (scrollController.position.extentAfter < 0.2 * scrollController.position.maxScrollExtent) {
        if(!categoryController.isLoadingMore.value){
          // User has scrolled to 80% of the content's height
          int itemsPerPage = int.parse(APIConstant.itemsPerPage); // Number of items per page
          if (categoryController.categories.length % itemsPerPage != 0) {
            // If the length of orders is not a multiple of itemsPerPage, it means all items have been fetched
            return; // Stop fetching
          }
          categoryController.isLoadingMore(true);
          categoryController.currentPage++; // Increment current page
          await categoryController.getAllCategory();
          categoryController.isLoadingMore(false);
        }
      }
    });

    return Scaffold(
      appBar: const TAppBar(),
      // bottomNavigationBar: const UpdateMobileNo(),
      floatingActionButton: const SendWhatsappScreen(),
      drawer: const MyDrawer(),
      body: RefreshIndicator(
        color: TColors.refreshIndicator,
        onRefresh: () async {
          bannerController.refreshBanners();
          categoryController.refreshCategories();
          brandController.refreshBrands();
        },
        child: ListView(
          controller: scrollController,
          physics: const AlwaysScrollableScrollPhysics(),
          children: [
            // const CircularProgressIndicator(), // Display a loading indicator until categories are fetched
            const TSearchBar(searchText: TTexts.search, padding: true),
            const HomeBanner(),
            const ScrollingBrandsImage(),
            const ScrollingCategoriesImage(),
            const Divider(),
            const YouTuberBanner(title: 'YouTuber\'s who like our products'),
            const Divider(),


            Column(
              spacing: Sizes.sm,
              children: [
                ScrollingProducts(title: 'Recently viewed', futureMethod: productController.getRecentProducts, orientation: OrientationType.horizontal),
                ScrollingProducts(title: 'Top Selling',  futureMethod: productController.getAllProducts),
                ScrollingProducts(title: 'Popular Products',  futureMethod: productController.getFeaturedProducts),
                ProductsScrollingByItemID(itemName: 'Soldering Irons', itemID: '61', futureMethod: productController.getProductsByCategoryId,),
                ProductsScrollingByItemID(itemName: 'SMD Machine Parts', itemID: '68', futureMethod: productController.getProductsByCategoryId,),
                ProductsScrollingByItemID(itemName: 'Cleaning Tools', itemID: '668', futureMethod: productController.getProductsByCategoryId,),
                ProductsScrollingByItemID(itemName: 'Li-ion Battery', itemID: '237', futureMethod: productController.getProductsByCategoryId,),
                ProductsScrollingByItemID(itemName: 'Tweezers', itemID: '65', futureMethod: productController.getProductsByCategoryId,),
                ProductsScrollingByItemID(itemName: 'Cutting Tool', itemID: '621', futureMethod: productController.getProductsByCategoryId,),
                ProductsScrollingByItemID(itemName: 'Mobile Screen Repair', itemID: '251', futureMethod: productController.getProductsByCategoryId,),
                ProductsScrollingByItemID(itemName: 'Solder Mask & UV Lamps', itemID: '672', futureMethod: productController.getProductsByCategoryId,),
                ProductsScrollingByItemID(itemName: 'Products under, "₹199"', itemID: '199', futureMethod: productController.getProductsUnderPrice),
              ],
            ),
            // const ProductCarousalByCategory(),
          ],
        ),
      ),
    );
  }
}

