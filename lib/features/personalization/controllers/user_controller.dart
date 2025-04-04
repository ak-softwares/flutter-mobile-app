import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../../common/dialog_box_massages/massages.dart';
import '../../../common/widgets/network_manager/network_manager.dart';
import '../../../data/repositories/authentication/authentication_repository.dart';
import '../../../data/repositories/user/user_repository.dart';
import '../../../data/repositories/woocommerce_repositories/customers/woo_customer_repository.dart';
import '../../../services/firebase_analytics/firebase_analytics.dart';
import '../../../utils/constants/db_constants.dart';
import '../../../utils/constants/image_strings.dart';
import '../../../utils/constants/local_storage_constants.dart';
import '../../../utils/helpers/navigation_helper.dart';
import '../../../utils/permissions/permissions.dart';
import '../../../common/dialog_box_massages/full_screen_loader.dart';
import '../../authentication/screens/email_login/email_login.dart';
import '../../authentication/screens/email_login/re_auth_user_login.dart';
import '../../settings/app_settings.dart';
import '../models/user_model.dart';

class UserController extends GetxController {
  static UserController get instance => Get.find();

  RxBool isLoading = false.obs;
  final GetStorage localStorage = GetStorage();
  Rx<CustomerModel> customer = CustomerModel.empty().obs;

  final hidePassword = true.obs; //Observable for hiding/showing password
  final imageUploading = false.obs;
  final verifyEmail = TextEditingController();
  final verifyPassword = TextEditingController();
  GlobalKey<FormState> reAuthFormKey = GlobalKey<FormState>();

  final userRepository = Get.put(UserRepository());
  final wooCustomersRepository = Get.put(WooCustomersRepository());
  final authenticationRepository = Get.put(AuthenticationRepository());

  @override
  void onInit() {
    super.onInit();
    customer.value = CustomerModel(id: fetchLocalAuthToken());
  }

  // Fetch user record
  Future<void> fetchCustomerData() async {
    try {
      final localAuthUserToken = fetchLocalAuthToken();
      if (localAuthUserToken > 0) { // Check if token is valid
        final customerData = await wooCustomersRepository.fetchCustomerById(localAuthUserToken.toString());
        customer(customerData);
      } else{
        throw 'customer not found';
      }
    } catch (error) {
      rethrow;
    }
  }

  int fetchLocalAuthToken() {
    final localAuthUserToken = localStorage.read(LocalStorage.authUserID);

    if (localAuthUserToken != null && localAuthUserToken.toString().isNotEmpty) {
      return int.tryParse(localAuthUserToken.toString()) ?? 0;
    }
    return 0;
  }


  //Refresh Customer data
  Future<void> refreshCustomer() async {
    try {
      isLoading(true);
      customer(CustomerModel.empty());
      await fetchCustomerData();
    } catch (error) {
      // TLoaders.warningSnackBar(title: 'Error', message: error.toString());
    } finally {
      isLoading(false);
    }
  }

  /// save user record form ay Registration provider
  Future<void> saveUserRecord(UserCredential? userCredentials) async {
    try {
      //First update Rx user and then check if user data is already stored. if not store new data.
      await fetchCustomerData();

      if(customer.value.id != null) {
        if (userCredentials != null) {
          // Map data
          final newUser = UserModel(
            userId: userCredentials.user!.uid,
            email: userCredentials.user!.email ?? '',
            phone: userCredentials.user!.phoneNumber ?? '',
            avatarUrl: userCredentials.user!.photoURL ?? '',
          );

          //Save user data
          await userRepository.saveUserRecord(newUser);
        }
      }
    } catch (error) {
      AppMassages.warningSnackBar(
        title: 'Data not saved',
        message: error.toString(),
      );
    }
  }

