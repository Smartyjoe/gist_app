class AppConstants {
  // App Info
  static const String appName = 'Community Reporter';
  static const String appVersion = '1.0.0';

  // Languages
  static const List<Language> supportedLanguages = [
    Language(code: 'en', name: 'English', nativeName: 'English'),
    Language(code: 'yo', name: 'Yoruba', nativeName: 'Yorùbá'),
    Language(code: 'ha', name: 'Hausa', nativeName: 'Hausa'),
    Language(code: 'ig', name: 'Igbo', nativeName: 'Igbo'),
  ];

  // Post Types
  static const String postTypeText = 'text';
  static const String postTypeVideo = 'video';
  static const String postTypeAudio = 'audio';
  static const String postTypeStatus = 'status';

  // Report Categories
  static const List<String> reportCategories = [
    'Infrastructure',
    'Security',
    'Health',
    'Education',
    'Environment',
    'Transportation',
    'Utilities',
    'Social Services',
    'Emergency',
    'Other',
  ];

  // Status duration (24 hours)
  static const int statusDurationHours = 24;

  // Pagination
  static const int postsPerPage = 20;
  static const int notificationsPerPage = 30;

  // Media
  static const int maxImageSizeMB = 10;
  static const int maxVideoSizeMB = 50;
  static const int maxAudioSizeMB = 20;
  static const int maxVideoDurationSeconds = 180; // 3 minutes
  static const int maxAudioDurationSeconds = 300; // 5 minutes

  // Map
  static const double defaultMapZoom = 14.0;
  static const double defaultLatitude = 6.5244; // Lagos, Nigeria
  static const double defaultLongitude = 3.3792;
}

class Language {
  final String code;
  final String name;
  final String nativeName;

  const Language({
    required this.code,
    required this.name,
    required this.nativeName,
  });
}
