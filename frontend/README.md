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
