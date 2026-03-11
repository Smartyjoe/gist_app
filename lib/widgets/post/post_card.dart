import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../models/post.dart';
import '../../config/app_theme.dart';
import '../../utils/responsive.dart';
import '../../screens/post/post_detail_screen.dart';
import 'share_bottom_sheet.dart';
import 'translation_overlay.dart' show TranslationBottomSheet;
import 'voice_reply_sheet.dart';
import 'hot_takes_section.dart';

// ── Colour helpers ────────────────────────────────────────────────────────────

Color _categoryColor(String category) {
  switch (category.toLowerCase()) {
    case 'emergency':     return const Color(0xFFD32F2F);
    case 'infrastructure':return const Color(0xFF1565C0);
    case 'health':        return const Color(0xFF2E7D32);
    case 'security':      return const Color(0xFF6A1B9A);
    case 'environment':   return const Color(0xFF00695C);
    case 'utilities':     return const Color(0xFFF57C00);
    default:              return AppTheme.greyMedium;
  }
}

Color _priorityColor(PostPriority p) {
  switch (p) {
    case PostPriority.emergency: return const Color(0xFFD32F2F);
    case PostPriority.highRisk:  return const Color(0xFFF57C00);
    case PostPriority.normal:    return AppTheme.greenPrimary;
  }
}

// ── PostCard ──────────────────────────────────────────────────────────────────

class PostCard extends StatefulWidget {
  final Post post;
  const PostCard({super.key, required this.post});

  @override
  State<PostCard> createState() => _PostCardState();
}

class _PostCardState extends State<PostCard> with SingleTickerProviderStateMixin {
  late Post _post;
  bool _expanded = false;
  bool _isBookmarked = false;

  // Like animation
  late AnimationController _likeCtrl;
  late Animation<double> _likeScale;

  static const int _contentPreviewLines = 3;

