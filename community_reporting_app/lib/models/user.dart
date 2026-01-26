class UserProfile {
  final String id;
  final String name;
  final String? avatar;
  final String? bio;
  final String? location;
  final String email;
  final String phone;
  final String preferredLanguage;
  final int postsCount;
  final int followersCount;
  final int followingCount;
  final int reportsCount;
  final bool isVerified;
  final DateTime joinedAt;

  UserProfile({
    required this.id,
    required this.name,
    this.avatar,
    this.bio,
    this.location,
    required this.email,
    required this.phone,
    this.preferredLanguage = 'en',
    this.postsCount = 0,
    this.followersCount = 0,
    this.followingCount = 0,
    this.reportsCount = 0,
    this.isVerified = false,
    required this.joinedAt,
  });

  UserProfile copyWith({
    String? id,
    String? name,
    String? avatar,
    String? bio,
    String? location,
    String? email,
    String? phone,
    String? preferredLanguage,
    int? postsCount,
    int? followersCount,
    int? followingCount,
    int? reportsCount,
    bool? isVerified,
    DateTime? joinedAt,
  }) {
    return UserProfile(
      id: id ?? this.id,
      name: name ?? this.name,
      avatar: avatar ?? this.avatar,
      bio: bio ?? this.bio,
      location: location ?? this.location,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      preferredLanguage: preferredLanguage ?? this.preferredLanguage,
      postsCount: postsCount ?? this.postsCount,
      followersCount: followersCount ?? this.followersCount,
      followingCount: followingCount ?? this.followingCount,
      reportsCount: reportsCount ?? this.reportsCount,
      isVerified: isVerified ?? this.isVerified,
      joinedAt: joinedAt ?? this.joinedAt,
    );
  }
}
