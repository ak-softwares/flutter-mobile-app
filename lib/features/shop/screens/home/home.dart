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
import '../../../personalization/screens/change_profile/update_mobile_no.dart';
import '../../controllers/banner_controller/banner_controller.dart';
import '../../controllers/category_controller/category_controller.dart';
import '../../controllers/home/home_controller.dart';
import '../../controllers/product/product_controller.dart';
import '../home_page_section/banner/banner_layout.dart';
import '../home_page_section/category/scrolling_categories_image.dart';
import '../home_page_section/products_carousal_by_categories/products_carousal_by_categories.dart';
import '../home_page_section/products_carousal_by_categories/widgets/products_scrolling_by_category.dart';
import '../home_page_section/products_carousal_by_categories/widgets/products_scrolling_vertical.dart';
import '../home_page_section/search/search_input_field.dart';
import '../home_page_section/youtuber_banner/youtuber_banner.dart';

class MyHomePage extends StatelessWidget {
  const MyHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    FBAnalytics.logPageView('home_screen1');
    final ScrollController scrollController = ScrollController();
    final homeController = Get.put(HomeController());
    final productController = Get.put(ProductController());
    final categoryController = Get.put(CategoryController());
    final bannerController = Get.put(BannerController());

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
          categoryController.refreshCategories();
          bannerController.refreshBanners();
        },
        child: SingleChildScrollView(
          controller: scrollController,
          child: Column(
            children: [
              // const CircularProgressIndicator(), // Display a loading indicator until categories are fetched
              const TSearchBar(searchText: TTexts.search, padding: true),
              const HomeBanner(),
              const ScrollingCategoriesImage(),
              const Divider(),
              const YouTuberBanner(title: 'YouTuber\'s who like our products'),
              const Divider(),

              // ProductsScrollingByCategory(title: 'Products under, "₹199"', parameter: '199', futureMethod: productController.getProductsUnderPrice),
              // const SizedBox(height: TSizes.sm),
              ProductsScrollingVertical(title: 'Top Selling',  futureMethod: productController.getAllProducts),
              const SizedBox(height: TSizes.sm),
              ProductsScrollingVertical(title: 'Popular Products',  futureMethod: productController.getFeaturedProducts),
              const SizedBox(height: TSizes.sm),
              ProductsScrollingByCategory(title: 'Mobile Repairing Tools', parameter: '617', futureMethod: productController.getProductsByCategoryId,),
              const SizedBox(height: TSizes.sm),
              ProductsScrollingByCategory(title: 'TV Repairing Tools', parameter: '662', futureMethod: productController.getProductsByCategoryId,),
              const SizedBox(height: TSizes.sm),
              ProductsScrollingByCategory(title: 'Soldering Irons', parameter: '61', futureMethod: productController.getProductsByCategoryId,),
              const SizedBox(height: TSizes.sm),
              const ProductCarousalByCategory(),
              const SizedBox(height: TSizes.sm),
              ProductsScrollingVertical(title: 'Recently viewed', futureMethod: productController.getRecentProducts),
            ],
          ),
        ),
      ),
    );
  }
}

