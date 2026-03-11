import 'package:intl/intl.dart';

enum LiveStatus { setup, live, ended }

enum LiveAudience { everyone, followers, friends }

class LiveComment {
  final String id;
  final String userId;
  final String userName;
  final String? userAvatar;
  final String text;
  final DateTime createdAt;
  final bool isHost;

  LiveComment({
    required this.id,
    required this.userId,
    required this.userName,
    this.userAvatar,
    required this.text,
    required this.createdAt,
    this.isHost = false,
  });

  String get formattedTime {
    final now = DateTime.now();
    final difference = now.difference(createdAt);

    if (difference.inSeconds < 60) return 'now';
    if (difference.inMinutes < 60) return '${difference.inMinutes}m ago';
    if (difference.inHours < 24) return '${difference.inHours}h ago';
    return DateFormat('MMM d').format(createdAt);
  }

  LiveComment copyWith({
    String? id,
    String? userId,
    String? userName,
    String? userAvatar,
    String? text,
    DateTime? createdAt,
    bool? isHost,
  }) {
    return LiveComment(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      userName: userName ?? this.userName,
      userAvatar: userAvatar ?? this.userAvatar,
      text: text ?? this.text,
      createdAt: createdAt ?? this.createdAt,
      isHost: isHost ?? this.isHost,
    );
  }
}

class LiveViewer {
  final String id;
  final String userName;
  final String? userAvatar;
  final DateTime joinedAt;

  LiveViewer({
    required this.id,
    required this.userName,
    this.userAvatar,
    required this.joinedAt,
  });

  LiveViewer copyWith({
    String? id,
    String? userName,
    String? userAvatar,
    DateTime? joinedAt,
  }) {
    return LiveViewer(
      id: id ?? this.id,
      userName: userName ?? this.userName,
      userAvatar: userAvatar ?? this.userAvatar,
      joinedAt: joinedAt ?? this.joinedAt,
    );
  }
}

class CoHost {
  final String id;
  final String userName;
  final String? userAvatar;
  final bool isAccepted;

  CoHost({
    required this.id,
    required this.userName,
    this.userAvatar,
    this.isAccepted = false,
  });

  CoHost copyWith({
    String? id,
    String? userName,
    String? userAvatar,
    bool? isAccepted,
  }) {
    return CoHost(
      id: id ?? this.id,
      userName: userName ?? this.userName,
      userAvatar: userAvatar ?? this.userAvatar,
      isAccepted: isAccepted ?? this.isAccepted,
    );
  }
}

class LiveModel {
  final String id;
  final String hostId;
  final String hostName;
  final String? hostAvatar;
  final String title;
  final String category;
  final LiveAudience audience;
  final LiveStatus status;
  final int viewerCount;
  final List<LiveComment> comments;
  final List<LiveViewer> viewers;
  final CoHost? coHost;
  final DateTime startedAt;
  final DateTime? endedAt;
  final String? thumbnailUrl;
  final int heartCount;

  LiveModel({
    required this.id,
    required this.hostId,
    required this.hostName,
    this.hostAvatar,
    required this.title,
    required this.category,
    this.audience = LiveAudience.everyone,
    this.status = LiveStatus.live,
    this.viewerCount = 0,
    this.comments = const [],
    this.viewers = const [],
    this.coHost,
    required this.startedAt,
    this.endedAt,
    this.thumbnailUrl,
    this.heartCount = 0,
  });

  String get formattedStartTime {
    final now = DateTime.now();
    final difference = now.difference(startedAt);

    if (difference.inSeconds < 60) return 'Just started';
    if (difference.inMinutes < 60) return '${difference.inMinutes}m ago';
    if (difference.inHours < 24) return '${difference.inHours}h ago';
    return DateFormat('MMM d, h:mm a').format(startedAt);
  }

  String get durationString {
    if (status == LiveStatus.setup) return 'Not started';

    final end = endedAt ?? DateTime.now();
    final duration = end.difference(startedAt);

    final hours = duration.inHours;
    final minutes = duration.inMinutes % 60;
    final seconds = duration.inSeconds % 60;

    if (hours > 0) {
      return '$hours:${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
    }
    return '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
  }

  bool get isLive => status == LiveStatus.live;

  bool get hasEnded => status == LiveStatus.ended;

