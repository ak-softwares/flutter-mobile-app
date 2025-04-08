import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:package_info_plus/package_info_plus.dart';

import '../../../common/dialog_box_massages/snack_bar_massages.dart';
import '../../../features/onboarding/controllers/is_first_run/is_first_run.dart';
import '../../../features/personalization/controllers/change_profile_controller.dart';
import '../../../features/personalization/controllers/user_controller.dart';
import '../../../features/personalization/models/user_model.dart';
import '../../../services/firebase_analytics/firebase_analytics.dart';
import '../../../services/notification/firebase_notification.dart';
import '../../../utils/constants/db_constants.dart';
import '../../../utils/constants/local_storage_constants.dart';
import '../../../utils/exceptions/firebase_auth_exceptions.dart';
import '../../../utils/exceptions/format_exceptions.dart';
import '../../../utils/helpers/navigation_helper.dart';
import '../user/user_repository.dart';

class AuthenticationRepository extends GetxController {
  static AuthenticationRepository get instance => Get.find();

  //variable
  final localStorage = GetStorage();
  final _auth = FirebaseAuth.instance;



/* ----------------Email & Password Sign in ------------------*/

  /// [EmailAuthentication] - Login
  Future<UserCredential> loginWithEmailAndPassword(String email, String password) async {
    try {
      // isUserLogin.value = true;
      var userCredential = await _auth.signInWithEmailAndPassword(email: email, password: password);
      return userCredential;
    }
    on FirebaseAuthException catch (error) {
      throw TFirebaseAuthException(error.code).message;
    } on FirebaseException catch (error) {
      throw TFirebaseAuthException(error.code).message;
    } on FormatException catch (_) {
      throw const TFormatException();
    } on PlatformException catch (error) {
      throw TFirebaseAuthException(error.code).message;
    }
    catch (error) {
      throw 'Something went wrong. Please try again';
    }
  }

  /// [EmailAuthentication] - REGISTER
  Future<UserCredential> registerWithEmailAndPassword(String email, String password) async {
    try {
      // isUserLogin.value = true;
      return await _auth.createUserWithEmailAndPassword(
          email: email, password: password);
    }
    on FirebaseAuthException catch (error) {
      throw TFirebaseAuthException(error.code).message;
    } on FirebaseException catch (error) {
      throw TFirebaseAuthException(error.code).message;
    } on FormatException catch (_) {
      throw const TFormatException();
    } on PlatformException catch (error) {
      throw TFirebaseAuthException(error.code).message;
    }
    catch (error) {
      throw 'Something went wrong. Please try again';
    }
  }

  /// [ReAuthenticate] - ReAuthenticate user
  Future<void> reAuthenticateWithEmailAndPassword(String email, String password) async {
    try {
      //Create a credential
      AuthCredential credential = EmailAuthProvider.credential(
          email: email, password: password);
      //ReAuthenticate
      await _auth.currentUser!.reauthenticateWithCredential(credential);
    }
    on FirebaseAuthException catch (error) {
      throw TFirebaseAuthException(error.code).message;
    } on FirebaseException catch (error) {
      throw TFirebaseAuthException(error.code).message;
    } on FormatException catch (_) {
      throw const TFormatException();
    } on PlatformException catch (error) {
      throw TFirebaseAuthException(error.code).message;
    }
    catch (error) {
      throw 'Something went wrong. Please try again';
    }
  }

  /// [Email Authentication] - Forget password
  Future<void> sendPasswordResetEMail(String email) async {
    try {
      await _auth.sendPasswordResetEmail(email: email);
    }
    on FirebaseAuthException catch (error) {
      throw TFirebaseAuthException(error.code).message;
    } on FirebaseException catch (error) {
      throw TFirebaseAuthException(error.code).message;
    } on FormatException catch (_) {
      throw const TFormatException();
    } on PlatformException catch (error) {
      throw TFirebaseAuthException(error.code).message;
    }
    catch (error) {
      throw 'Something went wrong. Please try again';
    }
  }

  /*---------------------- social login_controller ------------------------*/

  /// [Google Authentication] - Google

  Future<UserCredential> signInWithGoogle() async {
    try {
      // Trigger the authentication flow
      final GoogleSignInAccount? userAccount = await GoogleSignIn().signIn();

      //Obtain the auth details form the request
      final GoogleSignInAuthentication? googleAuth = await userAccount
          ?.authentication;

      //Create a new credential
      final credentials = GoogleAuthProvider.credential(
          accessToken: googleAuth?.accessToken, idToken: googleAuth?.idToken);

      //Once signed in, return the User Credential
      return await _auth.signInWithCredential(credentials);
    }
    on FirebaseAuthException catch (error) {
      throw TFirebaseAuthException(error.code).message;
    } on FirebaseException catch (error) {
      throw TFirebaseAuthException(error.code).message;
    } on FormatException catch (_) {
      throw const TFormatException();
    } on PlatformException catch (error) {
      throw TFirebaseAuthException(error.code).message;
    }
    catch (error) {
      // rethrow;
      throw 'Something went wrong. Please try again';
    }
  }

  /// [Facebook Authentication] - Facebook

  /*-------------------------- logout user / delete user -------------*/

  /// [Logout user] - valid for any authentication


  /// [Delete user] - Remove user auth and firebase account
  Future<void> deleteAccount() async {
    try {
      await UserRepository.instance.removeUserRecord(_auth.currentUser!.uid);
      await _auth.currentUser!.delete();
    }
    on FirebaseAuthException catch (error) {
      throw TFirebaseAuthException(error.code).message;
    } on FirebaseException catch (error) {
      throw TFirebaseAuthException(error.code).message;
    } on FormatException catch (_) {
      throw const TFormatException();
    } on PlatformException catch (error) {
      throw TFirebaseAuthException(error.code).message;
    }
    catch (error) {
      throw 'Something went wrong. Please try again';
    }
  }

}

