import 'package:flutter/material.dart';
import '../../models/notification.dart';
import '../../config/app_theme.dart';
import '../../utils/responsive.dart';
import '../../widgets/common/custom_app_bar.dart';

class NotificationsScreen extends StatefulWidget {
  const NotificationsScreen({super.key});

  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  final List<NotificationModel> _notifications = [
    NotificationModel(
      id: '1',
      title: 'EMERGENCY ALERT',
      message: 'Fire outbreak reported at Oshodi Market. Stay away from the area.',
      type: NotificationType.emergencyAlert,
      postId: '5',
      createdAt: DateTime.now().subtract(const Duration(minutes: 15)),
    ),
    NotificationModel(
      id: '2',
      title: 'HIGH RISK ALERT',
      message: 'Major flooding on Lekki-Epe Expressway. Avoid this route.',
      type: NotificationType.highRiskAlert,
      postId: '3',
      createdAt: DateTime.now().subtract(const Duration(hours: 2)),
    ),
    NotificationModel(
      id: '3',
      title: 'New Comment',
      message: 'Adewale commented on your post',
      type: NotificationType.comment,
      userId: 'user1',
      userName: 'Adewale',
      userAvatar: 'https://i.pravatar.cc/150?img=1',
      postId: 'post1',
      isRead: true,
      createdAt: DateTime.now().subtract(const Duration(hours: 5)),
    ),
    NotificationModel(
      id: '4',
      title: 'New Like',
      message: 'Chioma liked your post',
      type: NotificationType.like,
      userId: 'user2',
      userName: 'Chioma',
      userAvatar: 'https://i.pravatar.cc/150?img=2',
      postId: 'post2',
      isRead: true,
      createdAt: DateTime.now().subtract(const Duration(hours: 8)),
    ),
    NotificationModel(
      id: '5',
      title: 'Post Shared',
      message: 'Your post has been shared 50 times',
      type: NotificationType.share,
      postId: 'post1',
      isRead: true,
      createdAt: DateTime.now().subtract(const Duration(days: 1)),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final responsive = context.responsive;
    final alerts = _notifications.where((n) => n.isAlert).toList();
    final regular = _notifications.where((n) => !n.isAlert).toList();

    return Scaffold(
      backgroundColor: AppTheme.background,
      appBar: CustomAppBar(
        title: 'Notifications',
        actions: [
          IconButton(
            icon: Icon(Icons.done_all, size: responsive.sp(24)),
            onPressed: _markAllAsRead,
            tooltip: 'Mark all as read',
          ),
        ],
      ),
      body: ListView(
        padding: EdgeInsets.symmetric(vertical: responsive.sp(AppTheme.spacing8)),
        children: [
          // Emergency Alerts Section
          if (alerts.isNotEmpty) ...[
            _buildSectionHeader('Emergency Alerts', responsive),
            ...alerts.map((notification) => _buildNotificationCard(
                  notification,
                  responsive,
                )),
            SizedBox(height: responsive.sp(AppTheme.spacing16)),
          ],
          
          // Regular Notifications Section
          _buildSectionHeader('Recent Activity', responsive),
          ...regular.map((notification) => _buildNotificationCard(
                notification,
                responsive,
              )),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title, Responsive responsive) {
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: responsive.sp(AppTheme.spacing16),
        vertical: responsive.sp(AppTheme.spacing8),
      ),
      child: Text(
        title,
        style: TextStyle(
          fontSize: responsive.sp(16),
          fontWeight: FontWeight.w600,
          color: AppTheme.textPrimary,
        ),
      ),
    );
  }

  Widget _buildNotificationCard(
    NotificationModel notification,
    Responsive responsive,
  ) {
    return Dismissible(
      key: Key(notification.id),
      direction: DismissDirection.endToStart,
      background: Container(
        color: AppTheme.alertOrange,
        alignment: Alignment.centerRight,
        padding: EdgeInsets.only(right: responsive.sp(20)),
        child: Icon(
          Icons.delete,
          color: AppTheme.white,
          size: responsive.sp(24),
        ),
      ),
      onDismissed: (direction) {
        setState(() {
          _notifications.removeWhere((n) => n.id == notification.id);
        });
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Notification deleted')),
        );
      },
      child: Container(
        margin: EdgeInsets.symmetric(
          horizontal: responsive.sp(AppTheme.spacing16),
          vertical: responsive.sp(AppTheme.spacing4),
        ),
        decoration: BoxDecoration(
          color: notification.isRead
              ? AppTheme.white
              : AppTheme.greenPrimary.withOpacity(0.05),
          borderRadius: BorderRadius.circular(AppTheme.radiusMedium),
          border: notification.isAlert
              ? Border.all(color: AppTheme.alertOrange, width: 2)
              : Border.all(color: AppTheme.greySoft),
        ),
        child: InkWell(
          onTap: () => _handleNotificationTap(notification),
          borderRadius: BorderRadius.circular(AppTheme.radiusMedium),
          child: Padding(
            padding: EdgeInsets.all(responsive.sp(AppTheme.spacing12)),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Icon/Avatar
                _buildNotificationIcon(notification, responsive),
                
                SizedBox(width: responsive.sp(AppTheme.spacing12)),
                
                // Content
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: Text(
                              notification.title,
                              style: TextStyle(
                                fontSize: responsive.sp(14),
                                fontWeight: FontWeight.w600,
                                color: notification.isAlert
                                    ? AppTheme.alertOrange
                                    : AppTheme.textPrimary,
                              ),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          if (!notification.isRead) ...[
                            SizedBox(width: responsive.sp(8)),
                            Container(
                              width: responsive.sp(8),
                              height: responsive.sp(8),
                              margin: EdgeInsets.only(top: responsive.sp(4)),
                              decoration: const BoxDecoration(
                                color: AppTheme.greenPrimary,
                                shape: BoxShape.circle,
                              ),
                            ),
                          ],
                        ],
                      ),
                      SizedBox(height: responsive.sp(4)),
                      Text(
                        notification.message,
                        style: TextStyle(
                          fontSize: responsive.sp(13),
                          color: AppTheme.textSecondary,
                          height: 1.4,
                        ),
                      ),
                      SizedBox(height: responsive.sp(4)),
                      Text(
                        notification.formattedTime,
                        style: TextStyle(
                          fontSize: responsive.sp(11),
                          color: AppTheme.greyMedium,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildNotificationIcon(
    NotificationModel notification,
    Responsive responsive,
  ) {
    if (notification.isAlert) {
      return Container(
        width: responsive.sp(40),
        height: responsive.sp(40),
        decoration: BoxDecoration(
          color: AppTheme.alertOrange.withOpacity(0.1),
          shape: BoxShape.circle,
        ),
        child: Icon(
          Icons.warning,
          color: AppTheme.alertOrange,
          size: responsive.sp(24),
        ),
      );
    }

    if (notification.userAvatar != null) {
      return CircleAvatar(
        radius: responsive.sp(20),
        backgroundImage: NetworkImage(notification.userAvatar!),
      );
    }

    IconData iconData;
    Color iconColor;

    switch (notification.type) {
      case NotificationType.like:
        iconData = Icons.favorite;
        iconColor = AppTheme.alertOrange;
        break;
      case NotificationType.comment:
        iconData = Icons.comment;
        iconColor = AppTheme.greenPrimary;
        break;
      case NotificationType.share:
        iconData = Icons.share;
        iconColor = AppTheme.greenPrimary;
        break;
      case NotificationType.follow:
        iconData = Icons.person_add;
        iconColor = AppTheme.greenPrimary;
        break;
      default:
        iconData = Icons.notifications;
        iconColor = AppTheme.greyMedium;
    }

    return Container(
      width: responsive.sp(40),
      height: responsive.sp(40),
      decoration: BoxDecoration(
        color: iconColor.withOpacity(0.1),
        shape: BoxShape.circle,
      ),
      child: Icon(
        iconData,
        color: iconColor,
        size: responsive.sp(20),
      ),
    );
  }

  void _handleNotificationTap(NotificationModel notification) {
    setState(() {
      final index = _notifications.indexWhere((n) => n.id == notification.id);
      if (index != -1) {
        _notifications[index] = notification.copyWith(isRead: true);
      }
    });

    // Navigate to the relevant screen based on notification type
    if (notification.postId != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Opening post...')),
      );
    }
  }

  void _markAllAsRead() {
    setState(() {
      _notifications.asMap().forEach((index, notification) {
        _notifications[index] = notification.copyWith(isRead: true);
      });
    });
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('All notifications marked as read')),
    );
  }
}
