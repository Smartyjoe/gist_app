enum NotificationType {
  like,
  comment,
  share,
  follow,
  emergencyAlert,
  highRiskAlert,
  systemUpdate,
}

class NotificationModel {
  final String id;
  final String title;
  final String message;
  final NotificationType type;
  final String? userId;
  final String? userName;
  final String? userAvatar;
  final String? postId;
  final String? actionUrl;
  final bool isRead;
  final DateTime createdAt;

  NotificationModel({
    required this.id,
    required this.title,
    required this.message,
    required this.type,
    this.userId,
    this.userName,
    this.userAvatar,
    this.postId,
    this.actionUrl,
    this.isRead = false,
    required this.createdAt,
  });

  bool get isAlert =>
      type == NotificationType.emergencyAlert ||
      type == NotificationType.highRiskAlert;

  String get formattedTime {
    final now = DateTime.now();
    final difference = now.difference(createdAt);

    if (difference.inMinutes < 1) return 'Just now';
    if (difference.inMinutes < 60) return '${difference.inMinutes}m ago';
    if (difference.inHours < 24) return '${difference.inHours}h ago';
    if (difference.inDays < 7) return '${difference.inDays}d ago';
    return '${difference.inDays}d ago';
  }

  NotificationModel copyWith({
    String? id,
    String? title,
    String? message,
    NotificationType? type,
    String? userId,
    String? userName,
    String? userAvatar,
    String? postId,
    String? actionUrl,
    bool? isRead,
    DateTime? createdAt,
  }) {
    return NotificationModel(
      id: id ?? this.id,
      title: title ?? this.title,
      message: message ?? this.message,
      type: type ?? this.type,
      userId: userId ?? this.userId,
      userName: userName ?? this.userName,
      userAvatar: userAvatar ?? this.userAvatar,
      postId: postId ?? this.postId,
      actionUrl: actionUrl ?? this.actionUrl,
      isRead: isRead ?? this.isRead,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
