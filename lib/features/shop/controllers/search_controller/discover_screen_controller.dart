
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import '../../../../common/widgets/loaders/loader.dart';
import '../../../../data/repositories/user/user_repository.dart';
import '../../../../data/repositories/woocommerce_repositories/products/woo_product_repositories.dart';
import '../../../../utils/constants/db_constants.dart';
import '../../../../utils/constants/local_storage_constants.dart';
import '../../models/product_model.dart';
import '../product/product_controller.dart';

class DiscoverScreenController extends GetxController{
  static DiscoverScreenController get instance => Get.find();

  // Variable
  RxInt currentPage = 1.obs;
  RxBool isLoading = false.obs;
  RxBool isLoadingMore = false.obs;
  RxList<ProductModel> discoverProducts = <ProductModel>[].obs;
  final wooProductRepository = Get.put(WooProductRepository());
  final productController = Get.put(ProductController());


  Future<void> getDiscoverProducts() async {
    try {
        final newProducts = await productController.getAllProducts(currentPage.toString());
        discoverProducts.addAll(newProducts);
    } catch (e) {
      throw TLoaders.errorSnackBar(title: 'Error', message: e.toString());
    }
  }

  Future<void> refreshDiscoverProducts() async {
    try {
      isLoading(true);
      currentPage.value = 1; // Reset page number
      discoverProducts.clear(); // Clear existing orders
      await getDiscoverProducts();
    } catch (error) {
      TLoaders.warningSnackBar(title: 'Errors', message: error.toString());
    } finally {
      isLoading(false);
    }
  }
}