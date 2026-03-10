import 'package:flutter/material.dart';
import '../../config/app_theme.dart';
import '../../utils/responsive.dart';
import '../../screens/create_post/create_post_screen_v2.dart';
import '../../screens/search/search_screen.dart';
import '../../screens/messages/messages_screen.dart';

class GistlyAppBar extends StatelessWidget implements PreferredSizeWidget {
  final VoidCallback? onLogoTap;
  final int unreadMessages;

  const GistlyAppBar({
    Key? key,
    this.onLogoTap,
    this.unreadMessages = 0,
  }) : super(key: key);

  @override
  Size get preferredSize => const Size.fromHeight(56);

  @override
  Widget build(BuildContext context) {
    final responsive = context.responsive;

    return Container(
      decoration: BoxDecoration(
        color: AppTheme.white,
        border: Border(
          bottom: BorderSide(
            color: AppTheme.greySoft.withOpacity(0.5),
            width: 0.5,
          ),
        ),
      ),
      child: SafeArea(
        bottom: false,
        child: SizedBox(
          height: 56,
          child: Padding(
            padding: EdgeInsets.symmetric(
              horizontal: responsive.sp(16),
            ),
            child: Row(
              children: [
                // Left Section - Logo
                _buildLogo(context, responsive),

                const Spacer(),

                // Right Section - Actions
                _buildActions(context, responsive),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLogo(BuildContext context, Responsive responsive) {
    return InkWell(
      onTap: onLogoTap ?? () {
        // Scroll to top functionality
        // This will be handled by the parent widget
      },
      borderRadius: BorderRadius.circular(8),
      child: Padding(
        padding: EdgeInsets.symmetric(
          vertical: responsive.sp(8),
          horizontal: responsive.sp(4),
        ),
        child: Image.asset(
          'assets/images/gistly logo.png',
          height: responsive.sp(32),
          fit: BoxFit.contain,
        ),
      ),
    );
  }

  Widget _buildActions(BuildContext context, Responsive responsive) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Add Post Icon
        _AddPostButton(responsive: responsive),

        SizedBox(width: responsive.sp(12)),

        // Search Widget
        _SearchWidget(responsive: responsive),

        SizedBox(width: responsive.sp(12)),

        // DM Icon
        _DMButton(
          responsive: responsive,
          unreadCount: unreadMessages,
        ),
      ],
    );
  }
}

// Add Post Button
class _AddPostButton extends StatelessWidget {
  final Responsive responsive;

  const _AddPostButton({required this.responsive});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const CreatePostScreenV2(),
            ),
          );
        },
        borderRadius: BorderRadius.circular(20),
        child: Container(
          width: responsive.sp(40),
          height: responsive.sp(40),
          child: Icon(
            Icons.add_box_outlined,
            size: responsive.sp(28),
            color: AppTheme.textPrimary,
          ),
        ),
      ),
    );
  }
}

// Search Widget
class _SearchWidget extends StatelessWidget {
  final Responsive responsive;

  const _SearchWidget({required this.responsive});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const SearchScreen(),
            ),
          );
        },
        borderRadius: BorderRadius.circular(20),
        child: Container(
          height: responsive.sp(40),
          padding: EdgeInsets.symmetric(
            horizontal: responsive.sp(16),
          ),
          decoration: BoxDecoration(
            color: AppTheme.greySoft.withOpacity(0.7),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.search,
                size: responsive.sp(20),
                color: AppTheme.greyMedium,
              ),
              SizedBox(width: responsive.sp(8)),
              Text(
                'Search',
                style: TextStyle(
                  fontSize: responsive.sp(14),
                  color: AppTheme.greyMedium,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// DM Button with Badge
class _DMButton extends StatelessWidget {
  final Responsive responsive;
  final int unreadCount;

  const _DMButton({
    required this.responsive,
    required this.unreadCount,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const MessagesScreen(),
            ),
          );
        },
        borderRadius: BorderRadius.circular(20),
        child: Container(
          width: responsive.sp(40),
          height: responsive.sp(40),
          child: Stack(
            children: [
              Center(
                child: Icon(
                  Icons.chat_bubble_outline,
                  size: responsive.sp(24),
                  color: AppTheme.textPrimary,
                ),
              ),
              // Notification badge
              if (unreadCount > 0)
                Positioned(
                  top: responsive.sp(6),
                  right: responsive.sp(6),
                  child: Container(
                    constraints: BoxConstraints(
                      minWidth: responsive.sp(16),
                    ),
                    height: responsive.sp(16),
                    padding: EdgeInsets.symmetric(
                      horizontal: responsive.sp(4),
                    ),
                    decoration: BoxDecoration(
                      color: AppTheme.alertOrange,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: AppTheme.white,
                        width: 1.5,
                      ),
                    ),
                    child: Center(
                      child: Text(
                        unreadCount > 99 ? '99+' : '$unreadCount',
                        style: TextStyle(
                          fontSize: responsive.sp(9),
                          fontWeight: FontWeight.w700,
                          color: AppTheme.white,
                          height: 1.2,
                        ),
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
