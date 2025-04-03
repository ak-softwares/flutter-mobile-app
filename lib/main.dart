import 'package:aramarket/utils/helpers/navigation_helper.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'bindings/general_bindings.dart';
import 'data/repositories/authentication/authentication_repository.dart';
import 'features/settings/app_settings.dart';

import 'features/shop/screens/products/product_detail.dart';
import 'firebase_options.dart';
import 'routes/external_routes.dart';
import 'routes/internal_routes.dart';
import 'routes/routes.dart';
import 'services/firebase_analytics/firebase_analytics.dart';
import 'services/notification/firebase_notification.dart';
import 'services/notification/local_notification.dart';
import 'utils/cache/cache.dart';
import 'utils/theme/theme.dart';
import 'utils/theme/theme_controller.dart';

@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {

  // If you're going to use other Firebase services in the background, such as Firestore,
  // make sure you call `initializeApp` before using other Firebase services.
  // await Firebase.initializeApp();
  FirebaseNotification.handleMassage(message);
  // FirebaseNotification.showNotification(message);
  // print("Handling a background message: ${message.messageId}");
}

void main() async {

  // Load env variable
  await dotenv.load(fileName: ".env");

  // Add widgets Binding
  final WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();

  // GetX Local Storage
  await GetStorage.init();

  //await splash until other item load
  // FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);

  // Initialize Firebase
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform)
      .then((FirebaseApp value) => Get.put(AuthenticationRepository()));

  // Initialize Firebase Analytics
  await FBAnalytics.setDefaultEventParameters();

  // Initialize Firebase Notifications
  await FirebaseNotification.initNotification();

  await CacheHelper.initializeHive();

  // To handle messages while your application is terminated
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  // Initialize with the settings from NotificationSettings
  LocalNotificationServices.localNotificationsPlugin.initialize(
    LocalNotificationServices.initializationSettings, //this line for init local notification setting
    onDidReceiveNotificationResponse: (response) {  // line for when user click on notification when app is open
      InternalAppRoutes.handleInternalRoute(url: response.payload.toString());
      // AppRoutes.pageRouteHandle(routeName: response.payload.toString());
    },
    // onDidReceiveBackgroundNotificationResponse: (response) {  // line for when user click on notification when app is close
    //   InternalAppRoutes.internalRouteHandle(url: response.payload.toString());
    //   // AppRoutes.pageRouteHandle(routeName: response.payload.toString());
    // }
  );

  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
    statusBarColor: Colors.transparent,
    statusBarIconBrightness: Brightness.dark,
  ));

  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    // FBAnalytics.logPageView('main_function_screen');
    final themeController = Get.put(ThemeController());
    return Obx(() => GetMaterialApp(  //add .router when use go_router
      debugShowCheckedModeBanner: false,
      navigatorObservers: [FBAnalytics.observer],
      title: AppSettings.appName,
      themeMode: themeController.themeMode.value, // GetX-controlled theme
      theme: TAppTheme.lightTheme,
      darkTheme: TAppTheme.darkTheme,
      initialBinding: GeneralBindings(),
      home: NavigationHelper.navigateToBottomNavigationWidget(),

      onGenerateRoute: (settings) {
        return ExternalAppRoutes.handleDeepLink(settings: settings);
      },

    ));
  }
}

