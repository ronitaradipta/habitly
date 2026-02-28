# habitly

A habit tracking Flutter application with Firebase authentication.

## Setup Firebase

`lib/firebase_options.dart` is excluded from version control (it contains API keys). To set it up:

1. Install the FlutterFire CLI: `dart pub global activate flutterfire_cli`
2. Run: `flutterfire configure`
3. Select your Firebase project (`habitly-361f0`) and target platforms (Android, iOS)

The CLI will generate `lib/firebase_options.dart` automatically. See `lib/firebase_options.dart.example` for the expected file structure.

## Getting Started

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Lab: Write your first Flutter app](https://docs.flutter.dev/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://docs.flutter.dev/cookbook)

For help getting started with Flutter development, view the
[online documentation](https://docs.flutter.dev/), which offers tutorials,
samples, guidance on mobile development, and a full API reference.
