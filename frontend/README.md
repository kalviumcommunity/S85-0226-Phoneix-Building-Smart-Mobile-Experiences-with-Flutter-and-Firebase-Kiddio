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


## Persistent Session & Auto-Login Flow

### How Persistent Login Works
Firebase Authentication automatically persists user sessions securely on device. This means:
- Users stay logged in after closing/restarting the app (auto-login)
- Session tokens are refreshed in the background
- No need for manual storage (e.g., SharedPreferences)

### StreamBuilder for Session Routing
The app uses a global `StreamBuilder` on `FirebaseAuth.instance.authStateChanges()` in `main.dart`:

```dart
home: StreamBuilder<User?>(
  stream: FirebaseAuth.instance.authStateChanges(),
  builder: (ctx, snapshot) {
    if (snapshot.connectionState == ConnectionState.waiting) {
      return Center(child: CircularProgressIndicator());
    }
    if (snapshot.hasData) {
      return ResponsiveHome(); // or HomeScreen
    }
    return AuthScreen();
  },
),
```

**Behavior:**
- If logged in: goes directly to HomeScreen/ResponsiveHome
- If logged out: shows AuthScreen
- While checking: shows loading indicator (SplashScreen optional)

### Auto-Login & Logout Flow
1. **Login:**
   - User logs in via AuthScreen
   - Navigates to HomeScreen
2. **App Restart:**
   - Close and reopen app
   - App skips login, goes straight to HomeScreen (auto-login)
3. **Logout:**
   - Tap logout button (in HomeScreen/ResponsiveHome)
   - Calls `FirebaseAuth.instance.signOut()`
   - User is redirected to AuthScreen
   - Restarting app keeps user logged out

### Screenshots / Evidence

- HomeScreen before restart: (add screenshot here)
- Auto-login after restart: (add screenshot here)
- Logout screen: (add screenshot here)

### Reflection

- **Why persistent sessions improve UX:**
  - Users don’t have to log in every time, making the app feel seamless and professional.
- **How Firebase simplifies session management:**
  - Handles secure token storage, refresh, and session state automatically.
  - No manual code for session persistence needed.
- **Limitations / Challenges:**
  - Brief loading state on startup (can be improved with a SplashScreen)
  - Must ensure correct routing and avoid flicker between screens

---

Why logout is important:
Prevents unauthorized access and clears session securely.
