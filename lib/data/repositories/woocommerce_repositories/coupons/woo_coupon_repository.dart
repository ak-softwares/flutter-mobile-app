import 'dart:convert';

import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:http/http.dart' as http;

import '../../../../features/shop/models/coupon_model.dart';
import '../../../../utils/cache/cache.dart';
import '../../../../utils/constants/api_constants.dart';
import '../../../../utils/constants/local_storage_constants.dart';


class WooCouponRepository extends GetxController {
  static WooCouponRepository get instance => Get.find();

  final Box _cacheBox = Hive.box(CacheConstants.couponBox); // Hive storage
  final double cacheExpiryTimeInDays = 7;

  //Fetch all coupons
  Future<List<CouponModel>> fetchAllCoupons(String page) async {
    final String cacheKey = 'fetch_all_coupons_$page';

    // Check cache before making API request
    if (_cacheBox.containsKey(cacheKey) && CacheHelper.isCacheValid(cacheBox: _cacheBox, cacheKey: cacheKey, expiryTimeInDays: cacheExpiryTimeInDays)) {
      final cachedData = _cacheBox.get(cacheKey);
      return (json.decode(cachedData) as List).map((json) => CouponModel.fromJson(json)).toList();
    }

    try {
      final Map<String, String> queryParams = {
        'orderby': 'title',
        //date, id, include, title and slug. Default is date.
        'per_page': '10',
        'page': page,
      };

      final Uri uri = Uri.https(
        APIConstant.wooBaseDomain,
        APIConstant.wooCouponsApiPath,
        queryParams,
      );

      final response = await http.get(
        uri,
        headers: {
          'Authorization': APIConstant.authorization,
        },
      );

      if (response.statusCode == 200) {
        final List<dynamic> couponsJson = json.decode(response.body);
        final List<CouponModel> coupons = couponsJson.map((json) => CouponModel.fromJson(json)).toList();
        // Store data in cache with timestamp
        _cacheBox.put(cacheKey, response.body);
        _cacheBox.put('${cacheKey}_time', DateTime.now().millisecondsSinceEpoch);
        return coupons;
      } else {
        final Map<String, dynamic> errorJson = json.decode(response.body);
        final errorMessage = errorJson['message'];
        throw errorMessage ?? 'Failed to fetch Coupon';
      }
    } catch(e){
      rethrow;
    }
  }

  //Fetch coupon by id
  Future<CouponModel> fetchCouponById(String couponID) async {
    final String cacheKey = 'fetch_coupon_by_id_$couponID';

    // Check cache before making API request
    if (_cacheBox.containsKey(cacheKey) && CacheHelper.isCacheValid(cacheBox: _cacheBox, cacheKey: cacheKey, expiryTimeInDays: cacheExpiryTimeInDays)) {
      final cachedData = _cacheBox.get(cacheKey);
      return CouponModel.fromJson(json.decode(cachedData));
    }

    try {
      final Uri uri = Uri.https(
        APIConstant.wooBaseDomain,
        APIConstant.wooCouponsApiPath+couponID,
      );

      final response = await http.get(
        uri,
        headers: {
          'Authorization': APIConstant.authorization,
        },
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> couponJson = json.decode(response.body);
        final CouponModel coupon = CouponModel.fromJson(couponJson);
        // Store data in cache with timestamp
        _cacheBox.put(cacheKey, response.body);
        _cacheBox.put('${cacheKey}_time', DateTime.now().millisecondsSinceEpoch);
        return coupon;
      } else {
        final Map<String, dynamic> errorJson = json.decode(response.body);
        final errorMessage = errorJson['message'];
        throw errorMessage ?? 'Failed to fetch Coupon';
      }
    } catch (error) {
      rethrow;
    }
  }

  //Fetch coupon by code
  Future<CouponModel> fetchCouponByCode(String code) async {
    final String cacheKey = 'fetch_coupon_by_code_$code';

    // Check cache before making API request
    if (_cacheBox.containsKey(cacheKey) &&
        CacheHelper.isCacheValid(cacheBox: _cacheBox, cacheKey: cacheKey, expiryTimeInDays: cacheExpiryTimeInDays)) {
      final cachedData = _cacheBox.get(cacheKey);

      if (cachedData != null) {
        final List<dynamic> cachedJson = json.decode(cachedData);
        if (cachedJson.isNotEmpty) {
          return CouponModel.fromJson(cachedJson.first);
        }
      }
    }

    try {
      final Map<String, String> queryParams = {
        'code': code,
      };

      final Uri uri = Uri.https(
        APIConstant.wooBaseDomain,
        APIConstant.wooCouponsApiPath,
        queryParams,
      );

      final response = await http.get(
        uri,
        headers: {
          'Authorization': APIConstant.authorization,
        },
      );

      if (response.statusCode == 200) {
        final List<dynamic> couponsJson = json.decode(response.body);
        if(couponsJson.isNotEmpty) {
          final CouponModel coupon = CouponModel.fromJson(couponsJson.first);
          // Store data in cache with timestamp
          _cacheBox.put(cacheKey, response.body);
          _cacheBox.put('${cacheKey}_time', DateTime.now().millisecondsSinceEpoch);
          return coupon;
        } else{
          throw 'No Coupon found! Please try again';
        }
      } else {
        final Map<String, dynamic> errorJson = json.decode(response.body);
        final errorMessage = errorJson['message'];
        throw errorMessage ?? 'Failed to fetch Coupon';
      }
    } catch (error) {
      rethrow;
    }
  }
}