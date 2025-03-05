import 'dart:async';
import 'dart:convert';
import 'dart:isolate';
import 'package:hive/hive.dart';
import 'package:http/http.dart' as http;
import 'package:get/get.dart';

import '../../../../features/shop/models/product_model.dart';
import '../../../../utils/cache/cache.dart';
import '../../../../utils/constants/api_constants.dart';
import '../../../../utils/constants/local_storage_constants.dart';

class WooProductRepository extends GetxController {
  static WooProductRepository get instance => Get.find();

  final Box _cacheBox = Hive.box(CacheConstants.productBox); // Hive storage
  final double cacheExpiryTimeInDays = 1;


  // Fetch All Products
  Future<List<ProductModel>> fetchAllProducts({required String page}) async {
    final String cacheKey = 'fetch_all_products_$page';

    // Check cache before making API request
    if (_cacheBox.containsKey(cacheKey) && CacheHelper.isCacheValid(cacheBox: _cacheBox, cacheKey: cacheKey, expiryTimeInDays: cacheExpiryTimeInDays)) {
      final cachedData = _cacheBox.get(cacheKey);
      return (json.decode(cachedData) as List).map((json) => ProductModel.fromJson(json)).toList();
    }

    try {
      final Map<String, String> queryParams = {
        'orderby': 'popularity',
        'per_page': '10',
        'page': page,
      };

      final Uri uri = Uri.https(
        APIConstant.wooBaseUrl,
        APIConstant.wooProductsApiPath,
        queryParams,
      );

      final response = await http.get(
        uri,
        headers: {
          'Authorization': APIConstant.authorization,
        },
      ).timeout(const Duration(seconds: 30));

      if (response.statusCode == 200) {
        final List<dynamic> productsJson = json.decode(response.body);
        final List<ProductModel> productsByCategory = productsJson.map((json) => ProductModel.fromJson(json)).toList();
        // Store data in cache with timestamp
        _cacheBox.put(cacheKey, response.body);
        _cacheBox.put('${cacheKey}_time', DateTime.now().millisecondsSinceEpoch);
        return productsByCategory;
      } else {
        final Map<String, dynamic> errorJson = json.decode(response.body);
        final errorMessage = errorJson['message'];
        throw errorMessage ?? 'Failed to fetch Products';
      }
    } catch (error) {
      if (error is TimeoutException) {
        throw 'Connection timed out. Please check your internet connection and try again.';
      } else {
        rethrow;
      }
    }
  }

  // Fetch All Featured Products
  Future<List<ProductModel>> fetchFeaturedProducts({required String page}) async {
    final String cacheKey = 'fetch_featured_products_$page';

    // Check cache before making API request
    if (_cacheBox.containsKey(cacheKey) && CacheHelper.isCacheValid(cacheBox: _cacheBox, cacheKey: cacheKey, expiryTimeInDays: cacheExpiryTimeInDays)) {
      final cachedData = _cacheBox.get(cacheKey);
      return (json.decode(cachedData) as List).map((json) => ProductModel.fromJson(json)).toList();
    }

    try {
      final Map<String, String> queryParams = {
        'featured': 'true',
        'per_page': '10',
        'page': page,
      };

      final Uri uri = Uri.https(
        APIConstant.wooBaseUrl,
        APIConstant.wooProductsApiPath,
        queryParams,
      );

      final response = await http.get(
        uri,
        headers: {
          'Authorization': APIConstant.authorization,
        },
      );

      if (response.statusCode == 200) {
        final List<dynamic> productsJson = json.decode(response.body);
        final List<ProductModel> productsByCategory = productsJson.map((json) => ProductModel.fromJson(json)).toList();
        // Store data in cache with timestamp
        _cacheBox.put(cacheKey, response.body);
        _cacheBox.put('${cacheKey}_time', DateTime.now().millisecondsSinceEpoch);
        return productsByCategory;
      } else {
        final Map<String, dynamic> errorJson = json.decode(response.body);
        final errorMessage = errorJson['message'];
        throw errorMessage ?? 'Failed to fetch Featured Products';
      }
    } catch (error) {
      rethrow;
    }
  }

