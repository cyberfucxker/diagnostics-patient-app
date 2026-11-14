import 'package:diagnostics_patient/config/app_config.dart';
import 'dart:async';
import 'dart:convert';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart';
import 'package:diagnostics_patient/Screens/Custome_Widgets/page_widget.dart';
import 'package:diagnostics_patient/Screens/View/onBordingScreen.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../utils/api.dart';
import '../../../utils/strings.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {

  @override
  void initState() {
    super.initState();
    _initFirebaseAndProceed();
  }

  Future<void> _initFirebaseAndProceed() async {
    try {
      await Firebase.initializeApp();
    } catch (e) {
      print("Firebase init error: $e");
    }
    await Future.delayed(const Duration(seconds: 2));
    await getAndStoreToken();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                'assets/app_logo_wordmark.png',
                width: 150,
              ),
              const SizedBox(height: 7),
              Text(
                AppConfig.tagline,
                style: TextStyle(
                  color: Color(0xffe45c6d),
                  fontFamily: "Montserrat",
                  fontSize: 11,
                  fontWeight: FontWeight.bold,
                  fontStyle: FontStyle.italic,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> getAndStoreToken() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final isTokenStored = prefs.getBool("isTokenStored") ?? false;

      String? fcmToken;
      try {
        fcmToken = await FirebaseMessaging.instance.getToken();
        print("FCM Token: $fcmToken");
      } catch (e) {
        print("Token fetch error: $e");
      }

      if (fcmToken != null && !isTokenStored) {
        await storeToken(fcmToken);
      } else {
        goToChooseStoreCategory();
      }
    } catch (e) {
      print("getAndStoreToken error: $e");
      goToChooseStoreCategory();
    }
  }

  Future<void> storeToken(String token) async {
    try {
      final response = await get(
        Uri.parse("$SERVER_ADDRESS/savetoken?token=${token}&type=1"),
      );

      print("storeToken response: ${response.body}");

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data['status'] == 1) {
          final prefs = await SharedPreferences.getInstance();
          await prefs.setBool("isTokenStored", true);
        }
      }
    } catch (e) {
      print("storeToken error: $e");
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool("isTokenStored", false);
    } finally {
      goToChooseStoreCategory();
    }
  }

  void goToChooseStoreCategory() {
    if (!mounted) return;

    if (kISSTOREAPK) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => PagesWidget()),
      );
    } else {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => OnBoardingScreens()),
      );
    }
  }
}











