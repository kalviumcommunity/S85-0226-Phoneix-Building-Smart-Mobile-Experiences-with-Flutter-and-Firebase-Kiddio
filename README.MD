# Kiddio

Kiddio is a Flutter app that helps caregivers and families manage tasks, profiles, and scheduling. The app uses Firebase for authentication, Firestore for structured data, and Firebase Storage for user-uploaded files.

This workspace contains the Flutter frontend in the `frontend/` folder.

## New Feature: Certification Photo Upload

Caregivers can now upload photos of their certifications from their profile. The flow is:

- Open `ProfilePage` (Profile) in the app.
- Tap **Upload Certification Photo** to open the uploader.
- Choose an existing photo or take a new picture.
- The image is uploaded to Firebase Storage under `certifications/<userId>/` and a record is written to Firestore at `users/<userId>/certifications` with the file URL.

Implementation notes:

- UI: `lib/screens/cert_upload.dart` — image picker, upload progress, and Firestore record creation.
- Profile integration: `lib/profile_page.dart` now contains a button to navigate to the uploader.
- Dependencies added to `pubspec.yaml`: `firebase_storage`, `image_picker`.

## Setup & Run

1. Ensure you have Flutter installed (compatible with SDK constraints in `pubspec.yaml`).
2. Configure Firebase for the app (Android/iOS/web): add platform configuration files and initialize Firebase in `main.dart`. The project already contains `firebase_options.dart` to help initialize Firebase.
3. Add required packages and run:

```bash
cd frontend
flutter pub get
```

4. Platform-specific setup:

- Android: add camera and storage permissions in `AndroidManifest.xml` if you plan to use the camera/pick images.
- iOS: add `NSCameraUsageDescription` and `NSPhotoLibraryUsageDescription` to `Info.plist` for camera/photo access.

5. Run the app:

```bash
flutter run
```

## Code Locations

- Upload screen: `lib/screens/cert_upload.dart`
- Profile integration: `lib/profile_page.dart`
- Firestore demo: `lib/screens/firestore_demo.dart`

## How the upload works (developer summary)

- The uploader uses `image_picker` to select or take a photo.
- The selected file is uploaded to Firebase Storage and upload progress is displayed to the user.
- After a successful upload the code saves a document under `users/<userId>/certifications` with the `url` and `uploadedAt` timestamp.

## Notes & Next Steps

- Make sure Firebase rules allow authenticated users to upload to the `certifications/` path and write to their own `users/<uid>/certifications` collection.
- Consider adding image resizing/validation on-device before upload for bandwidth.
- Optionally, surface previously uploaded certification thumbnails on the Profile screen.

## Sprint 2 Demo: Hot Reload, Debug Console, DevTools

This repository now includes a quick demonstration in `frontend/lib/screens/home_tab.dart`:
- A demo counter with `debugPrint()` logs.
- A text box at the top designed for fast Hot Reload iteration.
- Task list stays live from Firestore.

### How to run the demo
1. Open terminal and run:
   ```bash
   cd frontend
   flutter pub get
   flutter run
   ```
2. When app is running, open the Home tab.
3. Tap “Increment Demo Counter” and watch logs in the Debug Console.
4. Change any UI text in `home_tab.dart` and save; use Hot Reload (`r` in terminal or ⚡ button in VS Code).
5. Open DevTools from VS Code command palette ("Flutter: Open DevTools") to inspect widgets, performance, and memory.

### What to capture for submission
- Screenshot after Hot Reload showing changed text.
- Screenshot of Debug Console showing `demo counter incremented` messages.
- Screenshot of Flutter DevTools Widget Inspector or Performance view.

### Reflection
- **Hot Reload** improves productivity by applying UI/code changes instantly without full restart.
- **Debug Console** gives real-time runtime visibility for state changes and errors via `debugPrint()`.
- **DevTools** helps inspect widget hierarchy and optimize performance, especially in team debugging.

If you need, I can also add a short `DEMO.md` file with one-command steps and sample screenshots for your PR description.

If you want, I can:

- Add a thumbnail list of uploaded certifications to the profile page.
- Add server-side validation or rules snippets to the README.

---
Updated: certification photo upload feature added and README expanded.