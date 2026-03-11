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

If you want, I can:

- Add a thumbnail list of uploaded certifications to the profile page.
- Add server-side validation or rules snippets to the README.

---
Updated: certification photo upload feature added and README expanded.