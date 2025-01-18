import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'bindings/general_bindings.dart';
import 'common/navigation_bar/bottom_navigation_bar2.dart';
import 'data/repositories/authentication/authentication_repository.dart';
import 'firebase_options.dart';
import 'routes/internal_routes.dart';
import 'services/notification/firebase_notification.dart';
import 'services/notification/local_notification.dart';
import 'utils/constants/text_strings.dart';
import 'utils/theme/theme.dart';

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

  // load env variable
  await dotenv.load(
    fileName: ".env"
  );

  //Add widgets Binding
  final WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();

  //GetX Local Storage
  await GetStorage.init();

  //await splash until other item load
  // FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);

  //Initialize Firebase
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform)
      .then((FirebaseApp value) => Get.put(AuthenticationRepository()));

  //Initialize Firebase Notifications
  await FirebaseNotification.initNotification();

  // To handle messages while your application is terminated
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  // Initialize with the settings from NotificationSettings
  LocalNotificationServices.localNotificationsPlugin.initialize(
    LocalNotificationServices.initializationSettings, //this line for init local notification setting
    onDidReceiveNotificationResponse: (response) {  // line for when user click on notification when app is open
      InternalAppRoutes.internalRouteHandle(url: response.payload.toString());
      // AppRoutes.pageRouteHandle(routeName: response.payload.toString());
    },
    // onDidReceiveBackgroundNotificationResponse: (response) {  // line for when user click on notification when app is close
    //   InternalAppRoutes.internalRouteHandle(url: response.payload.toString());
    //   // AppRoutes.pageRouteHandle(routeName: response.payload.toString());
    // }
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(  //add .router when use go_router
      debugShowCheckedModeBanner: false,
      title: TTexts.appName,
      theme: TAppTheme.lightTheme,
      initialBinding: GeneralBindings(),

      //these are the method for Get routes
      // initialRoute: CustomRoutes.home,
      // getPages: [
      //   ...AppRoutes.pages, // Include your defined routes
      //   AppRoutes.defaultRoute, // Include the default route
      // ],

      //these are the method for Get routes for another way
      // routes: {
      //   '/': (context)=>BottomNavigation2(),
      //   CustomRoutes.product: (context)=>ProductDetailScreen(slug: Get.parameters['slug']),
      //   'details': (context)=>TOrderScreen(),
      // },

      // these are the method for go_router
      // routerDelegate: DeeplinkGoRouter.router.routerDelegate,
      // backButtonDispatcher: DeeplinkGoRouter.router.backButtonDispatcher,
      // routeInformationParser: DeeplinkGoRouter.router.routeInformationParser,
      // routeInformationProvider: DeeplinkGoRouter.router.routeInformationProvider,

      home: const BottomNavigation2(),
    );
  }
}


// class MyApp extends StatelessWidget {
//   const MyApp({super.key});
//
//   // This widget is the root of your application.
//   @override
//   Widget build(BuildContext context) {
//     // Get.testMode = true;
//     return GetMaterialApp.router(
//       debugShowCheckedModeBanner: false,
//       title: TTexts.appName,
//       // themeMode: ThemeMode.system,
//       theme: TAppTheme.lightTheme,
//       routerConfig: _router,
//       // darkTheme: TAppTheme.darkTheme,
//       initialBinding: GeneralBindings(),
//       // initialRoute: CustomRoutes.home,
//       // getPages: [
//       //   ...AppRoutes.pages, // Include your defined routes
//       //   AppRoutes.defaultRoute, // Include the default route
//       // ],
//       // onGenerateRoute: (RouteSettings settings) {
//       //   onGenerateRoute: (RouteSettings settings) {
//       //     // Define a regular expression pattern to match dynamic product URLs
//       //     final Uri uri = Uri.parse(settings.name);
//       //     final RegExp productRegExp = RegExp(r'^/product/([^/]+)$');
//       //
//       //     // Match the route with the pattern
//       //     if (uri.path == '/') {
//       //       return MaterialPageRoute(builder: (context) => HomePage());
//       //     } else if (productRegExp.hasMatch(uri.path)) {
//       //       // Extract the product ID or slug from the route
//       //       final match = productRegExp.firstMatch(uri.path);
//       //       final productId = match.group(1);
//       //       return MaterialPageRoute(builder: (context) => ProductDetailsPage(productId: productId));
//       //     } else {
//       //       return MaterialPageRoute(builder: (context) => UnknownPage());
//       //     }
//       //   },
//       // },
//       // onGenerateRoute: (settings) {
//       //   print('----------------------1-${settings.name}');
//       //   if (settings.name!.startsWith('/product/')) {
//       //     // Extract the slug from the route
//       //     final String slug = settings.name!.substring('/product/'.length);
//       //     // Navigate to the product detail screen with the parsed slug
//       //     return GetPageRoute(
//       //       page: () => ProductDetailScreen(slug: slug),
//       //     );
//       //   }
//       //   if (settings.name == '/cart') {
//       //     // Parse deep link parameters
//       //     final Uri uri = Uri.parse(settings.name!);
//       //     final String slug = uri.pathSegments.last;
//       //
//       //     // Navigate to the product detail screen with the parsed slug
//       //     return GetPageRoute(
//       //       page: () => const CartScreen(),
//       //     );
//       //   }
//       //
//       //   // If the route is not recognized, try to handle it as a WebView URL
//       //   final Uri uri = Uri.parse(APIConstant.wooBaseUrl + settings.name!);
//       //   print('Navigating to WebView with URL: ${uri.toString()}');
//       //   return null;
//       //   // return GetPageRoute(
//       //   //   page: () => MyWebView(title: '', url: uri.toString()),
//       //   // );
//       //
//       //   // // If none of the conditions match, you can handle it as a fallback
//       //   // print('Route not recognized: ${settings.name}');
//       //   // return GetPageRoute(
//       //   //   page: () => UnknownRouteScreen(), // A screen to handle unknown routes
//       //   // );
//       //   // // Handle other routes or return null if not recognized
//       // },
//       home: const BottomNavigation2(),
//       // home: const FooterNavigation(),
//     );
//   }
// }
