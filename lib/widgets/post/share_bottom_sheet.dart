import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../config/app_theme.dart';
import '../../utils/responsive.dart';
import '../../models/post.dart';

class ShareBottomSheet extends StatelessWidget {
  final Post post;

  const ShareBottomSheet({
    Key? key,
    required this.post,
  }) : super(key: key);

  void _handleShare(BuildContext context, String platform) {
    Navigator.pop(context);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Sharing to $platform...'),
        backgroundColor: AppTheme.greenPrimary,
        duration: const Duration(seconds: 2),
      ),
    );
  }

  void _copyLink(BuildContext context) {
    Clipboard.setData(ClipboardData(text: 'https://communityapp.com/post/${post.id}'));
    Navigator.pop(context);
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Link copied to clipboard'),
        backgroundColor: AppTheme.greenPrimary,
        duration: Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final responsive = context.responsive;

    return Container(
      decoration: BoxDecoration(
        color: AppTheme.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(responsive.sp(AppTheme.radiusLarge)),
          topRight: Radius.circular(responsive.sp(AppTheme.radiusLarge)),
        ),
      ),
      child: SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Handle bar
            SizedBox(height: responsive.sp(12)),
            Container(
              width: responsive.sp(40),
              height: responsive.sp(4),
              decoration: BoxDecoration(
                color: AppTheme.greyMedium,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            SizedBox(height: responsive.sp(20)),

            // Title
            Padding(
              padding: EdgeInsets.symmetric(horizontal: responsive.sp(20)),
              child: Row(
                children: [
                  Text(
                    'Share Post',
                    style: TextStyle(
                      fontSize: responsive.sp(20),
                      fontWeight: FontWeight.w700,
                      color: AppTheme.textPrimary,
                    ),
                  ),
                  const Spacer(),
                  IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () => Navigator.pop(context),
                    iconSize: responsive.sp(24),
                  ),
                ],
              ),
            ),
            SizedBox(height: responsive.sp(12)),

            // Share options grid
            Padding(
              padding: EdgeInsets.symmetric(horizontal: responsive.sp(20)),
              child: Column(
                children: [
                  // Row 1: Social media
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      _ShareOption(
                        icon: Icons.message,
                        label: 'WhatsApp',
                        color: const Color(0xFF25D366),
                        onTap: () => _handleShare(context, 'WhatsApp'),
                        responsive: responsive,
                      ),
                      _ShareOption(
                        icon: Icons.facebook,
                        label: 'Facebook',
                        color: const Color(0xFF1877F2),
                        onTap: () => _handleShare(context, 'Facebook'),
                        responsive: responsive,
                      ),
                      _ShareOption(
                        icon: Icons.telegram,
                        label: 'Telegram',
                        color: const Color(0xFF0088CC),
                        onTap: () => _handleShare(context, 'Telegram'),
                        responsive: responsive,
                      ),
                      _ShareOption(
                        icon: Icons.send,
                        label: 'Twitter',
                        color: const Color(0xFF1DA1F2),
                        onTap: () => _handleShare(context, 'Twitter'),
                        responsive: responsive,
                      ),
                    ],
                  ),
                  SizedBox(height: responsive.sp(20)),

                  // Row 2: More options
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      _ShareOption(
                        icon: Icons.email,
                        label: 'Email',
                        color: AppTheme.greyMedium,
                        onTap: () => _handleShare(context, 'Email'),
                        responsive: responsive,
                      ),
                      _ShareOption(
                        icon: Icons.sms,
                        label: 'SMS',
                        color: AppTheme.greenPrimary,
                        onTap: () => _handleShare(context, 'SMS'),
                        responsive: responsive,
                      ),
                      _ShareOption(
                        icon: Icons.link,
                        label: 'Copy Link',
                        color: AppTheme.textPrimary,
                        onTap: () => _copyLink(context),
                        responsive: responsive,
                      ),
                      _ShareOption(
                        icon: Icons.more_horiz,
                        label: 'More',
                        color: AppTheme.greyMedium,
                        onTap: () => _handleShare(context, 'More'),
                        responsive: responsive,
                      ),
                    ],
                  ),
                ],
              ),
            ),
            SizedBox(height: responsive.sp(20)),

            Divider(height: 1, color: AppTheme.greySoft),

            // Send to friend
            ListTile(
              leading: Container(
                padding: EdgeInsets.all(responsive.sp(8)),
                decoration: BoxDecoration(
                  color: AppTheme.greenPrimary.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.person_add,
                  color: AppTheme.greenPrimary,
                  size: responsive.sp(24),
                ),
              ),
              title: Text(
                'Send to a Friend',
                style: TextStyle(
                  fontSize: responsive.sp(16),
                  fontWeight: FontWeight.w600,
                  color: AppTheme.textPrimary,
                ),
              ),
              subtitle: Text(
                'Share with someone in the app',
                style: TextStyle(
                  fontSize: responsive.sp(13),
                  color: AppTheme.greyMedium,
                ),
              ),
              trailing: Icon(
                Icons.arrow_forward_ios,
                size: responsive.sp(16),
                color: AppTheme.greyMedium,
              ),
              onTap: () {
                // TODO: Show user list to send to
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Friend list coming soon!'),
                    backgroundColor: AppTheme.greenPrimary,
                  ),
                );
              },
            ),

            // Report post
            ListTile(
              leading: Container(
                padding: EdgeInsets.all(responsive.sp(8)),
                decoration: BoxDecoration(
                  color: AppTheme.alertOrange.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.flag,
                  color: AppTheme.alertOrange,
                  size: responsive.sp(24),
                ),
              ),
              title: Text(
                'Report Post',
                style: TextStyle(
                  fontSize: responsive.sp(16),
                  fontWeight: FontWeight.w600,
                  color: AppTheme.alertOrange,
                ),
              ),
              subtitle: Text(
                'Report inappropriate content',
                style: TextStyle(
                  fontSize: responsive.sp(13),
                  color: AppTheme.greyMedium,
                ),
              ),
              trailing: Icon(
                Icons.arrow_forward_ios,
                size: responsive.sp(16),
                color: AppTheme.greyMedium,
              ),
              onTap: () {
                // TODO: Show report dialog
                Navigator.pop(context);
                _showReportDialog(context);
              },
            ),

            SizedBox(height: responsive.sp(12)),
          ],
        ),
      ),
    );
  }

  void _showReportDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Report Post'),
        content: const Text(
          'Are you sure you want to report this post as inappropriate?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Post reported. Thank you for your feedback.'),
                  backgroundColor: AppTheme.greenPrimary,
                ),
              );
            },
            child: const Text(
              'Report',
              style: TextStyle(color: AppTheme.alertOrange),
            ),
          ),
        ],
      ),
    );
  }
}

class _ShareOption extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback onTap;
  final Responsive responsive;

  const _ShareOption({
    required this.icon,
    required this.label,
    required this.color,
    required this.onTap,
    required this.responsive,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(responsive.sp(12)),
      child: Container(
        width: responsive.sp(70),
        padding: EdgeInsets.symmetric(vertical: responsive.sp(8)),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: EdgeInsets.all(responsive.sp(12)),
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(
                icon,
                size: responsive.sp(28),
                color: color,
              ),
            ),
            SizedBox(height: responsive.sp(8)),
            Text(
              label,
              style: TextStyle(
                fontSize: responsive.sp(12),
                color: AppTheme.textPrimary,
                fontWeight: FontWeight.w500,
              ),
              textAlign: TextAlign.center,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }
}
