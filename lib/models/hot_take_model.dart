enum HotTakeReaction { fire, disagree, mindBlown, agree }

class HotTake {
  final String id;
  final String postId;
  final String userId;
  final String userName;
  final String userAvatar;
  final String content;
  final Map<HotTakeReaction, int> reactions;
  final DateTime createdAt;
  final bool isLiked;
  final int likes;

  HotTake({
    required this.id,
    required this.postId,
    required this.userId,
    required this.userName,
    required this.userAvatar,
    required this.content,
    this.reactions = const {},
    required this.createdAt,
    this.isLiked = false,
    this.likes = 0,
  }) : assert(
    content.length <= 200,
    'Content must not exceed 200 characters',
  );

  int get reactionCount {
    return reactions.values.fold(0, (sum, count) => sum + count);
  }

  String reactionLabel(HotTakeReaction reaction) {
    switch (reaction) {
      case HotTakeReaction.fire:
        return '🔥';
      case HotTakeReaction.disagree:
        return '👎';
      case HotTakeReaction.mindBlown:
        return '🤯';
      case HotTakeReaction.agree:
        return '👍';
    }
  }

  HotTake copyWith({
    String? id,
    String? postId,
    String? userId,
    String? userName,
    String? userAvatar,
    String? content,
    Map<HotTakeReaction, int>? reactions,
    DateTime? createdAt,
    bool? isLiked,
    int? likes,
  }) {
    return HotTake(
      id: id ?? this.id,
      postId: postId ?? this.postId,
      userId: userId ?? this.userId,
      userName: userName ?? this.userName,
      userAvatar: userAvatar ?? this.userAvatar,
      content: content ?? this.content,
      reactions: reactions ?? this.reactions,
      createdAt: createdAt ?? this.createdAt,
      isLiked: isLiked ?? this.isLiked,
      likes: likes ?? this.likes,
    );
  }
}

List<HotTake> getMockHotTakes(String postId) {
  return [
    HotTake(
      id: 'hot_take_1',
      postId: postId,
      userId: 'user_1',
      userName: 'Tunde Adeyemi',
      userAvatar: 'https://api.dicebear.com/7.x/avataaars/svg?seed=Tunde',
      content:
          'The future of Nigeria depends on us supporting local tech startups. Let\'s invest in our own!',
      reactions: {
        HotTakeReaction.fire: 45,
        HotTakeReaction.agree: 32,
        HotTakeReaction.mindBlown: 8,
        HotTakeReaction.disagree: 2,
      },
      createdAt: DateTime.now().subtract(const Duration(hours: 3)),
      isLiked: false,
      likes: 87,
    ),
    HotTake(
      id: 'hot_take_2',
      postId: postId,
      userId: 'user_2',
      userName: 'Amara Okafor',
      userAvatar: 'https://api.dicebear.com/7.x/avataaars/svg?seed=Amara',
      content:
          'Remote work is the best thing that happened to African professionals. More flexibility, better life.',
      reactions: {
        HotTakeReaction.agree: 67,
        HotTakeReaction.fire: 23,
        HotTakeReaction.mindBlown: 15,
        HotTakeReaction.disagree: 11,
      },
      createdAt: DateTime.now().subtract(const Duration(hours: 2)),
      isLiked: false,
      likes: 116,
    ),
    HotTake(
      id: 'hot_take_3',
      postId: postId,
      userId: 'user_3',
      userName: 'Kwame Mensah',
      userAvatar: 'https://api.dicebear.com/7.x/avataaars/svg?seed=Kwame',
      content:
          'We need stricter regulations on social media companies operating in Africa. They\'re exploiting us.',
      reactions: {
        HotTakeReaction.fire: 89,
        HotTakeReaction.mindBlown: 42,
        HotTakeReaction.agree: 38,
        HotTakeReaction.disagree: 19,
      },
      createdAt: DateTime.now().subtract(const Duration(minutes: 45)),
      isLiked: false,
      likes: 188,
    ),
    HotTake(
      id: 'hot_take_4',
      postId: postId,
      userId: 'user_4',
      userName: 'Ngozi Eze',
      userAvatar: 'https://api.dicebear.com/7.x/avataaars/svg?seed=Ngozi',
      content:
          'Education tech is revolutionizing learning across Africa. The impact will be generational.',
      reactions: {
        HotTakeReaction.mindBlown: 56,
        HotTakeReaction.fire: 34,
        HotTakeReaction.agree: 44,
        HotTakeReaction.disagree: 7,
      },
      createdAt: DateTime.now().subtract(const Duration(minutes: 30)),
      isLiked: false,
      likes: 141,
    ),
  ];
}