  @override
  void initState() {
    super.initState();
    _post = widget.post;
    _likeCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 180),
    );
    _likeScale = TweenSequence([
      TweenSequenceItem(tween: Tween(begin: 1.0, end: 1.35), weight: 50),
      TweenSequenceItem(tween: Tween(begin: 1.35, end: 1.0), weight: 50),
    ]).animate(CurvedAnimation(parent: _likeCtrl, curve: Curves.easeOut));
  }

  @override
  void dispose() {
    _likeCtrl.dispose();
    super.dispose();
  }

  // ── Actions ────────────────────────────────────────────────────────────────

  void _handleLike() {
    setState(() {
      _post = _post.copyWith(
        isLiked: !_post.isLiked,
        likes: _post.isLiked ? _post.likes - 1 : _post.likes + 1,
      );
    });
    _likeCtrl.forward(from: 0);
  }

  void _handleComment() {
    Navigator.push(context,
        MaterialPageRoute(builder: (_) => PostDetailScreen(post: _post)));
  }

  void _handleShare() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (_) => ShareBottomSheet(post: _post),
    );
  }

  void _handleBookmark() {
    setState(() => _isBookmarked = !_isBookmarked);
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(_isBookmarked ? 'Post saved' : 'Post removed from saved'),
      behavior: SnackBarBehavior.floating,
      duration: const Duration(seconds: 2),
    ));
  }

  void _handleTranslate() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (_) => TranslationBottomSheet(
        originalText: _post.content,
        translatedText: 'Translated: ${_post.content}',
      ),
    );
  }

  void _handleVoiceReply() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (_) => VoiceReplySheet(
        postId: _post.id,
        onSend: (reply) {
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            content: Text('Voice reply sent!'),
            behavior: SnackBarBehavior.floating,
          ));
        },
      ),
    );
  }

  void _showOptionsMenu() {
    final responsive = context.responsive;
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (ctx) => Container(
        decoration: BoxDecoration(
          color: AppTheme.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(responsive.sp(20))),
        ),
        child: SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(height: responsive.sp(12)),
              Container(
                width: responsive.sp(40), height: responsive.sp(4),
                decoration: BoxDecoration(
                  color: AppTheme.greyMedium.withOpacity(0.4),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              SizedBox(height: responsive.sp(8)),
              _OptionTile(icon: Icons.bookmark_outline, label: _isBookmarked ? 'Unsave post' : 'Save post',
                  onTap: () { Navigator.pop(ctx); _handleBookmark(); }, responsive: responsive),
              _OptionTile(icon: Icons.volume_off_outlined, label: 'Mute @${_post.userName}',
                  onTap: () { Navigator.pop(ctx); _snack('Muted @${_post.userName}'); }, responsive: responsive),
              _OptionTile(icon: Icons.person_remove_outlined, label: 'Unfollow @${_post.userName}',
                  onTap: () { Navigator.pop(ctx); _snack('Unfollowed @${_post.userName}'); }, responsive: responsive),
              _OptionTile(icon: Icons.flag_outlined, label: 'Report post', color: AppTheme.alertOrange,
                  onTap: () { Navigator.pop(ctx); _showReportDialog(); }, responsive: responsive),
              SizedBox(height: responsive.sp(8)),
            ],
          ),
        ),
      ),
    );
  }

  void _snack(String msg) => ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(content: Text(msg), behavior: SnackBarBehavior.floating, duration: const Duration(seconds: 2)));

  void _showReportDialog() {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Report Post'),
        content: const Text('Are you sure you want to report this post as inappropriate?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Cancel')),
          TextButton(
            onPressed: () { Navigator.pop(ctx); _snack('Post reported. Thank you.'); },
            child: const Text('Report', style: TextStyle(color: AppTheme.alertOrange)),
          ),
        ],
      ),
    );
  }

  void _openPostDetail() => Navigator.push(context,
      MaterialPageRoute(builder: (_) => PostDetailScreen(post: _post)));

  // ── Build ──────────────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    final responsive = context.responsive;
    final priorityColor = _priorityColor(_post.priority);

    return Container(
      margin: EdgeInsets.symmetric(
        horizontal: responsive.sp(0),
        vertical: responsive.sp(4),
      ),
      decoration: BoxDecoration(
        color: AppTheme.white,
        border: Border(
          left: _post.isHighPriority
              ? BorderSide(color: priorityColor, width: 3)
              : BorderSide.none,
          bottom: const BorderSide(color: AppTheme.greySoft, width: 1),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          InkWell(
            onTap: _openPostDetail,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (_post.isHighPriority) _buildPriorityBanner(responsive, priorityColor),
                _buildHeader(responsive),
                _buildContent(responsive),
                if (_post.mediaUrl != null || _post.thumbnailUrl != null)
                  _buildMedia(responsive),
                if (_post.location != null) _buildLocation(responsive),
                if (_post.tags.isNotEmpty) _buildTags(responsive),
                _buildEngagementStats(responsive),
                Divider(height: 1, thickness: 1, color: AppTheme.greySoft),
                _buildActionBar(responsive),
              ],
            ),
          ),
          // Hot Takes section
          HotTakesSection(postId: _post.id),
        ],
      ),
    );
  }

  // ── Priority banner ────────────────────────────────────────────────────────

  Widget _buildPriorityBanner(Responsive responsive, Color color) {
    final isEmergency = _post.priority == PostPriority.emergency;
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(
          horizontal: responsive.sp(12), vertical: responsive.sp(6)),
      color: color.withOpacity(0.08),
      child: Row(
        children: [
          Icon(isEmergency ? Icons.emergency : Icons.warning_amber_rounded,
              size: responsive.sp(14), color: color),
          SizedBox(width: responsive.sp(6)),
          Text(
            _post.priorityLabel,
            style: TextStyle(
              fontSize: responsive.sp(11),
              fontWeight: FontWeight.w800,
              color: color,
              letterSpacing: 0.6,
            ),
          ),
        ],
      ),
    );
  }

  // ── Header ─────────────────────────────────────────────────────────────────

  Widget _buildHeader(Responsive responsive) {
    return Padding(
      padding: EdgeInsets.fromLTRB(
          responsive.sp(12), responsive.sp(12), responsive.sp(4), responsive.sp(6)),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Avatar
          GestureDetector(
            onTap: () => _snack('Opening @${_post.userName}\'s profile...'),
            child: Stack(
              children: [
                CircleAvatar(
                  radius: responsive.sp(20),
                  backgroundColor: AppTheme.greySoft,
                  backgroundImage: _post.userAvatar != null
                      ? CachedNetworkImageProvider(_post.userAvatar!)
                      : null,
                  child: _post.userAvatar == null
                      ? Icon(Icons.person, size: responsive.sp(22), color: AppTheme.greyMedium)
                      : null,
                ),
                // Online indicator
                Positioned(
                  bottom: 0, right: 0,
                  child: Container(
                    width: responsive.sp(10), height: responsive.sp(10),
                    decoration: BoxDecoration(
                      color: AppTheme.greenPrimary,
                      shape: BoxShape.circle,
                      border: Border.all(color: AppTheme.white, width: 1.5),
                    ),
                  ),
                ),
              ],
            ),
          ),

          SizedBox(width: responsive.sp(10)),

          // Name + meta
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Flexible(
                      child: Text(
                        _post.userName,
                        style: TextStyle(
                          fontSize: responsive.sp(14),
                          fontWeight: FontWeight.w700,
                          color: AppTheme.textPrimary,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    SizedBox(width: responsive.sp(3)),
                    // Verified
                    Icon(Icons.verified, size: responsive.sp(13), color: AppTheme.greenPrimary),
                    SizedBox(width: responsive.sp(6)),
                    // Category chip
                    _CategoryChip(category: _post.category, responsive: responsive),
                  ],
                ),
                SizedBox(height: responsive.sp(2)),
                Text(
                  _post.formattedDate,
                  style: TextStyle(fontSize: responsive.sp(11), color: AppTheme.greyMedium),
                ),
              ],
            ),
          ),

          // Options button
          IconButton(
            icon: Icon(Icons.more_horiz, color: AppTheme.greyMedium, size: responsive.sp(20)),
            onPressed: _showOptionsMenu,
            padding: EdgeInsets.all(responsive.sp(6)),
            constraints: const BoxConstraints(),
          ),
        ],
      ),
    );
  }

  // ── Content ────────────────────────────────────────────────────────────────

  Widget _buildContent(Responsive responsive) {
    return Padding(
      padding: EdgeInsets.symmetric(
          horizontal: responsive.sp(12), vertical: responsive.sp(4)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            _post.content,
            style: TextStyle(
              fontSize: responsive.sp(14),
              color: AppTheme.textPrimary,
              height: 1.5,
            ),
            maxLines: _expanded ? null : _contentPreviewLines,
            overflow: _expanded ? TextOverflow.visible : TextOverflow.ellipsis,
          ),
          // See more / See less
          if (_post.content.length > 120)
            GestureDetector(
              onTap: () => setState(() => _expanded = !_expanded),
              child: Padding(
                padding: EdgeInsets.only(top: responsive.sp(4)),
                child: Text(
                  _expanded ? 'See less' : 'See more',
                  style: TextStyle(
                    fontSize: responsive.sp(13),
                    color: AppTheme.greenPrimary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  // ── Media ──────────────────────────────────────────────────────────────────

  Widget _buildMedia(Responsive responsive) {
    final imageUrl = _post.thumbnailUrl ?? _post.mediaUrl!;
    return Padding(
      padding: EdgeInsets.only(top: responsive.sp(8)),
      child: ClipRRect(
        borderRadius: BorderRadius.zero,
        child: AspectRatio(
          aspectRatio: 16 / 9,
          child: Stack(
            fit: StackFit.expand,
            children: [
              CachedNetworkImage(
                imageUrl: imageUrl,
                fit: BoxFit.cover,
                placeholder: (_, __) => Container(
                  color: AppTheme.greySoft,
                  child: const Center(
                    child: CircularProgressIndicator(
                        strokeWidth: 2, color: AppTheme.greenPrimary),
                  ),
                ),
                errorWidget: (_, __, ___) => Container(
                  color: AppTheme.greySoft,
                  child: const Center(
                    child: Icon(Icons.broken_image, color: AppTheme.greyMedium, size: 40),
                  ),
                ),
              ),
              // Play overlay for video/audio
              if (_post.type == PostType.video || _post.type == PostType.audio)
                Center(
                  child: Container(
                    padding: EdgeInsets.all(responsive.sp(14)),
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.55),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      _post.type == PostType.video
                          ? Icons.play_arrow_rounded
                          : Icons.headphones_rounded,
                      color: Colors.white,
                      size: responsive.sp(36),
                    ),
                  ),
                ),
              // Duration badge
              if (_post.mediaDuration != null)
                Positioned(
                  bottom: responsive.sp(8), right: responsive.sp(8),
                  child: Container(
                    padding: EdgeInsets.symmetric(
                        horizontal: responsive.sp(8), vertical: responsive.sp(3)),
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.65),
                      borderRadius: BorderRadius.circular(responsive.sp(4)),
                    ),
                    child: Text(
                      _formatDuration(_post.mediaDuration!),
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: responsive.sp(11),
                          fontWeight: FontWeight.w600),
                    ),
                  ),
                ),
              // Type badge top-left
              Positioned(
                top: responsive.sp(8), left: responsive.sp(8),
                child: Container(
                  padding: EdgeInsets.symmetric(
                      horizontal: responsive.sp(8), vertical: responsive.sp(3)),
                  decoration: BoxDecoration(
                    color: _post.type == PostType.video
                        ? Colors.black.withOpacity(0.65)
                        : Colors.deepPurple.withOpacity(0.8),
                    borderRadius: BorderRadius.circular(responsive.sp(4)),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        _post.type == PostType.video
                            ? Icons.videocam_outlined
                            : Icons.headphones_outlined,
                        color: Colors.white,
                        size: responsive.sp(12),
                      ),
                      SizedBox(width: responsive.sp(3)),
                      Text(
                        _post.type == PostType.video ? 'VIDEO' : 'AUDIO',
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: responsive.sp(10),
                            fontWeight: FontWeight.w700,
                            letterSpacing: 0.5),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ── Location ───────────────────────────────────────────────────────────────

  Widget _buildLocation(Responsive responsive) {
    return Padding(
      padding: EdgeInsets.fromLTRB(
          responsive.sp(12), responsive.sp(6), responsive.sp(12), 0),
      child: Row(
        children: [
          Icon(Icons.location_on_outlined, size: responsive.sp(13), color: AppTheme.greyMedium),
          SizedBox(width: responsive.sp(3)),
          Expanded(
            child: Text(
              _post.location!,
              style: TextStyle(fontSize: responsive.sp(12), color: AppTheme.greyMedium),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }

  // ── Tags ───────────────────────────────────────────────────────────────────

  Widget _buildTags(Responsive responsive) {
    return Padding(
      padding: EdgeInsets.fromLTRB(
          responsive.sp(12), responsive.sp(6), responsive.sp(12), 0),
      child: Wrap(
        spacing: responsive.sp(6),
        runSpacing: responsive.sp(2),
        children: _post.tags.map((tag) => Text(
          '#$tag',
          style: TextStyle(
            color: AppTheme.greenPrimary,
            fontSize: responsive.sp(12),
            fontWeight: FontWeight.w500,
          ),
        )).toList(),
      ),
    );
  }

  // ── Engagement stats ───────────────────────────────────────────────────────

  Widget _buildEngagementStats(Responsive responsive) {
    final parts = <String>[];
    if (_post.likes > 0) parts.add('${_formatCount(_post.likes)} likes');
    if (_post.comments > 0) parts.add('${_formatCount(_post.comments)} comments');
    if (_post.shares > 0) parts.add('${_formatCount(_post.shares)} shares');
    if (parts.isEmpty) return const SizedBox.shrink();

    return Padding(
      padding: EdgeInsets.fromLTRB(
          responsive.sp(12), responsive.sp(8), responsive.sp(12), responsive.sp(4)),
      child: Text(
        parts.join(' · '),
        style: TextStyle(
          fontSize: responsive.sp(12),
          color: AppTheme.greyMedium,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  // ── Action bar ─────────────────────────────────────────────────────────────

  Widget _buildActionBar(Responsive responsive) {
    return Padding(
      padding: EdgeInsets.symmetric(
          horizontal: responsive.sp(4), vertical: responsive.sp(2)),
      child: Row(
        children: [
          // Like
          _AnimatedActionBtn(
            icon: _post.isLiked ? Icons.favorite_rounded : Icons.favorite_outline,
            count: _post.likes,
            color: _post.isLiked ? Colors.red : AppTheme.greyMedium,
            scaleAnimation: _likeScale,
            onTap: _handleLike,
            responsive: responsive,
          ),
          // Comment
          _ActionBtn(
            icon: Icons.chat_bubble_outline_rounded,
            count: _post.comments,
            onTap: _handleComment,
            responsive: responsive,
          ),
          // Share
          _ActionBtn(
            icon: Icons.share_outlined,
            count: _post.shares,
            onTap: _handleShare,
            responsive: responsive,
          ),
          // Translate
          _ActionBtn(
            icon: Icons.translate_rounded,
            onTap: _handleTranslate,
            responsive: responsive,
          ),
          // Voice Reply
          _ActionBtn(
            icon: Icons.mic_none_rounded,
            onTap: _handleVoiceReply,
            responsive: responsive,
          ),
          const Spacer(),
          // Bookmark
          IconButton(
            onPressed: _handleBookmark,
            icon: Icon(
              _isBookmarked ? Icons.bookmark_rounded : Icons.bookmark_outline,
              size: responsive.sp(20),
              color: _isBookmarked ? AppTheme.greenPrimary : AppTheme.greyMedium,
            ),
            padding: EdgeInsets.all(responsive.sp(6)),
            constraints: const BoxConstraints(),
          ),
        ],
      ),
    );
  }

  // ── Helpers ────────────────────────────────────────────────────────────────

  String _formatDuration(double seconds) {
    final d = Duration(seconds: seconds.toInt());
    final m = d.inMinutes.toString().padLeft(2, '0');
    final s = (d.inSeconds % 60).toString().padLeft(2, '0');
    return '$m:$s';
  }

  String _formatCount(int n) {
    if (n >= 1000000) return '${(n / 1000000).toStringAsFixed(1)}M';
    if (n >= 1000) return '${(n / 1000).toStringAsFixed(1)}K';
    return n.toString();
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Sub-widgets
// ─────────────────────────────────────────────────────────────────────────────

class _CategoryChip extends StatelessWidget {
  final String category;
  final Responsive responsive;
  const _CategoryChip({required this.category, required this.responsive});

  @override
  Widget build(BuildContext context) {
    final color = _categoryColor(category);
    return Container(
      padding: EdgeInsets.symmetric(
          horizontal: responsive.sp(7), vertical: responsive.sp(2)),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(responsive.sp(20)),
      ),
      child: Text(
        category,
        style: TextStyle(
          fontSize: responsive.sp(10),
          color: color,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}

class _AnimatedActionBtn extends StatelessWidget {
  final IconData icon;
  final int? count;
  final Color color;
  final Animation<double> scaleAnimation;
  final VoidCallback onTap;
  final Responsive responsive;

  const _AnimatedActionBtn({
    required this.icon,
    this.count,
    required this.color,
    required this.scaleAnimation,
    required this.onTap,
    required this.responsive,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(responsive.sp(8)),
      child: Padding(
        padding: EdgeInsets.symmetric(
            horizontal: responsive.sp(8), vertical: responsive.sp(8)),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            ScaleTransition(
              scale: scaleAnimation,
              child: Icon(icon, size: responsive.sp(20), color: color),
            ),
            if (count != null && count! > 0) ...[
              SizedBox(width: responsive.sp(4)),
              Text(
                count! >= 1000
                    ? '${(count! / 1000).toStringAsFixed(1)}K'
                    : '$count',
                style: TextStyle(
                  fontSize: responsive.sp(12),
                  color: color,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _ActionBtn extends StatelessWidget {
  final IconData icon;
  final int? count;
  final VoidCallback onTap;
  final Responsive responsive;

  const _ActionBtn({
    required this.icon,
    this.count,
    required this.onTap,
    required this.responsive,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(responsive.sp(8)),
      child: Padding(
        padding: EdgeInsets.symmetric(
            horizontal: responsive.sp(8), vertical: responsive.sp(8)),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: responsive.sp(20), color: AppTheme.greyMedium),
            if (count != null && count! > 0) ...[
              SizedBox(width: responsive.sp(4)),
              Text(
                count! >= 1000
                    ? '${(count! / 1000).toStringAsFixed(1)}K'
                    : '$count',
                style: TextStyle(
                  fontSize: responsive.sp(12),
                  color: AppTheme.greyMedium,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _OptionTile extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;
  final Responsive responsive;
  final Color? color;

  const _OptionTile({
    required this.icon,
    required this.label,
    required this.onTap,
    required this.responsive,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    final c = color ?? AppTheme.textPrimary;
    return ListTile(
      leading: Icon(icon, color: c, size: responsive.sp(22)),
      title: Text(label,
          style: TextStyle(fontSize: responsive.sp(15), color: c, fontWeight: FontWeight.w500)),
      onTap: onTap,
      dense: true,
    );
  }
}
