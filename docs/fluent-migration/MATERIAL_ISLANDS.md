# Material Islands

איים של `Material()` שנדרשים בתוך `FluentApp` כי החבילות הצד-שלישי שלהם
תלויות ב-`Material` widget אב.

כל אי עוטף ברמה הגבוהה ביותר של תת-העץ ה"זר", לא פר-widget:

```dart
Material(
  type: MaterialType.transparency,  // בלי רקע משלו
  child: QuillEditor(...),
)
```

---

| אי | קבצים | חבילה | מתי אפשר להסיר |
|---|---|---|---|
| עורך ההערות | `lib/personal_notes/` | `flutter_quill` | כשיש מקביל Fluent לעורך עשיר |
| תצוגת הדפסה | `lib/printing/` | `printing` | כשיש מקביל Fluent |
| דיאלוג עדכון | `lib/update/` | `updat` | כשיחליפו בפתרון פנימי |
| Markdown | 2 קבצים | `flutter_markdown` | כשיחליפו ב-widget פנימי |
| Split view | 1 קובץ | `multi_split_view` | כשיחליפו ב-widget פנימי |

---

**הערה:** `toggle_switch` ו-`flutter_spinbox` **לא** נעטפים — הם יוסרו
מ-`pubspec.yaml` ויוחלפו ב-`ToggleSwitch` ו-`NumberBox` של `fluent_ui`.
