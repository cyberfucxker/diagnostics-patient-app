# Diagnostics Patient App

A Flutter patient/customer app for a **home-collection diagnostics platform**. Patients browse lab tests and health packages, book a sample collection at home or a visit to a nearby lab, pay, and later download their reports.

The app talks to a REST backend that you provide (see [Backend contract](#backend-contract)). All deployment-specific values (API URL, map keys, branding strings) are configurable and ship as neutral placeholders.

> Status: this is a community-maintained code base extracted from a production app. It has not been build-verified in its open-source form; expect to fix small issues on first build (see [Known gaps](#known-gaps)).

## Features

Derived from the code in `lib/`:

- **Onboarding, splash and phone/OTP sign-in** (login, OTP verify, register, forgot password, SMS auto-fill for OTP).
- **Catalogue browsing**: categories, popular packages, individual tests, parameters, package/profile details, search, lifestyle-based recommendations, downloadable sample reports.
- **Cart and checkout**: multi-member cart (stored locally in SQLite), coupons, wallet balance, time-slot selection, home-visit or lab booking, pay online or cash on delivery.
- **Family members**: add, edit, delete members and book for them.
- **Addresses**: saved address list, add address with a Google Maps place picker, current-location detection.
- **Nearby labs**: lab list by city, lab details, map with route polyline, call/email actions.
- **Bookings**: booking list with filters, booking details, feedback/rating, invoice PDF generation.
- **Reports**: OTP-protected report login, report list, in-app PDF viewing, paid report download hook.
- **Prescriptions**: upload prescription images/PDFs, request a call back, request a home visit.
- **Profile**: edit profile, avatar upload, wallet, delete account.
- **Push notifications** via Firebase Cloud Messaging and local notifications; in-app update prompt.
- Language-map based UI strings (`lib/utils/AllText.dart`).

## Tech stack

- Flutter (Dart SDK `>=3.0.0 <4.0.0`)
- State management / routing / DI: [GetX](https://pub.dev/packages/get)
- Networking: `http`, `dio`
- Local storage: `sqflite`, `hive`, `shared_preferences`
- Firebase: `firebase_core`, `firebase_auth`, `firebase_messaging`
- Maps and location: `google_maps_flutter`, `geolocator`, `geocoding`, `location`, `flutter_polyline_points`, a Google Maps place picker
- PDF: `pdf`, `printing`, `flutter_cached_pdfview`

## Project structure

```
lib/
  main.dart                 App entry point
  config/                   app_config.dart (build-time config), api_config.dart, bindings
  constants/                App constants
  core/                     Newer layered networking (api_client/api_service), exceptions, base controllers
  modules/home/             Example of the newer module structure (binding/controller/repository/view)
  controller/               GetX controllers (legacy, one per feature)
  Models/                   JSON models
  Screens/                  UI screens and shared widgets
  Services/                 SQLite helper
  payments/                 Provider-agnostic payment gateway abstraction
  utils/ widgets/ themes/   Helpers, theme, reusable widgets, API constants
android/ ios/               Native projects
assets/ fonts/              Images and fonts (neutral placeholders)
```

## Getting started

### Prerequisites

- Flutter stable with Dart 3 (`flutter --version`)
- Android Studio / Xcode for the target platform
- Your own Firebase project and Google Maps API key

### 1. Install dependencies

```bash
flutter pub get
```

### 2. Configure the API and keys

All Dart-side configuration lives in `lib/config/app_config.dart` and is overridden at build time with `--dart-define`. Copy `config.example.json` to `config.json` (git-ignored), edit it, and pass it with `--dart-define-from-file`:

```bash
cp config.example.json config.json
flutter run --dart-define-from-file=config.json
```

| Key | Purpose |
| --- | --- |
| `API_BASE_URL` | REST API base URL, must end with `/` |
| `STORAGE_BASE_URL` | Public storage URL for profile pictures, reports and sample PDFs |
| `HOST_URL` | Server root, used for the report-portal endpoints and banner images |
| `GOOGLE_MAPS_API_KEY` | Key used by Dart code (places picker, directions) |
| `PAYMENT_PUBLIC_KEY` | Publishable key handed to your payment gateway delegate |
| `ANDROID_STORE_URL`, `IOS_STORE_URL` | Links used by "share app" |
| `COMPANY_NAME`, `WEBSITE_URL`, `SUPPORT_EMAIL`, `SUPPORT_PHONE`, `LEGAL_JURISDICTION` | Text printed on invoice PDFs |
| `APP_NAME`, `APP_TAGLINE` | In-app display strings |
| `DEFAULT_CITY_NAME`, `DEFAULT_CITY_SLUG`, `DEFAULT_LAT`, `DEFAULT_LNG` | Default location before the user picks one |

### 3. Firebase

The app uses the native Firebase config files (no `firebase_options.dart`).

- **Android**: download `google-services.json` from your Firebase console and save it as `android/app/google-services.json`. Use `android/app/google-services.json.example` as a reference. The Gradle plugin is applied only if the file exists.
- **iOS**: download `GoogleService-Info.plist` and save it as `ios/Runner/GoogleService-Info.plist` (the Xcode project already references it). See `ios/Runner/GoogleService-Info.plist.example`. Replace `YOUR_REVERSED_CLIENT_ID` in `ios/Runner/Info.plist` with the `REVERSED_CLIENT_ID` from that file.
- Register the Android package `com.example.diagnostics_patient` and the iOS bundle id `com.example.diagnosticsPatient`, or rename them first (see below).

### 4. Google Maps native keys

- **Android**: add `MAPS_API_KEY=your-key` to `android/local.properties` (or pass `-PMAPS_API_KEY=...`). It is injected into `AndroidManifest.xml` as a manifest placeholder.
- **iOS**: copy `ios/Flutter/Secrets.xcconfig.example` to `ios/Flutter/Secrets.xcconfig` and set `GOOGLE_MAPS_API_KEY`.

### 5. Payments

The checkout calls a small abstraction, `lib/payments/payment_gateway.dart`. No payment provider SDK or credential is bundled. To enable online payment, implement `PaymentGatewayDelegate` for your provider and assign it to `PaymentGateway.delegate` in `main()`. Create payment orders on your backend and never embed provider secrets in the app. Cash on delivery works without any gateway. The legacy card flow in `lib/Screens/stripe_screen.dart` reads `STRIPE_SECRET_KEY` from `--dart-define` and is only meant for local experiments.

### 6. Rename the app (recommended)

Change the Android `namespace`/`applicationId` in `android/app/build.gradle.kts`, move `android/app/src/main/kotlin/com/example/diagnostics_patient/`, update the iOS `PRODUCT_BUNDLE_IDENTIFIER` and URL scheme, and the display names in `AndroidManifest.xml` and `Info.plist`.

### Run

```bash
flutter run --dart-define-from-file=config.json
```

## Build

```bash
# Android
flutter build apk --release --dart-define-from-file=config.json
flutter build appbundle --release --dart-define-from-file=config.json

# iOS
cd ios && pod install && cd ..
flutter build ipa --release --dart-define-from-file=config.json
```

Release signing on Android: copy `android/key.properties.example` to `android/key.properties`, fill in your keystore details. Without that file, release builds fall back to the debug key. Never commit keystores.

## Backend contract

The endpoints the app calls are listed in `lib/config/api_config.dart` (`ApiEndpoints`) and `lib/utils/api.dart`: OTP login/verify, categories, packages, tests, parameters, labs, cities, slots, cart, booking, coupons, wallet, members, addresses, home visits, prescriptions, reports, and push-token registration. The report portal uses `report-api`, `report-download-api`, `otpsend_report` and `check_login_api` under `HOST_URL`. You need a compatible backend; the request/response shapes are defined by the models in `lib/Models/`.

## Known gaps

- Not build-verified after sanitisation; run `flutter pub get && flutter analyze` and fix any issues.
- No automated tests are included yet.
- Two overlapping config files (`lib/utils/api.dart` and `lib/config/api_config.dart`) and legacy and newer architectures coexist.
- Some bundled icons and the category illustrations were inherited from the original project and their provenance is unknown. Replace them with assets you own before publishing an app built from this code.
- Fonts: Noto Sans (SIL Open Font License 1.1) and Montserrat (SIL OFL 1.1).

## Contributing

See [CONTRIBUTING.md](CONTRIBUTING.md). Licensed under the [MIT License](LICENSE).
