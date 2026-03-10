import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../config/app_theme.dart';
import '../../utils/responsive.dart';
import '../../models/post.dart';
import '../../models/comment.dart';
import '../../widgets/comment/comment_item.dart';
import '../../widgets/comment/comment_input.dart';
import '../../widgets/post/share_bottom_sheet.dart';
import '../../widgets/post/translation_overlay.dart';

class PostDetailScreen extends StatefulWidget {
  final Post post;

  const PostDetailScreen({
    Key? key,
    required this.post,
  }) : super(key: key);

  @override
  State<PostDetailScreen> createState() => _PostDetailScreenState();
}

class _PostDetailScreenState extends State<PostDetailScreen> {
  late Post _post;
  late List<Comment> _comments;
  String? _replyingTo;
  Comment? _replyingToComment;
  bool _isTranslated = false;
  String? _translatedText;

  @override
  void initState() {
    super.initState();
    _post = widget.post;
    _comments = Comment.getMockComments(_post.id);
  }

  void _handleLike() {
    setState(() {
      _post = _post.copyWith(
        isLiked: !_post.isLiked,
        likes: _post.isLiked ? _post.likes - 1 : _post.likes + 1,
      );
    });
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

  void _handleCommentSubmit(String text) {
    final newComment = Comment(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      postId: _post.id,
      userId: 'current_user',
      userName: 'You',
      content: text,
      timestamp: DateTime.now(),
    );

    setState(() {
      if (_replyingToComment != null) {
        // Add as reply
        final commentIndex = _comments.indexWhere(
          (c) => c.id == _replyingToComment!.id,
        );
        if (commentIndex != -1) {
          final updatedComment = _comments[commentIndex].copyWith(
            replies: [..._comments[commentIndex].replies, newComment],
          );
          _comments[commentIndex] = updatedComment;
        }
      } else {
        // Add as new comment
        _comments.insert(0, newComment);
        _post = _post.copyWith(comments: _post.comments + 1);
      }
      _replyingTo = null;
      _replyingToComment = null;
    });
  }

  void _handleReply(Comment comment) {
    setState(() {
      _replyingTo = comment.userName;
      _replyingToComment = comment;
    });
  }

  void _cancelReply() {
    setState(() {
      _replyingTo = null;
      _replyingToComment = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    final responsive = context.responsive;

    return Scaffold(
      backgroundColor: AppTheme.background,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: AppTheme.white,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppTheme.textPrimary),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          _post.userName,
          style: TextStyle(
            fontSize: responsive.sp(18),
            fontWeight: FontWeight.w600,
            color: AppTheme.textPrimary,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.more_vert, color: AppTheme.textPrimary),
            onPressed: () {
              // Show post options
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // Post content - scrollable
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Post header
                  _buildPostHeader(responsive),

                  // Post content
                  _buildPostContent(responsive),

                  // Post image
                  if (_post.mediaUrl != null) _buildPostImage(),

                  // Engagement stats
                  _buildEngagementStats(responsive),

                  // Action buttons
                  _buildActionButtons(responsive),

                  Divider(height: 1, color: AppTheme.greySoft),
                  SizedBox(height: responsive.sp(16)),

                  // Comments section header
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: responsive.sp(16)),
                    child: Text(
                      'Comments',
                      style: TextStyle(
                        fontSize: responsive.sp(18),
                        fontWeight: FontWeight.w700,
                        color: AppTheme.textPrimary,
                      ),
                    ),
                  ),
                  SizedBox(height: responsive.sp(16)),

                  // Comments list
                  if (_comments.isEmpty)
                    Padding(
                      padding: EdgeInsets.all(responsive.sp(32)),
                      child: Center(
                        child: Column(
                          children: [
                            Icon(
                              Icons.comment_outlined,
                              size: responsive.sp(48),
                              color: AppTheme.greyMedium,
                            ),
                            SizedBox(height: responsive.sp(12)),
                            Text(
                              'No comments yet',
                              style: TextStyle(
                                fontSize: responsive.sp(16),
                                color: AppTheme.greyMedium,
                              ),
                            ),
                            SizedBox(height: responsive.sp(8)),
                            Text(
                              'Be the first to comment!',
                              style: TextStyle(
                                fontSize: responsive.sp(14),
                                color: AppTheme.greyMedium,
                              ),
                            ),
                          ],
                        ),
                      ),
                    )
                  else
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: responsive.sp(16)),
                      child: Column(
                        children: _comments.map((comment) {
                          return CommentItem(
                            comment: comment,
                            onLike: () {
                              setState(() {
                                final index = _comments.indexOf(comment);
                                _comments[index] = comment.copyWith(
                                  isLiked: !comment.isLiked,
                                  likes: comment.isLiked
                                      ? comment.likes - 1
                                      : comment.likes + 1,
                                );
                              });
                            },
                            onReply: () => _handleReply(comment),
                          );
                        }).toList(),
                      ),
                    ),

                  SizedBox(height: responsive.sp(80)),
                ],
              ),
            ),
          ),

          // Comment input - fixed at bottom
          CommentInput(
            replyingTo: _replyingTo,
            onCancelReply: _cancelReply,
            onSubmit: _handleCommentSubmit,
          ),
        ],
      ),
    );
  }

  Widget _buildPostHeader(Responsive responsive) {
    return Container(
      color: AppTheme.white,
      padding: EdgeInsets.all(responsive.sp(16)),
      child: Row(
        children: [
          CircleAvatar(
            radius: responsive.sp(24),
            backgroundColor: AppTheme.greySoft,
            backgroundImage: _post.userAvatar != null
                ? CachedNetworkImageProvider(_post.userAvatar!)
                : null,
            child: _post.userAvatar == null
                ? Icon(Icons.person, size: responsive.sp(28))
                : null,
          ),
          SizedBox(width: responsive.sp(12)),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  _post.userName,
                  style: TextStyle(
                    fontSize: responsive.sp(16),
                    fontWeight: FontWeight.w600,
                    color: AppTheme.textPrimary,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
                SizedBox(height: responsive.sp(2)),
                Row(
                  children: [
                    Text(
                      _post.formattedDate,
                      style: TextStyle(
                        fontSize: responsive.sp(13),
                        color: AppTheme.greyMedium,
                      ),
                    ),
                    SizedBox(width: responsive.sp(4)),
                    Icon(
                      Icons.public,
                      size: responsive.sp(14),
                      color: AppTheme.greyMedium,
                    ),
                  ],
                ),
              ],
            ),
          ),
          // Priority badge
          Container(
            padding: EdgeInsets.symmetric(
              horizontal: responsive.sp(12),
              vertical: responsive.sp(6),
            ),
            decoration: BoxDecoration(
              color: _post.priority == PostPriority.emergency
                  ? AppTheme.alertOrange
                  : _post.priority == PostPriority.highRisk
                      ? Colors.orange
                      : AppTheme.greenPrimary,
              borderRadius: BorderRadius.circular(AppTheme.radiusSmall),
            ),
            child: Text(
              _post.priorityLabel,
              style: TextStyle(
                fontSize: responsive.sp(12),
                fontWeight: FontWeight.w600,
                color: AppTheme.white,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPostContent(Responsive responsive) {
    return Container(
      color: AppTheme.white,
      width: double.infinity,
      padding: EdgeInsets.symmetric(
        horizontal: responsive.sp(16),
        vertical: responsive.sp(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            _isTranslated ? _translatedText! : _post.content,
            style: TextStyle(
              fontSize: responsive.sp(16),
              color: AppTheme.textPrimary,
              height: 1.5,
            ),
          ),
          if (_post.location != null) ...[
            SizedBox(height: responsive.sp(12)),
            Row(
              children: [
                Icon(
                  Icons.location_on,
                  size: responsive.sp(16),
                  color: AppTheme.greenPrimary,
                ),
                SizedBox(width: responsive.sp(4)),
                Expanded(
                  child: Text(
                    _post.location!,
                    style: TextStyle(
                      fontSize: responsive.sp(14),
                      color: AppTheme.greyMedium,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ],
          if (_post.category != null) ...[
            SizedBox(height: responsive.sp(8)),
            Wrap(
              spacing: responsive.sp(8),
              children: [
                Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: responsive.sp(12),
                    vertical: responsive.sp(4),
                  ),
                  decoration: BoxDecoration(
                    color: AppTheme.greySoft,
                    borderRadius: BorderRadius.circular(AppTheme.radiusSmall),
                  ),
                  child: Text(
                    _post.category!,
                    style: TextStyle(
                      fontSize: responsive.sp(12),
                      color: AppTheme.textPrimary,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildPostImage() {
    return Container(
      color: AppTheme.white,
      width: double.infinity,
      constraints: const BoxConstraints(maxHeight: 400),
      child: CachedNetworkImage(
        imageUrl: _post.mediaUrl!,
        fit: BoxFit.cover,
        placeholder: (context, url) => Container(
          height: 300,
          color: AppTheme.greySoft,
          child: const Center(child: CircularProgressIndicator()),
        ),
        errorWidget: (context, url, error) => Container(
          height: 300,
          color: AppTheme.greySoft,
          child: const Icon(Icons.error),
        ),
      ),
    );
  }

  Widget _buildEngagementStats(Responsive responsive) {
    return Container(
      color: AppTheme.white,
      padding: EdgeInsets.symmetric(
        horizontal: responsive.sp(16),
        vertical: responsive.sp(12),
      ),
      child: Row(
        children: [
          if (_post.likes > 0) ...[
            Icon(
              Icons.favorite,
              size: responsive.sp(18),
              color: AppTheme.alertOrange,
            ),
            SizedBox(width: responsive.sp(4)),
            Text(
              '${_post.likes}',
              style: TextStyle(
                fontSize: responsive.sp(14),
                color: AppTheme.greyMedium,
              ),
            ),
          ],
          const Spacer(),
          if (_post.comments > 0)
            Text(
              '${_post.comments} ${_post.comments == 1 ? 'comment' : 'comments'}',
              style: TextStyle(
                fontSize: responsive.sp(14),
                color: AppTheme.greyMedium,
              ),
            ),
          if (_post.shares > 0) ...[
            Text(
              ' • ',
              style: TextStyle(
                fontSize: responsive.sp(14),
                color: AppTheme.greyMedium,
              ),
            ),
            Text(
              '${_post.shares} ${_post.shares == 1 ? 'share' : 'shares'}',
              style: TextStyle(
                fontSize: responsive.sp(14),
                color: AppTheme.greyMedium,
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildActionButtons(Responsive responsive) {
    return Container(
      color: AppTheme.white,
      padding: EdgeInsets.symmetric(
        horizontal: responsive.sp(8),
        vertical: responsive.sp(4),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _ActionButton(
            icon: _post.isLiked ? Icons.favorite : Icons.favorite_border,
            label: 'Like',
            color: _post.isLiked ? AppTheme.alertOrange : AppTheme.greyMedium,
            onPressed: _handleLike,
            responsive: responsive,
          ),
          _ActionButton(
            icon: Icons.comment_outlined,
            label: 'Comment',
            onPressed: () {
              // Scroll to comment input or focus
            },
            responsive: responsive,
          ),
          _ActionButton(
            icon: Icons.share_outlined,
            label: 'Share',
            onPressed: _handleShare,
            responsive: responsive,
          ),
          _ActionButton(
            icon: Icons.translate,
            label: _isTranslated ? 'Original' : 'Translate',
            onPressed: _handleTranslate,
            color: _isTranslated ? AppTheme.greenPrimary : AppTheme.greyMedium,
            responsive: responsive,
          ),
        ],
      ),
    );
  }
}

class _ActionButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onPressed;
  final Color? color;
  final Responsive responsive;

  const _ActionButton({
    required this.icon,
    required this.label,
    required this.onPressed,
    this.color,
    required this.responsive,
  });

  @override
  Widget build(BuildContext context) {
    return Flexible(
      child: InkWell(
        onTap: onPressed,
        borderRadius: BorderRadius.circular(AppTheme.radiusSmall),
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: responsive.sp(8),
            vertical: responsive.sp(8),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                size: responsive.sp(20),
                color: color ?? AppTheme.greyMedium,
              ),
              SizedBox(width: responsive.sp(4)),
              Flexible(
                child: Text(
                  label,
                  style: TextStyle(
                    fontSize: responsive.sp(13),
                    color: color ?? AppTheme.greyMedium,
                    fontWeight: FontWeight.w500,
                  ),
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
