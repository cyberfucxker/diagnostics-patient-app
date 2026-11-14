/* // ignore_for_file: deprecated_member_use

import 'dart:developer';
import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:diagnostics_patient/utils/colors.dart';
import 'package:permission_handler/permission_handler.dart';

class MediaPermissionHelper with WidgetsBindingObserver {
  static final MediaPermissionHelper _instance =
      MediaPermissionHelper._internal();
  factory MediaPermissionHelper() => _instance;
  MediaPermissionHelper._internal();

  BuildContext? _context;
  bool _waitingForSettings = false;

  void init(BuildContext context) {
    _context = context;
    WidgetsBinding.instance.addObserver(this);
  }

  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _context = null;
    _waitingForSettings = false;
  }

  /*  Future<bool> requestMediaPermission(BuildContext context) async {
    init(context);

    if (await Permission.photos.isGranted ||
        await Permission.storage.isGranted) {
      dispose();
      return true;
    }

    Permission permission;
    if (Theme.of(context).platform == TargetPlatform.android) {
      permission = (await Permission.photos.status.isGranted)
          ? Permission.photos
          : Permission.storage;
    } else {
      permission = Permission.photos;
    }

    PermissionStatus status = await permission.request();

    if (status.isGranted) {
      print(' Media permission granted');
      dispose();
      return true;
    } else if (status.isPermanentlyDenied) {
      print(' Media permission permanently denied — open settings');
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Future.delayed(Duration(milliseconds: 300), () {
          if (!(Get.isDialogOpen ?? false)) {
            showMediaPermissionDialog(context, openSettings: true);
          }
        });
      });
      return false;
    } else {
      print(' Media permission denied — showing custom dialog');
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Future.delayed(Duration(milliseconds: 300), () {
          if (!(Get.isDialogOpen ?? false)) {
            showMediaPermissionDialog(context);
          }
        });
      });
      return false;
    }
  } */
  Future<bool> requestMediaPermission(BuildContext context) async {
    init(context); // assuming your class has init()

    // ✅ Shortcut if already granted
    if (await Permission.photos.isGranted ||
        await Permission.storage.isGranted) {
      dispose();
      return true;
    }

    Permission permission;

    if (Platform.isAndroid) {
      final androidInfo = await DeviceInfoPlugin().androidInfo;
      final sdkInt = androidInfo.version.sdkInt;

      if (sdkInt >= 33) {
        // Android 13+ uses Photos permission
        permission = Permission.photos;
      } else {
        // Android 12 and below
        permission = Permission.storage;
      }
    } else {
      // iOS uses Photos
      permission = Permission.photos;
    }

    final status = await permission.request();

    if (status.isGranted) {
      print('✅ Media permission granted');
      dispose();
      return true;
    } else if (status.isPermanentlyDenied) {
      print('❌ Media permission permanently denied — open settings');
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Future.delayed(Duration(milliseconds: 300), () {
          if (!(Get.isDialogOpen ?? false)) {
            showMediaPermissionDialog(context, openSettings: true);
          }
        });
      });
      return false;
    } else {
      print('⚠️ Media permission denied — showing custom dialog');
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Future.delayed(Duration(milliseconds: 300), () {
          if (!(Get.isDialogOpen ?? false)) {
            showMediaPermissionDialog(context);
          }
        });
      });
      return false;
    }
  }

  void showMediaPermissionDialog(BuildContext context,
      {bool openSettings = false}) {
    log("showMediaPermissionDialog");
    Get.dialog(
      WillPopScope(
        onWillPop: () async => false,
        child: AlertDialog(
          title: Text("Permission Required"),
          content: Text("This app needs access to your media permission."),
          actions: [
            TextButton(
              onPressed: () async {
                // Get.back(); // Close the dialog
                if (openSettings) {
                  _waitingForSettings = true;
                  await openAppSettings(); // Send user to app settings
                  // The check will happen when app resumes
                } else {
                  requestMediaPermission(context);
                }
              },
              child: Text("Open Settings", style: TextStyle(color: blackColor)),
            ),
          ],
        ),
      ),
      barrierDismissible: false,
    );
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) async {
    if (_waitingForSettings &&
        state == AppLifecycleState.resumed &&
        _context != null) {
      bool granted = await Permission.photos.isGranted ||
          await Permission.storage.isGranted;

      if (granted) {
        // ✅ Permission was granted — close dialog and dispose
        if (Get.isDialogOpen ?? false) {
          Get.back(); // Close permission dialog
        }
        dispose();
      } else {
        //  Permission still not granted — show dialog again
        Future.delayed(Duration(milliseconds: 300), () {
          if (!(Get.isDialogOpen ?? false)) {
            showMediaPermissionDialog(_context!, openSettings: true);
          }
        });
        //  Do NOT call dispose() here so we can keep checking
      }
    }
  }
}

/// Request storage permission
Future<bool> ensureStoragePermission() async {
  if (await Permission.storage.isGranted) return true;
  final result = await Permission.storage.request();
  return result.isGranted;
}
 */