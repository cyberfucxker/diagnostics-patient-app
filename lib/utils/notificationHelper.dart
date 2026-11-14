import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../Screens/View/BookScreens/book_details_screen.dart';

class NotificationHelper {
  String? title;
  String? body;
  String? payload;
  String? id;
  String? type;
  BuildContext? context;
  FlutterLocalNotificationsPlugin? flutterLocalNotificationsPlugin;

  NotificationHelper() {
    initialize();
    print("\n\nPayload : $payload");
  } // initialise the plugin. app_icon needs to be a added as a drawable resource to the Android head project

  initialize() async {
    flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
    const AndroidInitializationSettings initializationSettingsAndroid = AndroidInitializationSettings('@mipmap/launcher_icon');
    // final IOSInitializationSettings initializationSettingsIOS =
    // IOSInitializationSettings(
    //     onDidReceiveLocalNotification: onDidReceiveLocalNotification);

    // final InitializationSettings initializationSettings = InitializationSettings(
    //     android: initializationSettingsAndroid,
    //     iOS: initializationSettingsIOS);
    // flutterLocalNotificationsPlugin!.initialize(initializationSettings,
    //     onSelectNotification: onSelectNotification);
    await FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
      alert: true,
      badge: true,
      sound: true,
    );
  }

  showNotification({String? title, String? body, String? payload, String? id, BuildContext? context2}) async {
    context = context2;
    AndroidNotificationDetails androidPlatformChannelSpecifics = new AndroidNotificationDetails(
      id!,
      body!,
      importance: Importance.max,
      priority: Priority.high,
      showWhen: true,
    );
    NotificationDetails platformChannelSpecifics = NotificationDetails(android: androidPlatformChannelSpecifics);
    // SharedPreferences sharedPreferences=await SharedPreferences.getInstance();
    // //if(sharedPreferences.getString("payload_id").isNotEmpty){}
    // sharedPreferences.setString("payload_id", payload!.split(",")[0]);
    // sharedPreferences.setString("payload_key", payload.split(",")[1]);
    await flutterLocalNotificationsPlugin!.show(0, title, body, platformChannelSpecifics, payload: payload);
  }

  Future onSelectNotification(String? payload) async {
    print("Called");
    if (payload != null) {
      print('\n\nnotification payload: $payload');
    }
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    //if(sharedPreferences.getString("payload_id").isNotEmpty){}
    sharedPreferences.setString("payload_id", payload!.split(",")[0]);
    sharedPreferences.setString("payload_key", payload.split(",")[1]);
    if (context != null) {
      print(" context not null");
      checkPayload();
    } else {
      print("context null");
    }
  }

  Future<void> checkPayload() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();

    if (sharedPreferences.getString("payload_id") == null) {
      print("Testing " + "payload is null");
    } else if (sharedPreferences.getString("payload_id")!.isNotEmpty) {
      print("Testing  " + "payload exist");
      print("Testing  id " + sharedPreferences.getString("payload_id")!);
      print("Testing  key " + sharedPreferences.getString("payload_key")!);
      String id = sharedPreferences.getString("payload_id").toString();
      if (sharedPreferences.getString("payload_key").toString() == "Booking") {
        print("Testing " + "payload key is order");
        // Navigator.push(context, MaterialPageRoute(builder: (context)=>OrderDetailsScreen(sharedPreferences.getString("payload_id"))));
        Navigator.push(context!, MaterialPageRoute(builder: (context) => BookDetailsScreen(orderId: id)));
        // print("Testing " +"navgated "+sharedPreferences.getString("payload_id"));

        //Navigator.push(context, MaterialPageRoute(builder: (context)=>MyOrderDetailScreen(sharedPreferences.getString("payload_id"))));
        // sharedPreferences.setString("payload_id", "");
        // sharedPreferences.setString("payload_key", "");
      } else if (sharedPreferences.getString("payload_key").toString() == "normal") {
        print("Testing " + "payload key is normal");
        if (sharedPreferences.getString("payload_id")!.isNotEmpty) {
          Navigator.push(context!, MaterialPageRoute(builder: (context) => BookDetailsScreen(orderId: id)));
          // print("navigate"+sharedPreferences.getString("payload_id"));

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

  Future onDidReceiveLocalNotification(int? id, String? title, String? body, String? payload) async {
    // display a dialog with the notification details, tap ok to go to another page
    // showDialog(
    //   context: context,
    //   builder: (BuildContext context) => CupertinoAlertDialog(
    //     title: Text(title),
    //     content: Text(body),
    //     actions: [
    //       CupertinoDialogAction(
    //         isDefaultAction: true,
    //         child: Text('Ok'),
    //         onPressed: () async {
    //           Navigator.of(context, rootNavigator: true).pop();
    //           //await Navigator.push(
    //           // context,
    //           // MaterialPageRoute(
    //           //   builder: (context) => SecondScreen(payload),
    //           // ),
    //           //);
    //         },
    //       )
    //     ],
    //   ),
    // );
  }
}
