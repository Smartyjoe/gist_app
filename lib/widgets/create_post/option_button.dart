import 'package:flutter/material.dart';
import '../../config/app_theme.dart';
import '../../utils/responsive.dart';

class OptionButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;
  final Color? iconColor;
  final bool showBadge;

  const OptionButton({
    Key? key,
    required this.icon,
    required this.label,
    required this.onTap,
    this.iconColor,
    this.showBadge = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final responsive = context.responsive;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(AppTheme.radiusMedium),
      child: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: responsive.sp(8),
          vertical: responsive.sp(10),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Stack(
              clipBehavior: Clip.none,
              children: [
                Icon(
                  icon,
                  size: responsive.sp(22),
                  color: iconColor ?? AppTheme.greyMedium,
                ),
                if (showBadge)
                  Positioned(
                    top: -2,
                    right: -2,
                    child: Container(
                      width: responsive.sp(8),
                      height: responsive.sp(8),
                      decoration: const BoxDecoration(
                        color: AppTheme.greenPrimary,
                        shape: BoxShape.circle,
                      ),
                    ),
                  ),
              ],
            ),
            SizedBox(width: responsive.sp(6)),
            Flexible(
              child: Text(
                label,
                style: TextStyle(
                  fontSize: responsive.sp(13),
                  color: AppTheme.textPrimary,
                  fontWeight: FontWeight.w500,
                ),
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
