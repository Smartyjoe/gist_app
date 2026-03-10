import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../models/post.dart';
import '../../config/app_theme.dart';
import '../../utils/responsive.dart';
import '../../screens/post/post_detail_screen.dart';
import 'share_bottom_sheet.dart';
import 'translation_overlay.dart';

class PostCard extends StatefulWidget {
  final Post post;

  const PostCard({
    super.key,
    required this.post,
  });

  @override
  State<PostCard> createState() => _PostCardState();
}

class _PostCardState extends State<PostCard> {
  late Post _post;
  bool _isTranslated = false;
  String? _translatedText;

  @override
  void initState() {
    super.initState();
    _post = widget.post;
  }

  void _handleLike() {
    setState(() {
      _post = _post.copyWith(
        isLiked: !_post.isLiked,
        likes: _post.isLiked ? _post.likes - 1 : _post.likes + 1,
      );
    });
  }

  void _handleComment() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => PostDetailScreen(post: _post),
      ),
    );
  }

  void _handleShare() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) => ShareBottomSheet(post: _post),
    );
  }

  void _handleTranslate() {
    setState(() {
      if (_isTranslated) {
        _isTranslated = false;
        _translatedText = null;
      } else {
        // Simulate translation
        _isTranslated = true;
        _translatedText = 'Translated: ${_post.content}';
      }
    });

    if (_isTranslated) {
      _showTranslationOverlay();
    }
  }

  void _showTranslationOverlay() {
    showDialog(
      context: context,
      builder: (context) => TranslationOverlay(
        originalText: _post.content,
        translatedText: _translatedText!,
        onClose: () {
          Navigator.pop(context);
        },
      ),
    );
  }

  void _openPostDetail() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => PostDetailScreen(post: _post),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final responsive = context.responsive;

    return Card(
      margin: EdgeInsets.symmetric(
        horizontal: responsive.horizontalPadding,
        vertical: AppTheme.spacing8,
      ),
      child: InkWell(
        onTap: _openPostDetail,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            _buildHeader(context, responsive),
            
            // Priority Badge
            if (_post.isHighPriority) _buildPriorityBadge(responsive),
            
            // Content
            _buildContent(context, responsive),
            
            // Media
            if (_post.mediaUrl != null) _buildMedia(context),
            
            // Location
            if (_post.location != null) _buildLocation(responsive),
            
            // Engagement Stats
            _buildEngagementStats(context, responsive),
            
            const Divider(height: 1),
            
            // Action Buttons
            _buildActionButtons(context, responsive),
          ],
        ),
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
            backgroundImage: _post.userAvatar != null
                ? CachedNetworkImageProvider(_post.userAvatar!)
                : null,
            child: _post.userAvatar == null
                ? Icon(Icons.person, size: responsive.sp(24))
                : null,
          ),
          SizedBox(width: responsive.sp(AppTheme.spacing12)),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  _post.userName,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontSize: responsive.sp(16),
                        fontWeight: FontWeight.w600,
                      ),
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                ),
                Text(
                  _post.formattedDate,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        fontSize: responsive.sp(12),
                        color: AppTheme.textSecondary,
                      ),
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
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
            padding: EdgeInsets.all(responsive.sp(8)),
            constraints: const BoxConstraints(),
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
        color: _post.priority == PostPriority.emergency
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
            _post.priorityLabel,
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
            _isTranslated ? _translatedText! : _post.content,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  fontSize: responsive.sp(14),
                  height: 1.5,
                ),
            maxLines: 4,
            overflow: TextOverflow.ellipsis,
          ),
          if (_post.tags.isNotEmpty) ...[
            SizedBox(height: responsive.sp(AppTheme.spacing8)),
            Wrap(
              spacing: responsive.sp(8),
              runSpacing: responsive.sp(4),
              children: _post.tags.map((tag) {
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
            imageUrl: _post.thumbnailUrl ?? _post.mediaUrl!,
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
          if (_post.type == PostType.video || _post.type == PostType.audio)
            Center(
              child: Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.black54,
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  _post.type == PostType.video ? Icons.play_arrow : Icons.audiotrack,
                  color: Colors.white,
                  size: 40,
                ),
              ),
            ),
          if (_post.mediaDuration != null)
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
                  _formatDuration(_post.mediaDuration!),
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
              _post.location!,
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
          if (_post.likes > 0)
            Flexible(
              child: Text(
                '${_post.likes} ${_post.likes == 1 ? 'like' : 'likes'}',
                style: TextStyle(
                  fontSize: responsive.sp(12),
                  color: AppTheme.textSecondary,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
          const Spacer(),
          if (_post.comments > 0)
            Flexible(
              child: Text(
                '${_post.comments} ${_post.comments == 1 ? 'comment' : 'comments'}',
                style: TextStyle(
                  fontSize: responsive.sp(12),
                  color: AppTheme.textSecondary,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
          if (_post.comments > 0 && _post.shares > 0)
            Text(
              ' • ',
              style: TextStyle(
                fontSize: responsive.sp(12),
                color: AppTheme.textSecondary,
              ),
            ),
          if (_post.shares > 0)
            Flexible(
              child: Text(
                '${_post.shares} ${_post.shares == 1 ? 'share' : 'shares'}',
                style: TextStyle(
                  fontSize: responsive.sp(12),
                  color: AppTheme.textSecondary,
                ),
                overflow: TextOverflow.ellipsis,
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
          Flexible(
            child: _ActionButton(
              icon: _post.isLiked ? Icons.favorite : Icons.favorite_border,
              label: 'Like',
              color: _post.isLiked ? AppTheme.alertOrange : AppTheme.textSecondary,
              onPressed: _handleLike,
              responsive: responsive,
            ),
          ),
          Flexible(
            child: _ActionButton(
              icon: Icons.comment_outlined,
              label: 'Comment',
              onPressed: _handleComment,
              responsive: responsive,
            ),
          ),
          Flexible(
            child: _ActionButton(
              icon: Icons.share_outlined,
              label: 'Share',
              onPressed: _handleShare,
              responsive: responsive,
            ),
          ),
          Flexible(
            child: _ActionButton(
              icon: Icons.translate,
              label: _isTranslated ? 'Original' : 'Translate',
              onPressed: _handleTranslate,
              responsive: responsive,
            ),
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
          horizontal: responsive.sp(8),
          vertical: responsive.sp(AppTheme.spacing8),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: responsive.sp(20),
              color: color ?? AppTheme.textSecondary,
            ),
            SizedBox(width: responsive.sp(4)),
            Flexible(
              child: Text(
                label,
                style: TextStyle(
                  fontSize: responsive.sp(13),
                  color: color ?? AppTheme.textSecondary,
                  fontWeight: FontWeight.w500,
                ),
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
