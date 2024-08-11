import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import '../../../../utils/constants/db_constants.dart';
import '../../../../utils/constants/local_storage_constants.dart';
import '../../../authentication/controllers/phone_otp_controller/phone_otp_controller.dart';
import '../../../personalization/controllers/change_profile_controller.dart';

class IsFirstRunController extends GetxController {
  static IsFirstRunController get instance => Get.find();

  static Rx<bool> isFirstRun = false.obs;

  static final localStorage = GetStorage();

  static final oTPController = Get.put(OTPController());
  static final changeProfileController = Get.put(ChangeProfileController());


  @override
  void onInit() {
    super.onInit();
    isFirstRun.value = getIsFirstRunStatus();
  }

  static bool getIsFirstRunStatus() {
    return localStorage.read(LocalStorage.isFirstRun) ?? false;
  }

  static void setIsFirstRunStatus() {
    localStorage.write(LocalStorage.isFirstRun, false);
  }

  static Future<void> activation() async {

    // update fcm token to user meta in wordpress
    final fCMToken = await FirebaseMessaging.instance.getToken() ?? '';
    changeProfileController.wooUpdateUserMeta(key: CustomerMetaDataName.fCMToken, value: fCMToken);

    // set phone verified status to user meta in wordpress
    final isPhoneVerified = oTPController.isPhoneVerified.value;
    if(isPhoneVerified){
      changeProfileController.wooUpdateUserMeta(key: CustomerMetaDataName.verifyPhone, value: true);
    }

    // set
    setIsFirstRunStatus();
  }

}