import 'package:flutter/material.dart';
import '../../config/app_theme.dart';
import '../../utils/responsive.dart';
import 'action_item.dart';

/// Bottom action sheet component inspired by Facebook.
/// 
/// Features:
/// - Rounded top corners
/// - Drag handle for visual affordance
/// - Elevated with shadow
/// - Contains list of action items
/// - Can be draggable (when wrapped in GestureDetector)
class ActionSheet extends StatelessWidget {
  final List<ActionSheetItem> items;
  final double? height;

  const ActionSheet({
    Key? key,
    required this.items,
    this.height,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final responsive = context.responsive;

    return Container(
      height: height,
      decoration: BoxDecoration(
        color: AppTheme.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(responsive.sp(20)),
          topRight: Radius.circular(responsive.sp(20)),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Drag Handle
          SizedBox(height: responsive.sp(8)),
          Container(
            width: responsive.sp(40),
            height: responsive.sp(4),
            decoration: BoxDecoration(
              color: AppTheme.greyMedium.withOpacity(0.5),
              borderRadius: BorderRadius.circular(responsive.sp(2)),
            ),
          ),
          SizedBox(height: responsive.sp(16)),
          
          // Action Items
          Flexible(
            child: ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: items.length,
              itemBuilder: (context, index) {
                final item = items[index];
                return ActionItem(
                  icon: item.icon,
                  label: item.label,
                  color: item.color,
                  onTap: item.onTap,
                  enabled: item.enabled,
                );
              },
            ),
          ),
          
          SizedBox(height: responsive.sp(16)),
        ],
      ),
    );
  }
}

/// Data model for action sheet items
class ActionSheetItem {
  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback onTap;
  final bool enabled;

  const ActionSheetItem({
    required this.icon,
    required this.label,
    required this.color,
    required this.onTap,
    this.enabled = true,
  });
}
