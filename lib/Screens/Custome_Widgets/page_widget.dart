import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:diagnostics_patient/Screens/Custome_Widgets/custome_widget.dart';
import 'package:diagnostics_patient/Screens/View/BookScreens/book_list_screen.dart';
import 'package:diagnostics_patient/Screens/View/ProfileScreens/profile_screen.dart';
import 'package:diagnostics_patient/Screens/View/home_screen.dart';
import 'package:diagnostics_patient/Screens/home_visit_screen.dart';
import 'package:diagnostics_patient/main.dart';
import 'package:diagnostics_patient/utils/AllText.dart';
import 'package:diagnostics_patient/utils/colors.dart';
import 'package:diagnostics_patient/utils/strings.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../utils/NavigationService.dart';
import '../../utils/notificationHelper.dart';
import '../View/BookScreens/book_details_screen.dart';
import '../View/CartScreen/cart_detail_screen.dart';

class PagesWidget extends StatefulWidget {
  final int selectedIndex;

  const PagesWidget({Key? key, this.selectedIndex = 0}) : super(key: key);
  @override
  _PagesWidgetState createState() => _PagesWidgetState();
}

class _PagesWidgetState extends State<PagesWidget> {
  int _selectedIndex = 0;
  final List screens = [
    HomeScreen(),
    BookListScreen(),
    HomeVisitScreen(),
    CartDetailScreen(),
    ProfileScreen(),
  ];

  void _onItemTapped(int index) async {
    setState(() {
      _selectedIndex = index;
    });
  }

  NotificationHelper notificationHelper = NotificationHelper();

  @override
  void initState() {
    notificationHelper.initialize();
    print('Hello');
    // checkPayload();
    notifications();
    _selectedIndex = widget.selectedIndex;
    // widget.selectedIndex!=_selectedIndex;

    // notificationHelper.initialize();
    // FirebaseMessaging.onMessage.listen((message) {
    //   print("onMessage: $message");
    //   print("\n\n"+message.toString());
    //   notificationHelper.showNotification(title: message.notification!.title,body: message.notification!.body ,payload: "123", id: "124", context2: context);
    // });
    // FirebaseMessaging.onMessageOpenedApp.listen((message) {
    //   print("onResume: $message");
    //   print("\n\n"+message.data.toString());
    //   notificationHelper.showNotification(title: message.notification!.title,body: message.notification!.body ,payload: "123", id: "124", context2: context);
    // });
    getCheckCall();
    super.initState();
  }

  getCheckCall() async {
    // await SharedPreferences.getInstance().then((value) {
    //   // var tmp = value.getString('callSessionCS');
    //   print('shared pref new try : ${value.getString('callSessionCS')}');
    //   if(value.getString('callSessionCS')!=null){
    //     dialog();
    //   }
    // });
  }

  @override
  void dispose() {
    removePref();
    super.dispose();
  }

  removePref() async {
    // await SharedPreferences.getInstance().then((value) async {
    //   var tmp = await value.remove('callSessionCS');
    //   print('value null $tmp');
    // });
  }

