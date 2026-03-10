import 'package:flutter/material.dart';
import '../../config/app_theme.dart';
import '../../utils/responsive.dart';

class BottomNavBar extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTap;
  final bool showNotificationBadge;

  const BottomNavBar({
    super.key,
    required this.currentIndex,
    required this.onTap,
    this.showNotificationBadge = false,
  });

  @override
  Widget build(BuildContext context) {
    final responsive = context.responsive;

    return Container(
      decoration: BoxDecoration(
        color: AppTheme.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: responsive.horizontalPadding,
            vertical: responsive.sp(AppTheme.spacing8),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _NavItem(
                icon: Icons.home,
                label: 'Home',
                isActive: currentIndex == 0,
                onTap: () => onTap(0),
                responsive: responsive,
              ),
              _NavItem(
                icon: Icons.explore,
                label: 'Explore',
                isActive: currentIndex == 1,
                onTap: () => onTap(1),
                responsive: responsive,
              ),
              _NavItem(
                icon: Icons.add_circle,
                label: 'Create',
                isActive: currentIndex == 2,
                onTap: () => onTap(2),
                responsive: responsive,
                iconSize: responsive.sp(32),
              ),
              _NavItem(
                icon: Icons.notifications,
                label: 'Alerts',
                isActive: currentIndex == 3,
                onTap: () => onTap(3),
                responsive: responsive,
                showBadge: showNotificationBadge,
              ),
              _NavItem(
                icon: Icons.person,
                label: 'Profile',
                isActive: currentIndex == 4,
                onTap: () => onTap(4),
                responsive: responsive,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _NavItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool isActive;
  final VoidCallback onTap;
  final Responsive responsive;
  final double? iconSize;
  final bool showBadge;

  const _NavItem({
    required this.icon,
    required this.label,
    required this.isActive,
    required this.onTap,
    required this.responsive,
    this.iconSize,
    this.showBadge = false,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppTheme.radiusMedium),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Stack(
              clipBehavior: Clip.none,
              children: [
                Icon(
                  icon,
                  size: iconSize ?? responsive.sp(24),
                  color: isActive ? AppTheme.greenPrimary : AppTheme.greyMedium,
                ),
                if (showBadge)
                  Positioned(
                    top: -2,
                    right: -2,
                    child: Container(
                      width: responsive.sp(8),
                      height: responsive.sp(8),
                      decoration: const BoxDecoration(
                        color: AppTheme.alertOrange,
                        shape: BoxShape.circle,
                      ),
                    ),
                  ),
              ],
            ),
            SizedBox(height: responsive.sp(2)),
            Flexible(
              child: Text(
                label,
                style: TextStyle(
                  fontSize: responsive.sp(10),
                  fontWeight: isActive ? FontWeight.w600 : FontWeight.normal,
                  color: isActive ? AppTheme.greenPrimary : AppTheme.greyMedium,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
