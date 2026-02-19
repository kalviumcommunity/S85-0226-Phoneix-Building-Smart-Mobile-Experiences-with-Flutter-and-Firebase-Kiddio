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
