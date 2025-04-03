import 'dart:isolate';

import 'package:get/get.dart';

import '../../../../common/dialog_box_massages/massages.dart';
import '../../../../data/repositories/woocommerce_repositories/brands/woo_brands_repository.dart';
import '../../../../data/repositories/woocommerce_repositories/category/woo_category_repository.dart';
import '../../models/brand_model.dart';
import '../../models/category_model.dart';

class BrandController extends GetxController {
  static BrandController get instance => Get.find();

  //variables
  RxInt currentPage = 1.obs;
  RxBool isLoading = false.obs;
  RxBool isLoadingMore = false.obs;
  RxList<BrandModel> productBrands = <BrandModel>[].obs;

  final wooProductBrandsRepository = Get.put(WooBrandsRepository());


  @override
  void onInit() {
    super.onInit();
    refreshBrands();
  } // @override

  //Get all categories
  Future<void> getAllBrands() async {
    try {
      final newBrands = await wooProductBrandsRepository.fetchAllBrands(page: currentPage.toString());
      productBrands.addAll(newBrands);
    } catch (e) {
      throw AppMassages.errorSnackBar(title: 'Error', message: e.toString());
    }
  }

  Future<void> refreshBrands() async {
    try {
      isLoading(true);
      currentPage.value = 1; // Reset page number
      productBrands.clear(); // Clear existing orders
      await getAllBrands();
    } catch (error) {
      AppMassages.warningSnackBar(title: 'Error', message: error.toString());
    } finally {
      isLoading(false);
    }
  }

}