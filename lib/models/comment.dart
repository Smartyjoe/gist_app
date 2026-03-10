class Comment {
  final String id;
  final String postId;
  final String userId;
  final String userName;
  final String? userAvatar;
  final String content;
  final DateTime timestamp;
  final int likes;
  final bool isLiked;
  final List<Comment> replies;
  final String? parentCommentId;

  Comment({
    required this.id,
    required this.postId,
    required this.userId,
    required this.userName,
    this.userAvatar,
    required this.content,
    required this.timestamp,
    this.likes = 0,
    this.isLiked = false,
    this.replies = const [],
    this.parentCommentId,
  });

  String get formattedDate {
    final now = DateTime.now();
    final difference = now.difference(timestamp);

    if (difference.inDays > 7) {
      return '${timestamp.day}/${timestamp.month}/${timestamp.year}';
    } else if (difference.inDays > 0) {
      return '${difference.inDays}d ago';
    } else if (difference.inHours > 0) {
      return '${difference.inHours}h ago';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes}m ago';
    } else {
      return 'Just now';
    }
  }

  Comment copyWith({
    String? id,
    String? postId,
    String? userId,
    String? userName,
    String? userAvatar,
    String? content,
    DateTime? timestamp,
    int? likes,
    bool? isLiked,
    List<Comment>? replies,
    String? parentCommentId,
  }) {
    return Comment(
      id: id ?? this.id,
      postId: postId ?? this.postId,
      userId: userId ?? this.userId,
      userName: userName ?? this.userName,
      userAvatar: userAvatar ?? this.userAvatar,
      content: content ?? this.content,
      timestamp: timestamp ?? this.timestamp,
      likes: likes ?? this.likes,
      isLiked: isLiked ?? this.isLiked,
      replies: replies ?? this.replies,
      parentCommentId: parentCommentId ?? this.parentCommentId,
    );
  }

  // Mock data for testing
  static List<Comment> getMockComments(String postId) {
    return [
      Comment(
        id: '1',
        postId: postId,
        userId: 'user1',
        userName: 'Sarah Johnson',
        userAvatar: 'https://i.pravatar.cc/150?img=1',
        content: 'This is a very important issue! Thanks for reporting.',
        timestamp: DateTime.now().subtract(const Duration(hours: 2)),
        likes: 12,
        isLiked: false,
        replies: [
          Comment(
            id: '1-1',
            postId: postId,
            userId: 'user3',
            userName: 'Mike Chen',
            userAvatar: 'https://i.pravatar.cc/150?img=3',
            content: 'I agree! We need to fix this ASAP.',
            timestamp: DateTime.now().subtract(const Duration(hours: 1)),
            likes: 3,
            parentCommentId: '1',
          ),
        ],
      ),
      Comment(
        id: '2',
        postId: postId,
        userId: 'user2',
        userName: 'David Okon',
        userAvatar: 'https://i.pravatar.cc/150?img=2',
        content: 'I noticed this yesterday. The authorities should take action.',
        timestamp: DateTime.now().subtract(const Duration(minutes: 45)),
        likes: 8,
        isLiked: true,
      ),
      Comment(
        id: '3',
        postId: postId,
        userId: 'user4',
        userName: 'Amara Nwosu',
        content: 'Same problem in our area too! 😢',
        timestamp: DateTime.now().subtract(const Duration(minutes: 15)),
        likes: 5,
      ),
    ];
  }
}
