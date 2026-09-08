import 'package:flutter/material.dart' as m;
import 'package:fluent_ui/fluent_ui.dart' as f;
import 'package:otzaria/theme/app_tokens.dart';
import 'package:otzaria/widgets/misc/rtl_icon.dart';
import 'package:otzaria_icons/otzaria_icons.dart';

/// גרסת Fluent של NavRailColumn — מחליפה את NavRailItem+AnimatedContainer
/// ב-PaneItem styled widgets עם אפקטים של WinUI3.
///
/// ממשק זהה לחלוטין ל-NavRailColumn כדי שה-call site ב-MainWindowScreen
/// יוכל לבחור ביניהם לפי useFluentDesign בלי שינוי נוסף.
class FluentNavRailColumn extends m.StatelessWidget {
  const FluentNavRailColumn({
    super.key,
    required this.items,
    required this.bottomItem,
  });

  final List<FluentNavRailItem> items;
  final FluentNavRailItem bottomItem;

  @override
  m.Widget build(m.BuildContext context) {
    final allItems = [...items, bottomItem];

    return m.LayoutBuilder(
      builder: (context, constraints) {
        return m.SingleChildScrollView(
          child: m.ConstrainedBox(
            constraints: m.BoxConstraints(
              minHeight: constraints.maxHeight.isFinite
                  ? constraints.maxHeight
                  : 0,
            ),
            child: m.IntrinsicHeight(
              child: m.Column(
                children: [
                  ...items.map((item) => _FluentNavItem(item: item)),
                  const m.Spacer(),
                  _FluentNavItem(item: bottomItem),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

/// נתוני פריט ניווט לסרגל Fluent
class FluentNavRailItem {
  final m.IconData? icon;
  final m.IconData? iconFilled;
  final String? imageAsset;
  final String label;
  final bool isSelected;
  final m.VoidCallback onTap;
  final String? tooltip;
  final m.Key? tourTargetKey;
  final m.Key? tourItemKey;
  final bool isTourHighlighted;
  final bool compact;

  const FluentNavRailItem({
    this.icon,
    this.iconFilled,
    this.imageAsset,
    required this.label,
    required this.isSelected,
    required this.onTap,
    this.tooltip,
    this.tourTargetKey,
    this.tourItemKey,
    this.isTourHighlighted = false,
    this.compact = false,
  }) : assert(
         icon != null || imageAsset != null,
         'FluentNavRailItem requires icon or imageAsset',
       );
}

class _FluentNavItem extends m.StatelessWidget {
  const _FluentNavItem({required this.item});
  final FluentNavRailItem item;

  @override
  m.Widget build(m.BuildContext context) {
    final cs = m.Theme.of(context).colorScheme;

    final isSelected = item.isSelected;
    final iconColor = isSelected ? cs.onSecondaryContainer : cs.onSurfaceVariant;

    // ── אייקון ──────────────────────────────────────────────────────────
    m.Widget iconWidget;
    if (item.imageAsset != null) {
      iconWidget = m.ImageIcon(
        m.AssetImage(item.imageAsset!),
        size: 24,
        color: iconColor,
      );
    } else {
      final activeIcon =
          isSelected && item.iconFilled != null ? item.iconFilled! : item.icon!;
      iconWidget = _buildIcon(activeIcon, iconColor);
    }

    final double width = item.compact
        ? _kFluentNavCompactWidth
        : _kFluentNavWidth;

    m.Widget button = m.SizedBox(
      key: item.tourItemKey,
      width: width,
      child: m.Padding(
        padding: const m.EdgeInsets.symmetric(vertical: 4),
        child: m.Column(
          mainAxisSize: m.MainAxisSize.min,
          children: [
            // ── Active Indicator ─────────────────────────────────────
            m.AnimatedScale(
              scale: isSelected ? 1.0 : 0.95,
              duration: const Duration(milliseconds: 200),
              curve: m.Curves.easeInOutCubicEmphasized,
              child: m.AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                curve: m.Curves.easeInOutCubicEmphasized,
                decoration: m.BoxDecoration(
                  color: isSelected
                      ? cs.secondaryContainer
                      : item.isTourHighlighted
                      ? cs.primary.withAlpha((0.08 * 255).round())
                      : m.Colors.transparent,
                  borderRadius: AppTokens.borderRadiusAll,
                ),
                child: f.IconButton(
                  key: item.tourTargetKey,
                  onPressed: item.onTap,
                  icon: m.IconTheme(
                    data: m.IconThemeData(color: iconColor, size: 24),
                    child: iconWidget,
                  ),
                  style: const f.ButtonStyle(
                    backgroundColor:
                        f.WidgetStatePropertyAll(m.Colors.transparent),
                    shape: f.WidgetStatePropertyAll(
                      m.RoundedRectangleBorder(
                        borderRadius: AppTokens.borderRadiusAll,
                      ),
                    ),
                  ),
                ),
              ),
            ),
            const m.SizedBox(height: 2),
            // ── תווית ──────────────────────────────────────────────
            m.AnimatedDefaultTextStyle(
              duration: const Duration(milliseconds: 200),
              curve: m.Curves.easeInOutCubicEmphasized,
              style: m.TextStyle(
                fontSize: 11,
                color: isSelected
                    ? cs.onSecondaryContainer
                    : item.isTourHighlighted
                    ? cs.primary
                    : cs.onSurfaceVariant,
                fontWeight: item.isTourHighlighted
                    ? m.FontWeight.bold
                    : m.FontWeight.normal,
              ),
              child: m.Text(
                item.label,
                textAlign: m.TextAlign.center,
                overflow: m.TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );

    if (item.tooltip != null) {
      button = f.Tooltip(
        message: item.tooltip!,
        child: button,
      );
    }

    return button;
  }

  m.Widget _buildIcon(m.IconData icon, m.Color color) {
    if (icon.fontPackage == OtzariaIcons.fontPackage) {
      return m.Icon(icon, size: 24, color: color);
    }
    return RtlIcon(icon, size: 24, color: color);
  }
}

const double _kFluentNavWidth = 74;
const double _kFluentNavCompactWidth = 60;
