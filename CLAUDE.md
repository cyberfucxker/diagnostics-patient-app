# CLAUDE.md

Guidance for AI coding assistants working in this repository.

## Project

Diagnostics Patient App: a Flutter app for patients of a home-collection diagnostics platform (browse tests/packages, cart, booking, payments, reports, labs, family members, addresses). GetX for state/routing/DI. The Dart package name is `diagnostics_patient`; imports use `package:diagnostics_patient/...`.

## Commands

```bash
flutter pub get
flutter analyze
dart format .
flutter test
flutter run --dart-define-from-file=config.json   # copy config.example.json first
flutter build apk --release --dart-define-from-file=config.json
```

## Layout

- `lib/config/app_config.dart`: single source of build-time configuration (`String.fromEnvironment`). Add new deployment values here and in `config.example.json`.
- `lib/config/api_config.dart`, `lib/utils/api.dart`: endpoint names and URL constants (both derive from `AppConfig`).
- `lib/controller/`: legacy GetX controllers, one per feature. `lib/core/` and `lib/modules/home/`: newer layered pattern (api client, repository, binding). Prefer the newer pattern for new code.
- `lib/payments/payment_gateway.dart`: provider-agnostic payment hook; no provider SDK or credential is bundled.
- `lib/Screens/`: screens and shared widgets. `lib/Models/`: JSON models.
- Native config: Android `android/app/build.gradle.kts` (namespace/applicationId `com.example.diagnostics_patient`), iOS bundle id `com.example.diagnosticsPatient`.

## Rules

- Never commit secrets or local config: `google-services.json`, `GoogleService-Info.plist`, `key.properties`, keystores, `config.json`, `ios/Flutter/Secrets.xcconfig`. Provide `.example` templates instead.
- Never embed literal API URLs, keys or contact details in Dart code; use `AppConfig`.
- Do not add real brand names, logos or personal data. Use `example.com` and neutral placeholders.
- Keep existing asset file names when replacing images; many screens reference them by path.
- Match existing style; run `dart format` and `flutter analyze` before finishing.
