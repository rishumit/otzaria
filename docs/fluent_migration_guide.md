# Fluent UI Migration Guide

## Overview

This guide documents the incremental migration of Otzaria from Material Design to Fluent UI on Windows platform, while maintaining Material Design on other platforms (Android, iOS, Linux, macOS).

## Architecture

### Design Philosophy

- **Platform-Adaptive**: Windows uses Fluent UI, all other platforms use Material Design
- **Incremental Migration**: Components migrate one by one, not a big-bang rewrite
- **Visual Consistency**: Colors and themes sync between Material and Fluent
- **Zero Breaking Changes**: Existing code continues to work without modification

### Key Components

#### 1. Design System (`lib/utils/design_system.dart`)

```dart
bool useFluentDesign(BuildContext context) {
  return Platform.isWindows && context.mounted;
}
```

Central function that determines which design system to use based on platform.

#### 2. Adaptive Widgets (`lib/widgets/adaptive/`)

Wrapper widgets that automatically switch between Material and Fluent based on platform:

- **OtIconButton**: Material IconButton ↔ Fluent Button
- **OtTextField**: Material TextField ↔ Fluent TextBox
- **OtSwitch**: Material Switch ↔ Fluent ToggleSwitch
- **OtCheckbox**: Material Checkbox ↔ Fluent Checkbox
- **AdaptiveAlertDialog**: Material AlertDialog ↔ Fluent ContentDialog

All exported via `lib/widgets/adaptive/adaptive_widgets.dart`.

#### 3. Theme Synchronization (`lib/theme/fluent_theme_builder.dart`)

Builds Fluent themes from Material ColorScheme to maintain visual consistency:

```dart
FluentThemeData buildLightTheme(ColorScheme colorScheme)
FluentThemeData buildDarkTheme(ColorScheme colorScheme)
```

Features:
- Syncs accent colors using `fluentAccentFromMaterialSeed()`
- Maps Material surface colors to Fluent backgrounds
- Configures NavigationPane, Button, Checkbox, ToggleSwitch themes
- Full dark mode support

#### 4. Navigation (`lib/widgets/navigation/`)

- **FluentNavRailColumn**: Fluent-style navigation rail wrapper
- **NavRailItem**: Model for navigation items (shared between Material/Fluent)

### App Structure

```
lib/
├── app.dart                           # FluentApp/MaterialApp wrapper
├── utils/
│   └── design_system.dart            # useFluentDesign()
├── theme/
│   ├── fluent_theme_builder.dart     # Material→Fluent theme sync
│   └── fluent/
│       └── accent_from_seed.dart     # Accent color generation
├── widgets/
│   ├── adaptive/                      # Adaptive widgets
│   │   ├── adaptive_widgets.dart     # Library export
│   │   ├── ot_icon_button.dart
│   │   ├── ot_text_field.dart
│   │   ├── ot_switch.dart
│   │   └── ot_checkbox.dart
│   ├── dialogs/
│   │   └── adaptive_dialog.dart      # Adaptive dialog wrapper
│   └── navigation/
│       ├── fluent_nav_rail_column.dart
│       └── nav_rail_item.dart
└── navigation/view/
    └── main_window_screen.dart       # Uses adaptive components
```

## Migration Phases

### Phase 0: Foundation ✅
- Added `fluent_ui` dependency
- Created `design_system.dart` with `useFluentDesign()`
- Set up basic infrastructure

### Phase 1: FluentApp Wrapper ✅
- Wrapped app in `FluentApp` on Windows
- Maintained `MaterialApp` on other platforms
- Created basic Fluent theme from Material seed color

### Phase 2: Incremental Migration ✅

#### 2.1: Navigation Rail
- Created `FluentNavRailColumn` wrapper
- Added `OtIconButton` adaptive button
- Updated `main_window_screen.dart` with conditional navigation rail

#### 2.2: Bottom App Bar → CommandBar
- Migrated BottomAppBar to Fluent CommandBar on Windows
- Used adaptive OtIconButton for toolbar actions

#### 2.3: Dialogs
- Created `showAdaptiveDialog()` wrapper
- Built `AdaptiveAlertDialog` widget
- Updated `app_dialogs.dart` to use adaptive dialogs

#### 2.4-2.6: Form Controls
- Created `OtTextField` (TextField ↔ TextBox)
- Created `OtSwitch` + `OtSwitchListTile` (Switch ↔ ToggleSwitch)
- Created `OtCheckbox` + `OtCheckboxListTile` (Checkbox ↔ Checkbox)

### Phase 3: Theme Integration ✅
- Built `FluentThemeBuilder` for full color synchronization
- Configured all Fluent component themes (NavigationPane, Button, etc.)
- Added comprehensive dark mode support
- Updated `app.dart` to use FluentThemeBuilder

### Phase 4: Testing & Documentation ✅ (in progress)
- Created smoke tests (`fluent_migration_smoke_test.dart`)
- Created comprehensive tests for theme builder
- Created accent color generation tests
- Documented migration architecture (this file)

## Usage Guide

### Using Adaptive Widgets

```dart
import 'package:otzaria/widgets/adaptive/adaptive_widgets.dart';

// Adaptive icon button
OtIconButton(
  icon: Icon(Icons.search),
  onPressed: () => _handleSearch(),
)

// Adaptive text field
OtTextField(
  hintText: 'חיפוש',
  onSubmitted: (value) => _handleSubmit(value),
)

// Adaptive switch
OtSwitch(
  value: isEnabled,
  onChanged: (value) => setState(() => isEnabled = value),
)

// Adaptive checkbox
OtCheckbox(
  value: isChecked,
  onChanged: (value) => setState(() => isChecked = value ?? false),
)
```