  // Fetch Products Under Price
  Future<List<ProductModel>> fetchProductsUnderPrice({required String page, required String price}) async {
    final String cacheKey = 'fetch_products_under_price_${price}_$page';

    // Check cache before making API request
    if (_cacheBox.containsKey(cacheKey) && CacheHelper.isCacheValid(cacheBox: _cacheBox, cacheKey: cacheKey, expiryTimeInDays: cacheExpiryTimeInDays)) {
      final cachedData = _cacheBox.get(cacheKey);
      return (json.decode(cachedData) as List).map((json) => ProductModel.fromJson(json)).toList();
    }

    try {
      final Map<String, String> queryParams = {
        'orderby': 'popularity',
        'per_page': '10',
        'max_price': price,
        'page': page,
        'stock_status': 'instock',
      };

      final Uri uri = Uri.https(
        APIConstant.wooBaseUrl,
        APIConstant.wooProductsApiPath,
        queryParams,
      );

      final response = await http.get(
        uri,
        headers: {
          'Authorization': APIConstant.authorization,
        },
      );

      if (response.statusCode == 200) {
        final productsByCategory = await Isolate.run(() {
          final List<dynamic> productsJson = json.decode(response.body);
          return productsJson.map((json) => ProductModel.fromJson(json)).toList();
        });
        // Store data in cache with timestamp
        _cacheBox.put(cacheKey, response.body);
        _cacheBox.put('${cacheKey}_time', DateTime.now().millisecondsSinceEpoch);
        return productsByCategory;
      } else {
        final Map<String, dynamic> errorJson = json.decode(response.body);
        final errorMessage = errorJson['message'];
        throw errorMessage ?? 'Failed to fetch Products under price';
      }
    } catch (error) {
      rethrow;
    }
  }

  // Fetch Products By Category ID
  Future<List<ProductModel>> fetchProductsByCategoryID({required String categoryId, required String page}) async {
    final String cacheKey = 'fetch_products_by_category_${categoryId}_$page';

    // Check cache before making API request
    if (_cacheBox.containsKey(cacheKey) && CacheHelper.isCacheValid(cacheBox: _cacheBox, cacheKey: cacheKey, expiryTimeInDays: cacheExpiryTimeInDays)) {
      final cachedData = _cacheBox.get(cacheKey);
      return (json.decode(cachedData) as List).map((json) => ProductModel.fromJson(json)).toList();
    }

    try {
      final Map<String, String> queryParams = {
        'category': categoryId,
        'orderby': 'popularity',
        'per_page': '10',
        'page': page,
      };

      final Uri uri = Uri.https(
        APIConstant.wooBaseUrl,
        APIConstant.wooProductsApiPath,
        queryParams,
      );

      final response = await http.get(
        uri,
        headers: {
          'Authorization': APIConstant.authorization,
        },
      );

      if (response.statusCode == 200) {
        final List<dynamic> productsJson = json.decode(response.body);
        final List<ProductModel> productsByCategory = productsJson.map((json) => ProductModel.fromJson(json)).toList();
        // Store data in cache with timestamp
        _cacheBox.put(cacheKey, response.body);
        _cacheBox.put('${cacheKey}_time', DateTime.now().millisecondsSinceEpoch);
        return productsByCategory;
      } else {
        final Map<String, dynamic> errorJson = json.decode(response.body);
        final errorMessage = errorJson['message'];
        throw errorMessage ?? 'Failed to fetch Products by category';
      }
    } catch (error) {
      rethrow;
    }
  }

