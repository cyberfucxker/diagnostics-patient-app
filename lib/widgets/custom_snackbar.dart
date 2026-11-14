import 'package:flutter/material.dart';
import 'package:get/get.dart';

enum AppSnackbarType {
  success,
  error,
  warning,
  info,
}

class AppSnackbar {
  static void success(
      String title,
      String message, {
        Duration duration = const Duration(seconds: 3),
        SnackPosition snackPosition = SnackPosition.TOP,
        Color? backgroundColor,
        Color? colorText,
        EdgeInsets? margin,
        EdgeInsets? padding,
      }) {
    _show(title, message,
        type: AppSnackbarType.success,
        duration: duration,
        snackPosition: snackPosition,
        backgroundColor: backgroundColor,
        colorText: colorText,
        margin: margin,
        padding: padding);
  }

  static void error(
      String title,
      String message, {
        Duration duration = const Duration(seconds: 4),
        SnackPosition snackPosition = SnackPosition.TOP,
        Color? backgroundColor,
        Color? colorText,
        EdgeInsets? margin,
        EdgeInsets? padding,
      }) {
    _show(title, message,
        type: AppSnackbarType.error,
        duration: duration,
        snackPosition: snackPosition,
        backgroundColor: backgroundColor,
        colorText: colorText,
        margin: margin,
        padding: padding);
  }

  static void warning(
      String title,
      String message, {
        Duration duration = const Duration(seconds: 3),
        SnackPosition snackPosition = SnackPosition.TOP,
        Color? backgroundColor,
        Color? colorText,
        EdgeInsets? margin,
        EdgeInsets? padding,
      }) {
    _show(title, message,
        type: AppSnackbarType.warning,
        duration: duration,
        snackPosition: snackPosition,
        backgroundColor: backgroundColor,
        colorText: colorText,
        margin: margin,
        padding: padding);
  }

  static void info(
      String title,
      String message, {
        Duration duration = const Duration(seconds: 3),
        SnackPosition snackPosition = SnackPosition.TOP,
        Color? backgroundColor,
        Color? colorText,
        EdgeInsets? margin,
        EdgeInsets? padding,
      }) {
    _show(title, message,
        type: AppSnackbarType.info,
        duration: duration,
        snackPosition: snackPosition,
        backgroundColor: backgroundColor,
        colorText: colorText,
        margin: margin,
        padding: padding);
  }

  static void show(
      String title,
      String message, {
        AppSnackbarType? type,
        Duration duration = const Duration(seconds: 3),
        SnackPosition snackPosition = SnackPosition.TOP,
        Color? backgroundColor,
        Color? colorText,
        EdgeInsets? margin,
        EdgeInsets? padding,
      }) {
    _show(title, message,
        type: _resolveType(type, title, backgroundColor),
        duration: duration,
        snackPosition: snackPosition,
        backgroundColor: backgroundColor,
        colorText: colorText,
        margin: margin,
        padding: padding);
  }

  static AppSnackbarType _resolveType(
      AppSnackbarType? preferredType,
      String title,
      Color? backgroundColor,
      ) {
    if (preferredType != null) return preferredType;

    if (backgroundColor != null) {
      final v = backgroundColor.value;
      if (v == const Color(0xFF1B9C67).value) return AppSnackbarType.success;
      if (v == const Color(0xFFCF2B2B).value) return AppSnackbarType.error;
      if (v == const Color(0xFFE79A2C).value) return AppSnackbarType.warning;
      if (v == const Color(0xFF2376E7).value) return AppSnackbarType.info;
    }

    final t = title.toLowerCase();
    if (t.contains('success')) return AppSnackbarType.success;
    if (t.contains('warn')) return AppSnackbarType.warning;
    if (t.contains('error') || t.contains('fail')) return AppSnackbarType.error;
    return AppSnackbarType.info;
  }

  static void _show(
      String title,
      String message, {
        required AppSnackbarType type,
        required Duration duration,
        required SnackPosition snackPosition,
        Color? backgroundColor,
        Color? colorText,
        EdgeInsets? margin,
        EdgeInsets? padding,
      }) {
    Get.closeCurrentSnackbar();

    final palette = _paletteForType(type);
    final bg = backgroundColor ?? palette.background;
    final fg = colorText ?? Colors.white;

    Get.showSnackbar(
      GetSnackBar(
        titleText: Text(
          title,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 14,
            fontWeight: FontWeight.w700,
            letterSpacing: 0.1,
          ),
        ),
        messageText: Text(
          message,
          style: TextStyle(
            color: fg.withOpacity(0.90),
            fontSize: 12.5,
            height: 1.3,
            fontWeight: FontWeight.w500,
          ),
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        ),
        icon: _buildIcon(palette),

        snackPosition: snackPosition,
        backgroundColor: bg,
        duration: duration,

        // ✅ No more cast error
        margin: margin ?? const EdgeInsets.fromLTRB(12, 10, 12, 0),
        padding: padding ?? const EdgeInsets.symmetric(horizontal: 14, vertical: 12),

        borderRadius: 14,

        boxShadows: [
          BoxShadow(
            color: bg.withOpacity(0.35),        // colored shadow matching type
            blurRadius: 16,
            spreadRadius: 0,
            offset: const Offset(0, 6),
          ),
          BoxShadow(
            color: Colors.black.withOpacity(0.10),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],

        isDismissible: true,
        dismissDirection: DismissDirection.horizontal,

        // ⚡ Snappy: fast in, fast out
        animationDuration: const Duration(milliseconds: 220),
        forwardAnimationCurve: Curves.easeOutCubic,
        reverseAnimationCurve: Curves.easeInCubic,

        snackStyle: SnackStyle.FLOATING,
      ),
    );
  }

  static Widget _buildIcon(_SnackbarPalette palette) {
    return Container(
      width: 36,
      height: 36,
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.20),
        shape: BoxShape.circle,
      ),
      child: Icon(
        palette.icon,
        color: Colors.white,
        size: 20,
      ),
    );
  }

  static _SnackbarPalette _paletteForType(AppSnackbarType type) {
    switch (type) {
      case AppSnackbarType.success:
        return const _SnackbarPalette(
          background: Color(0xFF1B9C67),
          icon: Icons.check_circle_rounded,
        );
      case AppSnackbarType.error:
        return const _SnackbarPalette(
          background: Color(0xFFCF2B2B),
          icon: Icons.error_outline_rounded,
        );
      case AppSnackbarType.warning:
        return const _SnackbarPalette(
          background: Color(0xFFE79A2C),
          icon: Icons.warning_amber_rounded,
        );
      case AppSnackbarType.info:
        return const _SnackbarPalette(
          background: Color(0xFF2376E7),
          icon: Icons.info_outline_rounded,
        );
    }
  }
}

class _SnackbarPalette {
  final Color background;
  final IconData icon;

  const _SnackbarPalette({
    required this.background,
    required this.icon,
  });
}