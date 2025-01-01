import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';

import '../../routes/deeplink_get_router.dart';
import '../../routes/internal_routes.dart';
import 'local_notification.dart';

// Doc - https://firebase.google.com/docs/cloud-messaging/flutter/first-message?hl=en&authuser=0
class FirebaseNotification {
  //create a instance of firebase Messaging
  static final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;

  // Static variable to hold the FCM token
  static String? fCMToken;

  //function to initialize notification
  static Future<void> initNotification() async {
    //Request permission form user
    await _firebaseMessaging.requestPermission();

    //Fetch the FCM token for this device
    fCMToken = await _firebaseMessaging.getToken();

    //Print Token
    if (kDebugMode) {
      print('Token ======= "$fCMToken"');
    }

    //initPushNotification
    initPushNotification();
  }

  //Handel Msg
  static void handleMassage(RemoteMessage? message){
    if(message == null) return;
    // print('Initial message received: ${message.notification?.title}');
    // print('Initial message received: ${message.notification}');
    // print('Initial message received: ${message.notification?.body}');
    // print('Initial message received: ${message.data['product']}');
    if(message.data['url'] != null) {
      handelNotificationRoute(url: message.data['url']);
    }
  }

  static void handelNotificationRoute({required String url}) {
    InternalAppRoutes.internalRouteHandle(url: url);
  }

  static void showNotification(RemoteMessage? message){
    LocalNotificationServices.localNotificationsPlugin.
    show(
        0, //notification id it may anything
        message?.notification?.title,
        message?.notification?.body,
        LocalNotificationServices.getPlatformChannelSpecifics(),
        payload: message?.data['url']
    );
  }
  //function initiate background massage
  static Future initPushNotification() async {

    // Used to handle the initial message payload when the app is opened from a terminated state due to a notification click.
    _firebaseMessaging.getInitialMessage().then(handleMassage);

    // To handle messages while your application is in the foreground, listen to the onMessage stream.
    FirebaseMessaging.onMessage.listen(showNotification);

    // To handle messages while your application is running in the background, listen to the onMessageOpenedApp stream.
    FirebaseMessaging.onMessageOpenedApp.listen(handleMassage);
  }

}