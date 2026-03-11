import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

enum StoryType { camera, gallery, text, voice, live }

enum StoryReaction { heart, fire, wow, sad, laugh }

class StoryBackground {
  final String type; // 'solid', 'gradient', 'animated'
  final List<Color> colors;
  final String label;
  final bool isAnimated;

  StoryBackground({
    required this.type,
    required this.colors,
    required this.label,
    this.isAnimated = false,
  });

  StoryBackground copyWith({
    String? type,
    List<Color>? colors,
    String? label,
    bool? isAnimated,
  }) {
    return StoryBackground(
      type: type ?? this.type,
      colors: colors ?? this.colors,
      label: label ?? this.label,
      isAnimated: isAnimated ?? this.isAnimated,
    );
  }
}

class StoryPoll {
  final String question;
  final String optionA;
  final String optionB;
  final int votesA;
  final int votesB;

  StoryPoll({
    required this.question,
    required this.optionA,
    required this.optionB,
    this.votesA = 0,
    this.votesB = 0,
  });

  int get totalVotes => votesA + votesB;

  double get percentageA => totalVotes == 0 ? 0 : (votesA / totalVotes) * 100;

  double get percentageB => totalVotes == 0 ? 0 : (votesB / totalVotes) * 100;

  StoryPoll copyWith({
    String? question,
    String? optionA,
    String? optionB,
    int? votesA,
    int? votesB,
  }) {
    return StoryPoll(
      question: question ?? this.question,
      optionA: optionA ?? this.optionA,
      optionB: optionB ?? this.optionB,
      votesA: votesA ?? this.votesA,
      votesB: votesB ?? this.votesB,
    );
  }
}

class StoryModel {
  final String id;
  final String userId;
  final String userName;
  final String? userAvatar;
  final StoryType type;
  final String? content;
  final String? mediaUrl;
  final int duration; // in seconds
  final StoryBackground? background;
  final StoryPoll? poll;
  final Map<String, int> reactions; // emoji -> count
  final int viewCount;
  final DateTime createdAt;
  final DateTime expiresAt;

  StoryModel({
    required this.id,
    required this.userId,
    required this.userName,
    this.userAvatar,
    required this.type,
    this.content,
    this.mediaUrl,
    this.duration = 5,
    this.background,
    this.poll,
    this.reactions = const {},
    this.viewCount = 0,
    required this.createdAt,
    required this.expiresAt,
  });

  bool get isExpired => DateTime.now().isAfter(expiresAt);

  String get formattedTime {
    final now = DateTime.now();
    final difference = now.difference(createdAt);

    if (difference.inMinutes < 1) return 'Just now';
    if (difference.inMinutes < 60) return '${difference.inMinutes}m ago';
    if (difference.inHours < 24) return '${difference.inHours}h ago';
    if (difference.inDays < 7) return '${difference.inDays}d ago';
    return DateFormat('MMM d').format(createdAt);
  }

  StoryModel copyWith({
    String? id,
    String? userId,
    String? userName,
    String? userAvatar,
    StoryType? type,
    String? content,
    String? mediaUrl,
    int? duration,
    StoryBackground? background,
    StoryPoll? poll,
    Map<String, int>? reactions,
    int? viewCount,
    DateTime? createdAt,
    DateTime? expiresAt,
  }) {
    return StoryModel(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      userName: userName ?? this.userName,
      userAvatar: userAvatar ?? this.userAvatar,
      type: type ?? this.type,
      content: content ?? this.content,
      mediaUrl: mediaUrl ?? this.mediaUrl,
      duration: duration ?? this.duration,
      background: background ?? this.background,
      poll: poll ?? this.poll,
      reactions: reactions ?? this.reactions,
      viewCount: viewCount ?? this.viewCount,
      createdAt: createdAt ?? this.createdAt,
      expiresAt: expiresAt ?? this.expiresAt,
    );
  }

  static List<StoryBackground> get backgroundOptions {
    return [
      // Solid colors
      StoryBackground(
        type: 'solid',
        colors: [const Color(0xFFFFA726)], // Warm Yellow/Orange
        label: 'Warm Yellow',
      ),
      StoryBackground(
        type: 'solid',
        colors: [const Color(0xFF42A5F5)], // Sky Blue
        label: 'Sky Blue',
      ),
      StoryBackground(
        type: 'solid',
        colors: [const Color(0xFFEF5350)], // Coral
        label: 'Coral',
      ),
      StoryBackground(
        type: 'solid',
        colors: [const Color(0xFF26A69A)], // Mint
        label: 'Mint',
      ),
      // Gradients
      StoryBackground(
        type: 'gradient',
        colors: [const Color(0xFFAB47BC), const Color(0xFFEC407A)],
        label: 'Purple Pink',
      ),
      StoryBackground(
        type: 'gradient',
        colors: [const Color(0xFFFF7043), const Color(0xFFFDD835)],
        label: 'Orange Yellow',
      ),
      StoryBackground(
        type: 'gradient',
        colors: [const Color(0xFF00BCD4), const Color(0xFF4CAF50)],
        label: 'Teal Green',
      ),
      // Animated backgrounds (represented as gradients with isAnimated flag)
      StoryBackground(
        type: 'gradient',
        colors: [const Color(0xFF667EEA), const Color(0xFF764BA2)],
        label: 'Animated Purple',
        isAnimated: true,
      ),
      StoryBackground(
        type: 'gradient',
        colors: [const Color(0xFFF093FB), const Color(0xFFF5576C)],
        label: 'Animated Pink',
        isAnimated: true,
      ),
      StoryBackground(
        type: 'gradient',
        colors: [const Color(0xFF4FACFE), const Color(0xFF00F2FE)],
        label: 'Animated Cyan',
        isAnimated: true,
      ),
    ];
  }