  // Fetch Products By Brand ID
  Future<List<ProductModel>> fetchProductsByBrandID({required String brandID, required String page}) async {
    final String cacheKey = 'fetch_products_by_brand_${brandID}_$page';

    // Check cache before making API request
    if (_cacheBox.containsKey(cacheKey) && CacheHelper.isCacheValid(cacheBox: _cacheBox, cacheKey: cacheKey, expiryTimeInDays: cacheExpiryTimeInDays)) {
      final cachedData = _cacheBox.get(cacheKey);
      return (json.decode(cachedData) as List).map((json) => ProductModel.fromJson(json)).toList();
    }

    try {
      final Map<String, String> queryParams = {
        'brand': brandID,
        'orderby': 'popularity',
        'per_page': '10',
        'page': page,
      };

      final Uri uri = Uri.https(
        APIConstant.wooBaseUrl,
        APIConstant.wooProductsApiPath,
        queryParams,
      );

      final response = await http.get(
        uri,
        headers: {
          'Authorization': APIConstant.authorization,
        },
      ).timeout(const Duration(seconds: 30));

      if (response.statusCode == 200) {
        final List<dynamic> productsByBrandIDJson = json.decode(response.body);
        final List<ProductModel> productsByBrandID = productsByBrandIDJson.map((json) => ProductModel.fromJson(json)).toList();
        // Store data in cache with timestamp
        _cacheBox.put(cacheKey, response.body);
        _cacheBox.put('${cacheKey}_time', DateTime.now().millisecondsSinceEpoch);
        return productsByBrandID;
      } else {
        final Map<String, dynamic> errorJson = json.decode(response.body);
        final errorMessage = errorJson['message'];
        throw errorMessage ?? 'Failed to fetch Products by brand';
      }
    } catch (error) {
      if (error is TimeoutException) {
        throw 'Connection timed out. Please check your internet connection and try again.';
      } else {
        rethrow;
      }
    }
  }

  // Fetch Products By Ids
  Future<List<ProductModel>> fetchProductsByIds({required String productIds, required String page}) async {
    final String cacheKey = 'fetch_products_by_ids_${productIds}_$page';

    // Check cache before making API request
    if (_cacheBox.containsKey(cacheKey) && CacheHelper.isCacheValid(cacheBox: _cacheBox, cacheKey: cacheKey, expiryTimeInDays: cacheExpiryTimeInDays)) {
      final cachedData = _cacheBox.get(cacheKey);
      return (json.decode(cachedData) as List).map((json) => ProductModel.fromJson(json)).toList();
    }

    try {
      final Map<String, String> queryParams = {
        'include': productIds,
        'orderby': 'include',
        'per_page': '10',
        'page': page,
      };

      final Uri uri = Uri.https(
        APIConstant.wooBaseUrl,
        APIConstant.wooProductsApiPath,
        queryParams,
      );

      final response = await http.get(
        uri,
        headers: {
          'Authorization': APIConstant.authorization,
        },
      ).timeout(const Duration(seconds: 30));

      if (response.statusCode == 200) {
        final List<dynamic> productsJson = json.decode(response.body);
        final List<ProductModel> productsByCategory = productsJson.map((json) => ProductModel.fromJson(json)).toList();
        // Store data in cache with timestamp
        _cacheBox.put(cacheKey, response.body);
        _cacheBox.put('${cacheKey}_time', DateTime.now().millisecondsSinceEpoch);
        return productsByCategory;
      } else {
        final Map<String, dynamic> errorJson = json.decode(response.body);
        final errorMessage = errorJson['message'];
        throw errorMessage ?? 'Failed to fetch Products by Ids';
      }
    } catch (error) {
      if (error is TimeoutException) {
        throw 'Connection timed out. Please check your internet connection and try again.';
      } else {
        rethrow;
      }
    }
  }

