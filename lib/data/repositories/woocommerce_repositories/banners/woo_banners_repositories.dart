import 'dart:convert';

import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:http/http.dart' as http;

import '../../../../features/shop/models/banner_model.dart';
import '../../../../utils/cache/cache.dart';
import '../../../../utils/constants/api_constants.dart';
import '../../../../utils/constants/local_storage_constants.dart';


class WooBannersRepositories extends GetxController {
  static WooBannersRepositories get instance => Get.find();

  final Box _cacheBox = Hive.box(CacheConstants.bannersBox); // Hive storage
  final double productCacheExpiryTimeInDays = 7;

  // Fetch Banners with caching
  Future<List<BannerModel>> fetchBanners() async {
    const String cacheKey = 'banners';

    // Check cache before making API request
    if (_cacheBox.containsKey(cacheKey) &&
        CacheHelper.isCacheValid(cacheBox: _cacheBox, cacheKey: cacheKey, expiryTimeInDays: productCacheExpiryTimeInDays)) {
      final cachedData = _cacheBox.get(cacheKey);
      final Map<String, dynamic> cachedJson = json.decode(cachedData); // Decode as Map
      final List<dynamic> bannersJson = cachedJson['banners'] ?? []; // Extract banners
      return bannersJson.map((json) => BannerModel.fromJson(json)).toList();
    }

    try {
      final Uri uri = Uri.https(
        APIConstant.wooBaseUrl,
        APIConstant.wooBanners,
      );

      final response = await http.get(
        uri,
        headers: {
          'Authorization': APIConstant.authorization,
        },
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseJson = json.decode(response.body);
        final List<dynamic> bannersJson = responseJson['banners'] ?? [];
        final List<BannerModel> banners = bannersJson.map((json) => BannerModel.fromJson(json)).toList();

        // Store response in cache
        _cacheBox.put(cacheKey, response.body);
        _cacheBox.put('${cacheKey}_time', DateTime.now().millisecondsSinceEpoch);

        return banners;
      } else {
        final Map<String, dynamic> errorJson = json.decode(response.body);
        final errorMessage = errorJson['message'];
        throw Exception(errorMessage ?? 'Failed to fetch Banners');
      }
    } catch (error) {
      rethrow;
    }
  }

}