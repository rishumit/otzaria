# Fluent UI Migration - Quick Reference

## What is this?

Otzaria now uses **Fluent UI** (Windows design language) on Windows, while keeping **Material Design** on other platforms (Android, iOS, Linux, macOS).

This provides a native Windows experience while maintaining platform consistency elsewhere.

## Quick Start

### Using Adaptive Widgets

Instead of using Material widgets directly, use the adaptive wrappers:

| Material Widget | Adaptive Widget | Fluent Equivalent |
|----------------|----------------|-------------------|
| `IconButton` | `OtIconButton` | `Button` |
| `TextField` | `OtTextField` | `TextBox` |
| `Switch` | `OtSwitch` | `ToggleSwitch` |
| `Checkbox` | `OtCheckbox` | `Checkbox` |
| `AlertDialog` | `AdaptiveAlertDialog` | `ContentDialog` |
| `showDialog()` | `showAdaptiveDialog()` | `showDialog()` (Fluent) |

### Example Code

```dart
import 'package:otzaria/widgets/adaptive/adaptive_widgets.dart';

// ✅ Good - adapts automatically
OtIconButton(
  icon: Icon(Icons.search),
  onPressed: () => search(),
)

// ❌ Bad - always Material even on Windows
IconButton(
  icon: Icon(Icons.search),
  onPressed: () => search(),
)
```

### Dialogs

```dart
import 'package:otzaria/widgets/dialogs/app_dialogs.dart';

// These now automatically adapt to Fluent on Windows:
showSingleActionDialog(context: context, title: 'הודעה', content: 'תוכן');
showTwoActionsDialog(context: context, title: 'שאלה', content: 'להמשיך?');
showWarningDialog(context: context, title: 'אזהרה', content: 'זהירות!');
```

## Architecture

```
┌─────────────────────────────────────────┐
│          Application Code               │
│    (uses adaptive widgets & themes)     │
└─────────────────┬───────────────────────┘
                  │
      ┌───────────▼───────────┐
      │  useFluentDesign()?   │
      └───────────┬───────────┘
                  │
       ┌──────────┴──────────┐
       │                     │
   YES (Windows)         NO (other)
       │                     │
       ▼                     ▼
┌──────────────┐    ┌──────────────┐
│  Fluent UI   │    │  Material 3  │
│  Components  │    │  Components  │
└──────────────┘    └──────────────┘
```

## File Organization

```
lib/
├── utils/
│   └── design_system.dart              # useFluentDesign()
├── theme/
│   ├── fluent_theme_builder.dart       # Material→Fluent sync
│   └── fluent/
│       └── accent_from_seed.dart       # Color generation
├── widgets/
│   ├── adaptive/                        # ⭐ Adaptive widgets
│   │   ├── adaptive_widgets.dart       # Export file
│   │   ├── ot_icon_button.dart
│   │   ├── ot_text_field.dart
│   │   ├── ot_switch.dart
│   │   └── ot_checkbox.dart
│   ├── dialogs/
│   │   ├── adaptive_dialog.dart        # ⭐ Adaptive dialogs
│   │   └── app_dialogs.dart            # Updated to use adaptive
│   └── navigation/
│       └── fluent_nav_rail_column.dart # ⭐ Fluent nav rail
└── app.dart                             # FluentApp/MaterialApp wrapper
```

## Testing

```bash
# Run Fluent migration tests
flutter test test/theme/fluent/

# Smoke test
flutter test test/theme/fluent/fluent_migration_smoke_test.dart

# Theme tests
flutter test test/theme/fluent/fluent_theme_builder_test.dart
flutter test test/theme/fluent/accent_from_seed_test.dart
```

## Migration Status

✅ **Completed:**
- App wrapper (FluentApp on Windows)
- Navigation rail
- Dialogs (AlertDialog → ContentDialog)
- Form controls (TextField, Switch, Checkbox)
- Icon buttons
- Theme synchronization
- Dark mode support

🚧 **TODO (future):**
- Dropdown → ComboBox
- Slider → Slider (Fluent)
- RadioButton → RadioButton (Fluent)
- Tabs → TabView
- Progress indicators → ProgressBar/ProgressRing

## Common Pitfalls

### 1. Forgetting to use adaptive widgets

```dart
// ❌ Wrong - Material everywhere
IconButton(icon: Icon(Icons.add), onPressed: ...)

// ✅ Right - adapts to platform
OtIconButton(icon: Icon(Icons.add), onPressed: ...)
```

### 2. Hardcoding colors

```dart
// ❌ Wrong - breaks theme consistency
color: Colors.blue

// ✅ Right - adapts to theme
color: Theme.of(context).colorScheme.primary
```

### 3. Using showDialog directly

```dart
// ❌ Wrong - always Material
showDialog(context: context, builder: (_) => AlertDialog(...))

// ✅ Right - adapts to platform
showAdaptiveDialog(context: context, builder: (_) => AdaptiveAlertDialog(...))
```

## Documentation

See [`fluent_migration_guide.md`](./fluent_migration_guide.md) for comprehensive documentation including:
- Detailed architecture
- All migration phases
- Usage examples
- WCAG compliance notes
- Troubleshooting guide

## Questions?

1. Check the full guide: [`fluent_migration_guide.md`](./fluent_migration_guide.md)
2. Look at existing code in `lib/widgets/adaptive/`
3. Run the smoke tests to verify your changes work
