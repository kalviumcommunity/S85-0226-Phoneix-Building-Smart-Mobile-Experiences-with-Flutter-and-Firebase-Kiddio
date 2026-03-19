# 3.23 Responsive Design (MediaQuery + LayoutBuilder)

## What was implemented

A dedicated responsive screen was added:
- File: `lib/screens/responsive_design_screen.dart`
- Route: `/responsive-design`
- Access: Home tab AppBar button

This screen demonstrates both:
- `MediaQuery` for proportional sizing (padding, font, card heights, orientation awareness)
- `LayoutBuilder` for conditional layout structure (mobile vs tablet)

## How the UI adapts

- Mobile (`maxWidth < 700`): vertical list dashboard
- Tablet/Desktop (`maxWidth >= 700`): split layout with sidebar + card grid

## Key snippet

```dart
final media = MediaQuery.of(context);
final screenWidth = media.size.width;

body: LayoutBuilder(
  builder: (context, constraints) {
    final isMobileLayout = constraints.maxWidth < 700;
    return isMobileLayout ? mobileWidget : tabletWidget;
  },
)
```

## Demo steps (for video)

1. Run app on a phone-size device and open `Responsive Design Demo`.
2. Show the mobile list layout and screen metrics.
3. Run app on a tablet-size device and open the same screen.
4. Show the tablet split layout and explain that `LayoutBuilder` changed structure.
5. Rotate device and show that spacing/heights adapt using `MediaQuery`.

## Reflection prompts

- Why responsive design matters:
  It prevents overflow, improves readability, and supports a wider device range.

- MediaQuery vs LayoutBuilder:
  `MediaQuery` reads device-level metrics; `LayoutBuilder` reacts to parent constraints and switches widget structures.

- Team scalability:
  Shared breakpoints and reusable responsive widgets make cross-feature UI consistency easier.
