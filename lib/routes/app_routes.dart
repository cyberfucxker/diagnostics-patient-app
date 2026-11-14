import 'package:get/get.dart';

/// App Routes
/// Centralized route management for the application

class AppRoutes {
  static const String splash = '/splash';
  static const String onBoarding = '/onboarding';
  static const String login = '/login';
  static const String otp = '/otp';
  static const String register = '/register';
  static const String home = '/home';
  static const String categoryDetail = '/category-detail';
  static const String packageDetail = '/package-detail';
  static const String testDetail = '/test-detail';
  static const String cart = '/cart';
  static const String checkout = '/checkout';
  static const String bookingDetail = '/booking-detail';
  static const String profile = '/profile';
  static const String addressList = '/address-list';
  static const String familyMemberList = '/family-member-list';
  static const String reports = '/reports';
}

/// App Pages Configuration
/// Define all routes and their bindings here

class AppPages {
  static final pages = <GetPage>[
    // TODO: Add page routes here
    // Example:
    // GetPage(
    //   name: AppRoutes.home,
    //   page: () => const HomeScreen(),
    //   binding: HomeBinding(),
    //   transition: Transition.fadeIn,
    // ),
  ];

  /// Get page transition
  static Transition get defaultTransition => Transition.fadeIn;

  /// Get page duration
  static Duration get transitionDuration => const Duration(milliseconds: 300);
}
