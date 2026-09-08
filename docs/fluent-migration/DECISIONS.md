# Fluent Migration — Decisions

כל סטייה מ-`otzaria-fluent-migration-agent-brief.md` + נימוק.

---

## D-001 — `_buildMaterialApp` מקבל `ThemeData` במקום `ColorScheme`

**הסיבה:** בניית `FluentThemeData` דורשת את ה-`activeTheme` המחושב (ולא רק את ה-ColorScheme),
לכן העברנו את בניית `materialTheme` / `materialDarkTheme` לפני ה-split ושיתפנו בין שתי הנתיבות.
ה-`_buildMaterialApp` מקבל `ThemeData` מוכן במקום לבנות מחדש — תוצאה זהה, ללא שכפול.

---

## D-002 — `AccentColor` ב-Spike נגזר מ-`colorScheme.primary` (לא מ-seed)

**הסיבה:** שלב 2 (מחולל `accentFromSeed`) עדיין לא ממומש. ב-Spike עוברים דרך
`colorScheme.primary` שכבר מחושב מה-seed, וזה מספיק לאימות שה-FluentApp עולה.
**שלב 2 יחליף זאת** ב-`accentFromSeed` המלא עם טסט ניגודיות WCAG AA.
