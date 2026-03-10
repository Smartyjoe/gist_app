import 'package:flutter/material.dart';
import '../../config/app_theme.dart';
import '../../utils/responsive.dart';

class ContentTypeButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool isSelected;
  final VoidCallback onTap;
  final Color? activeColor;

  const ContentTypeButton({
    Key? key,
    required this.icon,
    required this.label,
    this.isSelected = false,
    required this.onTap,
    this.activeColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final responsive = context.responsive;
    final color = isSelected 
        ? (activeColor ?? AppTheme.greenPrimary)
        : AppTheme.greyMedium;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(AppTheme.radiusMedium),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: EdgeInsets.symmetric(
          horizontal: responsive.sp(12),
          vertical: responsive.sp(8),
        ),
        decoration: BoxDecoration(
          color: isSelected 
              ? (activeColor ?? AppTheme.greenPrimary).withOpacity(0.1)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(AppTheme.radiusMedium),
          border: Border.all(
            color: isSelected 
                ? (activeColor ?? AppTheme.greenPrimary)
                : AppTheme.greySoft,
            width: 1.5,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              size: responsive.sp(20),
              color: color,
            ),
            SizedBox(width: responsive.sp(6)),
            Text(
              label,
              style: TextStyle(
                fontSize: responsive.sp(13),
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                color: color,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
