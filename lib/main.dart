import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:reparin_mobile/app/modules/profile/controllers/profile_controller.dart';
import 'package:reparin_mobile/app/modules/bookingsuccess/controllers/booksuccess_controller.dart';
import 'package:reparin_mobile/app/modules/settings/controllers/settings_controller.dart';
import 'package:reparin_mobile/app/modules/home/controllers/home_controller.dart';
import 'package:reparin_mobile/app/modules/login/controllers/login_controller.dart';
import 'package:reparin_mobile/firebase_options.dart';
import 'app/data/services/authentication/controllers/authentication_controller.dart';
import 'app/modules/navbar/controllers/navbar_controller.dart';
import 'app/routes/app_pages.dart';
import 'app/data/services/notification_handler.dart';
import 'package:reparin_mobile/dependency_injection.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await Get.putAsync(() async => await SharedPreferences.getInstance());
  await FirebaseMessagingHandler().initPushNotification();
  await FirebaseMessagingHandler().initLocalNotification();
  final AuthenticationController _authenticationController =
  Get.put(AuthenticationController());
  Get.put(BooksuccessController());
  Get.put(SettingsController());
  Get.put(HomeController(), permanent: true);
  Get.put(LoginController(), permanent: true);
  Get.put(AuthenticationController(), permanent: true);
  Get.put(NavbarController(), permanent: true);
  Get.put(ProfileController(), permanent: true);
  runApp(
    GetMaterialApp(
      title: "Reparin-Mobile",
      initialRoute:
          _authenticationController.isLoggedIn.value ? '/home' : '/login',
      getPages: AppPages.routes,
      theme: ThemeData(
        primaryColor: const Color(0xFF0093B7),
        colorScheme: ColorScheme.fromSwatch().copyWith(
          secondary: const Color(0xFF0093B7),
          surface: Colors.white,
        ),
        scaffoldBackgroundColor: Colors.white,
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFF0093B7),
          iconTheme: IconThemeData(color: Colors.white),
          titleTextStyle: TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        buttonTheme: const ButtonThemeData(
          buttonColor: Color(0xFF0093B7),
          textTheme: ButtonTextTheme.primary,
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            foregroundColor: Colors.white,
            backgroundColor: const Color(0xFF0093B7),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
        ),
        textButtonTheme: TextButtonThemeData(
          style: TextButton.styleFrom(
            foregroundColor: const Color(0xFF0093B7),
            textStyle: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        tabBarTheme: const TabBarTheme(
          labelColor: Colors.white,
          unselectedLabelColor: Colors.white70,
          indicator: UnderlineTabIndicator(
            borderSide: BorderSide(color: Colors.white, width: 2),
          ),
        ),
      ),
    ),
  );
  DependencyInjection.init();
}
