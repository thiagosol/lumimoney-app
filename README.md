# lumimoney_app

A new Flutter project.

## Getting Started

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Lab: Write your first Flutter app](https://docs.flutter.dev/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://docs.flutter.dev/cookbook)

For help getting started with Flutter development, view the
[online documentation](https://docs.flutter.dev/), which offers tutorials,
samples, guidance on mobile development, and a full API reference.

flutter pub run build_runner build --delete-conflicting-outputs

flutter run -d chrome --web-port=8000 --dart-define=API_BASE_URL=http://localhost:8080

flutter build apk --release

📌 Como criar uma keystore
keytool -genkeypair -v -keystore lumimoney-release.keystore -keyalg RSA -keysize 2048 -validity 10000 -alias lumimoney

📌 Comando para pegar a SHA-1 da keystore personalizada (release)
keytool -list -v -keystore lumimoney-release.keystore -alias lumimoney
