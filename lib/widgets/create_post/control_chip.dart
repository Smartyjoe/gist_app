import 'package:flutter/material.dart';
import '../../config/app_theme.dart';
import '../../utils/responsive.dart';

/// Control chip component for settings like Audience, Language, etc.
/// 
/// Features:
/// - Pill-shaped design
/// - Icon + Label + Dropdown arrow
/// - Light gray background
/// - Colored icons for visual distinction
/// - Touch-friendly size
class ControlChip extends StatelessWidget {
  final IconData? icon;
  final String label;
  final Color iconColor;
  final VoidCallback onTap;
  final bool showPlus;
  final bool showDropdown;

  const ControlChip({
    Key? key,
    this.icon,
    required this.label,
    this.iconColor = AppTheme.textPrimary,
    required this.onTap,
    this.showPlus = false,
    this.showDropdown = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final responsive = context.responsive;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(responsive.sp(16)),
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: responsive.sp(12),
          vertical: responsive.sp(6),
        ),
        decoration: BoxDecoration(
          color: AppTheme.greySoft.withOpacity(0.5),
          borderRadius: BorderRadius.circular(responsive.sp(16)),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Plus icon (for "Add" actions)
            if (showPlus) ...[
              Icon(
                Icons.add,
                size: responsive.sp(16),
                color: iconColor,
              ),
              SizedBox(width: responsive.sp(4)),
            ],
            
            // Regular icon
            if (icon != null && !showPlus) ...[
              Icon(
                icon,
                size: responsive.sp(16),
                color: iconColor,
              ),
              SizedBox(width: responsive.sp(4)),
            ],
            
            // Label text
            Text(
              label,
              style: TextStyle(
                fontSize: responsive.sp(14),
                color: iconColor,
                fontWeight: FontWeight.w500,
              ),
            ),
            
            // Dropdown arrow
            if (showDropdown) ...[
              SizedBox(width: responsive.sp(4)),
              Icon(
                Icons.arrow_drop_down,
                size: responsive.sp(18),
                color: iconColor,
              ),
            ],
          ],
        ),
      ),
    );
  }
}
