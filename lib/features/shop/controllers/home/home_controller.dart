import 'package:get/get.dart';

import '../../../../common/dialog_box_massages/snack_bar_massages.dart';
import '../../../../services/app_update/app_update.dart';
import '../../../../services/notification/local_notification.dart';

class HomeController extends GetxController {
  static HomeController get instance => Get.find();

  //variables
  RxBool isLoading = false.obs;
  RxBool isLoadingMore = false.obs;


  @override
  void onInit() {
    super.onInit();
    AppUpdate().checkForUpdate();
    LocalNotificationServices.checkNotificationAppLunch;
  }
}