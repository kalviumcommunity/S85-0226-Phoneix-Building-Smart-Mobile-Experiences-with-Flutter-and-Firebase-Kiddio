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