  LiveModel copyWith({
    String? id,
    String? hostId,
    String? hostName,
    String? hostAvatar,
    String? title,
    String? category,
    LiveAudience? audience,
    LiveStatus? status,
    int? viewerCount,
    List<LiveComment>? comments,
    List<LiveViewer>? viewers,
    CoHost? coHost,
    DateTime? startedAt,
    DateTime? endedAt,
    String? thumbnailUrl,
    int? heartCount,
  }) {
    return LiveModel(
      id: id ?? this.id,
      hostId: hostId ?? this.hostId,
      hostName: hostName ?? this.hostName,
      hostAvatar: hostAvatar ?? this.hostAvatar,
      title: title ?? this.title,
      category: category ?? this.category,
      audience: audience ?? this.audience,
      status: status ?? this.status,
      viewerCount: viewerCount ?? this.viewerCount,
      comments: comments ?? this.comments,
      viewers: viewers ?? this.viewers,
      coHost: coHost ?? this.coHost,
      startedAt: startedAt ?? this.startedAt,
      endedAt: endedAt ?? this.endedAt,
      thumbnailUrl: thumbnailUrl ?? this.thumbnailUrl,
      heartCount: heartCount ?? this.heartCount,
    );
  }

  static List<LiveModel> getMockLiveStreams() {
    final now = DateTime.now();
    return [
      LiveModel(
        id: 'live_1',
        hostId: 'user_host_1',
        hostName: 'Dr. Ngozi Adeyemi',
        hostAvatar: 'https://i.pravatar.cc/150?img=10',
        title: 'Community Health Awareness Session',
        category: 'Health & Wellness',
        audience: LiveAudience.everyone,
        status: LiveStatus.live,
        viewerCount: 547,
        startedAt: now.subtract(const Duration(minutes: 15)),
        thumbnailUrl: 'https://picsum.photos/400/300?random=10',
        heartCount: 234,
        comments: getMockLiveComments().sublist(0, 3),
        viewers: [
          LiveViewer(
            id: 'viewer_1',
            userName: 'Chioma Okoro',
            userAvatar: 'https://i.pravatar.cc/150?img=1',
            joinedAt: now.subtract(const Duration(minutes: 12)),
          ),
          LiveViewer(
            id: 'viewer_2',
            userName: 'Adekunle Bankole',
            userAvatar: 'https://i.pravatar.cc/150?img=2',
            joinedAt: now.subtract(const Duration(minutes: 8)),
          ),
          LiveViewer(
            id: 'viewer_3',
            userName: 'Zainab Hassan',
            userAvatar: 'https://i.pravatar.cc/150?img=3',
            joinedAt: now.subtract(const Duration(minutes: 5)),
          ),
        ],
        coHost: CoHost(
          id: 'cohost_1',
          userName: 'Dr. Kunle Okonkwo',
          userAvatar: 'https://i.pravatar.cc/150?img=11',
          isAccepted: true,
        ),
      ),
      LiveModel(
        id: 'live_2',
        hostId: 'user_host_2',
        hostName: 'Pastor Michael Adeyemi',
        hostAvatar: 'https://i.pravatar.cc/150?img=20',
        title: 'Sunday Service - Community Prayer & Reflection',
        category: 'Spirituality',
        audience: LiveAudience.everyone,
        status: LiveStatus.live,
        viewerCount: 892,
        startedAt: now.subtract(const Duration(minutes: 45)),
        thumbnailUrl: 'https://picsum.photos/400/300?random=20',
        heartCount: 567,
        comments: getMockLiveComments().sublist(2, 5),
        viewers: [
          LiveViewer(
            id: 'viewer_4',
            userName: 'Amara Okafor',
            userAvatar: 'https://i.pravatar.cc/150?img=4',
            joinedAt: now.subtract(const Duration(minutes: 40)),
          ),
          LiveViewer(
            id: 'viewer_5',
            userName: 'Ibrahim Mustapha',
            userAvatar: 'https://i.pravatar.cc/150?img=5',
            joinedAt: now.subtract(const Duration(minutes: 35)),
          ),
        ],
      ),
      LiveModel(
        id: 'live_3',
        hostId: 'user_host_3',
        hostName: 'Fatima Ibrahim',
        hostAvatar: 'https://i.pravatar.cc/150?img=30',
        title: 'Women Entrepreneurs Meetup - Q&A Session',
        category: 'Business & Career',
        audience: LiveAudience.followers,
        status: LiveStatus.live,
        viewerCount: 234,
        startedAt: now.subtract(const Duration(minutes: 20)),
        thumbnailUrl: 'https://picsum.photos/400/300?random=30',
        heartCount: 156,
        comments: getMockLiveComments().sublist(4, 7),
        viewers: [
          LiveViewer(
            id: 'viewer_6',
            userName: 'Blessing Okonkwo',
            userAvatar: 'https://i.pravatar.cc/150?img=6',
            joinedAt: now.subtract(const Duration(minutes: 18)),
          ),
        ],
      ),
      LiveModel(
        id: 'live_4',
        hostId: 'user_host_4',
        hostName: 'Chief Olugbemi Olaniran',
        hostAvatar: 'https://i.pravatar.cc/150?img=40',
        title: 'Community Development Forum - 2024 Planning',
        category: 'Community Affairs',
        audience: LiveAudience.friends,
        status: LiveStatus.ended,
        viewerCount: 412,
        startedAt: now.subtract(const Duration(hours: 2)),
        endedAt: now.subtract(const Duration(minutes: 30)),
        thumbnailUrl: 'https://picsum.photos/400/300?random=40',
        heartCount: 289,
        comments: getMockLiveComments(),
        viewers: [
          LiveViewer(
            id: 'viewer_7',
            userName: 'Tunde Adebiyi',
            userAvatar: 'https://i.pravatar.cc/150?img=7',
            joinedAt: now.subtract(const Duration(hours: 2)),
          ),
          LiveViewer(
            id: 'viewer_8',
            userName: 'Grace Adebayo',
            userAvatar: 'https://i.pravatar.cc/150?img=8',
            joinedAt: now.subtract(const Duration(hours: 1, minutes: 55)),
          ),
        ],
      ),
    ];
  }