  // Fetch Variations By Product Id
  Future<List<ProductModel>> fetchVariationByProductsIds({required String parentID}) async {
    final String cacheKey = 'fetch_variations_by_product_id_$parentID';

    // Check cache before making API request
    if (_cacheBox.containsKey(cacheKey) && CacheHelper.isCacheValid(cacheBox: _cacheBox, cacheKey: cacheKey, expiryTimeInDays: cacheExpiryTimeInDays)) {
      final cachedData = _cacheBox.get(cacheKey);
      return (json.decode(cachedData) as List).map((json) => ProductModel.fromJson(json)).toList();
    }

    try {
      final Uri uri = Uri.https(
        APIConstant.wooBaseUrl,
        '${APIConstant.wooProductsApiPath}$parentID/variations/',
      );

      final response = await http.get(
        uri,
        headers: {
          'Authorization': APIConstant.authorization,
        },
      ).timeout(const Duration(seconds: 30));

      if (response.statusCode == 200) {
        final List<dynamic> childrenJson = json.decode(response.body) as List<dynamic>;
        final List<ProductModel> childrenByParentID = childrenJson.map((json) => ProductModel.fromJson(json as Map<String, dynamic>)).toList();
        // Store data in cache with timestamp
        _cacheBox.put(cacheKey, response.body);
        _cacheBox.put('${cacheKey}_time', DateTime.now().millisecondsSinceEpoch);
        return childrenByParentID;
      } else {
        final Map<String, dynamic> errorJson = json.decode(response.body);
        final errorMessage = errorJson['message'];
        throw errorMessage ?? 'Failed to fetch Variations by product ID';
      }
    } catch (error) {
      if (error is TimeoutException) {
        throw 'Connection timed out. Please check your internet connection and try again.';
      } else {
        rethrow;
      }
    }
  }

  // Fetch Product By Id
  Future<ProductModel> fetchProductById(String productId) async {
    final String cacheKey = 'fetch_product_by_id_$productId';

    // Check cache before making API request
    if (_cacheBox.containsKey(cacheKey) &&
        CacheHelper.isCacheValid(cacheBox: _cacheBox, cacheKey: cacheKey, expiryTimeInDays: cacheExpiryTimeInDays)) {
      final cachedData = _cacheBox.get(cacheKey);
      return ProductModel.fromJson(json.decode(cachedData));
    }

    try {
      final Uri uri = Uri.https(
        APIConstant.wooBaseUrl,
        APIConstant.wooProductsApiPath + productId,
      );

      final response = await http.get(
        uri,
        headers: {
          'Authorization': APIConstant.authorization,
        },
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> productJson = json.decode(response.body);
        final ProductModel product = ProductModel.fromJson(productJson);
        // Store data in cache with timestamp
        _cacheBox.put(cacheKey, response.body);
        _cacheBox.put('${cacheKey}_time', DateTime.now().millisecondsSinceEpoch);
        return product;
      } else {
        final Map<String, dynamic> errorJson = json.decode(response.body);
        final errorMessage = errorJson['message'];
        throw errorMessage ?? 'Failed to fetch Product by Id';
      }
    } catch (error) {
      rethrow;
    }
  }

  // Fetch Product By Slug
  Future<ProductModel> fetchProductBySlug(String slug) async {
    final String cacheKey = 'fetch_product_by_slug_$slug';

    // Check cache before making API request
    if (_cacheBox.containsKey(cacheKey) && CacheHelper.isCacheValid(cacheBox: _cacheBox, cacheKey: cacheKey, expiryTimeInDays: cacheExpiryTimeInDays)) {
      final cachedData = _cacheBox.get(cacheKey);
      return ProductModel.fromJson(json.decode(cachedData));
    }

    try {
      final Map<String, String> queryParams = {
        'slug': slug,
      };

      final Uri uri = Uri.https(
        APIConstant.wooBaseUrl,
        APIConstant.wooProductsApiPath,
        queryParams,
      );

      final response = await http.get(
        uri,
        headers: {
          'Authorization': APIConstant.authorization,
        },
      );

      if (response.statusCode == 200) {
        final List<dynamic> productJson = json.decode(response.body);
        if (productJson.isNotEmpty) {
          final ProductModel product = ProductModel.fromJson(productJson.first);
          // Store data in cache with timestamp
          _cacheBox.put(cacheKey, response.body);
          _cacheBox.put('${cacheKey}_time', DateTime.now().millisecondsSinceEpoch);
          return product;
        } else {
          throw 'No Product found! Please try again';
        }
      } else {
        final Map<String, dynamic> errorJson = json.decode(response.body);
        final errorMessage = errorJson['message'];
        throw errorMessage ?? 'Failed to fetch Product by Slug';
      }
    } catch (error) {
      rethrow;
    }
  }

