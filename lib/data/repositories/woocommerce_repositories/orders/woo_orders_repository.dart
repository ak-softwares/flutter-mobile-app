import 'dart:convert';

import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:http/http.dart' as http;

import '../../../../features/shop/models/order_model.dart';
import '../../../../utils/cache/cache.dart';
import '../../../../utils/constants/api_constants.dart';
import '../../../../utils/constants/local_storage_constants.dart';


class WooOrdersRepository extends GetxController {
  static WooOrdersRepository get instance => Get.find();

  final Box _cacheBox = Hive.box(CacheConstants.orderBox); // Hive storage
  final double cacheExpiryTimeInDays = 7;

  //Fetch orders by customer's id
  Future<List<OrderModel>> fetchOrdersByCustomerId({required String customerId, required String page}) async {
    final String cacheKey = 'fetch_order_customer_id_$page';

    // Check cache before making API request
    if (_cacheBox.containsKey(cacheKey) && CacheHelper.isCacheValid(cacheBox: _cacheBox, cacheKey: cacheKey, expiryTimeInDays: cacheExpiryTimeInDays)) {
      final cachedData = _cacheBox.get(cacheKey);
      return (json.decode(cachedData) as List).map((json) => OrderModel.fromJson(json)).toList();
    }

    try {
      final Map<String, String> queryParams = {
        'customer': customerId,
        'orderby': 'date', //date, id, include, title and slug. Default is date.
        'per_page': '20',
        'page': page,
      };

      final Uri uri = Uri.https(
        APIConstant.wooBaseUrl,
        APIConstant.wooOrdersApiPath,
        queryParams,
      );

      final response = await http.get(
        uri,
        headers: {
          'Authorization': APIConstant.authorization,
        },
      );

      if (response.statusCode == 200) {
        final List<dynamic> ordersJson = json.decode(response.body);
        final List<OrderModel> orders = ordersJson.map((json) => OrderModel.fromJson(json)).toList();
        // Store data in cache with timestamp
        _cacheBox.put(cacheKey, response.body);
        _cacheBox.put('${cacheKey}_time', DateTime.now().millisecondsSinceEpoch);
        return orders;
      } else {
        final Map<String, dynamic> errorJson = json.decode(response.body);
        final errorMessage = errorJson['message'];
        throw errorMessage ?? 'Failed to fetch Orders';
      }
    } catch (error) {
      rethrow;
    }
  }

  //Fetch orders by customer's email
  Future<List<OrderModel>> fetchOrdersByCustomerEmail({required String customerEmail, required String page}) async {
    try {
      final Map<String, String> queryParams = {
        // 'customer': customersId,
        'search': customerEmail,
        'orderby': 'date', //date, id, include, title and slug. Default is date.
        'per_page': '10',
        'page': page,
      };

      final Uri uri = Uri.https(
        APIConstant.wooBaseUrl,
        APIConstant.wooOrdersApiPath,
        queryParams,
      );

      final response = await http.get(
        uri,
        headers: {
          'Authorization': APIConstant.authorization,
        },
      );

      if (response.statusCode == 200) {
        final List<dynamic> ordersJson = json.decode(response.body);
        final List<OrderModel> orders = ordersJson.map((json) => OrderModel.fromJson(json)).toList();
        return orders;
      } else {
        final Map<String, dynamic> errorJson = json.decode(response.body);
        final errorMessage = errorJson['message'];
        throw errorMessage ?? 'Failed to fetch Orders';
      }
    } catch (error) {
      rethrow;
    }
  }

  //create order
  Future<OrderModel> createOrderByCustomerId(OrderModel orderData) async {
    try {

      final Uri uri = Uri.https(
        APIConstant.wooBaseUrl,
        APIConstant.wooOrdersApiPath,
      );
      final http.Response response = await http.post(
        uri,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': APIConstant.authorization,
        },
        body: jsonEncode(orderData.toJsonForWoo()),
      );

      // Check if the request was successful
      if (response.statusCode == 201) {
        final Map<String, dynamic> orderJson = json.decode(response.body);
        final OrderModel order = OrderModel.fromJson(orderJson);
        CacheHelper.clearCacheBox(cacheBoxName: CacheConstants.orderBox);
        return order;
      } else {
        final Map<String, dynamic> errorJson = json.decode(response.body);
        final errorMessage = errorJson['message'];
        throw errorMessage ?? 'Failed to create Order';
      }
    } catch (error) {
      rethrow;
    }
  }

  //Cancel order
  Future<OrderModel> updateStatusByOrderId(String orderId, String status) async {
    try {
      Map<String, dynamic> data = {
        'status': status,
      };
      final Uri uri = Uri.https(
        APIConstant.wooBaseUrl,
        APIConstant.wooOrdersApiPath + orderId,
      );
      final http.Response response = await http.put(
        uri,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': APIConstant.authorization,
        },
        body: jsonEncode(data),
      );

      // Check if the request was successful
      if (response.statusCode == 200) {
        final Map<String, dynamic> orderJson = json.decode(response.body);
        final OrderModel order = OrderModel.fromJson(orderJson);
        CacheHelper.clearCacheBox(cacheBoxName: CacheConstants.orderBox);
        return order;
      } else {
        final Map<String, dynamic> errorJson = json.decode(response.body);
        final errorMessage = errorJson['message'];
        throw errorMessage ?? 'Failed to update order status';
      }
    } catch (error) {
      rethrow;
    }
  }
}