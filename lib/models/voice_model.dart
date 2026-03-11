import 'dart:math';

class VoiceReply {
  final String id;
  final String postId;
  final String userId;
  final String userName;
  final String userAvatar;
  final int durationSeconds;
  final DateTime createdAt;
  final int likes;
  final bool isLiked;
  final List<double> waveformData;

  VoiceReply({
    required this.id,
    required this.postId,
    required this.userId,
    required this.userName,
    required this.userAvatar,
    required this.durationSeconds,
    required this.createdAt,
    this.likes = 0,
    this.isLiked = false,
    required this.waveformData,
  }) : assert(waveformData.length == 30, 'Waveform data must have exactly 30 values');

  VoiceReply copyWith({
    String? id,
    String? postId,
    String? userId,
    String? userName,
    String? userAvatar,
    int? durationSeconds,
    DateTime? createdAt,
    int? likes,
    bool? isLiked,
    List<double>? waveformData,
  }) {
    return VoiceReply(
      id: id ?? this.id,
      postId: postId ?? this.postId,
      userId: userId ?? this.userId,
      userName: userName ?? this.userName,
      userAvatar: userAvatar ?? this.userAvatar,
      durationSeconds: durationSeconds ?? this.durationSeconds,
      createdAt: createdAt ?? this.createdAt,
      likes: likes ?? this.likes,
      isLiked: isLiked ?? this.isLiked,
      waveformData: waveformData ?? this.waveformData,
    );
  }

  static List<double> generateMockWaveform() {
    final random = Random();
    return List<double>.generate(
      30,
      (_) => 0.1 + random.nextDouble() * 0.9,
    );
  }
}

class VoiceStatus {
  final String id;
  final String userId;
  final int durationSeconds;
  final DateTime recordedAt;
  final List<double> waveformData;

  VoiceStatus({
    required this.id,
    required this.userId,
    required this.durationSeconds,
    required this.recordedAt,
    required this.waveformData,
  }) : assert(waveformData.length == 30, 'Waveform data must have exactly 30 values');
}

List<VoiceReply> getMockVoiceReplies(String postId) {
  return [
    VoiceReply(
      id: 'voice_1',
      postId: postId,
      userId: 'user_1',
      userName: 'Chinedu Okoro',
      userAvatar: 'https://api.dicebear.com/7.x/avataaars/svg?seed=Chinedu',
      durationSeconds: 15,
      createdAt: DateTime.now().subtract(const Duration(hours: 2)),
      likes: 24,
      isLiked: false,
      waveformData: VoiceReply.generateMockWaveform(),
    ),
    VoiceReply(
      id: 'voice_2',
      postId: postId,
      userId: 'user_2',
      userName: 'Zainab Abubakar',
      userAvatar: 'https://api.dicebear.com/7.x/avataaars/svg?seed=Zainab',
      durationSeconds: 22,
      createdAt: DateTime.now().subtract(const Duration(hours: 1)),
      likes: 18,
      isLiked: false,
      waveformData: VoiceReply.generateMockWaveform(),
    ),
  ];
}
