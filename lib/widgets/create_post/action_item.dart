import 'package:flutter/material.dart';
import '../../config/app_theme.dart';
import '../../utils/responsive.dart';

/// Action item component for the bottom action sheet.
/// 
/// Features:
/// - Colored circular icon background
/// - Label text
/// - Touch-friendly 56px height
/// - Ripple effect on tap
/// - Clean spacing
class ActionItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback onTap;
  final bool enabled;

  const ActionItem({
    Key? key,
    required this.icon,
    required this.label,
    required this.color,
    required this.onTap,
    this.enabled = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final responsive = context.responsive;

    return InkWell(
      onTap: enabled ? onTap : null,
      child: Container(
        height: responsive.sp(56),
        padding: EdgeInsets.symmetric(
          horizontal: responsive.sp(20),
        ),
        child: Row(
          children: [
            // Circular icon container
            Container(
              width: responsive.sp(40),
              height: responsive.sp(40),
              decoration: BoxDecoration(
                color: enabled 
                  ? color.withOpacity(0.1)
                  : AppTheme.greySoft,
                shape: BoxShape.circle,
              ),
              child: Icon(
                icon,
                color: enabled ? color : AppTheme.greyMedium,
                size: responsive.sp(24),
              ),
            ),
            
            SizedBox(width: responsive.sp(16)),
            
            // Label
            Expanded(
              child: Text(
                label,
                style: TextStyle(
                  fontSize: responsive.sp(16),
                  color: enabled ? AppTheme.textPrimary : AppTheme.greyMedium,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
