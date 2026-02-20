# frontend

A new Flutter project.

## Getting Started

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Learn Flutter](https://docs.flutter.dev/get-started/learn-flutter)
- [Write your first Flutter app](https://docs.flutter.dev/get-started/codelab)
- [Flutter learning resources](https://docs.flutter.dev/reference/learning-resources)

For help getting started with Flutter development, view the
[online documentation](https://docs.flutter.dev/), which offers tutorials,
samples, guidance on mobile development, and a full API reference.

## Responsive Layout Demo

This project includes a small responsive UI example at `lib/screens/responsive_home.dart`.

Key points:

- Uses `MediaQuery.of(context).size` to detect `screenWidth` and `screenHeight`.
- Switches layout when `screenWidth > 600` to use a two-column (tablet) layout.
- Uses `LayoutBuilder`, `Flexible`, `Expanded`, `AspectRatio`, `GridView`, and `Wrap` to adapt content.

Example snippet (MediaQuery + conditional layout):

```dart
final screenWidth = MediaQuery.of(context).size.width;
final isTablet = screenWidth > 600;

return LayoutBuilder(builder: (context, constraints) {
	if (isTablet) {
		// two-column layout
	} else {
		// single-column layout
	}
});
```

Take screenshots of the app in portrait and landscape, and include them here when submitting.

See also: `PROJECT_STRUCTURE.md` for a short guide to this Flutter app's folder layout.

## Firebase Email & Password Authentication

This project includes a simple Email/Password authentication flow using Firebase Authentication.

### Setup

1. Enable Email/Password sign-in in your Firebase Console: Authentication → Sign-in method → Email/Password → Enable.
2. Install FlutterFire CLI and configure your Firebase app (generates `firebase_options.dart`):

```bash
dart pub global activate flutterfire_cli
cd frontend
flutterfire configure
flutter pub get
```

3. Ensure the following dependencies exist in `pubspec.yaml` and run `flutter pub get`:

- `firebase_core: ^3.0.0`
- `firebase_auth: ^5.0.0`

4. Run the app and use the Authentication screen to Signup/Login. New users will appear in Firebase Console → Authentication → Users.

### Files

- `lib/main.dart` — Initializes Firebase and shows either the Auth screen or the app home depending on authentication state.
- `lib/screens/auth_screen.dart` — Signup and Login UI with FirebaseAuth logic.
- `lib/screens/responsive_home.dart` — App home; includes a Sign out button.

### Code snippets

Signup / Login (already implemented in `auth_screen.dart`):

```dart
await FirebaseAuth.instance.createUserWithEmailAndPassword(
	email: email,
	password: password,
);

await FirebaseAuth.instance.signInWithEmailAndPassword(
	email: email,
	password: password,
);
```

Listen to auth state changes:

```dart
FirebaseAuth.instance.authStateChanges().listen((user) {
	if (user == null) print('signed out');
	else print('signed in: ${user.email}');
});
```

### Screenshots / Evidence

- App Authentication UI: (add screenshot here)
- Firebase Console → Users: (add screenshot here)

### Reflection

- Why Firebase Auth: Provides secure, maintained authentication without a custom backend; supports multiple providers and integrates with other Firebase services.
- Security features: Email verification, secure token lifecycle, integrated rules with other Firebase services.
- Challenges: Ensure `firebase_options.dart` is present for each platform and compatible plugin versions. Use `flutterfire configure` to generate platform options.

---
