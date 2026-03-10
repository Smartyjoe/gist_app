import 'package:flutter/material.dart';
import '../../config/app_theme.dart';
import '../../utils/responsive.dart';

class CommentInput extends StatefulWidget {
  final String? replyingTo;
  final VoidCallback? onCancelReply;
  final Function(String) onSubmit;

  const CommentInput({
    Key? key,
    this.replyingTo,
    this.onCancelReply,
    required this.onSubmit,
  }) : super(key: key);

  @override
  State<CommentInput> createState() => _CommentInputState();
}

class _CommentInputState extends State<CommentInput> {
  final TextEditingController _controller = TextEditingController();
  bool _hasText = false;

  @override
  void initState() {
    super.initState();
    _controller.addListener(() {
      setState(() {
        _hasText = _controller.text.trim().isNotEmpty;
      });
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _submit() {
    if (_hasText) {
      widget.onSubmit(_controller.text.trim());
      _controller.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    final responsive = context.responsive;

    return Container(
      decoration: BoxDecoration(
        color: AppTheme.white,
        border: Border(
          top: BorderSide(
            color: AppTheme.greySoft,
            width: 1,
          ),
        ),
      ),
      child: SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Replying to indicator
            if (widget.replyingTo != null)
              Container(
                width: double.infinity,
                padding: EdgeInsets.symmetric(
                  horizontal: responsive.sp(16),
                  vertical: responsive.sp(8),
                ),
                color: AppTheme.greySoft.withOpacity(0.3),
                child: Row(
                  children: [
                    Icon(
                      Icons.reply,
                      size: responsive.sp(16),
                      color: AppTheme.greyMedium,
                    ),
                    SizedBox(width: responsive.sp(8)),
                    Expanded(
                      child: Text(
                        'Replying to ${widget.replyingTo}',
                        style: TextStyle(
                          fontSize: responsive.sp(13),
                          color: AppTheme.greyMedium,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    IconButton(
                      icon: Icon(
                        Icons.close,
                        size: responsive.sp(18),
                      ),
                      onPressed: widget.onCancelReply,
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(),
                    ),
                  ],
                ),
              ),

            // Input field
            Padding(
              padding: EdgeInsets.all(responsive.sp(12)),
              child: Row(
                children: [
                  // User avatar
                  CircleAvatar(
                    radius: responsive.sp(18),
                    backgroundColor: AppTheme.greenPrimary,
                    child: Icon(
                      Icons.person,
                      size: responsive.sp(20),
                      color: AppTheme.white,
                    ),
                  ),
                  SizedBox(width: responsive.sp(12)),

                  // Text field
                  Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                        color: AppTheme.greySoft.withOpacity(0.5),
                        borderRadius: BorderRadius.circular(AppTheme.radiusLarge),
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: TextField(
                              controller: _controller,
                              decoration: InputDecoration(
                                hintText: 'Write a comment...',
                                hintStyle: TextStyle(
                                  fontSize: responsive.sp(14),
                                  color: AppTheme.greyMedium,
                                ),
                                border: InputBorder.none,
                                contentPadding: EdgeInsets.symmetric(
                                  horizontal: responsive.sp(16),
                                  vertical: responsive.sp(10),
                                ),
                              ),
                              style: TextStyle(
                                fontSize: responsive.sp(14),
                                color: AppTheme.textPrimary,
                              ),
                              maxLines: 5,
                              minLines: 1,
                              textCapitalization: TextCapitalization.sentences,
                            ),
                          ),
                          
                          // Emoji button
                          IconButton(
                            icon: Icon(
                              Icons.emoji_emotions_outlined,
                              size: responsive.sp(20),
                              color: AppTheme.greyMedium,
                            ),
                            onPressed: () {
                              // TODO: Show emoji picker
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(width: responsive.sp(8)),

                  // Send button
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    child: IconButton(
                      icon: Icon(
                        Icons.send,
                        size: responsive.sp(24),
                        color: _hasText ? AppTheme.greenPrimary : AppTheme.greyMedium,
                      ),
                      onPressed: _hasText ? _submit : null,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
