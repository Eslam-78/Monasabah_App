import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:monasbah/SplashRoute.dart';
import 'package:monasbah/core/util/common.dart';
import 'package:monasbah/features/ServiceProviders/home/presentation/pages/ServiceProviderMainHome.dart';
import 'package:flutter/material.dart';
import 'package:monasbah/features/users/data/models/customerModel.dart';
import 'core/others/constants.dart';
import 'features/customers/home/presentation/pages/mainMinuPage.dart';
import 'features/onboarding/routes/OnboardingRoute.dart';
import 'features/users/presentation/pages/singupRoute.dart';
import 'features/users/presentation/pages/LoginRoute.dart';
import 'package:monasbah/injection_container.dart' as dl;
import 'package:firebase_messaging/firebase_messaging.dart';

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();

  void showNotification(RemoteMessage message) {
    const AndroidNotificationDetails androidPlatformChannelSpecifics =
        AndroidNotificationDetails(
            'your_channel_id', 'your_channel_name', 'your_channel_description',
            importance: Importance.max,
            priority: Priority.high,
            showWhen: false);
    const NotificationDetails platformChannelSpecifics =
        NotificationDetails(android: androidPlatformChannelSpecifics);
    flutterLocalNotificationsPlugin.show(0, message.notification?.title,
        message.notification?.body, platformChannelSpecifics,
        payload: message.data['payload']);
  }

  showNotification(message);
}

Future<void> main() async {
  // Force unsound null safety mode
  // ignore: prefer_void_to_null
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  final InitializationSettings initializationSettings = InitializationSettings(
    android: AndroidInitializationSettings('@mipmap/ic_launcher'),
  );

  await flutterLocalNotificationsPlugin.initialize(initializationSettings);
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  await dl.init();

  ///to make all the application portrait
/*  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);*/
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late CustomerModel? customerModel;

  @override
  void initState() {
    // SharedPreferences.setMockInitialValues({'CACHED_USER':null,});
    checkCustomerLoggedIn().fold((l) {
      customerModel = l;
    }, (r) {
      customerModel = null;
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,

      // home: ServiceProviderMainMenuPage(),
      initialRoute: kSplashRoute,
      routes: {
        kSplashRoute: (context) => SplashRoute(),
        kOnboardinghRoute: (context) => OnboardingRoute(),
        kLoginRoute: (context) => LoginPage(userBrand: ''),
        kClintSignupRoute: (context) => SignupPage(userBrand: ''),
        kHomeRoute: (context) => MainMenuPage(),
        // kServiceProviderHome:(context)=>ServiceProviderHome(),
        kServiceProviderMAinHome: (context) =>
            ServiceProviderMainHomeRoute(currentIndex: 1),
      },
    );
  }
}
