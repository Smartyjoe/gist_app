import 'package:intl/intl.dart';

enum PostType { text, video, audio, status }

enum PostPriority { normal, highRisk, emergency }

class Post {
  final String id;
  final String userId;
  final String userName;
  final String? userAvatar;
  final String content;
  final PostType type;
  final PostPriority priority;
  final String? mediaUrl;
  final String? thumbnailUrl;
  final double? mediaDuration; // For video/audio in seconds
  final String? location;
  final double? latitude;
  final double? longitude;
  final String category;
  final List<String> tags;
  final int likes;
  final int comments;
  final int shares;
  final bool isLiked;
  final DateTime createdAt;
  final DateTime? expiresAt; // For status posts (24h)
  final String language;

  Post({
    required this.id,
    required this.userId,
    required this.userName,
    this.userAvatar,
    required this.content,
    required this.type,
    this.priority = PostPriority.normal,
    this.mediaUrl,
    this.thumbnailUrl,
    this.mediaDuration,
    this.location,
    this.latitude,
    this.longitude,
    required this.category,
    this.tags = const [],
    this.likes = 0,
    this.comments = 0,
    this.shares = 0,
    this.isLiked = false,
    required this.createdAt,
    this.expiresAt,
    this.language = 'en',
  });

  bool get isExpired {
    if (expiresAt == null) return false;
    return DateTime.now().isAfter(expiresAt!);
  }

  bool get isHighPriority =>
      priority == PostPriority.highRisk || priority == PostPriority.emergency;

  String get formattedDate {
    final now = DateTime.now();
    final difference = now.difference(createdAt);

    if (difference.inMinutes < 1) return 'Just now';
    if (difference.inMinutes < 60) return '${difference.inMinutes}m ago';
    if (difference.inHours < 24) return '${difference.inHours}h ago';
    if (difference.inDays < 7) return '${difference.inDays}d ago';
    return DateFormat('MMM d, yyyy').format(createdAt);
  }

  String get priorityLabel {
    switch (priority) {
      case PostPriority.emergency:
        return 'EMERGENCY';
      case PostPriority.highRisk:
        return 'HIGH RISK';
      case PostPriority.normal:
        return '';
    }
  }

  Post copyWith({
    String? id,
    String? userId,
    String? userName,
    String? userAvatar,
    String? content,
    PostType? type,
    PostPriority? priority,
    String? mediaUrl,
    String? thumbnailUrl,
    double? mediaDuration,
    String? location,
    double? latitude,
    double? longitude,
    String? category,
    List<String>? tags,
    int? likes,
    int? comments,
    int? shares,
    bool? isLiked,
    DateTime? createdAt,
    DateTime? expiresAt,
    String? language,
  }) {
    return Post(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      userName: userName ?? this.userName,
      userAvatar: userAvatar ?? this.userAvatar,
      content: content ?? this.content,
      type: type ?? this.type,
      priority: priority ?? this.priority,
      mediaUrl: mediaUrl ?? this.mediaUrl,
      thumbnailUrl: thumbnailUrl ?? this.thumbnailUrl,
      mediaDuration: mediaDuration ?? this.mediaDuration,
      location: location ?? this.location,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      category: category ?? this.category,
      tags: tags ?? this.tags,
      likes: likes ?? this.likes,
      comments: comments ?? this.comments,
      shares: shares ?? this.shares,
      isLiked: isLiked ?? this.isLiked,
      createdAt: createdAt ?? this.createdAt,
      expiresAt: expiresAt ?? this.expiresAt,
      language: language ?? this.language,
    );
  }
}
