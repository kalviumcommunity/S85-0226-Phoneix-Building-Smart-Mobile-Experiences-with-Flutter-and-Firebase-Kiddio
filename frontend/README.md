# Kiddio Frontend – Firebase Integration via FlutterFire CLI

This project demonstrates automated Firebase integration in a Flutter app using the official FlutterFire CLI. The CLI streamlines setup for Android, iOS, and Web, ensuring your app is always aligned with Firebase’s latest SDKs.

## 🚀 Quick Start

### 1. Prerequisites
- Flutter SDK installed
- Node.js and npm
- Firebase project already created

### 2. Install Required Tools
```sh
npm install -g firebase-tools
dart pub global activate flutterfire_cli
```

### 3. Log In and Configure Firebase
```sh
firebase login
cd frontend
flutterfire configure
```
- Select your Firebase project
- Choose Android, iOS, and Web
- The CLI generates `lib/firebase_options.dart`

### 4. Add Firebase Core Dependency
In `pubspec.yaml`:
```yaml
dependencies:
  firebase_core: ^3.0.0
```
Then run:
```sh
flutter pub get
```

### 5. Initialize Firebase in Your App
In `lib/main.dart`:
```dart
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'FlutterFire Integration Demo',
      home: Scaffold(
        appBar: AppBar(title: const Text('Firebase Integration Complete')),
        body: const Center(
          child: Text('Firebase SDK setup successful!'),
        ),
      ),
    );
  }
}
```

### 6. Verify the Setup
- Run your app: `flutter run`
- Check the Firebase Console → Project Settings → Your Apps
- Look for logs: `Firebase initialized with DefaultFirebaseOptions`

### 7. Add More Firebase SDKs
Add to `pubspec.yaml` as needed:
```yaml
firebase_auth: ^5.0.0
cloud_firestore: ^5.0.0
firebase_analytics: ^11.0.0
```
Then run:
```sh
flutter pub get
```

## 📝 Reflection
- **How does FlutterFire CLI simplify setup?**
  - Automates platform registration, config generation, and keeps SDKs up to date.
- **Issues faced:**
  - CLI not in PATH: Add `~/.pub-cache/bin` to PATH.
  - Missing initialization: Ensure `await Firebase.initializeApp()` is called.
- **Team benefits:**
  - Consistent, error-free setup for all platforms. Easy to add new Firebase features.

---

## 📸 Screenshots & Demo
- Terminal log of `flutterfire configure`
- Screenshot of Firebase Console showing registered app
- App running with success message

---

## Pro Tip
The FlutterFire CLI ensures your Firebase SDKs are always correctly configured and updated — one command saves hours of manual editing and debugging.


# Firebase Auth Flow — Flutter

This project implements a complete authentication flow using Firebase Authentication.

## Features
- Sign Up
- Login
- Logout
- Real-time session handling
- Automatic navigation using authStateChanges()

## How It Works

### Sign Up
Uses:
FirebaseAuth.instance.createUserWithEmailAndPassword()

### Login
Uses:
FirebaseAuth.instance.signInWithEmailAndPassword()

### Logout
Uses:
FirebaseAuth.instance.signOut()

### Session Handling
StreamBuilder listens to authStateChanges() to switch screens automatically.

## Screens
- AuthScreen → Login & Sign Up
- HomeScreen → Logged-in state

## Reflection

Hardest Part:
Managing UI state between login and signup modes.

Why StreamBuilder helps:
Removes manual navigation and keeps UI synced with session state.


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

Why logout is important:
Prevents unauthorized access and clears session securely.
