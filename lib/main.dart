import 'package:diagnostics_patient/config/app_config.dart';
import 'dart:io';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:diagnostics_patient/Models/user_details_class.dart';
import 'package:diagnostics_patient/Screens/View/SplashScreen/SplashScreen.dart';
import 'package:diagnostics_patient/config/app_binding.dart';
import 'package:diagnostics_patient/config/api_config.dart';
import 'package:diagnostics_patient/routes/app_routes.dart';
import 'package:diagnostics_patient/themes/app_theme.dart';
import 'package:diagnostics_patient/utils/api.dart';
import 'package:diagnostics_patient/utils/colors.dart';
import 'package:diagnostics_patient/utils/mediaRequestHelper.dart';
import 'package:diagnostics_patient/utils/strings.dart';
// import 'package:onesignal_flutter/onesignal_flutter.dart'; // OneSignal disabled for now
import 'package:shared_preferences/shared_preferences.dart';
import 'package:upgrader/upgrader.dart';

UserDetailsClass userDetailsClass = UserDetailsClass();
final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp();
  await Hive.initFlutter();

  HttpOverrides.global = MyHttpOverrides();

  // ----- OneSignal disabled for now (OneSignal.initialize() not configured) -----
  // OneSignal.consentRequired(true);
  //  OneSignal.consentGiven(true);

  final  prefs = await SharedPreferences.getInstance();
  await prefs.setBool('isLocationDialogOpen', false);

  // palyer_id = OneSignal.User.pushSubscription.id;

  // _setupOneSignalObservers();

  runApp(const MyApp());
}

// ----- OneSignal disabled for now -----
// void _setupOneSignalObservers() {
//   OneSignal.Notifications.addPermissionObserver((permission) {
//     if (permission == false)  {
//       OneSignal.Notifications.canRequest();
//     }
//   });
//
//   OneSignal.User.pushSubscription.addObserver((subscription) async {
//     if (subscription.current.optedIn == true) {
//       palyer_id = OneSignal.User.pushSubscription.id;
//       print('OneSignal ID: $palyer_id');
//     }
//   });
//
//   OneSignal.Notifications.addClickListener(
//         (OSNotificationClickEvent result) async {
//       result.preventDefault();
//       result.notification.display();
//     },
//   );
// }

Future<void> notificationOpener(result, {String? id}) async {
  // Handle notification opening
}

// ✅ Sirf ek MyApp — StatefulWidget rakha (zyada control milta hai)
class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
    // ----- OneSignal disabled for now -----
    // palyer_id = OneSignal.User.pushSubscription.id;
    // print('OneSignal ID: $palyer_id');
    //
    // OneSignal.User.getOnesignalId();
    //
    // OneSignal.Notifications.addPermissionObserver((permission) {
    //   if (permission == false) {
    //     OneSignal.Notifications.canRequest();
    //   }
    // });
    //
    // OneSignal.Notifications.addClickListener(
    //       (OSNotificationClickEvent result) async {
    //     print('Notification clicked: $result');
    //     result.preventDefault();
    //     result.notification.display();
    //     await notificationOpener(result);
    //   },
    // );
  }

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      navigatorKey: navigatorKey,
      initialBinding: AppBinding(),
      theme: AppTheme.lightTheme(),
      locale: lan ? const Locale('en', 'US') : const Locale('ar', 'SA'),
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      title: AppConfig.appName,
      builder: (context, child) {
        final mediaQuery = MediaQuery.of(context);
        final isGestureMode = mediaQuery.viewPadding.bottom == 0;
        final isKeyboardOpen = mediaQuery.viewInsets.bottom > 0;
        final bottomPadding = (isGestureMode && !isKeyboardOpen)
            ? 10.0
            : mediaQuery.viewPadding.bottom;
        return Padding(
          padding: EdgeInsets.only(bottom: bottomPadding),
          child: child ?? const SizedBox(),
        );
      },
      home: UpgradeAlert(
        upgrader: Upgrader(
          debugLogging: false,
          durationUntilAlertAgain: const Duration(milliseconds: 300),
        ),
        showIgnore: false,
        barrierDismissible: false,
        shouldPopScope: () => false,
        onUpdate: () {
          print('Click update');
          return true;
        },
        child: SplashScreen(),
      ),
    );
  }
}

class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
  }
}