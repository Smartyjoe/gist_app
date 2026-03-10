import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../models/post.dart';
import '../../config/app_theme.dart';
import '../../utils/responsive.dart';

class PostCard extends StatelessWidget {
  final Post post;
  final VoidCallback? onLike;
  final VoidCallback? onComment;
  final VoidCallback? onShare;
  final VoidCallback? onTranslate;

  const PostCard({
    super.key,
    required this.post,
    this.onLike,
    this.onComment,
    this.onShare,
    this.onTranslate,
  });

  @override
  Widget build(BuildContext context) {
    final responsive = context.responsive;

    return Card(
      margin: EdgeInsets.symmetric(
        horizontal: responsive.horizontalPadding,
        vertical: AppTheme.spacing8,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          _buildHeader(context, responsive),
          
          // Priority Badge
          if (post.isHighPriority) _buildPriorityBadge(responsive),
          
          // Content
          _buildContent(context, responsive),
          
          // Media
          if (post.mediaUrl != null) _buildMedia(context),
          
          // Location
          if (post.location != null) _buildLocation(responsive),
          
          // Engagement Stats
          _buildEngagementStats(context, responsive),
          
          const Divider(height: 1),
          
          // Action Buttons
          _buildActionButtons(context, responsive),
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context, Responsive responsive) {
    return Padding(
      padding: EdgeInsets.all(responsive.sp(AppTheme.spacing12)),
      child: Row(
        children: [
          CircleAvatar(
            radius: responsive.sp(20),
            backgroundColor: AppTheme.greySoft,
            backgroundImage: post.userAvatar != null
                ? CachedNetworkImageProvider(post.userAvatar!)
                : null,
            child: post.userAvatar == null
                ? Icon(Icons.person, size: responsive.sp(24))
                : null,
          ),
          SizedBox(width: responsive.sp(AppTheme.spacing12)),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  post.userName,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontSize: responsive.sp(16),
                        fontWeight: FontWeight.w600,
                      ),
                ),
                Text(
                  post.formattedDate,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        fontSize: responsive.sp(12),
                        color: AppTheme.textSecondary,
                      ),
                ),
              ],
            ),
          ),
          IconButton(
            icon: const Icon(Icons.more_vert),
            onPressed: () {
              // Show options menu
            },
            iconSize: responsive.sp(24),
          ),
        ],
      ),
    );
  }

  Widget _buildPriorityBadge(Responsive responsive) {
    return Container(
      margin: EdgeInsets.symmetric(
        horizontal: responsive.sp(AppTheme.spacing12),
        vertical: responsive.sp(AppTheme.spacing4),
      ),
      padding: EdgeInsets.symmetric(
        horizontal: responsive.sp(AppTheme.spacing12),
        vertical: responsive.sp(AppTheme.spacing4),
      ),
      decoration: BoxDecoration(
        color: post.priority == PostPriority.emergency
            ? AppTheme.alertOrange
            : AppTheme.alertOrange.withOpacity(0.8),
        borderRadius: BorderRadius.circular(AppTheme.radiusSmall),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.warning,
            color: AppTheme.white,
            size: responsive.sp(14),
          ),
          SizedBox(width: responsive.sp(4)),
          Text(
            post.priorityLabel,
            style: TextStyle(
              color: AppTheme.white,
              fontSize: responsive.sp(11),
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildContent(BuildContext context, Responsive responsive) {
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: responsive.sp(AppTheme.spacing12),
        vertical: responsive.sp(AppTheme.spacing8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            post.content,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  fontSize: responsive.sp(14),
                  height: 1.5,
                ),
          ),
          if (post.tags.isNotEmpty) ...[
            SizedBox(height: responsive.sp(AppTheme.spacing8)),
            Wrap(
              spacing: responsive.sp(8),
              runSpacing: responsive.sp(4),
              children: post.tags.map((tag) {
                return Text(
                  '#$tag',
                  style: TextStyle(
                    color: AppTheme.greenPrimary,
                    fontSize: responsive.sp(13),
                    fontWeight: FontWeight.w500,
                  ),
                );
              }).toList(),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildMedia(BuildContext context) {
    return AspectRatio(
      aspectRatio: 16 / 9,
      child: Stack(
        children: [
          CachedNetworkImage(
            imageUrl: post.thumbnailUrl ?? post.mediaUrl!,
            width: double.infinity,
            fit: BoxFit.cover,
            placeholder: (context, url) => Container(
              color: AppTheme.greySoft,
              child: const Center(child: CircularProgressIndicator()),
            ),
            errorWidget: (context, url, error) => Container(
              color: AppTheme.greySoft,
              child: const Icon(Icons.error),
            ),
          ),
          if (post.type == PostType.video || post.type == PostType.audio)
            Center(
              child: Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.black54,
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  post.type == PostType.video ? Icons.play_arrow : Icons.audiotrack,
                  color: Colors.white,
                  size: 40,
                ),
              ),
            ),
          if (post.mediaDuration != null)
            Positioned(
              bottom: 8,
              right: 8,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.black54,
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  _formatDuration(post.mediaDuration!),
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildLocation(Responsive responsive) {
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: responsive.sp(AppTheme.spacing12),
        vertical: responsive.sp(AppTheme.spacing8),
      ),
      child: Row(
        children: [
          Icon(
            Icons.location_on,
            size: responsive.sp(16),
            color: AppTheme.textSecondary,
          ),
          SizedBox(width: responsive.sp(4)),
          Expanded(
            child: Text(
              post.location!,
              style: TextStyle(
                fontSize: responsive.sp(12),
                color: AppTheme.textSecondary,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEngagementStats(BuildContext context, Responsive responsive) {
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: responsive.sp(AppTheme.spacing12),
        vertical: responsive.sp(AppTheme.spacing8),
      ),
      child: Row(
        children: [
          if (post.likes > 0)
            Text(
              '${post.likes} ${post.likes == 1 ? 'like' : 'likes'}',
              style: TextStyle(
                fontSize: responsive.sp(12),
                color: AppTheme.textSecondary,
              ),
            ),
          const Spacer(),
          if (post.comments > 0)
            Text(
              '${post.comments} ${post.comments == 1 ? 'comment' : 'comments'}',
              style: TextStyle(
                fontSize: responsive.sp(12),
                color: AppTheme.textSecondary,
              ),
            ),
          if (post.comments > 0 && post.shares > 0)
            Text(
              ' • ',
              style: TextStyle(
                fontSize: responsive.sp(12),
                color: AppTheme.textSecondary,
              ),
            ),
          if (post.shares > 0)
            Text(
              '${post.shares} ${post.shares == 1 ? 'share' : 'shares'}',
              style: TextStyle(
                fontSize: responsive.sp(12),
                color: AppTheme.textSecondary,
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildActionButtons(BuildContext context, Responsive responsive) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: responsive.sp(AppTheme.spacing4)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _ActionButton(
            icon: post.isLiked ? Icons.favorite : Icons.favorite_border,
            label: 'Like',
            color: post.isLiked ? AppTheme.alertOrange : AppTheme.textSecondary,
            onPressed: onLike,
            responsive: responsive,
          ),
          _ActionButton(
            icon: Icons.comment_outlined,
            label: 'Comment',
            onPressed: onComment,
            responsive: responsive,
          ),
          _ActionButton(
            icon: Icons.share_outlined,
            label: 'Share',
            onPressed: onShare,
            responsive: responsive,
          ),
          _ActionButton(
            icon: Icons.translate,
            label: 'Translate',
            onPressed: onTranslate,
            responsive: responsive,
          ),
        ],
      ),
    );
  }

  String _formatDuration(double seconds) {
    final duration = Duration(seconds: seconds.toInt());
    final minutes = duration.inMinutes;
    final secs = duration.inSeconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:${secs.toString().padLeft(2, '0')}';
  }
}

class _ActionButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color? color;
  final VoidCallback? onPressed;
  final Responsive responsive;

  const _ActionButton({
    required this.icon,
    required this.label,
    this.color,
    this.onPressed,
    required this.responsive,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onPressed,
      borderRadius: BorderRadius.circular(AppTheme.radiusSmall),
      child: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: responsive.sp(AppTheme.spacing12),
          vertical: responsive.sp(AppTheme.spacing8),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              size: responsive.sp(20),
              color: color ?? AppTheme.textSecondary,
            ),
            SizedBox(width: responsive.sp(4)),
            Text(
              label,
              style: TextStyle(
                fontSize: responsive.sp(13),
                color: color ?? AppTheme.textSecondary,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
