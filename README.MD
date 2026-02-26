# Kiddio Project

A Flutter-based task management application with Firebase integration.

## Recently Implemented Features
- **UI State Handling**: 
  - Implemented checkbox-based task status management (Pending/Completed).
  - Integrated Firestore to persist status changes in real-time.
  - Added "Remember me" functionality to the Authentication screen.
- **Improved Core Flow**:
  - Restored the authentication state stream in `main.dart` to allow automatic routing between Auth and the Task List.

For more details, see the [frontend/README.md](frontend/README.md).

## Caregiver Search Screen

- **File:** [frontend/lib/screens/caregiver_search.dart](frontend/lib/screens/caregiver_search.dart)
- **Description:** A simple caregiver search UI that reads documents from the Firestore `caregivers` collection and displays results in a `ListView.separated`. The search box performs client-side, case-insensitive filtering by name, skills, or location.
- **Usage:** To show the screen in the app you can push it from anywhere in your Flutter app, for example:

  ```dart
  Navigator.of(context).push(
    MaterialPageRoute(builder: (_) => const CaregiverSearch()),
  );
  ```

  Ensure your Firestore collection `caregivers` contains documents with fields like `name`, `skills`, `location`, and optionally `rating`.