  Future<bool> _onWillPop() async {
    return (await Get.bottomSheet(
      Padding(
        padding: const EdgeInsets.all(15.0),
        child: Container(
          height: 200,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 10),
              boldText(
                  text: "Do you want to exit?",
                  color: blackColor,
                  size: 24,
                  alignment: TextAlign.center),
              SizedBox(height: 20),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: customeElevatedButton(
                    MediaQuery.of(context).size.width * 0.9, "Yes",
                    callback: () {
                  SystemNavigator.pop();
                }),
              ),
              SizedBox(height: 20),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: customeElevatedButtonOutLine(
                  MediaQuery.of(context).size.width * 0.9,
                  "No",
                  color: themeSecondaryColor,
                  callback: () {
                    Get.back();
                  },
                ),
              ),
            ],
          ),
        ),
      ),
      backgroundColor: Colors.white,
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20), topRight: Radius.circular(20)),
      ),
    ));
  }

  @override
  Widget build(BuildContext context) {
    // ignore: deprecated_member_use
    return WillPopScope(
      onWillPop: _onWillPop,
      child: MediaQuery.removePadding(
        context: context,
        removeBottom: true, // 👈 bottom padding reset
        child: Scaffold(
          resizeToAvoidBottomInset: true,
          bottomNavigationBar: BottomNavigationBar(
            onTap: _onItemTapped,
            showSelectedLabels: false,
            showUnselectedLabels: false,
            type: BottomNavigationBarType.fixed,
            backgroundColor: whiteColor,
            // selectedItemColor: themeColor,
            currentIndex: _selectedIndex,
            items: [
              BottomNavigationBarItem(
                icon: Image.asset(
                  'assets/home/home_unfill.png',
                  height: 32,
                  width: 32,
                ),
                label: ' ',
                activeIcon: Padding(
                  padding: const EdgeInsets.only(left: 5),
                  child: Container(
                    height: 30,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(50),
                      color: themeColor,
                    ),
                    child: Padding(
                      padding: const EdgeInsets.only(right: 5),
                      child: FittedBox(
                        fit: BoxFit.scaleDown,
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Image.asset(
                              'assets/home/home_fill.png',
                              height: 28,
                              width: 28,
                            ),
                            Text(
                              Home[LANGUAGE_TYPE],
                              style: const TextStyle(
                                  fontFamily: "Regular",
                                  color: whiteColor,
                                  fontSize: 12),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                // backgroundColor: themeColor,
              ),
              BottomNavigationBarItem(
                icon: Image.asset(
                  'assets/home/report_unfill.png',
                  height: 25,
                  width: 25,
                ),
                label: ' ',
                activeIcon: Padding(
                  padding: const EdgeInsets.only(left: 5),
                  child: Container(
                    height: 30,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(50),
                      color: themeColor,
                    ),
                    child: Padding(
                      padding: const EdgeInsets.only(right: 5),
                      child: FittedBox(
                        fit: BoxFit.scaleDown,
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Image.asset(
                              'assets/home/report_fill.png',
                              height: 20,
                              width: 20,
                            ),
                            Text(
                              Report[LANGUAGE_TYPE],
                              style: const TextStyle(
                                  fontFamily: "Regular",
                                  color: whiteColor,
                                  fontSize: 12),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                // backgroundColor: themeColor,
              ),
              BottomNavigationBarItem(
                icon: Image.asset(
                  'assets/home/home_unfill.png',
                  height: 32,
                  width: 32,
                ),
                label: ' ',
                activeIcon: Padding(
                  padding: const EdgeInsets.only(left: 5),
                  child: Container(
                    height: 30,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(50),
                      color: themeColor,
                    ),
                    child: Padding(
                      padding: const EdgeInsets.only(right: 5),
                      child: FittedBox(
                        fit: BoxFit.scaleDown,
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Image.asset(
                              'assets/home/home_fill.png',
                              height: 28,
                              width: 28,
                            ),
                            Text(
                              Home[LANGUAGE_TYPE],
                              style: const TextStyle(
                                  fontFamily: "Regular",
                                  color: whiteColor,
                                  fontSize: 12),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                // backgroundColor: themeColor,
              ),
              BottomNavigationBarItem(
                icon: Image.asset(
                  'assets/home/cart_unfill.png',
                  height: 32,
                  width: 32,
                ),
                label: ' ',
                activeIcon: Padding(
                  padding: const EdgeInsets.only(left: 5),
                  child: Container(
                    height: 30,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(50),
                      color: themeColor,
                    ),
                    child: Padding(
                      padding: const EdgeInsets.only(right: 5),
                      child: FittedBox(
                        fit: BoxFit.scaleDown,
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Image.asset(
                              'assets/home/cart_fill.png',
                              height: 28,
                              width: 28,
                            ),
                            Text(
                              CartTxt[LANGUAGE_TYPE],
                              style: const TextStyle(
                                  fontFamily: "Regular",
                                  color: whiteColor,
                                  fontSize: 12),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              // BottomNavigationBarItem(
              //   icon: Image.asset(
              //     'assets/home/chat_unfill.png',
              //     height: 32,
              //     width: 32,
              //   ),
              //   label: ' ',
              //   activeIcon:Padding(
              //     padding: const EdgeInsets.only(left: 5),
              //     child: Container(
              //       height: 30,
              //       decoration: BoxDecoration(
              //         borderRadius: BorderRadius.circular(50),
              //         color: themeColor,
              //       ),
              //       child: Padding(
              //         padding: const EdgeInsets.only(right: 5),
              //         child: Row(
              //           mainAxisAlignment: MainAxisAlignment.center,
              //           children: [
              //             Image.asset(
              //               'assets/home/chat_fill.png',
              //               height: 28,
              //               width: 28,
              //             ),
              //             Text(
              //               Chat[LANGUAGE_TYPE],
              //               style:const TextStyle(
              //                 fontFamily: "Regular",
              //                 color: whiteColor,
              //               ),
              //             ),
              //           ],
              //         ),
              //       ),
              //     ),
              //   ),
              // ),
              BottomNavigationBarItem(
                icon: Image.asset(
                  'assets/home/profile_unfill.png',
                  height: 32,
                  width: 32,
                ),
                label: ' ',
                activeIcon: Padding(
                  padding: const EdgeInsets.only(right: 5),
                  child: Container(
                    height: 30,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(50),
                      color: themeColor,
                    ),
                    child: Padding(
                      padding: const EdgeInsets.only(right: 5),
                      child: FittedBox(
                        fit: BoxFit.scaleDown,
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Image.asset(
                              'assets/home/profil_fill.png',
                              height: 28,
                              width: 28,
                            ),
                            Text(
                              Profile[LANGUAGE_TYPE],
                              style: const TextStyle(
                                  fontFamily: "Regular",
                                  color: whiteColor,
                                  fontSize: 12),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
          body: screens[_selectedIndex],
        ),
      ),
    );
  }

  notifications() {
    FirebaseMessaging.onMessage.listen((event) {
      print("message received app opened");
      print("message received data app opened " + event.data.toString());
      print("message received title" + event.data['title']);
      print("message received title" + event.data['message']);
      String payload = "";

      if (event.data.containsKey("key")) {
        if (event.data['key'] == "Booking") {
          print("order");
          payload = "${event.data['order_id']},${event.data['key']}";
          print("payload " + payload);
        } else if (event.data['key'] == "normal") {
          print("normal");
          if (event.data.containsKey("itemId")) {
            print("testing item id exist " + event.data['itemId']);

            payload = "${event.data['itemId']},${event.data['key']}";
          } else {
            print("testing item id doesnt exist ");

            payload = "123";
          }
          print("payload " + payload);
        }
      }
      notificationHelper.showNotification(
          title: event.data['title'],
          body: event.data['message'],
          payload: payload,
          id: "124",
          context2: context);
    });

    FirebaseMessaging.onMessageOpenedApp.listen((event) {
      print("message received 2");
      print("message received data 2 " + event.data.toString());
      print("message received title" + event.data['title']);
      print("message received title" + event.data['message']);
      String payload = "";

      if (event.data.containsKey("key")) {
        if (event.data['key'] == "Booking") {
          print("order");
          payload = "${event.data['order_id']},${event.data['key']}";

          print("payload " + payload);
        } else if (event.data['key'] == "normal") {
          print("normal");
          if (event.data.containsKey("itemId")) {
            print("testing item id exist " + event.data['itemId']);
            payload = "${event.data['itemId']},${event.data['key']}";
          } else {
            print("testing item id doesnt exist ");

            //payload=event.data['title']+","+event.data['key'];
            payload = "123";
          }
          print("payload " + payload);
        }
      }
      notificationHelper.showNotification(
          title: event.data['title'],
          body: event.data['message'],
          payload: payload,
          id: "124",
          context2: context);
    });

    FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);
  }

  Future<void> checkPayload() async {
    print("Testing " + "");

    var details = await notificationHelper.flutterLocalNotificationsPlugin!
        .getNotificationAppLaunchDetails();
    if (details!.didNotificationLaunchApp) {
      // if (details.payload != null) {
      SharedPreferences sharedPreferences =
          await SharedPreferences.getInstance();

      if (sharedPreferences.getString("payload_id") == null) {
        print("Testing " + "payload is null");
      } else if (sharedPreferences.getString("payload_id")!.isNotEmpty) {
        print("Testing  " + "payload exist");
        // print("Testing  id " +sharedPreferences.getString("payload_id"));
        // print("Testing  key " +sharedPreferences.getString("payload_key"));
        String id = sharedPreferences.getString("payload_id").toString();

        if (sharedPreferences.getString("payload_key").toString() ==
            "Booking") {
          print("Testing " + "payload key is order");
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => BookDetailsScreen(orderId: id)));

          //  Navigator.push(context, MaterialPageRoute(builder: (context)=>MyOrderDetailScreen(sharedPreferences.getString("payload_id"))));
          sharedPreferences.setString("payload_id", "");
          sharedPreferences.setString("payload_key", "");
        } else if (sharedPreferences.getString("payload_key").toString() ==
            "normal") {
          print("Testing " + "payload key is normal");
          if (sharedPreferences.getString("payload_id")!.isNotEmpty) {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => BookDetailsScreen(orderId: id)));

            // Navigator.push(context, MaterialPageRoute(builder: (context)=>MyOrderDetailScreen(sharedPreferences.getString("payload_id"))));
            sharedPreferences.setString("payload_id", "");
            sharedPreferences.setString("payload_key", "");
          } else {
            sharedPreferences.setString("payload_id", "");
            sharedPreferences.setString("payload_key", "");
            print("Navigate to product");
          }
        }
      } else {
        print("empty");
      }
    }
  }
  // }
}

Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  // print("Handling a background message "+message.data.toString());
  // print("Handling a background message "+message.data["title"]);
  // print("Handling a background message whole "+message.toString());
  String payload = "";
  if (message.data.containsKey("key")) {
    if (message.data['key'] == "Booking") {
      print("order");
      payload = "${message.data['order_id']},${message.data['key']}";

      print("payload " + payload);
    } else if (message.data['key'] == "normal") {
      print("normal");
      if (message.data.containsKey("itemId")) {
        print("testing item id exist " + message.data['itemId']);
        payload = "${message.data['itemId']},${message.data['key']}";
      } else {
        print("testing item id doesnt exist ");

        //payload=event.data['title']+","+event.data['key'];
        payload = "123";
      }
      print("payload " + payload);
    }
  } else {
    payload = "123";
  }

  NotificationHelper notificationHelper = NotificationHelper();
  notificationHelper.initialize();

  notificationHelper.showNotification(
      title: message.data["title"].toString(),
      body: message.data["message"].toString(),
      payload: payload,
      id: "124",
      context2: NavigationService.navigatorKey.currentContext);
  // notificationHelper.showNotification(title: message.notification!.title,body:message.notification!.body ,payload:"123, id: "124",context2: NavigationService.navigatorKey.currentContext);
}
