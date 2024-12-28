import 'package:get/get.dart';

import '../../../common/widgets/loaders/loader.dart';
import '../../../data/repositories/woocommerce_repositories/settings/woo_settings_repositories.dart';
import '../models/settings_model.dart';

class SettingsController extends GetxController {

  //variables
  final isLoading = false.obs;
  final Rx<AppSettingsModel> appSettings = AppSettingsModel().obs;

  final wooSettingsRepositories = Get.put(WooSettingsRepositories());

  @override
  void onInit() {
    refreshBanners();
    super.onInit();
  }

  //fetch banner
  Future<void> getAppSettings() async {
    try {
      //fetch Banners from data source(firebase, api, etc)
      final fetchedAppSettings = await wooSettingsRepositories.fetchAppSettings();
      //assign banner
      appSettings.value = fetchedAppSettings;
    } catch (e) {
      TLoaders.errorSnackBar(
          title: 'Error - Banner loading', message: e.toString());
    }
  }

  Future<void> refreshBanners() async {
    try {
      isLoading(true);
      appSettings.value = AppSettingsModel(); // Resets all fields to default values
      await getAppSettings();
    } catch (error) {
      TLoaders.warningSnackBar(title: 'Error', message: error.toString());
    } finally {
      isLoading(false);
    }
  }
}