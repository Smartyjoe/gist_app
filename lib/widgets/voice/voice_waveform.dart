import 'package:flutter/material.dart';
import '../../config/app_theme.dart';
import '../../utils/responsive.dart';

class VoiceWaveform extends StatefulWidget {
  final List<double> waveformData;
  final bool isPlaying;
  final Color color;
  final double height;
  final double barWidth;
  final double barSpacing;

  const VoiceWaveform({
    super.key,
    required this.waveformData,
    required this.isPlaying,
    this.color = AppTheme.greenPrimary,
    this.height = 40,
    this.barWidth = 3,
    this.barSpacing = 2,
  });

  @override
  State<VoiceWaveform> createState() => _VoiceWaveformState();
}

class _VoiceWaveformState extends State<VoiceWaveform>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(seconds: 1),
      vsync: this,
    );
    if (widget.isPlaying) {
      _animationController.forward();
    }
  }

  @override
  void didUpdateWidget(VoiceWaveform oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isPlaying && !oldWidget.isPlaying) {
      _animationController.forward();
    } else if (!widget.isPlaying && oldWidget.isPlaying) {
      _animationController.stop();
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animationController,
      builder: (context, child) {
        return CustomPaint(
          painter: _WaveformPainter(
            waveformData: widget.waveformData,
            color: widget.color,
            progress: _animationController.value,
            barWidth: widget.barWidth,
            barSpacing: widget.barSpacing,
          ),
          size: Size(double.infinity, widget.height),
        );
      },
    );
  }
}

class _WaveformPainter extends CustomPainter {
  final List<double> waveformData;
  final Color color;
  final double progress;
  final double barWidth;
  final double barSpacing;

  _WaveformPainter({
    required this.waveformData,
    required this.color,
    required this.progress,
    required this.barWidth,
    required this.barSpacing,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final barCount = waveformData.length;
    final totalBarWidth = barCount * barWidth + (barCount - 1) * barSpacing;
    final startX = (size.width - totalBarWidth) / 2;
    final centerY = size.height / 2;

    for (int i = 0; i < barCount; i++) {
      final x = startX + i * (barWidth + barSpacing);
      final barHeight = waveformData[i] * size.height;

      // Determine if this bar is in the played section
      final progressX = startX + progress * totalBarWidth;
      final isPlayed = x < progressX;

      // Draw bar
      final paintColor = isPlayed ? color : color.withOpacity(0.3);
      canvas.drawRRect(
        RRect.fromRectAndRadius(
          Rect.fromCenter(
            center: Offset(x + barWidth / 2, centerY),
            width: barWidth,
            height: barHeight,
          ),
          const Radius.circular(1.5),
        ),
        Paint()
          ..color = paintColor
          ..style = PaintingStyle.fill,
      );
    }
  }

  @override
  bool shouldRepaint(_WaveformPainter oldDelegate) {
    return oldDelegate.progress != progress ||
        oldDelegate.color != color ||
        oldDelegate.waveformData != waveformData;
  }
}

class VoicePlayerCard extends StatelessWidget {
  final String userName;
  final String userAvatar;
  final List<double> waveformData;
  final int durationSeconds;
  final int likes;
  final bool isLiked;
  final VoidCallback onPlayToggle;
  final VoidCallback onLike;

  const VoicePlayerCard({
    super.key,
    required this.userName,
    required this.userAvatar,
    required this.waveformData,
    required this.durationSeconds,
    required this.likes,
    required this.isLiked,
    required this.onPlayToggle,
    required this.onLike,
  });

  String _formatDuration(int seconds) {
    final minutes = seconds ~/ 60;
    final secs = seconds % 60;
    return '$minutes:${secs.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(
        horizontal: AppTheme.spacing16,
        vertical: AppTheme.spacing12,
      ),
      child: Padding(
        padding: EdgeInsets.all(AppTheme.spacing12),
        child: Row(
          children: [
            // Avatar
            CircleAvatar(
              radius: 20,
              backgroundImage: NetworkImage(userAvatar),
              backgroundColor: AppTheme.greySoft,
            ),
            SizedBox(width: AppTheme.spacing12),
            // Content
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    userName,
                    style: const TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 14,
                      color: AppTheme.textPrimary,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(height: AppTheme.spacing8),
                  SizedBox(
                    height: 30,
                    child: VoiceWaveform(
                      waveformData: waveformData,
                      isPlaying: false,
                      color: AppTheme.greenPrimary,
                      height: 30,
                      barWidth: 2,
                      barSpacing: 1.5,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(width: AppTheme.spacing12),
            // Duration
            Text(
              _formatDuration(durationSeconds),
              style: const TextStyle(
                fontSize: 12,
                color: AppTheme.textSecondary,
                fontWeight: FontWeight.w500,
              ),
            ),
            SizedBox(width: AppTheme.spacing8),
            // Play/Pause Button
            GestureDetector(
              onTap: onPlayToggle,
              child: Container(
                padding: EdgeInsets.all(AppTheme.spacing8),
                decoration: BoxDecoration(
                  color: AppTheme.greenPrimary,
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.play_arrow,
                  color: AppTheme.white,
                  size: 16,
                ),
              ),
            ),
            SizedBox(width: AppTheme.spacing8),
            // Like Button
            GestureDetector(
              onTap: onLike,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    isLiked ? Icons.favorite : Icons.favorite_border,
                    color: isLiked ? Colors.red : AppTheme.textSecondary,
                    size: 18,
                  ),
                  SizedBox(height: 2),
                  Text(
                    likes.toString(),
                    style: const TextStyle(
                      fontSize: 10,
                      color: AppTheme.textSecondary,
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
