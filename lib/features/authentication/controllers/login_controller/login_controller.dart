import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import '../../../../common/dialog_box_massages/massages.dart';
import '../../../../common/widgets/network_manager/network_manager.dart';
import '../../../../data/repositories/authentication/authentication_repository.dart';
import '../../../../data/repositories/woocommerce_repositories/authentication/woo_authentication.dart';
import '../../../../data/repositories/woocommerce_repositories/customers/woo_customer_repository.dart';
import '../../../../utils/constants/image_strings.dart';
import '../../../../utils/constants/local_storage_constants.dart';
import '../../../../utils/helpers/navigation_helper.dart';
import '../../../../common/dialog_box_massages/full_screen_loader.dart';
import '../../../personalization/models/user_model.dart';

class LoginController extends GetxController {
  static LoginController get instance => Get.find();

  //variables
  final localStorage = GetStorage();
  final hidePassword = true.obs; //Observable for hiding/showing password
  final rememberMe = true.obs; //Observable for Remember me checked or not
  final email     = TextEditingController();
  final password  = TextEditingController();
  GlobalKey<FormState> loginFormKey = GlobalKey<FormState>();

  final wooCustomersRepository = Get.put(WooCustomersRepository());
  final wooAuthenticationRepository = Get.put(WooAuthenticationRepository());
  final authenticationRepository = Get.put(AuthenticationRepository());

  //Init method fetch user's saved password and email from local storage
  @override
  void onInit() {
    // Read email from local storage
    String? rememberedEmail = localStorage.read(LocalStorage.rememberMeEmail);
    if (rememberedEmail != null) {
      email.text = rememberedEmail;
    }
    // Read password from local storage
    String? rememberedPassword = localStorage.read(LocalStorage.rememberMePassword);
    if (rememberedPassword != null) {
      password.text = rememberedPassword;
    }
    super.onInit();
  }

  //Login with email and password form woocommerce
  Future<void> wooLoginWithEmailAndPassword() async {
    try {
      //Start Loading
      TFullScreenLoader.openLoadingDialog('We are processing your information..', Images.docerAnimation);
      //check internet connectivity
      final isConnected = await Get.put(NetworkManager()).isConnected();
      if (!isConnected) {
        //remove Loader
        TFullScreenLoader.stopLoading();
        return;
      }
      // Form Validation
      if (!loginFormKey.currentState!.validate()) {
        //remove Loader
        TFullScreenLoader.stopLoading();
        return;
      }

      String userId = await wooAuthenticationRepository.loginWithEmailAndPass(email.text.trim(), password.text);
      final CustomerModel customer = await wooCustomersRepository.fetchCustomerById(userId);

      //save to local storage
      if (rememberMe.value) {
        localStorage.write(LocalStorage.rememberMeEmail, email.text.trim());
        localStorage.write(LocalStorage.rememberMePassword, password.text);
      }
      //remove Loader
      TFullScreenLoader.stopLoading();
      authenticationRepository.login(customer: customer, loginMethod: 'Email');
    } catch (error) {
      //remove Loader
      TFullScreenLoader.stopLoading();
      AppMassages.errorSnackBar(title: 'Error', message: error.toString());
    }
  }

  //Email and Password signIn
  Future<void> loginWithEmailAndPassword() async {
    try {
      //Start Loading
      TFullScreenLoader.openLoadingDialog('We are processing your information..', Images.docerAnimation);

      //check internet connectivity
      final isConnected = await NetworkManager.instance.isConnected();
      if (!isConnected) {
        //remove Loader
        TFullScreenLoader.stopLoading();
        return;
      }

      // Form Validation
      if(!loginFormKey.currentState!.validate()) {
        //remove Loader
        TFullScreenLoader.stopLoading();
        return;
      }
      // Register user in the Firebase Authentication & save user data in the Firebase
      final userCredential = await AuthenticationRepository.instance.loginWithEmailAndPassword(email.text.trim(), password.text.trim());

      //privacy policy check
      if(rememberMe.value) {
        localStorage.write(LocalStorage.rememberMeEmail, email.text.trim());
        localStorage.write(LocalStorage.rememberMePassword, password.text.trim());
      }

      //remove Loader
      TFullScreenLoader.stopLoading();
      // UserController.instance.fetchUserRecord();
      AppMassages.showToastMessage(message: 'Login successfully!');

      // redirect
      // AuthenticationRepository.instance.screenRedirect();
      // move to next screen
      NavigationHelper.navigateToBottomNavigation();

    } catch (error) {
      //remove Loader
      TFullScreenLoader.stopLoading();
      //show some Generic error to the user
      AppMassages.errorSnackBar(title: 'Oh Snap!', message: error.toString());
    }
  }
}




