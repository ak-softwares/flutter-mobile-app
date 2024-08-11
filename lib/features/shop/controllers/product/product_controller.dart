import 'dart:isolate';

import 'package:aramarket/features/shop/models/category_model.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';

import '../../../../common/widgets/loaders/loader.dart';
import '../../../../data/repositories/firebase/products/product_repository.dart';
import '../../../../data/repositories/woocommerce_repositories/category/woo_category_repository.dart';
import '../../../../data/repositories/woocommerce_repositories/products/woo_product_repositories.dart';
import '../../models/product_model.dart';
import '../recently_viewed_controller/recently_viewed_controller.dart';

class ProductController extends GetxController {
  static ProductController get instance => Get.find();

  // RxBool isLoading = false.obs;
  // Rx<ProductModel> product = ProductModel.empty().obs; // Initialize with a default value if necessary
  RxList<ProductModel> featuredProducts = <ProductModel>[].obs;

  final productRepository = Get.put(ProductRepository());
  final wooProductRepository = Get.put(WooProductRepository());
  final wooCategoryRepository = Get.put(WooCategoryRepository());
  final recentlyViewedController = Get.put(RecentlyViewedController());


  //Get All products
  Future<List<ProductModel>> getAllProducts(String page) async {
    try{
      //fetch products
      final products = await wooProductRepository.fetchAllProducts(page: page);
      return products;
    } catch (e){
      TLoaders.errorSnackBar(title: 'Error in Products Fetching', message: e.toString());
      return [];
    }
  }

  //Get All Featured products
  Future<List<ProductModel>> getFeaturedProducts(String page) async {
    try{
      //fetch products
      final products = await wooProductRepository.fetchFeaturedProducts(page: page);
      return products;
    } catch (e){
      TLoaders.errorSnackBar(title: 'Error in Products Fetching', message: e.toString());
      return [];
    }
  }

  //Get Products under ₹199
  Future<List<ProductModel>> getProductsUnderPrice( String price, String page) async {
    try{
      //fetch products
      // final products = await compute(() => wooProductRepository.fetchProductsUnderPrice(page: page, price: price));
      final products = await wooProductRepository.fetchProductsUnderPrice(page: page, price: price);
      return products;
    } catch (e){
      TLoaders.errorSnackBar(title: 'Error in Products Fetching', message: e.toString());
      return [];
    }
  }

  Future<List<ProductModel>> getRecentProducts(String page) async {
    try{
      //fetch products
      if(recentlyViewedController.recentlyViewed.isNotEmpty) {
        final products = await wooProductRepository.fetchProductsByIds(productIds: recentlyViewedController.recentlyViewed.join(','), page: page);
        return products;
      }else{
        return [];
      }
    } catch (e){
      TLoaders.errorSnackBar(title: 'Error in Products Fetching', message: e.toString());
      return [];
    }
  }

  //Get products by category id
  Future<List<ProductModel>> getProductsByCategoryId(String categoryId, String page) async {
    try{
      //fetch products
      final products = await wooProductRepository.fetchProductsByCategory(categoryId: categoryId, page: page);
      return products;
    } catch (e){
      TLoaders.errorSnackBar(title: 'Error in Products Fetching', message: e.toString());
      return [];
    }
  }

  //Get products by category id
  Future<List<ProductModel>> getProductsByCategorySlug(String slug, String page) async {
    try{
      //fetch products
      final CategoryModel category = await wooCategoryRepository.fetchCategoryBySlug(slug);
      final products = await wooProductRepository.fetchProductsByCategory(categoryId: category.id ?? '', page: page);
      return products;
    } catch (e){
      TLoaders.errorSnackBar(title: 'Error in Products Fetching', message: e.toString());
      return [];
    }
  }

  //Get products by products ids
  Future<List<ProductModel>> getProductsByIds(String productIds, String page) async {
    try{
      //fetch products
      final products = await wooProductRepository.fetchProductsByIds(productIds: productIds, page: page);
      return products;
    } catch (e){
      TLoaders.errorSnackBar(title: 'Error in Products Fetching', message: e.toString());
      return [];
    }
  }

  //Get products by product id
  Future<ProductModel> getProductById(String productsId) async {
    try{
      //fetch products
      final ProductModel product = await wooProductRepository.fetchProductById(productsId);
      return product;
    } catch (e){
      TLoaders.errorSnackBar(title: 'Error in Products Fetching', message: e.toString());
      return ProductModel.empty();
    }
  }

  //Get products by product's slug
  Future<ProductModel> getProductBySlug(String permalink) async {
    try{
      //fetch products
      final ProductModel product = await wooProductRepository.fetchProductBySlug(permalink);
      return product;
    } catch (e){
      TLoaders.errorSnackBar(title: 'Error in Products Fetching', message: e.toString());
      return ProductModel.empty();
    }
  }

  //
  // Future<void> fetchProduct({ProductModel? product, String? slug, String? productId}) async {
  //   try {
  //     // this.product.value = ProductModel.empty();
  //     isLoading(true); // Set loading state to true
  //     if (product != null) {
  //       // If product is provided, set it directly
  //       this.product.value = product;
  //     } else if (slug != null) {
  //       final fetchedProduct = await getProductBySlug(slug);
  //       this.product.value = fetchedProduct;
  //     } else if (productId != null) {
  //       final fetchedProduct = await getProductById(productId);
  //       this.product.value = fetchedProduct;
  //     } else {
  //       throw Exception('Either product or productId must be provided.');
  //     }
  //   } catch (e) {
  //     rethrow;
  //   } finally {
  //     isLoading(false); // Set loading state to false
  //   }
  // }
  //
  // //Get products by Refresh page
  // Future<void> refreshProduct() async{
  //   final productId = product.value.id;
  //   try {
  //     product.value = ProductModel.empty();
  //     await fetchProduct(productId: productId.toString());
  //   } catch (error) {
  //     TLoaders.warningSnackBar(title: 'Error', message: error.toString());
  //   }
  // }

  //Get Products By Search Query
  Future<List<ProductModel>> getProductsBySearchQuery(String searchQuery) async {
    try{
      //fetch products
      final products = await wooProductRepository.fetchProductsBySearchQuery(query: searchQuery, page: '1');
      return products;
    } catch (e){
      TLoaders.errorSnackBar(title: 'Error in Products Fetching', message: e.toString());
      return [];
    }
  }

  //Get Limited featured products
  void fetchFeaturedProducts() async {
    try{
      //fetch products
      final products = await productRepository.getFeaturedProducts();
      //assign Products
      featuredProducts.assignAll(products);

    } catch (e){
      TLoaders.errorSnackBar(title: 'Error in Products Fetching', message: e.toString());
    }
  }

  //Get Products By Search Query
  Future<List<ProductModel>> getFBTProducts(String productId, String page) async {
    try{
      //fetch products
      final products = await wooProductRepository.fetchFBTProducts(productId: productId);
      return products;
    } catch (e){
      // TLoaders.errorSnackBar(title: 'Error in Products Fetching', message: e.toString());
      return [];
    }
  }
}