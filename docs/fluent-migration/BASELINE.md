# Fluent Migration — Baseline

**ענף בסיס:** main (fork dev)
**commit בסיס:** ללא commits עדיין — קוד הועתק ישירות
**תאריך:** 8 בספטמבר 2026
**`fluent_ui`:** 4.16.1
**Flutter:** 3.47.2

---

## מדדי קו הבסיס

ימולאו אחרי הרצת CI הראשונה על ענף `fluent/spike-phase0`.

| מדד | ערך |
|---|---|
| `flutter analyze` issues | _ימולא מ-CI_ |
| מספר טסטים עוברים | _ימולא מ-CI_ |
| `flutter build windows --release` | _ימולא מ-CI_ |

---

## ספירות נקודת פתיחה (נבדק ב-`1e3429e` / fork dev)

| רכיב | מופעים |
|---|---|
| קבצים מייבאים `flutter/material.dart` | 319 |
| קריאות `Theme.of(context)` | 763 |
| `IconButton` | 195 |
| `showDialog` | 96 |
| `Tooltip` | 95 |
| `InkWell` | 82 |
| `TextButton`/`FilledButton`/`OutlinedButton` | 89 |
| `Divider` | 50 |
| `ListTile` | 44 |
| `TabBar`+`TabBarView` | 39 |
| `Scaffold` | 35 |
| `AlertDialog` | 34 |
| `Switch` | 28 |
| `Checkbox` | 25 |
| `Card` | 17 |
| `TextField` | 15 |
| `ExpansionTile` | 11 |
| `Slider` | 8 |
| `AppBar` | 9 |
| `PopupMenuButton` | 3 |

---

## קריטריוני מעבר — Spike (שלב 1)

- [ ] האפליקציה עולה ב-Windows ומגיעה למסך הראשי בלי `No Material widget found`
- [ ] פתיחת ספר טקסט + ספר PDF + חיפוש — עובדים
- [ ] `flutter test` — אותו מספר עובר כמו ב-BASELINE
- [ ] `flutter build apk --debug` — עובר (Android לא נשבר)
- [ ] `flutter build linux --debug` — עובר (Linux לא נשבר)
- [ ] `--dart-define=OTZARIA_FLUENT=false` — חוזר ל-Material זהה לחלוטין
