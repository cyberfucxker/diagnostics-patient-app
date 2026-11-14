import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:diagnostics_patient/core/base/dialog_service.dart';

/// Extension methods for common operations

/// Build Context Extensions
extension ContextExtensions on BuildContext {
  double get screenWidth => MediaQuery.of(this).size.width;
  double get screenHeight => MediaQuery.of(this).size.height;
  bool get isMobile => screenWidth < 600;
  bool get isTablet => screenWidth >= 600 && screenWidth < 1200;
  bool get isDesktop => screenWidth >= 1200;
  bool get isPortrait => MediaQuery.of(this).orientation == Orientation.portrait;
  bool get isLandscape => MediaQuery.of(this).orientation == Orientation.landscape;
}

/// GetX Navigation Extensions
extension NavigationExtensions on GetxController {
  void goToNamed(String route, {dynamic arguments}) {
    Get.toNamed(route, arguments: arguments);
  }

  void offNamed(String route, {dynamic arguments}) {
    Get.offNamed(route, arguments: arguments);
  }

  void offAllNamed(String route, {dynamic arguments}) {
    Get.offAllNamed(route, arguments: arguments);
  }

  void back() {
    Get.back();
  }
}

/// String Extensions
extension StringExtensions on String {
  bool get isValidEmail {
    final emailRegex = RegExp(
      r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
    );
    return emailRegex.hasMatch(this);
  }

  bool get isValidPhone {
    final phoneRegex = RegExp(r'^[0-9]{10}$');
    return phoneRegex.hasMatch(this);
  }

  String get capitalize {
    if (isEmpty) return this;
    return '${this[0].toUpperCase()}${substring(1).toLowerCase()}';
  }

  String get capitalizeWords {
    return split(' ').map((word) => GetStringUtils(word).capitalize).join(' ');
  }

  bool get isNotBlank {
    return trim().isNotEmpty;
  }
}

/// List Extensions
extension ListExtensions<T> on List<T> {
  List<T> removeDuplicates() {
    return toSet().toList();
  }

  void addIfNotNull(T? item) {
    if (item != null) {
      add(item);
    }
  }

  void addAllIfNotNull(Iterable<T>? items) {
    if (items != null && items.isNotEmpty) {
      addAll(items);
    }
  }

  bool get isNotEmpty => isNotEmpty;
  bool get isEmpty => isEmpty;
}

/// Num Extensions
extension NumExtensions on num {
  String get toFormattedString {
    return toString();
  }

  String get toCurrency {
    return '₹${toString()}';
  }

  Duration get milliseconds => Duration(milliseconds: toInt());
  Duration get seconds => Duration(seconds: toInt());
  Duration get minutes => Duration(minutes: toInt());
}

/// DateTime Extensions
extension DateTimeExtensions on DateTime {
  bool get isToday {
    final now = DateTime.now();
    return year == now.year && month == now.month && day == now.day;
  }

  bool get isYesterday {
    final yesterday = DateTime.now().subtract(const Duration(days: 1));
    return year == yesterday.year && month == yesterday.month && day == yesterday.day;
  }

  bool get isTomorrow {
    final tomorrow = DateTime.now().add(const Duration(days: 1));
    return year == tomorrow.year && month == tomorrow.month && day == tomorrow.day;
  }

  String get formattedDate {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final yesterday = today.subtract(const Duration(days: 1));
    final tomorrow = today.add(const Duration(days: 1));
    
    final dateToCheck = DateTime(year, month, day);
    
    if (dateToCheck == today) {
      return 'Today';
    } else if (dateToCheck == yesterday) {
      return 'Yesterday';
    } else if (dateToCheck == tomorrow) {
      return 'Tomorrow';
    } else {
      return '$day/$month/$year';
    }
  }

  String get formattedTime {
    final hour = this.hour.toString().padLeft(2, '0');
    final minute = this.minute.toString().padLeft(2, '0');
    return '$hour:$minute';
  }

  String get formattedDateTime {
    return '$formattedDate $formattedTime';
  }
}

/// Dialog Service Extensions
extension DialogServiceExtensions on DialogService {
  void showSessionExpired() {
    showAlertDialog(
      title: 'Session Expired',
      message: 'Your session has expired. Please login again.',
      buttonText: 'Login',
    );
  }

  void showNetworkError() {
    showError(
      title: 'Network Error',
      message: 'Please check your internet connection.',
    );
  }

  void showServerError() {
    showError(
      title: 'Server Error',
      message: 'An error occurred. Please try again later.',
    );
  }

  void showValidationError(String message) {
    showError(
      title: 'Validation Error',
      message: message,
    );
  }
}

/// Widget Extensions
extension WidgetExtensions on Widget {
  Widget get withSafeArea => SafeArea(child: this);
  
  Widget get withScaffold => Scaffold(body: this);
  
  Widget get center => Center(child: this);
  
  Widget get expanded => Expanded(child: this);
  
  Widget get flexible => Flexible(child: this);
  
  Widget get constrained => SizedBox.expand(child: this);
  
  Widget withPadding(EdgeInsets padding) {
    return Padding(padding: padding, child: this);
  }
  
  Widget withMargin(EdgeInsets margin) {
    return Container(margin: margin, child: this);
  }
  
  Widget withOpacity(double opacity) {
    return Opacity(opacity: opacity, child: this);
  }
  
  Widget withTransform(Matrix4 transform) {
    return Transform(transform: transform, child: this);
  }
}