  // Fetch Products By Search Query
  Future<List<ProductModel>> fetchProductsBySearchQuery({required String query, required String page}) async {
    final String cacheKey = 'fetch_products_by_search_query_${query}_$page';

    // Check cache before making API request
    if (_cacheBox.containsKey(cacheKey) &&
        CacheHelper.isCacheValid(cacheBox: _cacheBox, cacheKey: cacheKey, expiryTimeInDays: cacheExpiryTimeInDays)) {
      final cachedData = _cacheBox.get(cacheKey);
      return (json.decode(cachedData) as List).map((json) => ProductModel.fromJson(json)).toList();
    }

    try {
      final Map<String, String> queryParams = {
        'search': query,
        'orderby': 'popularity',
        'type': 'simple',
        'per_page': '10',
        'page': page,
      };

      final Uri uri = Uri.https(
        APIConstant.wooBaseUrl,
        APIConstant.wooProductsApiPath,
        queryParams,
      );

      final response = await http.get(
        uri,
        headers: {
          'Authorization': APIConstant.authorization,
        },
      );

      if (response.statusCode == 200) {
        final List<dynamic> productsJson = json.decode(response.body);
        final List<ProductModel> productsByCategory = productsJson.map((json) => ProductModel.fromJson(json)).toList();
        // Store data in cache
        _cacheBox.put(cacheKey, response.body);
        _cacheBox.put('${cacheKey}_time', DateTime.now().millisecondsSinceEpoch);

        return productsByCategory;
      } else {
        final Map<String, dynamic> errorJson = json.decode(response.body);
        final errorMessage = errorJson['message'];
        throw errorMessage ?? 'Failed to fetch Products by search query';
      }
    } catch (error) {
      rethrow;
    }
  }

  // Fetch Frequently Bought Together Products
  Future<List<ProductModel>> fetchFBTProducts({required String productId}) async {
    final String cacheKey = 'fetch_fbt_products_$productId';

    // Check cache before making API request
    if (_cacheBox.containsKey(cacheKey) && CacheHelper.isCacheValid(cacheBox: _cacheBox, cacheKey: cacheKey, expiryTimeInDays: cacheExpiryTimeInDays)) {
      final cachedData = _cacheBox.get(cacheKey);
      return (json.decode(cachedData) as List).map((json) => ProductModel.fromJson(json)).toList();
    }

    try {
      final Map<String, String> queryParams = {
        'product_id': productId,
      };

      final Uri uri = Uri.https(
          APIConstant.wooBaseUrl,
          APIConstant.wooFBT,
          queryParams,
      );

      final response = await http.get(
        uri,
        // headers: {
        //   'Content-Type': 'application/json',
        // },
      );

      if (response.statusCode == 200) {
        final List<dynamic> productsJson = json.decode(response.body);
        // final List productsFBTStringList = productsJson.map((int value) => value.toString()).toList();
        if(productsJson.isNotEmpty){
          final List<ProductModel>  productsFBT = await fetchProductsByIds(productIds: productsJson.join(','), page: '1');
          // Store data in cache
          // Convert product list to JSON before storing in cache
          final String jsonEncodedProducts = json.encode(productsFBT.map((product) => product.toJson()).toList());
          _cacheBox.put(cacheKey, jsonEncodedProducts);
          _cacheBox.put('${cacheKey}_time', DateTime.now().millisecondsSinceEpoch);

          return productsFBT;
        } else{
          return [];
        }
      } else {
        final Map<String, dynamic> errorJson = json.decode(response.body);
        final errorMessage = errorJson['message'];
        throw errorMessage ?? 'Failed to fetch Products search query';
      }
    } catch(error) {
      rethrow;
    }
  }
}
