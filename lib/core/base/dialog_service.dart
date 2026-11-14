import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:diagnostics_patient/widgets/custom_snackbar.dart';

/// Dialog and Snackbar Service
/// Centralized management for all dialogs and snackbars

class DialogService extends GetxService {
  /// Show success snackbar
  void showSuccess({
    required String title,
    String? message,
    Duration duration = const Duration(seconds: 3),
  }) {
    AppSnackbar.success(
      title,
      message ?? '',
      duration: duration,
    );
  }

  /// Show error snackbar
  void showError({
    required String title,
    String? message,
    Duration duration = const Duration(seconds: 3),
  }) {
    AppSnackbar.error(
      title,
      message ?? '',
      duration: duration,
    );
  }

  /// Show warning snackbar
  void showWarning({
    required String title,
    String? message,
    Duration duration = const Duration(seconds: 3),
  }) {
    AppSnackbar.warning(
      title,
      message ?? '',
      duration: duration,
    );
  }

  /// Show info snackbar
  void showInfo({
    required String title,
    String? message,
    Duration duration = const Duration(seconds: 3),
  }) {
    AppSnackbar.info(
      title,
      message ?? '',
      duration: duration,
    );
  }

  /// Show simple confirmation dialog
  Future<bool> showConfirmDialog({
    required String title,
    String? message,
    String confirmText = 'Yes',
    String cancelText = 'No',
  }) async {
    final result = await Get.dialog<bool>(
      Dialog(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF333333),
                ),
              ),
              if (message != null)
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  child: Text(
                    message,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 14,
                      color: Color(0xFF666666),
                    ),
                  ),
                ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => Get.back(result: false),
                      style: OutlinedButton.styleFrom(
                        side: const BorderSide(color: Color(0xFF00A8A8)),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: Text(
                        cancelText,
                        style: const TextStyle(
                          color: Color(0xFF00A8A8),
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () => Get.back(result: true),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF00A8A8),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: Text(
                        confirmText,
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
      barrierDismissible: false,
    );

    return result ?? false;
  }

  /// Show simple alert dialog
  Future<void> showAlertDialog({
    required String title,
    String? message,
    String buttonText = 'OK',
    VoidCallback? onPressed,
  }) {
    return Get.dialog(
      Dialog(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF333333),
                ),
              ),
              if (message != null)
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  child: Text(
                    message,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 14,
                      color: Color(0xFF666666),
                    ),
                  ),
                ),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    Get.back();
                    onPressed?.call();
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF00A8A8),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: Text(
                    buttonText,
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      barrierDismissible: false,
    );
  }
}
