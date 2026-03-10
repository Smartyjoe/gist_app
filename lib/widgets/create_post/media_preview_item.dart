import 'dart:io';
import 'package:flutter/material.dart';
import '../../config/app_theme.dart';
import '../../utils/responsive.dart';
import '../../models/media_attachment.dart';

class MediaPreviewItem extends StatelessWidget {
  final MediaAttachment media;
  final VoidCallback onRemove;

  const MediaPreviewItem({
    Key? key,
    required this.media,
    required this.onRemove,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final responsive = context.responsive;

    return Container(
      width: responsive.sp(120),
      height: responsive.sp(120),
      margin: EdgeInsets.only(right: responsive.sp(8)),
      decoration: BoxDecoration(
        color: AppTheme.greySoft,
        borderRadius: BorderRadius.circular(AppTheme.radiusMedium),
        border: Border.all(color: AppTheme.greyMedium.withOpacity(0.2)),
      ),
      child: Stack(
        children: [
          // Content based on media type
          ClipRRect(
            borderRadius: BorderRadius.circular(AppTheme.radiusMedium),
            child: _buildMediaContent(context, responsive),
          ),
          
          // Remove button
          Positioned(
            top: responsive.sp(4),
            right: responsive.sp(4),
            child: GestureDetector(
              onTap: onRemove,
              child: Container(
                padding: EdgeInsets.all(responsive.sp(4)),
                decoration: const BoxDecoration(
                  color: Colors.black54,
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.close,
                  size: responsive.sp(16),
                  color: Colors.white,
                ),
              ),
            ),
          ),
          
          // Duration/Size overlay for video/audio
          if (media.type == MediaType.video || media.type == MediaType.audio)
            Positioned(
              bottom: responsive.sp(4),
              left: responsive.sp(4),
              child: Container(
                padding: EdgeInsets.symmetric(
                  horizontal: responsive.sp(6),
                  vertical: responsive.sp(3),
                ),
                decoration: BoxDecoration(
                  color: Colors.black54,
                  borderRadius: BorderRadius.circular(AppTheme.radiusSmall),
                ),
                child: Text(
                  media.durationFormatted.isNotEmpty 
                      ? media.durationFormatted 
                      : media.fileSizeFormatted,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: responsive.sp(10),
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildMediaContent(BuildContext context, Responsive responsive) {
    switch (media.type) {
      case MediaType.image:
        return Image.file(
          media.file,
          width: double.infinity,
          height: double.infinity,
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) => _buildErrorWidget(responsive),
        );
        
      case MediaType.video:
        return media.thumbnailPath != null
            ? Image.file(
                File(media.thumbnailPath!),
                width: double.infinity,
                height: double.infinity,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) => _buildIconWidget(Icons.videocam, responsive),
              )
            : _buildIconWidget(Icons.videocam, responsive);
            
      case MediaType.audio:
        return _buildFileWidget(Icons.audiotrack, responsive);
        
      case MediaType.file:
        return _buildFileWidget(Icons.insert_drive_file, responsive);
    }
  }

  Widget _buildIconWidget(IconData icon, Responsive responsive) {
    return Container(
      width: double.infinity,
      height: double.infinity,
      color: AppTheme.greySoft,
      child: Icon(
        icon,
        size: responsive.sp(40),
        color: AppTheme.greenPrimary,
      ),
    );
  }

  Widget _buildFileWidget(IconData icon, Responsive responsive) {
    return Container(
      width: double.infinity,
      height: double.infinity,
      padding: EdgeInsets.all(responsive.sp(8)),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            icon,
            size: responsive.sp(32),
            color: AppTheme.greenPrimary,
          ),
          SizedBox(height: responsive.sp(8)),
          Text(
            media.displayName,
            style: TextStyle(
              fontSize: responsive.sp(10),
              color: AppTheme.textSecondary,
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.center,
          ),
          if (media.fileSizeFormatted.isNotEmpty) ...[
            SizedBox(height: responsive.sp(4)),
            Text(
              media.fileSizeFormatted,
              style: TextStyle(
                fontSize: responsive.sp(9),
                color: AppTheme.greyMedium,
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildErrorWidget(Responsive responsive) {
    return Container(
      width: double.infinity,
      height: double.infinity,
      color: AppTheme.greySoft,
      child: Icon(
        Icons.broken_image,
        size: responsive.sp(40),
        color: AppTheme.greyMedium,
      ),
    );
  }
}
