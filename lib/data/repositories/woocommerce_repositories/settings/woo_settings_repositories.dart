import 'dart:convert';

import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:http/http.dart' as http;

import '../../../../features/settings/models/settings_model.dart';
import '../../../../features/shop/models/review_model.dart';
import '../../../../utils/cache/cache.dart';
import '../../../../utils/constants/api_constants.dart';
import '../../../../utils/constants/local_storage_constants.dart';


class WooSettingsRepositories extends GetxController {
  static WooSettingsRepositories get instance => Get.find();

  final Box _cacheBox = Hive.box(CacheConstants.settingsBox); // Hive storage
  final double cacheExpiryTimeInDays = APIConstant.appSettingCacheTime;

  // Fetch App Settings with caching
  Future<AppSettingsModel> fetchAppSettings() async {
    const String cacheKey = 'app_settings';

    // Check cache before making API request
    if (_cacheBox.containsKey(cacheKey) && CacheHelper.isCacheValid(cacheBox: _cacheBox, cacheKey: cacheKey, expiryTimeInDays: cacheExpiryTimeInDays)) {
      final cachedData = _cacheBox.get(cacheKey);
      return AppSettingsModel.fromJson(json.decode(cachedData));
    }

    try {
      final Uri uri = Uri.https(
        APIConstant.wooBaseDomain,
        APIConstant.wooSettings,
      );

      final response = await http.get(
        uri,
        headers: {
          'Authorization': APIConstant.authorization,
        },
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> settingsJson = json.decode(response.body);
        // Store data in cache with timestamp
        _cacheBox.put(cacheKey, response.body);
        _cacheBox.put('${cacheKey}_time', DateTime.now().millisecondsSinceEpoch);
        return AppSettingsModel.fromJson(settingsJson);
      } else {
        final Map<String, dynamic> errorJson = json.decode(response.body);
        final errorMessage = errorJson['message'];
        throw Exception(errorMessage ?? 'Failed to fetch App Settings');
      }
    } catch (error) {
      rethrow;
    }
  }
}