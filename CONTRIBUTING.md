# Contributing

Thanks for your interest in improving Diagnostics Patient App.

## Getting set up

1. Fork and clone the repository.
2. Follow the setup steps in [README.md](README.md) (`flutter pub get`, Firebase files, `config.json`).
3. Create a branch: `git checkout -b feat/short-description`.

## Guidelines

- Keep pull requests focused; one change per PR.
- Run `dart format .` and `flutter analyze` before pushing.
- Add or update tests under `test/` when you change behaviour.
- Do not commit secrets: API keys, `google-services.json`, `GoogleService-Info.plist`, keystores, `key.properties`, `config.json`. These are git-ignored; keep it that way.
- Do not add real brand names, logos, personal data or production URLs. Use `example.com` and neutral placeholders.
- New deployment-specific values belong in `lib/config/app_config.dart` and `config.example.json`, read via `String.fromEnvironment`.
- Use [Conventional Commits](https://www.conventionalcommits.org/) style messages (`feat:`, `fix:`, `docs:`, `refactor:`).

## Reporting bugs and requesting features

Open an issue using the templates in `.github/ISSUE_TEMPLATE/`. Include Flutter version, platform, and reproduction steps.

## License

By contributing you agree that your contributions are licensed under the MIT License.
