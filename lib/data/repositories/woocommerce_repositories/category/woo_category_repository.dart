import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

import '../../../../features/shop/models/category_model.dart';
import '../../../../utils/cache/cache.dart';
import '../../../../utils/constants/api_constants.dart';
import '../../../../utils/constants/local_storage_constants.dart';

class WooCategoryRepository extends GetxController {
  static WooCategoryRepository get instance => Get.find();

  final Box _cacheBox = Hive.box(CacheConstants.categoryBox); // Hive storage
  final double productCacheExpiryTimeInDays = 1;

  // Fetch all categories
  Future<List<CategoryModel>> fetchAllCategory(String page) async {
    final String cacheKey = 'fetch_all_categories_$page';

    // Check cache before making API request
    if (_cacheBox.containsKey(cacheKey) &&
        CacheHelper.isCacheValid(cacheBox: _cacheBox, cacheKey: cacheKey, expiryTimeInDays: productCacheExpiryTimeInDays)) {
      final cachedData = _cacheBox.get(cacheKey);
      return (json.decode(cachedData) as List).map((json) => CategoryModel.fromJson(json)).toList();
    }

    try {
      final Map<String, String> queryParams = {
        'orderby': 'name',
        'per_page': '30',
        'page': page,
      };

      final Uri uri = Uri.https(
        APIConstant.wooBaseDomain,
        APIConstant.wooCategoriesApiPath,
        queryParams,
      );

      final response = await http.get(
        uri,
        headers: {
          'Authorization': APIConstant.authorization,
        },
      );

      if (response.statusCode == 200) {
        final List<dynamic> categoriesJson = json.decode(response.body);
        final List<CategoryModel> categories = categoriesJson.map((json) => CategoryModel.fromJson(json)).toList();
        // Store data in cache
        _cacheBox.put(cacheKey, response.body);
        _cacheBox.put('${cacheKey}_time', DateTime.now().millisecondsSinceEpoch);
        return categories;
      } else {
        final Map<String, dynamic> errorJson = json.decode(response.body);
        throw errorJson['message'] ?? 'Failed to fetch Categories';
      }
    } catch (e) {
      rethrow;
    }
  }

  // Fetch category by slug
  Future<CategoryModel> fetchCategoryBySlug(String slug) async {
    final String cacheKey = 'fetch_category_$slug';

    // Check cache before making API request
    if (_cacheBox.containsKey(cacheKey) &&
        CacheHelper.isCacheValid(cacheBox: _cacheBox, cacheKey: cacheKey, expiryTimeInDays: productCacheExpiryTimeInDays)) {
      final cachedData = _cacheBox.get(cacheKey);
      return CategoryModel.fromJson(json.decode(cachedData));
    }

    try {
      final Map<String, String> queryParams = {
        'slug': slug,
      };

      final Uri uri = Uri.https(
        APIConstant.wooBaseDomain,
        APIConstant.wooCategoriesApiPath,
        queryParams,
      );

      final response = await http.get(
        uri,
        headers: {
          'Authorization': APIConstant.authorization,
        },
      );

      if (response.statusCode == 200) {
        final List<dynamic> categoriesJson = json.decode(response.body);
        if (categoriesJson.isNotEmpty) {
          final CategoryModel category = CategoryModel.fromJson(categoriesJson.first);
          // Store data in cache
          _cacheBox.put(cacheKey, json.encode(categoriesJson.first));
          _cacheBox.put('${cacheKey}_time', DateTime.now().millisecondsSinceEpoch);
          return category;
        } else {
          throw 'No Category found! Please try again';
        }
      } else {
        final Map<String, dynamic> errorJson = json.decode(response.body);
        throw errorJson['message'] ?? 'Failed to fetch Category';
      }
    } catch (e) {
      rethrow;
    }
  }
}