  static List<StoryModel> getMockStories() {
    final now = DateTime.now();
    return [
      StoryModel(
        id: 'story_1',
        userId: 'user_1',
        userName: 'Chioma Okoro',
        userAvatar: 'https://i.pravatar.cc/150?img=1',
        type: StoryType.gallery,
        mediaUrl: 'https://picsum.photos/400/600?random=1',
        duration: 5,
        viewCount: 234,
        createdAt: now.subtract(const Duration(hours: 2)),
        expiresAt: now.add(const Duration(hours: 22)),
      ),
      StoryModel(
        id: 'story_2',
        userId: 'user_2',
        userName: 'Adekunle Bankole',
        userAvatar: 'https://i.pravatar.cc/150?img=2',
        type: StoryType.text,
        content: 'Just finished an amazing community event! 🎉',
        background: StoryBackground(
          type: 'gradient',
          colors: [const Color(0xFFAB47BC), const Color(0xFFEC407A)],
          label: 'Purple Pink',
        ),
        viewCount: 567,
        reactions: {'❤️': 45, '🔥': 23, '😮': 8},
        createdAt: now.subtract(const Duration(hours: 1)),
        expiresAt: now.add(const Duration(hours: 23)),
      ),
      StoryModel(
        id: 'story_3',
        userId: 'user_3',
        userName: 'Zainab Hassan',
        userAvatar: 'https://i.pravatar.cc/150?img=3',
        type: StoryType.camera,
        mediaUrl: 'https://picsum.photos/400/600?random=3',
        duration: 5,
        viewCount: 892,
        reactions: {'❤️': 120, '🔥': 67, '😂': 34, '😮': 12},
        createdAt: now.subtract(const Duration(minutes: 45)),
        expiresAt: now.add(const Duration(hours: 23, minutes: 15)),
      ),
      StoryModel(
        id: 'story_4',
        userId: 'user_4',
        userName: 'Tunde Adebiyi',
        userAvatar: 'https://i.pravatar.cc/150?img=4',
        type: StoryType.text,
        content: 'Poll: Which community initiative should we focus on next?',
        background: StoryBackground(
          type: 'gradient',
          colors: [const Color(0xFF4FACFE), const Color(0xFF00F2FE)],
          label: 'Animated Cyan',
          isAnimated: true,
        ),
        poll: StoryPoll(
          question: 'Which community initiative should we focus on next?',
          optionA: 'Healthcare Program',
          optionB: 'Education Outreach',
          votesA: 156,
          votesB: 234,
        ),
        viewCount: 445,
        createdAt: now.subtract(const Duration(minutes: 30)),
        expiresAt: now.add(const Duration(hours: 23, minutes: 30)),
      ),
      StoryModel(
        id: 'story_5',
        userId: 'user_5',
        userName: 'Amara Okafor',
        userAvatar: 'https://i.pravatar.cc/150?img=5',
        type: StoryType.voice,
        content: 'Quick update on the community center renovation',
        mediaUrl: 'https://example.com/audio.mp3',
        duration: 45,
        viewCount: 312,
        reactions: {'❤️': 78, '🔥': 45},
        createdAt: now.subtract(const Duration(minutes: 15)),
        expiresAt: now.add(const Duration(hours: 23, minutes: 45)),
      ),
      StoryModel(
        id: 'story_6',
        userId: 'user_6',
        userName: 'Ibrahim Mustapha',
        userAvatar: 'https://i.pravatar.cc/150?img=6',
        type: StoryType.live,
        content: 'Live from the community health clinic',
        mediaUrl: 'https://example.com/live-stream',
        viewCount: 1245,
        reactions: {'❤️': 234, '🔥': 156, '😮': 67, '😂': 45, '😢': 12},
        createdAt: now.subtract(const Duration(minutes: 5)),
        expiresAt: now.add(const Duration(hours: 23, minutes: 55)),
      ),
    ];
  }
}
