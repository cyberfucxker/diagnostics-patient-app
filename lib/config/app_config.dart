/// Single place for deployment-specific configuration.
///
/// Every value can be overridden at build/run time with `--dart-define`, e.g.
///
/// ```
/// flutter run \
///   --dart-define=API_BASE_URL=https://api.your-domain.example/api/ \
///   --dart-define=STORAGE_BASE_URL=https://api.your-domain.example/storage/app/public/ \
///   --dart-define=HOST_URL=https://api.your-domain.example/ \
///   --dart-define=GOOGLE_MAPS_API_KEY=your-key
/// ```
///
/// Or put them in a JSON file and use `--dart-define-from-file=config.json`
/// (see `config.example.json`). The defaults below are placeholders only.
class AppConfig {
  AppConfig._();

  /// Display name used inside the app (native display names live in
  /// AndroidManifest.xml / Info.plist).
  static const String appName = String.fromEnvironment('APP_NAME',
      defaultValue: 'Diagnostics Patient App');

  /// REST API base URL (must end with a slash).
  static const String apiBaseUrl = String.fromEnvironment('API_BASE_URL',
      defaultValue: 'https://api.example.com/api/');

  /// Public file storage base URL (profile pictures, reports, sample PDFs).
  static const String storageBaseUrl = String.fromEnvironment(
      'STORAGE_BASE_URL',
      defaultValue: 'https://api.example.com/storage/app/public/');

  /// Server root (used for report-portal endpoints and public banner images).
  /// Must end with a slash.
  static const String hostUrl =
      String.fromEnvironment('HOST_URL', defaultValue: 'https://api.example.com/');

  /// Google Maps / Places key used by Dart code (places picker, polylines).
  /// Native map keys are configured separately, see README.
  static const String googleMapsApiKey =
      String.fromEnvironment('GOOGLE_MAPS_API_KEY', defaultValue: '');

  /// Public (publishable) payment key passed to the payment gateway delegate.
  static const String paymentPublicKey =
      String.fromEnvironment('PAYMENT_PUBLIC_KEY', defaultValue: '');

  /// Store links used by the "share app" feature.
  static const String androidStoreUrl = String.fromEnvironment(
      'ANDROID_STORE_URL',
      defaultValue:
          'https://play.google.com/store/apps/details?id=com.example.diagnostics_patient');
  static const String iosStoreUrl = String.fromEnvironment('IOS_STORE_URL',
      defaultValue: 'https://apps.apple.com/app/id0000000000');

  /// Support contact shown on generated PDFs.
  static const String supportEmail = String.fromEnvironment('SUPPORT_EMAIL',
      defaultValue: 'support@example.com');

  /// Support phone shown on generated PDFs.
  static const String supportPhone =
      String.fromEnvironment('SUPPORT_PHONE', defaultValue: '+00-0000000000');

  /// Legal entity name printed on generated invoices.
  static const String companyName = String.fromEnvironment('COMPANY_NAME',
      defaultValue: 'Example Diagnostics Pvt. Ltd.');

  /// Website printed in the invoice footer.
  static const String websiteUrl =
      String.fromEnvironment('WEBSITE_URL', defaultValue: 'www.example.com');

  /// Jurisdiction sentence in the invoice footer notes.
  static const String legalJurisdiction = String.fromEnvironment(
      'LEGAL_JURISDICTION',
      defaultValue: 'your local jurisdiction');

  /// Tagline shown on the splash screen.
  static const String tagline = String.fromEnvironment('APP_TAGLINE',
      defaultValue: 'Trusted results, caring service');

  /// Default map location / city used before the user picks one.
  static const String defaultCityName =
      String.fromEnvironment('DEFAULT_CITY_NAME', defaultValue: 'Default City');
  static const String defaultCitySlug =
      String.fromEnvironment('DEFAULT_CITY_SLUG', defaultValue: 'default-city');
  static const double defaultLat =
      double.fromEnvironment('DEFAULT_LAT', defaultValue: 20.5937);
  static const double defaultLng =
      double.fromEnvironment('DEFAULT_LNG', defaultValue: 78.9629);
}
