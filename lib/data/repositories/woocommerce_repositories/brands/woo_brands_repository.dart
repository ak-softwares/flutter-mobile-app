import 'dart:async';
import 'dart:convert';
import 'package:hive/hive.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

import '../../../../features/shop/models/brand_model.dart';
import '../../../../utils/cache/cache.dart';
import '../../../../utils/constants/api_constants.dart';
import '../../../../utils/constants/local_storage_constants.dart';

class WooProductBrandsRepository extends GetxController {
  static WooProductBrandsRepository get instance => Get.find();

  final Box _cacheBox = Hive.box(CacheConstants.brandBox); // Hive storage
  final double productCacheExpiryTimeInDays = 7;

  // Fetch All Brands
  Future<List<BrandModel>> fetchAllBrands({required String page}) async {
    final String cacheKey = 'fetch_all_brands_$page';

    // Check cache before making API request
    if (_cacheBox.containsKey(cacheKey) &&
        CacheHelper.isCacheValid(cacheBox: _cacheBox, cacheKey: cacheKey, expiryTimeInDays: productCacheExpiryTimeInDays)) {
      final cachedData = _cacheBox.get(cacheKey);
      return (json.decode(cachedData) as List).map((json) => BrandModel.fromJson(json)).toList();
    }

    try {
      final Map<String, String> queryParams = {
        'orderby': 'name', // id, include, name, slug, term_group, description, and count
        'per_page': '20',
        'page': page,
      };

      final Uri uri = Uri.https(
        APIConstant.wooBaseUrl,
        APIConstant.wooProductBrandsApiPath,
        queryParams,
      );

      final response = await http.get(
        uri,
        headers: {
          'Authorization': APIConstant.authorization,
        },
      ).timeout(const Duration(seconds: 30));

      if (response.statusCode == 200) {
        final List<dynamic> productBrandsJson = json.decode(response.body);
        final List<BrandModel> productBrands = productBrandsJson.map((json) => BrandModel.fromJson(json)).toList();
        // Store data in cache with timestamp
        _cacheBox.put(cacheKey, response.body);
        _cacheBox.put('${cacheKey}_time', DateTime.now().millisecondsSinceEpoch);
        return productBrands;
      } else {
        final Map<String, dynamic> errorJson = json.decode(response.body);
        final errorMessage = errorJson['message'];
        throw errorMessage ?? 'Failed to fetch Brands';
      }
    } catch (error) {
      if (error is TimeoutException) {
        throw 'Connection timed out. Please check your internet connection and try again.';
      } else {
        rethrow;
      }
    }
  }
}
