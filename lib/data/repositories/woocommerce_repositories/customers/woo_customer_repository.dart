import 'dart:convert';

import 'package:get/get.dart';
import 'package:http/http.dart' as http;

import '../../../../features/personalization/controllers/user_controller.dart';
import '../../../../features/personalization/models/user_model.dart';
import '../../../../utils/constants/api_constants.dart';


class WooCustomersRepository extends GetxController {
  static WooCustomersRepository get instance => Get.find();

  //Fetch customer by id it gives single user
  Future<CustomerModel> fetchCustomerById(String customerId) async {
    try {
      final Uri uri = Uri.https(
        APIConstant.wooBaseUrl,
        APIConstant.wooCustomersApiPath+customerId,
      );
      final response = await http.get(
        uri,
        headers: {
          'Authorization': APIConstant.authorization,
        },
      );
      // Check if the request was successful
      if (response.statusCode == 200) {
        final Map<String, dynamic> customerJson = json.decode(response.body);
        final CustomerModel customer = CustomerModel.fromJson(customerJson);
        return customer;
      } else {
        final Map<String, dynamic> errorJson = json.decode(response.body);
        final errorMessage = errorJson['message'];
        throw errorMessage ?? 'Failed to fetch user';
      }
    } catch (error) {
      rethrow;
    }
  }

  //Fetch customer by email it give array
  Future<CustomerModel> fetchCustomerByEmail(String email) async {
    try {
      final Map<String, String> queryParams = {
        'email': email,
        'role':'all',
      };
      final Uri uri = Uri.https(
        APIConstant.wooBaseUrl,
        APIConstant.wooCustomersApiPath,
        queryParams,
      );
      final response = await http.get(
        uri,
        headers: {
          'Authorization': APIConstant.authorization,
        },
      );

      // Check if the request was successful
      if (response.statusCode == 200) {
        final List<dynamic> customerJson = json.decode(response.body);
        if(customerJson.isNotEmpty){
          final CustomerModel customer = CustomerModel.fromJson(customerJson.first);
          return customer;
        } else{
          throw 'Customer not found';
        }
      }else {
        final Map<String, dynamic> errorJson = json.decode(response.body);
        final errorMessage = errorJson['message'];
        throw errorMessage ?? 'Failed to fetch user';
      }
    } catch (error) {
      rethrow;
    }
  }

  //Fetch customer by Phone
  Future<String> fetchCustomerByPhone(String phone) async {
    try {
      final Map<String, String> queryParams = {
        'phone': phone,
      };
      final Uri uri = Uri.https(
        APIConstant.wooBaseUrl,
        APIConstant.wooCustomersPhonePath,
        queryParams,
      );
      final response = await http.get(
        uri,
        headers: {
          'Authorization': APIConstant.authorization,
        },
      );

      // Check if the request was successful
      if (response.statusCode == 200) {
        final Map<String, dynamic> customerEmailData = json.decode(response.body);
        final String userId = customerEmailData['id'];
        // final String email = customerEmailData['email'];
        return userId;
      } else if(response.statusCode == 404){
        final Map<String, dynamic> errorJson = json.decode(response.body);
        final errorMessage = errorJson['message'];
        throw errorMessage ?? 'Customer not found';
      } else {
        final Map<String, dynamic> errorJson = json.decode(response.body);
        final errorMessage = errorJson['message'];
        throw errorMessage ?? 'Failed to fetch user';
      }
    } catch (error) {
      rethrow;
    }
  }

  Future<CustomerModel> updateCustomerById(Map<String, dynamic> customerUpdateData) async {
    try {
      final Uri uri = Uri.https(
        APIConstant.wooBaseUrl,
        APIConstant.wooCustomersApiPath+UserController.instance.customer.value.id.toString(),
      );

      final response = await http.put(
        uri,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': APIConstant.authorization,
        },
        body: jsonEncode(customerUpdateData),
      );

      // Check if the request was successful
      if (response.statusCode == 200) {
        final Map<String, dynamic> customerJson = json.decode(response.body);
        final CustomerModel customer = CustomerModel.fromJson(customerJson);
        return customer;
      }else {
        final Map<String, dynamic> errorJson = json.decode(response.body);
        final errorMessage = errorJson['message'];
        throw errorMessage ?? 'Failed to update user details';
      }
    } catch (error) {
      rethrow;
    }
  }

  Future<CustomerModel> deleteCustomerById(String customerId) async {
    try {
      final Map<String, String> queryParams = {
        'force': 'true',
      };

      final Uri uri = Uri.https(
        APIConstant.wooBaseUrl,
        APIConstant.wooCustomersApiPath + customerId,
        queryParams
      );

      final response = await http.delete(
        uri,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': APIConstant.authorization,
        },
      );

      // Check if the request was successful
      if (response.statusCode == 200) {
        final Map<String, dynamic> customerJson = json.decode(response.body);
        final CustomerModel customer = CustomerModel.fromJson(customerJson);
        return customer;
      }else {
        final Map<String, dynamic> errorJson = json.decode(response.body);
        final errorMessage = errorJson['message'];
        throw errorMessage ?? 'Failed to update user details';
      }
    } catch (error) {
      rethrow;
    }
  }

}