# Kiddio Project

A Flutter-based task management application with Firebase integration.

## Recently Implemented Features

### Managing Images, Icons, and Local Assets (Sprint 3.24)

Organized, registered, and displayed local assets (images and icons) alongside Flutter's built-in Material and Cupertino icon libraries.

#### Asset Folder Structure

```
frontend/
  assets/
   ├── images/
   │    ├── logo.png
   │    ├── banner.jpg
   │    └── background.png
   └── icons/
        ├── star.png
        └── profile.png
```

#### pubspec.yaml Configuration

```yaml
flutter:
  uses-material-design: true
  assets:
    - assets/images/
    - assets/icons/
```

#### Displaying Local Images

```dart
// Simple image widget
Image.asset(
  'assets/images/logo.png',
  width: 150,
  height: 150,
  fit: BoxFit.cover,
)

// Image as a container background
Container(
  decoration: BoxDecoration(
    image: DecorationImage(
      image: AssetImage('assets/images/background.png'),
      fit: BoxFit.cover,
    ),
  ),
  child: Center(
    child: Text('Welcome to Flutter!',
        style: TextStyle(color: Colors.white, fontSize: 22)),
  ),
)
```

#### Using Built-in Icons

```dart
// Material Icons
Row(
  mainAxisAlignment: MainAxisAlignment.center,
  children: [
    Icon(Icons.star, color: Colors.amber, size: 36),
    Icon(Icons.flutter_dash, color: Colors.blue, size: 36),
    Icon(Icons.android, color: Colors.green, size: 36),
    Icon(Icons.apple, color: Colors.grey, size: 36),
  ],
)

// Cupertino (iOS) Icons
Icon(CupertinoIcons.heart_fill, color: Colors.red, size: 32)
```

#### Reflection

- **What steps are necessary to load assets correctly in Flutter?**  
  Create an organized folder under `assets/`, register each directory in `pubspec.yaml` under `flutter: assets:`, then run `flutter pub get` to refresh the build.

- **What common errors did you face while configuring pubspec.yaml?**  
  YAML is whitespace-sensitive — incorrect indentation (tabs instead of spaces, or wrong nesting level) causes silent build failures. File path mismatches between code and the actual folder also trigger "missing asset" errors.

- **How do proper asset management practices support scalability?**  
  Grouping assets into categorical sub-folders (`images/`, `icons/`, `fonts/`) keeps the project maintainable as it grows. Registering entire directories instead of individual files reduces pubspec churn when new assets are added.

---

- **UI State Handling**: 
  - Implemented checkbox-based task status management (Pending/Completed).
  - Integrated Firestore to persist status changes in real-time.
  - Added "Remember me" functionality to the Authentication screen.
- **Improved Core Flow**:
  - Restored the authentication state stream in `main.dart` to allow automatic routing between Auth and the Task List.

For more details, see the [frontend/README.md](frontend/README.md).