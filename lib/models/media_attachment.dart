import 'dart:io';

enum MediaType {
  image,
  video,
  audio,
  file,
}

class MediaAttachment {
  final String id;
  final MediaType type;
  final File file;
  final String? fileName;
  final String? thumbnailPath;
  final int? duration; // For video/audio in seconds
  final int? fileSize; // In bytes

  MediaAttachment({
    required this.id,
    required this.type,
    required this.file,
    this.fileName,
    this.thumbnailPath,
    this.duration,
    this.fileSize,
  });

  String get displayName => fileName ?? file.path.split('/').last;

  String get fileSizeFormatted {
    if (fileSize == null) return '';
    if (fileSize! < 1024) return '$fileSize B';
    if (fileSize! < 1024 * 1024) return '${(fileSize! / 1024).toStringAsFixed(1)} KB';
    return '${(fileSize! / (1024 * 1024)).toStringAsFixed(1)} MB';
  }

  String get durationFormatted {
    if (duration == null) return '';
    final minutes = duration! ~/ 60;
    final seconds = duration! % 60;
    return '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
  }

  MediaAttachment copyWith({
    String? id,
    MediaType? type,
    File? file,
    String? fileName,
    String? thumbnailPath,
    int? duration,
    int? fileSize,
  }) {
    return MediaAttachment(
      id: id ?? this.id,
      type: type ?? this.type,
      file: file ?? this.file,
      fileName: fileName ?? this.fileName,
      thumbnailPath: thumbnailPath ?? this.thumbnailPath,
      duration: duration ?? this.duration,
      fileSize: fileSize ?? this.fileSize,
    );
  }
}
