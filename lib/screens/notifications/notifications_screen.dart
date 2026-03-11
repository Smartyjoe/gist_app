import 'package:flutter/material.dart';
import '../../models/notification.dart';
import '../../config/app_theme.dart';
import '../../utils/responsive.dart';

class NotificationsScreen extends StatefulWidget {
  const NotificationsScreen({super.key});

  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  final List<NotificationModel> _notifications = [
    // Alerts
    NotificationModel(
      id: 'a1', title: 'EMERGENCY ALERT',
      message: 'Fire outbreak at Oshodi Market. Emergency services deployed. Stay away from the area.',
      type: NotificationType.emergencyAlert, postId: 'p1',
      createdAt: DateTime.now().subtract(const Duration(minutes: 5)),
    ),
    NotificationModel(
      id: 'a2', title: 'HIGH RISK ALERT',
      message: 'Major flooding on Lekki-Epe Expressway. Road completely blocked. Seek alternative routes.',
      type: NotificationType.highRiskAlert, postId: 'p2',
      createdAt: DateTime.now().subtract(const Duration(minutes: 22)),
    ),
    NotificationModel(
      id: 'a3', title: 'EMERGENCY ALERT',
      message: 'Gas leak reported near Yaba market area. Residents advised to evacuate immediately.',
      type: NotificationType.emergencyAlert, postId: 'p3',
      createdAt: DateTime.now().subtract(const Duration(hours: 1)),
    ),
    // Social — today
    NotificationModel(
      id: 's1', title: 'New follower',
      message: 'Adewale Johnson started following you',
      type: NotificationType.follow,
      userId: 'u1', userName: 'Adewale Johnson',
      userAvatar: 'https://i.pravatar.cc/150?img=1',
      createdAt: DateTime.now().subtract(const Duration(minutes: 35)),
    ),
    NotificationModel(
      id: 's2', title: 'New like',
      message: 'Chioma Obi liked your post about the bridge situation',
      type: NotificationType.like,
      userId: 'u2', userName: 'Chioma Obi',
      userAvatar: 'https://i.pravatar.cc/150?img=2',
      postId: 'p4', isRead: true,
      createdAt: DateTime.now().subtract(const Duration(hours: 2)),
    ),
    NotificationModel(
      id: 's3', title: 'New comment',
      message: 'Emeka: "This is exactly what I reported last week! Thanks for sharing 🙏"',
      type: NotificationType.comment,
      userId: 'u3', userName: 'Emeka Okafor',
      userAvatar: 'https://i.pravatar.cc/150?img=3',
      postId: 'p5', isRead: true,
      createdAt: DateTime.now().subtract(const Duration(hours: 3)),
    ),
    NotificationModel(
      id: 's4', title: 'Post shared',
      message: 'Fatima Hassan shared your flooding report with 3 groups',
      type: NotificationType.share,
      userId: 'u4', userName: 'Fatima Hassan',
      userAvatar: 'https://i.pravatar.cc/150?img=4',
      postId: 'p2', isRead: true,
      createdAt: DateTime.now().subtract(const Duration(hours: 5)),
    ),
    NotificationModel(
      id: 's5', title: 'New like',
      message: 'Bola Adeyemi and 47 others liked your post',
      type: NotificationType.like,
      userId: 'u5', userName: 'Bola Adeyemi',
      userAvatar: 'https://i.pravatar.cc/150?img=6',
      postId: 'p1', isRead: true,
      createdAt: DateTime.now().subtract(const Duration(hours: 7)),
    ),
    // Yesterday
    NotificationModel(
      id: 's6', title: 'New follower',
      message: 'Ngozi Obi started following you',
      type: NotificationType.follow,
      userId: 'u6', userName: 'Ngozi Obi',
      userAvatar: 'https://i.pravatar.cc/150?img=7',
      isRead: true,
      createdAt: DateTime.now().subtract(const Duration(days: 1, hours: 2)),
    ),
    NotificationModel(
      id: 's7', title: 'New comment',
      message: 'Tunde: "The authorities need to act on this immediately!"',
      type: NotificationType.comment,
      userId: 'u7', userName: 'Tunde Bakare',
      userAvatar: 'https://i.pravatar.cc/150?img=8',
      postId: 'p3', isRead: true,
      createdAt: DateTime.now().subtract(const Duration(days: 1, hours: 5)),
    ),
    NotificationModel(
      id: 'sys1', title: 'Your post is trending',
      message: 'Your report on the Lekki flooding has been viewed 10,000+ times and is trending in Lagos.',
      type: NotificationType.systemUpdate,
      postId: 'p2', isRead: true,
      createdAt: DateTime.now().subtract(const Duration(days: 1, hours: 8)),
    ),
    // Earlier
    NotificationModel(
      id: 's8', title: 'New like',
      message: 'Amina Yusuf liked your comment',
      type: NotificationType.like,
      userId: 'u8', userName: 'Amina Yusuf',
      userAvatar: 'https://i.pravatar.cc/150?img=9',
      postId: 'p5', isRead: true,
      createdAt: DateTime.now().subtract(const Duration(days: 3)),
    ),
    NotificationModel(
      id: 'sys2', title: 'Welcome to Gistly!',
      message: 'Your account is verified. Start reporting community incidents and make a difference.',
      type: NotificationType.systemUpdate, isRead: true,
      createdAt: DateTime.now().subtract(const Duration(days: 5)),
    ),
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  int get _unreadCount => _notifications.where((n) => !n.isRead).length;

  List<NotificationModel> get _allNotifs => _notifications;
  List<NotificationModel> get _unreadNotifs =>
      _notifications.where((n) => !n.isRead).toList();
  List<NotificationModel> get _alertNotifs =>
      _notifications.where((n) => n.isAlert).toList();
  List<NotificationModel> get _activityNotifs =>
      _notifications.where((n) => !n.isAlert).toList();

  void _markAllAsRead() {
    setState(() {
      for (int i = 0; i < _notifications.length; i++) {
        _notifications[i] = _notifications[i].copyWith(isRead: true);
      }
    });
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('All notifications marked as read'),
        behavior: SnackBarBehavior.floating,
        duration: Duration(seconds: 2),
      ),
    );
  }

  void _deleteNotification(String id) {
    setState(() => _notifications.removeWhere((n) => n.id == id));
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('Notification removed'),
        behavior: SnackBarBehavior.floating,
        duration: const Duration(seconds: 2),
        action: SnackBarAction(label: 'Undo', onPressed: () {}),
      ),
    );
  }

  void _markAsRead(String id) {
    setState(() {
      final i = _notifications.indexWhere((n) => n.id == id);
      if (i != -1) {
        _notifications[i] = _notifications[i].copyWith(isRead: true);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final responsive = context.responsive;

    return Scaffold(
      backgroundColor: AppTheme.background,
      appBar: AppBar(
        backgroundColor: AppTheme.white,
        elevation: 0,
        automaticallyImplyLeading: false,
        title: Text('Notifications',
            style: TextStyle(
                fontSize: responsive.sp(20),
                fontWeight: FontWeight.w800,
                color: AppTheme.textPrimary)),
        actions: [
          if (_unreadCount > 0)
            TextButton(
              onPressed: _markAllAsRead,
              child: Text('Mark all read',
                  style: TextStyle(
                      fontSize: responsive.sp(13),
                      color: AppTheme.greenPrimary,
                      fontWeight: FontWeight.w600)),
            ),
          SizedBox(width: responsive.sp(4)),
        ],
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(responsive.sp(44)),
          child: Column(
            children: [
              Divider(height: 1, color: AppTheme.greySoft),
              TabBar(
                controller: _tabController,
                indicatorColor: AppTheme.greenPrimary,
                indicatorWeight: 2,
                labelColor: AppTheme.greenPrimary,
                unselectedLabelColor: AppTheme.greyMedium,
                labelStyle: TextStyle(
                    fontSize: responsive.sp(12), fontWeight: FontWeight.w700),
                unselectedLabelStyle: TextStyle(
                    fontSize: responsive.sp(12), fontWeight: FontWeight.w500),
                tabs: [
                  const Tab(text: 'All'),
                  Tab(
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Text('Unread'),
                        if (_unreadCount > 0) ...[
                          SizedBox(width: responsive.sp(4)),
                          Container(
                            padding: EdgeInsets.symmetric(
                                horizontal: responsive.sp(5),
                                vertical: responsive.sp(1)),
                            decoration: BoxDecoration(
                              color: AppTheme.greenPrimary,
                              borderRadius:
                                  BorderRadius.circular(responsive.sp(10)),
                            ),
                            child: Text('$_unreadCount',
                                style: TextStyle(
                                    color: AppTheme.white,
                                    fontSize: responsive.sp(9),
                                    fontWeight: FontWeight.w800)),
                          ),
                        ],
                      ],
                    ),
                  ),
                  Tab(
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Text('Alerts'),
                        SizedBox(width: responsive.sp(4)),
                        Container(
                          padding: EdgeInsets.symmetric(
                              horizontal: responsive.sp(5),
                              vertical: responsive.sp(1)),
                          decoration: BoxDecoration(
                            color: const Color(0xFFD32F2F),
                            borderRadius:
                                BorderRadius.circular(responsive.sp(10)),
                          ),
                          child: Text('${_alertNotifs.length}',
                              style: TextStyle(
                                  color: AppTheme.white,
                                  fontSize: responsive.sp(9),
                                  fontWeight: FontWeight.w800)),
                        ),
                      ],
                    ),
                  ),
                  const Tab(text: 'Activity'),
                ],
              ),
            ],
          ),
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _NotifList(
            notifications: _allNotifs,
            onDelete: _deleteNotification,
            onRead: _markAsRead,
            responsive: responsive,
          ),
          _NotifList(
            notifications: _unreadNotifs,
            onDelete: _deleteNotification,
            onRead: _markAsRead,
            responsive: responsive,
            emptyMessage: 'You\'re all caught up!',
            emptyIcon: Icons.done_all_rounded,
          ),
          _NotifList(
            notifications: _alertNotifs,
            onDelete: _deleteNotification,
            onRead: _markAsRead,
            responsive: responsive,
            emptyMessage: 'No active alerts',
            emptyIcon: Icons.shield_outlined,
          ),
          _NotifList(
            notifications: _activityNotifs,
            onDelete: _deleteNotification,
            onRead: _markAsRead,
            responsive: responsive,
            emptyMessage: 'No activity yet',
            emptyIcon: Icons.notifications_none_outlined,
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Notification List with time grouping
// ─────────────────────────────────────────────────────────────────────────────

class _NotifList extends StatelessWidget {
  final List<NotificationModel> notifications;
  final void Function(String) onDelete;
  final void Function(String) onRead;
  final Responsive responsive;
  final String emptyMessage;
  final IconData emptyIcon;

  const _NotifList({
    required this.notifications,
    required this.onDelete,
    required this.onRead,
    required this.responsive,
    this.emptyMessage = 'No notifications',
    this.emptyIcon = Icons.notifications_none_outlined,
  });

  String _groupLabel(DateTime t) {
    final now = DateTime.now();
    final diff = now.difference(t);
    if (diff.inDays == 0) return 'Today';
    if (diff.inDays == 1) return 'Yesterday';
    if (diff.inDays <= 7) return 'This week';
    return 'Earlier';
  }

  @override
  Widget build(BuildContext context) {
    if (notifications.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(emptyIcon, size: responsive.sp(52), color: AppTheme.greyMedium),
            SizedBox(height: responsive.sp(12)),
            Text(emptyMessage,
                style: TextStyle(
                    fontSize: responsive.sp(15),
                    color: AppTheme.greyMedium,
                    fontWeight: FontWeight.w500)),
          ],
        ),
      );
    }

    // Group by time
    final groups = <String, List<NotificationModel>>{};
    for (final n in notifications) {
      final label = _groupLabel(n.createdAt);
      groups.putIfAbsent(label, () => []).add(n);
    }

    final groupOrder = ['Today', 'Yesterday', 'This week', 'Earlier'];
    final orderedGroups = groupOrder
        .where((g) => groups.containsKey(g))
        .map((g) => MapEntry(g, groups[g]!))
        .toList();

    return ListView.builder(
      padding: EdgeInsets.only(
          top: responsive.sp(8), bottom: responsive.sp(24)),
      itemCount: orderedGroups.fold<int>(0, (sum, e) => sum + 1 + e.value.length),
      itemBuilder: (context, index) {
        // Flatten groups into a single list with headers
        int cursor = 0;
        for (final entry in orderedGroups) {
          if (index == cursor) {
            return _GroupHeader(label: entry.key, responsive: responsive);
          }
          cursor++;
          final itemIndex = index - cursor;
          if (itemIndex < entry.value.length) {
            return _NotifTile(
              notification: entry.value[itemIndex],
              onDelete: onDelete,
              onRead: onRead,
              responsive: responsive,
            );
          }
          cursor += entry.value.length;
        }
        return const SizedBox.shrink();
      },
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Group Header
// ─────────────────────────────────────────────────────────────────────────────

class _GroupHeader extends StatelessWidget {
  final String label;
  final Responsive responsive;
  const _GroupHeader({required this.label, required this.responsive});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(
          responsive.sp(16), responsive.sp(12), responsive.sp(16), responsive.sp(4)),
      child: Text(
        label,
        style: TextStyle(
          fontSize: responsive.sp(12),
          fontWeight: FontWeight.w700,
          color: AppTheme.greyMedium,
          letterSpacing: 0.5,
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Notification Tile
// ─────────────────────────────────────────────────────────────────────────────

class _NotifTile extends StatelessWidget {
  final NotificationModel notification;
  final void Function(String) onDelete;
  final void Function(String) onRead;
  final Responsive responsive;

  const _NotifTile({
    required this.notification,
    required this.onDelete,
    required this.onRead,
    required this.responsive,
  });

  // ── Icon / avatar ────────────────────────────────────────────────────────

  Widget _buildLeading() {
    final n = notification;
    final r = responsive;

    // Alert icon
    if (n.isAlert) {
      final isEmergency = n.type == NotificationType.emergencyAlert;
      final color = isEmergency
          ? const Color(0xFFD32F2F)
          : const Color(0xFFF57C00);
      return Container(
        width: r.sp(46),
        height: r.sp(46),
        decoration: BoxDecoration(
          color: color.withOpacity(0.12),
          shape: BoxShape.circle,
        ),
        child: Icon(
          isEmergency ? Icons.emergency_rounded : Icons.warning_amber_rounded,
          color: color,
          size: r.sp(26),
        ),
      );
    }

    // System notification
    if (n.type == NotificationType.systemUpdate) {
      return Container(
        width: r.sp(46),
        height: r.sp(46),
        decoration: BoxDecoration(
          color: AppTheme.greenPrimary.withOpacity(0.1),
          shape: BoxShape.circle,
        ),
        child: Icon(Icons.campaign_outlined,
            color: AppTheme.greenPrimary, size: r.sp(24)),
      );
    }

    // Social with avatar + action badge
    if (n.userAvatar != null) {
      Color badgeColor;
      IconData badgeIcon;
      switch (n.type) {
        case NotificationType.like:
          badgeColor = Colors.red;
          badgeIcon = Icons.favorite_rounded;
          break;
        case NotificationType.comment:
          badgeColor = AppTheme.greenPrimary;
          badgeIcon = Icons.chat_bubble_rounded;
          break;
        case NotificationType.share:
          badgeColor = Colors.blue;
          badgeIcon = Icons.share_rounded;
          break;
        case NotificationType.follow:
          badgeColor = AppTheme.greenPrimary;
          badgeIcon = Icons.person_add_rounded;
          break;
        default:
          badgeColor = AppTheme.greyMedium;
          badgeIcon = Icons.notifications_rounded;
      }

      return SizedBox(
        width: r.sp(46),
        height: r.sp(46),
        child: Stack(
          children: [
            CircleAvatar(
              radius: r.sp(21),
              backgroundColor: AppTheme.greySoft,
              backgroundImage: NetworkImage(n.userAvatar!),
            ),
            Positioned(
              bottom: 0, right: 0,
              child: Container(
                width: r.sp(18),
                height: r.sp(18),
                decoration: BoxDecoration(
                  color: badgeColor,
                  shape: BoxShape.circle,
                  border: Border.all(color: AppTheme.white, width: 1.5),
                ),
                child: Icon(badgeIcon, color: Colors.white, size: r.sp(10)),
              ),
            ),
          ],
        ),
      );
    }

    // Generic icon fallback
    return Container(
      width: r.sp(46),
      height: r.sp(46),
      decoration: BoxDecoration(
        color: AppTheme.greyMedium.withOpacity(0.1),
        shape: BoxShape.circle,
      ),
      child: Icon(Icons.notifications_outlined,
          color: AppTheme.greyMedium, size: r.sp(22)),
    );
  }

  // ── Action buttons ────────────────────────────────────────────────────────

  Widget? _buildActions(BuildContext context) {
    final n = notification;
    final r = responsive;

    if (n.type == NotificationType.follow) {
      return SizedBox(
        height: r.sp(30),
        child: ElevatedButton(
          onPressed: () => ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Following ${n.userName}'),
              behavior: SnackBarBehavior.floating,
              duration: const Duration(seconds: 2),
            ),
          ),
          style: ElevatedButton.styleFrom(
            backgroundColor: AppTheme.greenPrimary,
            foregroundColor: AppTheme.white,
            elevation: 0,
            padding: EdgeInsets.symmetric(horizontal: r.sp(16)),
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(r.sp(8))),
          ),
          child: Text('Follow back',
              style: TextStyle(
                  fontSize: r.sp(12), fontWeight: FontWeight.w700)),
        ),
      );
    }

    if (n.postId != null &&
        (n.type == NotificationType.like ||
            n.type == NotificationType.comment ||
            n.type == NotificationType.share)) {
      return SizedBox(
        height: r.sp(30),
        child: OutlinedButton(
          onPressed: () => ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Opening post...'),
              behavior: SnackBarBehavior.floating,
            ),
          ),
          style: OutlinedButton.styleFrom(
            foregroundColor: AppTheme.textPrimary,
            side: const BorderSide(color: AppTheme.greySoft),
            padding: EdgeInsets.symmetric(horizontal: r.sp(12)),
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(r.sp(8))),
          ),
          child: Text('View post',
              style: TextStyle(
                  fontSize: r.sp(12), fontWeight: FontWeight.w600)),
        ),
      );
    }

    if (n.isAlert && n.postId != null) {
      return SizedBox(
        height: r.sp(30),
        child: ElevatedButton(
          onPressed: () => ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Opening alert post...'),
              behavior: SnackBarBehavior.floating,
            ),
          ),
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFFD32F2F),
            foregroundColor: AppTheme.white,
            elevation: 0,
            padding: EdgeInsets.symmetric(horizontal: r.sp(12)),
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(r.sp(8))),
          ),
          child: Text('View alert',
              style: TextStyle(
                  fontSize: r.sp(12), fontWeight: FontWeight.w700)),
        ),
      );
    }

    return null;
  }

  // ── Priority colour for alerts ────────────────────────────────────────────

  Color? get _alertAccent {
    if (!notification.isAlert) return null;
    return notification.type == NotificationType.emergencyAlert
        ? const Color(0xFFD32F2F)
        : const Color(0xFFF57C00);
  }

  @override
  Widget build(BuildContext context) {
    final n = notification;
    final r = responsive;
    final accent = _alertAccent;
    final actions = _buildActions(context);

    return Dismissible(
      key: Key(n.id),
      direction: DismissDirection.endToStart,
      background: Container(
        color: Colors.red.shade400,
        alignment: Alignment.centerRight,
        padding: EdgeInsets.only(right: r.sp(20)),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.delete_outline, color: Colors.white, size: r.sp(22)),
            SizedBox(height: r.sp(2)),
            Text('Delete',
                style: TextStyle(
                    color: Colors.white,
                    fontSize: r.sp(10),
                    fontWeight: FontWeight.w600)),
          ],
        ),
      ),
      onDismissed: (_) => onDelete(n.id),
      child: InkWell(
        onTap: () => onRead(n.id),
        child: Container(
          decoration: BoxDecoration(
            color: n.isRead
                ? AppTheme.white
                : (accent ?? AppTheme.greenPrimary).withOpacity(0.04),
            border: accent != null
                ? Border(left: BorderSide(color: accent, width: 3))
                : null,
          ),
          padding: EdgeInsets.fromLTRB(
              r.sp(accent != null ? 13 : 16),
              r.sp(12),
              r.sp(16),
              r.sp(12)),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Leading icon/avatar
              _buildLeading(),

              SizedBox(width: r.sp(12)),

              // Content
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Title row + unread dot
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Text(
                            n.isAlert
                                ? n.title
                                : _buildRichTitle(n),
                            style: TextStyle(
                              fontSize: r.sp(13),
                              fontWeight: n.isRead
                                  ? FontWeight.w500
                                  : FontWeight.w700,
                              color: accent ?? AppTheme.textPrimary,
                              letterSpacing: n.isAlert ? 0.4 : 0,
                            ),
                          ),
                        ),
                        if (!n.isRead)
                          Container(
                            width: r.sp(8),
                            height: r.sp(8),
                            margin: EdgeInsets.only(
                                top: r.sp(4), left: r.sp(6)),
                            decoration: BoxDecoration(
                              color: accent ?? AppTheme.greenPrimary,
                              shape: BoxShape.circle,
                            ),
                          ),
                      ],
                    ),

                    SizedBox(height: r.sp(3)),

                    // Message
                    Text(
                      n.message,
                      style: TextStyle(
                        fontSize: r.sp(12),
                        color: AppTheme.textSecondary,
                        height: 1.4,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),

                    SizedBox(height: r.sp(6)),

                    // Time + action button row
                    Row(
                      children: [
                        Icon(Icons.access_time,
                            size: r.sp(11), color: AppTheme.greyMedium),
                        SizedBox(width: r.sp(3)),
                        Text(n.formattedTime,
                            style: TextStyle(
                                fontSize: r.sp(11),
                                color: AppTheme.greyMedium)),
                        if (actions != null) ...[
                          SizedBox(width: r.sp(12)),
                          actions,
                        ],
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _buildRichTitle(NotificationModel n) {
    switch (n.type) {
      case NotificationType.like:
        return '${n.userName ?? 'Someone'} liked your post';
      case NotificationType.comment:
        return '${n.userName ?? 'Someone'} commented';
      case NotificationType.share:
        return '${n.userName ?? 'Someone'} shared your post';
      case NotificationType.follow:
        return '${n.userName ?? 'Someone'} followed you';
      case NotificationType.systemUpdate:
        return n.title;
      default:
        return n.title;
    }
  }
}
