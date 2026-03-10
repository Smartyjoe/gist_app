import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../config/app_theme.dart';
import '../../utils/responsive.dart';
import '../../models/comment.dart';

class CommentItem extends StatelessWidget {
  final Comment comment;
  final VoidCallback onLike;
  final VoidCallback onReply;
  final bool isReply;

  const CommentItem({
    Key? key,
    required this.comment,
    required this.onLike,
    required this.onReply,
    this.isReply = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final responsive = context.responsive;

    return Padding(
      padding: EdgeInsets.only(
        left: isReply ? responsive.sp(48) : 0,
        bottom: responsive.sp(12),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // User avatar
          CircleAvatar(
            radius: responsive.sp(isReply ? 16 : 20),
            backgroundColor: AppTheme.greySoft,
            backgroundImage: comment.userAvatar != null
                ? CachedNetworkImageProvider(comment.userAvatar!)
                : null,
            child: comment.userAvatar == null
                ? Icon(
                    Icons.person,
                    size: responsive.sp(isReply ? 18 : 24),
                    color: AppTheme.greyMedium,
                  )
                : null,
          ),
          SizedBox(width: responsive.sp(12)),

          // Comment content
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Comment bubble
                Container(
                  padding: EdgeInsets.all(responsive.sp(12)),
                  decoration: BoxDecoration(
                    color: AppTheme.greySoft.withOpacity(0.5),
                    borderRadius: BorderRadius.circular(AppTheme.radiusLarge),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // User name
                      Text(
                        comment.userName,
                        style: TextStyle(
                          fontSize: responsive.sp(14),
                          fontWeight: FontWeight.w600,
                          color: AppTheme.textPrimary,
                        ),
                      ),
                      SizedBox(height: responsive.sp(4)),

                      // Comment text
                      Text(
                        comment.content,
                        style: TextStyle(
                          fontSize: responsive.sp(14),
                          color: AppTheme.textPrimary,
                          height: 1.4,
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: responsive.sp(4)),

                // Action buttons (Like, Reply, Time)
                Padding(
                  padding: EdgeInsets.only(left: responsive.sp(12)),
                  child: Row(
                    children: [
                      // Timestamp
                      Text(
                        comment.formattedDate,
                        style: TextStyle(
                          fontSize: responsive.sp(12),
                          color: AppTheme.greyMedium,
                        ),
                      ),
                      SizedBox(width: responsive.sp(16)),

                      // Like button
                      InkWell(
                        onTap: onLike,
                        child: Text(
                          'Like',
                          style: TextStyle(
                            fontSize: responsive.sp(12),
                            fontWeight: FontWeight.w600,
                            color: comment.isLiked
                                ? AppTheme.greenPrimary
                                : AppTheme.greyMedium,
                          ),
                        ),
                      ),
                      if (comment.likes > 0) ...[
                        SizedBox(width: responsive.sp(4)),
                        Icon(
                          Icons.favorite,
                          size: responsive.sp(12),
                          color: AppTheme.alertOrange,
                        ),
                        SizedBox(width: responsive.sp(2)),
                        Text(
                          '${comment.likes}',
                          style: TextStyle(
                            fontSize: responsive.sp(12),
                            color: AppTheme.greyMedium,
                          ),
                        ),
                      ],
                      SizedBox(width: responsive.sp(16)),

                      // Reply button (hide for replies)
                      if (!isReply)
                        InkWell(
                          onTap: onReply,
                          child: Text(
                            'Reply',
                            style: TextStyle(
                              fontSize: responsive.sp(12),
                              fontWeight: FontWeight.w600,
                              color: AppTheme.greyMedium,
                            ),
                          ),
                        ),
                    ],
                  ),
                ),

                // Nested replies
                if (comment.replies.isNotEmpty) ...[
                  SizedBox(height: responsive.sp(12)),
                  ...comment.replies.map((reply) => CommentItem(
                        comment: reply,
                        onLike: () {},
                        onReply: () {},
                        isReply: true,
                      )),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}
