import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../models/post.dart';
import '../../config/app_theme.dart';
import '../../utils/responsive.dart';

class StatusStories extends StatelessWidget {
  final List<Post> stories;
  final VoidCallback? onAddStory;

  const StatusStories({
    super.key,
    required this.stories,
    this.onAddStory,
  });

  @override
  Widget build(BuildContext context) {
    final responsive = context.responsive;

    return Container(
      height: responsive.sp(102),
      color: AppTheme.white,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: EdgeInsets.symmetric(
            horizontal: responsive.sp(12), vertical: responsive.sp(8)),
        itemCount: stories.length + 1,
        itemBuilder: (context, index) {
          if (index == 0) {
            return _AddStoryCard(onTap: onAddStory, responsive: responsive);
          }
          return _StoryCard(
            story: stories[index - 1],
            isViewed: index % 3 == 0, // mock viewed state
            responsive: responsive,
          );
        },
      ),
    );
  }
}

// ── Add Story Card ────────────────────────────────────────────────────────────

class _AddStoryCard extends StatelessWidget {
  final VoidCallback? onTap;
  final Responsive responsive;

  const _AddStoryCard({this.onTap, required this.responsive});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: responsive.sp(68),
        margin: EdgeInsets.only(right: responsive.sp(10)),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Stack(
              alignment: Alignment.center,
              children: [
                // Dashed ring placeholder
                Container(
                  width: responsive.sp(62),
                  height: responsive.sp(62),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: AppTheme.greySoft,
                      width: 2,
                    ),
                  ),
                  child: CircleAvatar(
                    backgroundColor: AppTheme.greySoft,
                    child: Icon(Icons.person,
                        size: responsive.sp(28), color: AppTheme.greyMedium),
                  ),
                ),
                // Green + badge
                Positioned(
                  bottom: 0,
                  right: 0,
                  child: Container(
                    width: responsive.sp(20),
                    height: responsive.sp(20),
                    decoration: const BoxDecoration(
                      color: AppTheme.greenPrimary,
                      shape: BoxShape.circle,
                    ),
                    child: Icon(Icons.add,
                        color: AppTheme.white, size: responsive.sp(14)),
                  ),
                ),
              ],
            ),
            SizedBox(height: responsive.sp(4)),
            Text(
              'Add Story',
              style: TextStyle(
                fontSize: responsive.sp(10),
                fontWeight: FontWeight.w600,
                color: AppTheme.textPrimary,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}

// ── Story Card ────────────────────────────────────────────────────────────────

class _StoryCard extends StatelessWidget {
  final Post story;
  final bool isViewed;
  final Responsive responsive;

  const _StoryCard({
    required this.story,
    required this.isViewed,
    required this.responsive,
  });

  // Time remaining as a 0–1 progress value
  double get _timeProgress {
    if (story.expiresAt == null) return 1.0;
    final total = story.expiresAt!.difference(story.createdAt).inSeconds;
    final remaining = story.expiresAt!.difference(DateTime.now()).inSeconds;
    if (total <= 0) return 0;
    return (remaining / total).clamp(0.0, 1.0);
  }

  String get _timeLabel {
    if (story.expiresAt == null) return '';
    final remaining = story.expiresAt!.difference(DateTime.now());
    if (remaining.isNegative) return 'Expired';
    if (remaining.inHours >= 1) return '${remaining.inHours}h';
    return '${remaining.inMinutes}m';
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('Opening ${story.userName}\'s story...'),
          behavior: SnackBarBehavior.floating,
          duration: const Duration(seconds: 1),
        ));
      },
      child: Container(
        width: responsive.sp(68),
        margin: EdgeInsets.only(right: responsive.sp(10)),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Stack(
              alignment: Alignment.center,
              children: [
                // Progress ring
                SizedBox(
                  width: responsive.sp(66),
                  height: responsive.sp(66),
                  child: CustomPaint(
                    painter: _StoryRingPainter(
                      progress: _timeProgress,
                      isViewed: isViewed,
                    ),
                  ),
                ),
                // White gap ring
                Container(
                  width: responsive.sp(58),
                  height: responsive.sp(58),
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: AppTheme.white,
                  ),
                ),
                // Avatar
                CircleAvatar(
                  radius: responsive.sp(26),
                  backgroundColor: AppTheme.greySoft,
                  backgroundImage: story.userAvatar != null
                      ? CachedNetworkImageProvider(story.userAvatar!)
                      : null,
                  child: story.userAvatar == null
                      ? Icon(Icons.person,
                          size: responsive.sp(24), color: AppTheme.greyMedium)
                      : null,
                ),
                // Time remaining badge
                if (_timeLabel.isNotEmpty)
                  Positioned(
                    bottom: 0,
                    child: Container(
                      padding: EdgeInsets.symmetric(
                          horizontal: responsive.sp(5), vertical: responsive.sp(1)),
                      decoration: BoxDecoration(
                        color: isViewed
                            ? AppTheme.greyMedium
                            : AppTheme.greenPrimary,
                        borderRadius:
                            BorderRadius.circular(responsive.sp(10)),
                      ),
                      child: Text(
                        _timeLabel,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: responsive.sp(8),
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ),
              ],
            ),
            SizedBox(height: responsive.sp(4)),
            Text(
              story.userName,
              style: TextStyle(
                fontSize: responsive.sp(10),
                fontWeight: isViewed ? FontWeight.w400 : FontWeight.w600,
                color: isViewed ? AppTheme.greyMedium : AppTheme.textPrimary,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}

// ── Story Ring Painter ────────────────────────────────────────────────────────

class _StoryRingPainter extends CustomPainter {
  final double progress;
  final bool isViewed;

  const _StoryRingPainter({required this.progress, required this.isViewed});

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = (size.width - 3) / 2;
    final strokeWidth = 2.5;

    // Background track (grey)
    final trackPaint = Paint()
      ..color = AppTheme.greySoft
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    canvas.drawCircle(center, radius, trackPaint);

    if (isViewed) return;

    // Progress arc (green gradient effect via single colour)
    final progressPaint = Paint()
      ..shader = const LinearGradient(
        colors: [AppTheme.greenPrimary, AppTheme.alertOrange],
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
      ).createShader(Rect.fromCircle(center: center, radius: radius))
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      -3.14159 / 2, // start at top
      2 * 3.14159 * progress,
      false,
      progressPaint,
    );
  }

  @override
  bool shouldRepaint(_StoryRingPainter old) =>
      old.progress != progress || old.isViewed != isViewed;
}