  // delete user account
  void deleteUserAccount() async {
    try{
      TFullScreenLoader.openLoadingDialog('Processing', Images.docerAnimation);

      ///First re-auth user
      final auth = AuthenticationRepository.instance;
      final provider = auth.authUser!.providerData.map((e) => e.providerId).first;
      if(provider.isNotEmpty){
        //re verify auth email
        if(provider == "google.com"){
          await auth.signInWithGoogle();
          await auth.deleteAccount();
          TFullScreenLoader.stopLoading();
          Get.offAll(() => const EmailLoginScreen());
        } else if (provider == 'password'){
          TFullScreenLoader.stopLoading();
          Get.to(() => const ReAuthLoginForm());
        }
      }
    }catch (e) {
      TFullScreenLoader.stopLoading();
      AppMassages.warningSnackBar(title: 'Error', message: e.toString());
    }
  }

  // Re-Authenticate before deleting
  Future<void> reAuthenticateEmailAndPasswordUser() async {
    try {
      //Start Loading
      TFullScreenLoader.openLoadingDialog('Processing', Images.docerAnimation);
      //check internet connectivity
      final isConnected = await NetworkManager.instance.isConnected();
      if (!isConnected) {TFullScreenLoader.stopLoading(); return;}
      // Form Validation
      if (!reAuthFormKey.currentState!.validate()) {TFullScreenLoader.stopLoading(); return;}

      await AuthenticationRepository.instance.reAuthenticateWithEmailAndPassword(verifyEmail.text.trim(), verifyPassword.text.trim());
      await AuthenticationRepository.instance.deleteAccount();
      FBAnalytics.logLogin('re_auth_user_login');
      AppMassages.successSnackBar(title: 'Congratulation', message: 'Your Account Deleted successfully!');
      TFullScreenLoader.stopLoading();
      Get.off(() => const EmailLoginScreen());
    } catch (error) {
      //remove Loader
      TFullScreenLoader.stopLoading();
      //show some Generic error to the user
      AppMassages.warningSnackBar(title: 'Error - Re-Auth', message: error.toString());
    }
  }

  // Re-Authenticate before deleting
  Future<void> wooDeleteAccount() async {
    try {
      //Start Loading
      TFullScreenLoader.openLoadingDialog('Processing', Images.docerAnimation);
      //check internet connectivity
      final isConnected = await NetworkManager.instance.isConnected();
      if (!isConnected) {TFullScreenLoader.stopLoading(); return;}

      await wooCustomersRepository.deleteCustomerById(customer.value.id.toString());

      authenticationRepository.logout();
      //save to local storage
      localStorage.remove(LocalStorage.rememberMeEmail);
      localStorage.remove(LocalStorage.rememberMePassword);

      AppMassages.showToastMessage(message: 'Your Account Deleted successfully!');
      TFullScreenLoader.stopLoading();
      NavigationHelper.navigateToLoginScreen(); //navigate to other screen
    } catch (error) {
      TFullScreenLoader.stopLoading();
      AppMassages.warningSnackBar(title: 'Error', message: error.toString());
    }
  }

  //upload profile picture
  uploadProfilePicture(BuildContext context) async {
    try{
      final permissionStatus = await RequestPermissions.checkPermission(Permission.mediaLibrary);
      if (permissionStatus) {
        final image = await ImagePicker().pickImage(source: ImageSource.gallery, imageQuality: 70, maxHeight: 512, maxWidth: 512);
        if(image != null) {
          imageUploading.value = true;
          //upload Image
          final imageUrl = await userRepository.uploadImage(
              StoragePath.userAvtar, image);
          //Update user image record
          Map<String, dynamic> json = {UserFieldName.avatarUrl: imageUrl};
          await userRepository.updateSingleField(json);

          customer.value.avatarUrl = imageUrl;
          customer.refresh();

          AppMassages.successSnackBar(title: 'Congratulation',
              message: 'Your profile image has been updated.');
        }
      } else {
          RequestPermissions.showPermissionDialog(context);
      }
    } catch (e) {
      AppMassages.errorSnackBar(title: 'Error - Upload Pic', message: 'Something went wrong: $e');
    } finally {
      imageUploading.value = false;
    }
  }
}