class UserProfile {
  final String id;
  final String name;
  final String username;
  final String? avatar;
  final String? bio;
  final String? website;
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
  final DateTime? birthday;
  final bool isPrivate;

  UserProfile({
    required this.id,
    required this.name,
    String? username,
    this.avatar,
    this.bio,
    this.website,
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
    this.birthday,
    this.isPrivate = false,
  }) : username = username ?? name.toLowerCase().replaceAll(' ', '_');

  UserProfile copyWith({
    String? id,
    String? name,
    String? username,
    String? avatar,
    String? bio,
    String? website,
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
    DateTime? birthday,
    bool? isPrivate,
  }) {
    return UserProfile(
      id: id ?? this.id,
      name: name ?? this.name,
      username: username ?? this.username,
      avatar: avatar ?? this.avatar,
      bio: bio ?? this.bio,
      website: website ?? this.website,
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
      birthday: birthday ?? this.birthday,
      isPrivate: isPrivate ?? this.isPrivate,
    );
  }

  /// Formats follower/following counts with K/M suffix.
  static String formatCount(int count) {
    if (count >= 1000000) return '${(count / 1000000).toStringAsFixed(1)}M';
    if (count >= 1000) return '${(count / 1000).toStringAsFixed(1)}K';
    return count.toString();
  }
}
