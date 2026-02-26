# Kiddio Frontend – Firebase Integration via FlutterFire CLI

## Firestore Schema Design

### Collections

- **users**
  - `uid` (Document ID): User ID from Firebase Auth
  - `name`: User's display name
  - `email`: User's email address
  - `yearsOfExperience`: Sitter's years of experience
  - `createdAt`: Timestamp when user profile was created

- **tasks**
  - `taskId` (Document ID): Auto-generated
  - `userId`: Reference to user's UID
  - `title`: Task title
  - `description`: Task description
  - `status`: Task status (`pending`, `completed`, etc.)
  - `createdAt`: Timestamp when task was created
  - `updatedAt`: Timestamp when task was last updated

### Usage

- On signup, a user profile is created in Firestore under `users`.
- Tasks are created with a reference to the user, and include timestamps and status.

### Example Document

**users/{uid}**
```
{
  "name": "John Doe",
  "email": "john@example.com",
  "yearsOfExperience": 5,
  "createdAt": <timestamp>
}
```

**tasks/{taskId}**
```
{
  "userId": "uid123",
  "title": "Buy groceries",
  "description": "Milk, eggs, bread",
  "status": "pending",
  "createdAt": <timestamp>,
  "updatedAt": <timestamp>
}
```

## UI/UX & App Features

- Modern, responsive design for all screens
- Real-time updates for tasks
- Persistent session and auto-login
- Error handling and loading states
- Intuitive navigation
- **Implemented Task: Simple UI handling (Checkbox clicks)**:
  - Added checkboxes for task status updates in `TaskListPage`.
  - Added "Remember me" checkbox in `AuthScreen` for improved UX.

## How to Use

1. Sign up or log in
2. View and manage your profile
3. Add, view, and update tasks
4. Logout securely

## Project Quality

- Follows best practices for frontend and backend logic
- Scalable Firestore schema
- Robust error handling
- Clean, maintainable code

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

Take screenshots of the app in portrait and landscape, and include them here when submitting.

## Reusable Custom Widgets

This project demonstrates reusable custom widgets placed under `lib/widgets/` and reused across screens.

Included widgets:

- `lib/widgets/info_card.dart` — `InfoCard` is a small stateless card component that displays an icon, title, subtitle and accepts an optional `onTap`.
- `lib/widgets/custom_button.dart` — `CustomButton` is a simple wrapper around `ElevatedButton` for consistent styling.

Usage examples (already wired in the app):

```dart
// Create an InfoCard
InfoCard(
	title: 'Profile',
	subtitle: 'View details',
	icon: Icons.person,
	onTap: () => Navigator.push(...),
);
```

Screens demonstrating reuse:

- `lib/screens/responsive_home.dart` — uses `InfoCard` instances in both tablet and phone layouts.
- `lib/screens/details_screen.dart` — shows a single `InfoCard` instance.

Add screenshots showing the widget reused in multiple places (place in `frontend/screenshots/`):

- `./screenshots/info_card_home.png`
- `./screenshots/info_card_details.png`

Reflection:

- Reusable widgets reduce duplication and centralize UI updates.
- Challenges: designing flexible APIs (props) so widgets are useful in multiple contexts.

Why logout is important:
Prevents unauthorized access and clears session securely.

## Stateless vs Stateful Demo

This repo includes a small demo screen that demonstrates the difference between `StatelessWidget` and `StatefulWidget`.

- `lib/screens/stateless_stateful_demo.dart` — shows a `HeaderWidget` (stateless) and `CounterColorWidget` (stateful).

How to run the demo:

1. Start the app:
```powershell
cd frontend
flutter pub get
flutter run -d <deviceId>
```
2. From the home screen tap the "toggle" icon in the AppBar to open the demo.

What to capture for submission:
- Initial UI (before interaction)
- UI after tapping `Increment` and `Toggle Color`

Reflection:

- The `HeaderWidget` is a `StatelessWidget` — it renders the title and doesn't hold mutable state.
- The `CounterColorWidget` is `StatefulWidget` — it uses `setState()` to update the counter and background color.


## Firestore Queries, Filters & Ordering

This project includes a small Firestore demo that shows how to structure queries using `where`, `orderBy` and `limit`, and how to display results in real time using `StreamBuilder`.

Example query used in `lib/screens/firestore_demo.dart`:

```dart
FirebaseFirestore.instance
  .collection('tasks')
  .where('isCompleted', isEqualTo: false)
  .orderBy('priority', descending: true)
  .limit(20)
  .snapshots();
```

This query fetches only incomplete tasks, sorts them by `priority` (highest first), and limits the results for performance.

To add test data from the app, use the "Add Test" button in the Firestore demo screen — it writes a sample document with `title`, `priority`, `isCompleted`, and `createdAt`.

Screenshots to include (place in `frontend/screenshots/`):

- `./screenshots/firestore_list.png` — App showing filtered/sorted list
- `./screenshots/firestore_console.png` — Firestore console showing `tasks` documents

Notes & Best Practices:

- If Firestore prompts for a composite index when combining `where` + `orderBy`, follow the link in the error message to create the index in the console.
- Index fields used in queries for faster reads.
- Use timestamps (`createdAt`) for stable ordering of recent items.

## Responsive Layout — Rows, Columns & Containers (Task 3.17)

This task demonstrates how to build responsive UIs in Flutter using **Row**, **Column**, **Container**, **MediaQuery**, **Expanded**, and **Flexible**.

### File

- `lib/screens/responsive_layout.dart` — Self-contained responsive screen accessible via the dashboard icon in the AppBar.

### Key Concepts Used

| Widget / API | Purpose |
|---|---|
| `Container` | Adds padding, decoration (gradients, shadows, rounded corners), and constraints |
| `Row` | Lays children out horizontally (used for wide/tablet layout) |
| `Column` | Lays children out vertically (used for narrow/phone layout) |
| `Expanded` | Fills remaining space in a Row/Column with configurable `flex` ratio |
| `MediaQuery` | Reads device width to decide layout breakpoint (`> 600 → wide`) |

### Layout Behaviour

- **Wide screens (> 600 px):** A `Row` with two `Expanded` panels (flex 2 : 1) displays main content beside a sidebar. Feature cards arrange in a horizontal `Row`.
- **Narrow screens (≤ 600 px):** Everything stacks in a single `Column`. The sidebar moves below the main content. Feature cards stack vertically.

### Code Snippet

```dart
final width = MediaQuery.of(context).size.width;
final isWide = width > 600;

// Wide → horizontal Row; Narrow → vertical Column
isWide
  ? Row(children: [
      Expanded(flex: 2, child: mainContent),
      Expanded(flex: 1, child: sidebar),
    ])
  : Column(children: [mainContent, sidebar]);
```

### How to Run

```powershell
cd frontend
flutter pub get
flutter run -d chrome        # or flutter run -d <deviceId>
```
Tap the **dashboard** icon in the AppBar to open the Responsive Layout Demo.

### Screenshots (place in `frontend/screenshots/`)

- `./screenshots/responsive_wide.png` — Wide / tablet layout
- `./screenshots/responsive_narrow.png` — Narrow / phone layout

### Reflection

- **MediaQuery** lets the app read the device's screen dimensions at build time, enabling conditional layout logic without third-party packages.
- **Expanded & Flexible** distribute remaining space proportionally, making fluid layouts straightforward.
- **Challenge:** Deciding the breakpoint value (600 px) — tested across Chrome resizes and emulator rotation to settle on a value that felt natural.