### Using Adaptive Dialogs

```dart
import 'package:otzaria/widgets/dialogs/adaptive_dialog.dart';

// Show adaptive dialog
final result = await showAdaptiveDialog<bool>(
  context: context,
  builder: (context) => AdaptiveAlertDialog(
    title: Text('אישור'),
    content: Text('האם אתה בטוח?'),
    actions: [
      AdaptiveDialogAction(
        child: Text('ביטול'),
        onPressed: () => Navigator.pop(context, false),
      ),
      AdaptiveDialogAction(
        isPrimary: true,
        child: Text('אישור'),
        onPressed: () => Navigator.pop(context, true),
      ),
    ],
  ),
);
```

### Using Existing Dialog Functions

The existing `app_dialogs.dart` functions now automatically use Fluent on Windows:

```dart
import 'package:otzaria/widgets/dialogs/app_dialogs.dart';

// All these automatically adapt to Windows Fluent:
await showSingleActionDialog(context: context, title: 'הודעה', content: 'תוכן');
await showTwoActionsDialog(context: context, title: 'בחירה', content: 'האם להמשיך?');
await showWarningDialog(context: context, title: 'אזהרה', content: 'פעולה מסוכנת');
```

## Testing

### Running Tests

```bash
# Run all Fluent migration tests
flutter test test/theme/fluent/

# Run specific test file
flutter test test/theme/fluent/fluent_migration_smoke_test.dart

# Run with coverage
flutter test --coverage test/theme/fluent/
```

### Test Coverage

- ✅ Accent color generation (`accent_from_seed_test.dart`)
- ✅ Theme builder (`fluent_theme_builder_test.dart`)
- ✅ Smoke tests for all adaptive widgets (`fluent_migration_smoke_test.dart`)
- ✅ Integration tests for nested widgets

## WCAG Compliance

### Contrast Requirements

All accent colors generated by `fluentAccentFromMaterialSeed()` are tested for WCAG AA compliance:
- Light mode: accent colors maintain 4.5:1 contrast with light backgrounds
- Dark mode: accent colors maintain 4.5:1 contrast with dark backgrounds

See `test/theme/fluent/accent_from_seed_test.dart` for automated contrast testing.

### Accessibility Features

- RTL (Right-to-Left) support maintained across both Material and Fluent
- Keyboard navigation preserved in all adaptive widgets
- Focus indicators maintained (Material ripple ↔ Fluent focus rectangle)
- Screen reader support via semantic labels (unchanged)

### Manual Testing Required

Per WCAG guidelines, full accessibility validation requires:
1. Manual testing with screen readers (NVDA on Windows)
2. Keyboard-only navigation testing
3. Color blindness simulation testing
4. High contrast mode testing (Windows)

These cannot be automated and require human verification.

## Known Limitations

1. **Platform Detection**: `useFluentDesign()` only checks `Platform.isWindows`. Future enhancement could check Windows version to require Windows 10+.

2. **Fluent Components Not Yet Migrated**: Many components still use Material widgets even on Windows:
   - DropdownButton (future: use Fluent ComboBox)
   - Slider (future: use Fluent Slider)
   - RadioButton (future: use Fluent RadioButton)
   - Tabs (future: use Fluent TabView)
   - Progress indicators (future: use Fluent ProgressBar/ProgressRing)

3. **Custom Widgets**: App-specific custom widgets (e.g., `SettingsCard`, `ActionButton`) remain Material-styled. These will migrate incrementally as needed.

## Future Enhancements

### Short Term
- Migrate remaining form controls (Slider, Radio, Dropdown)
- Add more comprehensive integration tests on real Windows
- Create migration guide for plugin developers

### Long Term
- Automatic Fluent theme preview in settings
- Support for Mica background material on Windows 11
- WinUI 3 native controls exploration (via FFI or platform channels)

## Troubleshooting

### Issue: Widgets look Material on Windows

**Cause**: Not using adaptive widgets.

**Fix**: Replace Material widgets with adaptive equivalents:
```dart
// Before
IconButton(icon: Icon(Icons.search), onPressed: ...)

// After
OtIconButton(icon: Icon(Icons.search), onPressed: ...)
```

### Issue: Colors don't match between platforms

**Cause**: Not using theme from context.

**Fix**: Always use `Theme.of(context).colorScheme` or `FluentTheme.of(context).accentColor`:
```dart
// Correct
color: Theme.of(context).colorScheme.primary

// Wrong
color: Colors.blue
```

### Issue: Dialogs don't adapt on Windows

**Cause**: Using `showDialog()` directly instead of `showAdaptiveDialog()`.

**Fix**: Use adaptive dialog functions:
```dart
// Before
showDialog(context: context, builder: (_) => AlertDialog(...))

// After
showAdaptiveDialog(context: context, builder: (_) => AdaptiveAlertDialog(...))
```

## Contributing

When adding new components:

1. Create adaptive wrapper in `lib/widgets/adaptive/`
2. Export from `adaptive_widgets.dart`
3. Add smoke test in `fluent_migration_smoke_test.dart`
4. Update this documentation
5. Test on both Windows and non-Windows platforms

## References

- [Fluent UI Flutter Package](https://pub.dev/packages/fluent_ui)
- [Material Design 3](https://m3.material.io/)
- [Windows UI Guidelines](https://learn.microsoft.com/en-us/windows/apps/design/)
- [WCAG 2.1 Guidelines](https://www.w3.org/WAI/WCAG21/quickref/)