  static List<LiveComment> getMockLiveComments() {
    final now = DateTime.now();
    return [
      LiveComment(
        id: 'comment_1',
        userId: 'user_1',
        userName: 'Chioma Okoro',
        userAvatar: 'https://i.pravatar.cc/150?img=1',
        text: 'This is so helpful! Thank you for sharing this information.',
        createdAt: now.subtract(const Duration(minutes: 8)),
        isHost: false,
      ),
      LiveComment(
        id: 'comment_2',
        userId: 'user_host_1',
        userName: 'Dr. Ngozi Adeyemi',
        userAvatar: 'https://i.pravatar.cc/150?img=10',
        text: 'Great question! Let me explain that in more detail...',
        createdAt: now.subtract(const Duration(minutes: 6)),
        isHost: true,
      ),
      LiveComment(
        id: 'comment_3',
        userId: 'user_2',
        userName: 'Adekunle Bankole',
        userAvatar: 'https://i.pravatar.cc/150?img=2',
        text: 'When will this be available in my area? 🤔',
        createdAt: now.subtract(const Duration(minutes: 5)),
        isHost: false,
      ),
      LiveComment(
        id: 'comment_4',
        userId: 'user_3',
        userName: 'Zainab Hassan',
        userAvatar: 'https://i.pravatar.cc/150?img=3',
        text: 'Amazing session! Really learning a lot here. 👏',
        createdAt: now.subtract(const Duration(minutes: 3)),
        isHost: false,
      ),
      LiveComment(
        id: 'comment_5',
        userId: 'user_4',
        userName: 'Amara Okafor',
        userAvatar: 'https://i.pravatar.cc/150?img=4',
        text: 'Can you share the resources mentioned? 📚',
        createdAt: now.subtract(const Duration(minutes: 2)),
        isHost: false,
      ),
      LiveComment(
        id: 'comment_6',
        userId: 'user_5',
        userName: 'Ibrahim Mustapha',
        userAvatar: 'https://i.pravatar.cc/150?img=5',
        text: 'Looking forward to the follow-up session!',
        createdAt: now.subtract(const Duration(minutes: 1)),
        isHost: false,
      ),
      LiveComment(
        id: 'comment_7',
        userId: 'user_6',
        userName: 'Blessing Okonkwo',
        userAvatar: 'https://i.pravatar.cc/150?img=6',
        text: 'This is exactly what our community needs right now.',
        createdAt: now,
        isHost: false,
      ),
      LiveComment(
        id: 'comment_8',
        userId: 'user_7',
        userName: 'Tunde Adebiyi',
        userAvatar: 'https://i.pravatar.cc/150?img=7',
        text: 'Can I get a link to the organization mentioned?',
        createdAt: now.subtract(const Duration(seconds: 30)),
        isHost: false,
      ),
    ];
  }
}