// import 'dart:async';
// import 'dart:convert';
// import 'package:firebase_core/firebase_core.dart';
// import 'package:firebase_messaging/firebase_messaging.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:google_maps_flutter/google_maps_flutter.dart';
// import 'package:http/http.dart';
// import 'package:diagnostics_patient/Screens/Custome_Widgets/page_widget.dart';
// import 'package:diagnostics_patient/Screens/View/onBordingScreen.dart';
// import 'package:diagnostics_patient/controller/add_address_controller.dart';
// import 'package:shared_preferences/shared_preferences.dart';
//
// import '../../../utils/api.dart';
// import '../../../utils/notificationHelper.dart';
// import '../../../utils/strings.dart';
//
// class SplashScreen extends StatefulWidget {
//   @override
//   _SplashScreenState createState() => _SplashScreenState();
// }
//
// class _SplashScreenState extends State<SplashScreen> {
//   NotificationHelper notificationHelper = NotificationHelper();
//   FirebaseMessaging firebaseMessaging = FirebaseMessaging.instance;
//
//   @override
//   void initState() {
//     Firebase.initializeApp();
//
//     super.initState();
//     print('width====================================>${Get.width}');
//     getAndStoreToken();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return SafeArea(
//       child: Scaffold(
//         // backgroundColor: blackColor,
//         body: Center(
//           child: Column(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: [
//               Get.put(AddAddressController()).isGoogleMapLoading
//                   ? const SizedBox()
//                   : GoogleMap(
//                       onMapCreated:
//                           Get.put(AddAddressController()).onMapCreated,
//                       scrollGesturesEnabled: true,
//                       initialCameraPosition: CameraPosition(
//                         target: Get.put(AddAddressController()).center!,
//                         zoom: 15.0,
//                       ),
//                       onTap: (latLang) {
//                         Get.put(AddAddressController()).onMapTap(latLang);
//                         //Toast.show(latLang.toString(), context,duration: 2);
//                       },
//                       buildingsEnabled: true,
//                       compassEnabled: true,
//                       markers: Get.put(AddAddressController())
//                           .markers
//                           .values
//                           .toSet(),
//                     ),
//               Padding(
//                 padding: const EdgeInsets.fromLTRB(70, 0, 70, 0),
//                 child: Image.asset(
//                   'assets/labLogo1.jpg',
//                   // AppImages.newAppLogo,
//                   width: 150,
//                   // color: Colors.white,
//                   // height: 400,
//                 ),
//               ),
//               const SizedBox(height: 7),
//               Text(
//                 style: const TextStyle(
//                   // color: Colors.black,
//                   color: Color(0xffe45c6d),
//                   fontFamily: "Montserrat",
//                   fontSize: 11,
//                   fontWeight: FontWeight.bold,
//                   fontStyle: FontStyle.italic,
//                 ),
//               )
//               // ct.semiboldText(
//               //   text: ONLINE_DUKAAN,
//               //   color: kWHITE,
//               //   size: 35,
//               // ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
//
//   getAndStoreToken() async {
//     await Future.delayed(Duration(seconds: 2));
//     SharedPreferences.getInstance().then((value) {
//       //first time
//       if (value.getBool("isTokenStored") ?? false) {
//         FirebaseMessaging.instance.getToken().then((value) {
//           print("value $value");
//           storeToken(value);
//         }).catchError((e) {
//           print("SplashScreen/Token Retrieving Error :" + e.toString());
//           value.setBool("isTokenStored", false);
//           print("one3");
//         });
//         print("one4");
//
//         goToChooseStoreCategory();
//       } else if (value.getBool("isTokenStored") == null) {
//         FirebaseMessaging.instance.getToken().then((value) {
//           print("value $value");
//           storeToken(value);
//         }).catchError((e) {
//           print("SplashScreen/Token Retrieving Error :" + e.toString());
//           value.setBool("isTokenStored", false);
//           print("one3");
//
//           goToChooseStoreCategory();
//           //
//         });
//       } else if (value.getBool("isTokenStored") == false) {
//         FirebaseMessaging.instance.getToken().then((value) {
//           print("value $value");
//
//           storeToken(value);
//         }).catchError((e) {
//           print("SplashScreen/Token Retrieving Error :" + e.toString());
//           value.setBool("isTokenStored", false);
//           print("one2");
//
//           goToChooseStoreCategory();
//         });
//       }
//     });
//   }
//
//   storeToken(token) async {
//     await get(Uri.parse(
//             "$SERVER_ADDRESS/savetoken?token=${palyer_id ?? "abc"}&type=1"))
//         .then((value) {
//       print(
//           "SplashScreen--------------------$SERVER_ADDRESS/savetoken?token=${palyer_id ?? "abc"}&type=1");
//       print("SplashScreen/===============${value.body}");
//       if (value.statusCode == 200) {
//         print("SplashScreen/===============$value");
//         print("SplashScreen/===============${value.body}");
//         var data = jsonDecode(value.body);
//         if (data['status'] == 1) {
//           print(data['msg']);
//           SharedPreferences.getInstance().then((value) {
//             value.setBool("isTokenStored", true);
//             print("one");
//             goToChooseStoreCategory();
//           });
//         } else {
//           goToChooseStoreCategory();
//         }
//       }
//     }).catchError((e) {
//       print("SplashScreenError/=================" + e.toString());
//       SharedPreferences.getInstance().then((value) {
//         value.setBool("isTokenStored", false);
//         goToChooseStoreCategory();
//
//         print("stored");
//       });
//     });
//
//     // await get(Uri.parse("$SERVER_ADDRESS/savetoken?token=${token ?? "abc"}&type=1"))
//     //
//     //     .then((value){
//     //   print("SplashScreen--------------------$SERVER_ADDRESS/savetoken?token=${token ?? "abc"}&type=1");
//     //   final jsonResponse = jsonDecode(value.body);
//     //   print("SplashScreen/===============${jsonResponse}");
//     //   if(jsonResponse.statusCode == 200 && jsonResponse['data']['status'] == 1){
//     //     SharedPreferences.getInstance().then((value){
//     //       value.setBool("isTokenStored", true);
//     //       print("one");
//     //       goToChooseStoreCategory();
//     //     });
//     //   }
//     //   else{
//     //     goToChooseStoreCategory();
//     //   }
//     // }).catchError((e){
//     //   print("SplashScreenError/================="+ e.toString());
//     //   SharedPreferences.getInstance().then((value){
//     //     value.setBool("isTokenStored", false);
//     //     goToChooseStoreCategory();
//     //
//     //     print("stored");
//     //   });
//     // });
//   }
//
//   // goToLogin(){
//   //   Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=> SellerLoginScreen()));
//   // }
//   //
//   // goToHome(){
//   //   Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=> SellerTabScreen()));
//   // }
//   goToChooseStoreCategory() async {
//     if (kISSTOREAPK) {
//       final prefs = await SharedPreferences.getInstance();
//       if (!mounted) return;
//
//       final isLoggedIn = prefs.getBool('isLoggedIn') ?? false;
//
//       if (isLoggedIn) {
//         Navigator.pushReplacement(
//           context,
//           MaterialPageRoute(builder: (context) => PagesWidget()),
//         );
//       } else {
//         Navigator.pushReplacement(
//           context,
//           MaterialPageRoute(builder: (context) => PagesWidget()),
//         );
//       }
//     } else {
//       if (!mounted) return;
//       Navigator.pushReplacement(
//         context,
//         MaterialPageRoute(builder: (context) => OnBoardingScreens()),
//       );
//     }
//   }
//
// /*   goToChooseStoreCategory() async {
//     if (kISSTOREAPK) {
//       await SharedPreferences.getInstance().then((value) async {
//         print("value.getBool('isLoggedIn') ${value.getBool('isLoggedIn')}");
//         // if(value.getBool('isRtlView') ?? false  ){
//         if (value.getBool('isLoggedIn') ?? false) {
//           //
//           //     // print('isrtlview=====>${value.getBool('isRtlView')}');
//           // await Get.put(NearByLabController()).getLabList();
//           Navigator.pushReplacement(
//               context, MaterialPageRoute(builder: (context) => PagesWidget()));
//         } else {
//           // Navigator.pushReplacement(
//           //     context, MaterialPageRoute(builder: (context) => LoginScreen()));
//           // await Get.put(NearByLabController()).getLabList();
//           Navigator.pushReplacement(
//               context, MaterialPageRoute(builder: (context) => PagesWidget()));
//         }
//
//         // }else{
//         //   // Navigator.pushReplacement(context,
//         //   //     MaterialPageRoute(builder: (context) => SellerLoginScreen()));
//         //   Navigator.pushReplacement(context,
//         //       MaterialPageRoute(builder: (context) => ChangeLanguageFirstScreen()));
//         // }
//       });
//     } else {
//       Navigator.of(context).pushReplacement(
//           MaterialPageRoute(builder: (context) => OnBoardingScreens()));
//     }
//   } */
// }
