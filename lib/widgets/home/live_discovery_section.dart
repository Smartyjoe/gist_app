import 'package:flutter/material.dart';
import '../../models/live_model.dart';
import '../../config/app_theme.dart';
import '../../utils/responsive.dart';

class LiveDiscoverySection extends StatelessWidget {
  const LiveDiscoverySection({super.key});

  @override
  Widget build(BuildContext context) {
    final liveStreams = LiveModel.getMockLiveStreams();
    final activeLiveStreams =
        liveStreams.where((stream) => stream.isLive).toList();

    // Only render if there are active live streams
    if (activeLiveStreams.isEmpty) {
      return const SizedBox.shrink();
    }

    final responsive = Responsive(context);

    return Container(
      color: const Color(0xFF0F9D58).withValues(alpha: 0.08),
      padding: EdgeInsets.symmetric(
        horizontal: responsive.horizontalPadding,
        vertical: AppTheme.spacing16,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header row with pulsing dot
          Padding(
            padding: const EdgeInsets.only(bottom: AppTheme.spacing12),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    _PulsingDot(),
                    const SizedBox(width: AppTheme.spacing8),
                    Text(
                      'Live Now',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                  ],
                ),
                TextButton(
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Viewing all live streams')),
                    );
                  },
                  child: const Text('See all'),
                ),
              ],
            ),
          ),
          // Horizontal scrollable list of live cards
          SizedBox(
            height: 200.0,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: activeLiveStreams.length,
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.only(right: AppTheme.spacing12),
                  child: LiveCard(
                    liveStream: activeLiveStreams[index],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class LiveCard extends StatefulWidget {
  final LiveModel liveStream;

  const LiveCard({
    super.key,
    required this.liveStream,
  });

  @override
  State<LiveCard> createState() => _LiveCardState();
}

class _LiveCardState extends State<LiveCard> with TickerProviderStateMixin {
  late AnimationController _pulseController;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    )..repeat();
  }

  @override
  void dispose() {
    _pulseController.dispose();
    super.dispose();
  }

  String _formatViewerCount(int count) {
    if (count >= 1000) {
      return '${(count / 1000).toStringAsFixed(1)}K watching';
    }
    return '$count watching';
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Joining ${widget.liveStream.hostName}\'s live...'),
          ),
        );
      },
      child: Container(
        width: 140.0,
        height: 180.0,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(AppTheme.radiusXLarge),
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Colors.grey[800]!,
              Colors.grey[900]!,
            ],
          ),
        ),
        child: Stack(
          children: [
            // Background image or placeholder
            ClipRRect(
              borderRadius: BorderRadius.circular(AppTheme.radiusXLarge),
              child: widget.liveStream.thumbnailUrl != null
                  ? Image.network(
                      widget.liveStream.thumbnailUrl!,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return Container(
                          color: Colors.grey[800],
                        );
                      },
                    )
                  : Container(
                      color: Colors.grey[800],
                    ),
            ),
            // Gradient overlay
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(AppTheme.radiusXLarge),
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.transparent,
                    Colors.black.withValues(alpha: 0.8),
                  ],
                ),
              ),
            ),
            // Profile photo (circular, top-center)
            Positioned(
              top: AppTheme.spacing8,
              left: 0,
              right: 0,
              child: Center(
                child: Container(
                  width: 40.0,
                  height: 40.0,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: AppTheme.white,
                      width: 2.0,
                    ),
                  ),
                  child: ClipOval(
                    child: widget.liveStream.hostAvatar != null
                        ? Image.network(
                            widget.liveStream.hostAvatar!,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) {
                              return Container(
                                color: AppTheme.greyMedium,
                                child: const Icon(Icons.person),
                              );
                            },
                          )
                        : Container(
                            color: AppTheme.greyMedium,
                            child: const Icon(Icons.person),
                          ),
                  ),
                ),
              ),
            ),
            // LIVE badge with pulsing animation (top-right)
            Positioned(
              top: AppTheme.spacing8,
              right: AppTheme.spacing8,
              child: ScaleTransition(
                scale: Tween<double>(begin: 1.0, end: 1.08)
                    .animate(CurvedAnimation(
                  parent: _pulseController,
                  curve: Curves.easeInOut,
                )),
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 6.0,
                    vertical: 2.0,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.red,
                    borderRadius: BorderRadius.circular(4.0),
                  ),
                  child: Text(
                    'LIVE',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: AppTheme.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 10.0,
                        ),
                  ),
                ),
              ),
            ),
            // Bottom content
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Padding(
                padding: const EdgeInsets.all(AppTheme.spacing8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Viewer count
                    Text(
                      _formatViewerCount(widget.liveStream.viewerCount),
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: AppTheme.white,
                            fontSize: 11.0,
                          ),
                    ),
                    const SizedBox(height: AppTheme.spacing4),
                    // Stream title (2 lines max)
                    Text(
                      widget.liveStream.title,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: AppTheme.white,
                            fontWeight: FontWeight.w600,
                            fontSize: 12.0,
                          ),
                    ),
                    const SizedBox(height: AppTheme.spacing4),
                    // Username
                    Text(
                      widget.liveStream.hostName,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: AppTheme.greySoft,
                            fontSize: 11.0,
                          ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _PulsingDot extends StatefulWidget {
  const _PulsingDot();

  @override
  State<_PulsingDot> createState() => _PulsingDotState();
}

class _PulsingDotState extends State<_PulsingDot>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    )..repeat();

    _animation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return Container(
          width: 12.0,
          height: 12.0,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.green,
            boxShadow: [
              BoxShadow(
                color: Colors.green.withValues(alpha: _animation.value * 0.7),
                blurRadius: 4.0 + (_animation.value * 8.0),
                spreadRadius: _animation.value * 3.0,
              ),
            ],
          ),
        );
      },
    );
  }
}
