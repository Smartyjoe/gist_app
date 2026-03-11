import 'package:flutter/material.dart';
import 'dart:async';
import '../../config/app_theme.dart';
import '../../models/live_model.dart';
import '../../utils/responsive.dart';
import 'live_replay_screen.dart';

class LiveBroadcastScreen extends StatefulWidget {
  final String title;
  final LiveAudience audience;
  final String category;

  const LiveBroadcastScreen({
    super.key,
    required this.title,
    required this.audience,
    required this.category,
  });

  @override
  State<LiveBroadcastScreen> createState() => _LiveBroadcastScreenState();
}

class _LiveBroadcastScreenState extends State<LiveBroadcastScreen>
    with TickerProviderStateMixin {
  late Timer _timerUpdater;
  late Timer _commentUpdater;
  late Timer _viewerUpdater;
  late AnimationController _heartAnimController;

  final TextEditingController _commentController = TextEditingController();
  final List<LiveComment> _comments = [];
  int _viewerCount = 245;
  int _secondsElapsed = 0;
  int _currentCommentIndex = 0;
  bool _isMicOn = true;
  bool _isCameraOn = true;
  bool _hasCoHost = false;

  final List<_FloatingHeart> _floatingHearts = [];
  int _heartIdCounter = 0;

  @override
  void initState() {
    super.initState();
    _comments.addAll(LiveModel.getMockLiveComments().take(6));

    _heartAnimController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2000),
    );

    // Timer for counting up
    _timerUpdater = Timer.periodic(const Duration(seconds: 1), (_) {
      setState(() {
        _secondsElapsed++;
      });
    });

    // Timer for new comments every 3 seconds
    _commentUpdater = Timer.periodic(const Duration(seconds: 3), (_) {
      _addMockComment();
    });

    // Timer for viewer count increment every 5 seconds
    _viewerUpdater = Timer.periodic(const Duration(seconds: 5), (_) {
      setState(() {
        _viewerCount += (1 + (_viewerCount % 3));
      });
    });
  }

  @override
  void dispose() {
    _timerUpdater.cancel();
    _commentUpdater.cancel();
    _viewerUpdater.cancel();
    _heartAnimController.dispose();
    _commentController.dispose();
    super.dispose();
  }

  void _addMockComment() {
    final allComments = LiveModel.getMockLiveComments();
    if (_currentCommentIndex < allComments.length) {
      setState(() {
        _comments.add(allComments[_currentCommentIndex]);
        if (_comments.length > 6) {
          _comments.removeAt(0);
        }
        _currentCommentIndex++;
        if (_currentCommentIndex >= allComments.length) {
          _currentCommentIndex = 0;
        }
      });
    }
  }

  void _addFloatingHeart() {
    final heart = _FloatingHeart(
      id: _heartIdCounter++,
      left: MediaQuery.of(context).size.width * 0.8 +
          (DateTime.now().millisecond % 40 - 20).toDouble(),
    );
    setState(() {
      _floatingHearts.add(heart);
    });

    Future.delayed(const Duration(milliseconds: 2000), () {
      setState(() {
        _floatingHearts.removeWhere((h) => h.id == heart.id);
      });
    });
  }

  String _formatDuration(int seconds) {
    final hours = seconds ~/ 3600;
    final minutes = (seconds % 3600) ~/ 60;
    final secs = seconds % 60;

    if (hours > 0) {
      return '$hours:${minutes.toString().padLeft(2, '0')}:${secs.toString().padLeft(2, '0')}';
    }
    return '${minutes.toString().padLeft(2, '0')}:${secs.toString().padLeft(2, '0')}';
  }

  void _showEndLiveDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('End Live?'),
        content: const Text('Are you sure you want to end this live stream?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              Navigator.of(context).pushReplacement(
                MaterialPageRoute(
                  builder: (context) => LiveReplayScreen(
                    title: widget.title,
                    duration: _secondsElapsed,
                    peakViewers: _viewerCount,
                  ),
                ),
              );
            },
            child: const Text(
              'End Live',
              style: TextStyle(color: Colors.red),
            ),
          ),
        ],
      ),
    );
  }

  void _showCoHostSheet() {
    setState(() {
      _hasCoHost = !_hasCoHost;
    });
  }

  void _shareStream() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Share stream feature')),
    );
  }

  @override
  Widget build(BuildContext context) {
    final responsive = Responsive(context);

    return Scaffold(
      body: GestureDetector(
        onTap: _addFloatingHeart,
        child: Stack(
          children: [
            // Camera preview background
            Container(
              width: double.infinity,
              height: double.infinity,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.grey[800]!,
                    Colors.grey[900]!,
                  ],
                ),
              ),
              child: _hasCoHost
                  ? Row(
                      children: [
                        Expanded(
                          child: Container(
                            color: Colors.grey[800],
                            child: const Center(
                              child: Icon(
                                Icons.camera_alt,
                                size: 48,
                                color: AppTheme.white,
                              ),
                            ),
                          ),
                        ),
                        Expanded(
                          child: Container(
                            color: Colors.grey[850],
                            child: const Center(
                              child: Icon(
                                Icons.camera_alt,
                                size: 48,
                                color: AppTheme.white,
                              ),
                            ),
                          ),
                        ),
                      ],
                    )
                  : Center(
                      child: Icon(
                        Icons.camera_alt,
                        size: 80,
                        color: Colors.grey[700],
                      ),
                    ),
            ),

            // Floating hearts
            ..._floatingHearts.map((heart) {
              return _FloatingHeartWidget(heart: heart);
            }),

            // Top bar with LIVE badge and info
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              child: Container(
                padding: EdgeInsets.fromLTRB(
                  AppTheme.spacing16,
                  MediaQuery.of(context).padding.top + AppTheme.spacing12,
                  AppTheme.spacing16,
                  AppTheme.spacing12,
                ),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.black.withValues(alpha: 0.6),
                      Colors.transparent,
                    ],
                  ),
                ),
                child: Row(
                  children: [
                    // LIVE badge
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.red,
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: const Row(
                        children: [
                          Icon(
                            Icons.circle,
                            size: 8,
                            color: AppTheme.white,
                          ),
                          SizedBox(width: 4),
                          Text(
                            'LIVE',
                            style: TextStyle(
                              color: AppTheme.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(width: AppTheme.spacing8),

                    // Viewer count
                    Text(
                      '$_viewerCount viewers',
                      style: const TextStyle(
                        color: AppTheme.white,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const Spacer(),

                    // Duration timer
                    Text(
                      _formatDuration(_secondsElapsed),
                      style: const TextStyle(
                        color: AppTheme.white,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    SizedBox(width: AppTheme.spacing12),

                    // Flip camera icon
                    GestureDetector(
                      onTap: () => ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Camera flipped')),
                      ),
                      child: Icon(
                        Icons.flip_camera_ios,
                        color: AppTheme.white,
                        size: 24,
                      ),
                    ),
                    SizedBox(width: AppTheme.spacing12),

                    // End button
                    GestureDetector(
                      onTap: _showEndLiveDialog,
                      child: const Icon(
                        Icons.close,
                        color: AppTheme.white,
                        size: 24,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Bottom comment stream and input
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Comments
                  Container(
                    height: responsive.hp(25),
                    padding: EdgeInsets.all(AppTheme.spacing12),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.bottomCenter,
                        end: Alignment.topCenter,
                        colors: [
                          Colors.black.withValues(alpha: 0.8),
                          Colors.black.withValues(alpha: 0.3),
                        ],
                      ),
                    ),
                    child: ListView.builder(
                      reverse: true,
                      itemCount: _comments.length,
                      itemBuilder: (context, index) {
                        final comment = _comments[index];
                        return Padding(
                          padding: EdgeInsets.only(bottom: AppTheme.spacing8),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              CircleAvatar(
                                backgroundImage: NetworkImage(
                                  comment.userAvatar ?? '',
                                ),
                                radius: 16,
                              ),
                              SizedBox(width: AppTheme.spacing8),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        Text(
                                          comment.userName,
                                          style: const TextStyle(
                                            color: AppTheme.white,
                                            fontWeight: FontWeight.w600,
                                            fontSize: 12,
                                          ),
                                        ),
                                        if (comment.isHost)
                                          Padding(
                                            padding: EdgeInsets.only(
                                              left: AppTheme.spacing4,
                                            ),
                                            child: const Icon(
                                              Icons.star,
                                              size: 12,
                                              color: Colors.orange,
                                            ),
                                          ),
                                      ],
                                    ),
                                    Text(
                                      comment.text,
                                      style: const TextStyle(
                                        color: AppTheme.white,
                                        fontSize: 12,
                                      ),
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ),

                  // Comment input
                  Container(
                    padding: EdgeInsets.all(AppTheme.spacing12),
                    color: Colors.black.withValues(alpha: 0.9),
                    child: Row(
                      children: [
                        Expanded(
                          child: TextField(
                            controller: _commentController,
                            style: const TextStyle(color: AppTheme.white),
                            decoration: InputDecoration(
                              hintText: 'Add a comment...',
                              hintStyle: const TextStyle(
                                color: Colors.grey,
                              ),
                              filled: true,
                              fillColor: Colors.grey[800],
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(24),
                                borderSide: BorderSide.none,
                              ),
                              contentPadding: EdgeInsets.symmetric(
                                horizontal: AppTheme.spacing16,
                                vertical: AppTheme.spacing8,
                              ),
                            ),
                          ),
                        ),
                        SizedBox(width: AppTheme.spacing8),
                        GestureDetector(
                          onTap: () {
                            if (_commentController.text.isNotEmpty) {
                              _commentController.clear();
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('Comment posted'),
                                  duration: Duration(milliseconds: 500),
                                ),
                              );
                            }
                          },
                          child: const Icon(
                            Icons.send,
                            color: AppTheme.greenPrimary,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            // Bottom control buttons overlay
            Positioned(
              bottom: responsive.hp(27),
              left: 0,
              right: 0,
              child: Container(
                padding: EdgeInsets.symmetric(
                  horizontal: AppTheme.spacing16,
                  vertical: AppTheme.spacing12,
                ),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.bottomCenter,
                    end: Alignment.topCenter,
                    colors: [
                      Colors.black.withValues(alpha: 0.5),
                      Colors.transparent,
                    ],
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    // Mic toggle
                    _ControlButton(
                      icon: _isMicOn ? Icons.mic : Icons.mic_off,
                      onTap: () => setState(() => _isMicOn = !_isMicOn),
                    ),

                    // Camera toggle
                    _ControlButton(
                      icon: _isCameraOn ? Icons.videocam : Icons.videocam_off,
                      onTap: () => setState(() => _isCameraOn = !_isCameraOn),
                    ),

                    // Invite co-host
                    _ControlButton(
                      icon: Icons.person_add,
                      onTap: _showCoHostSheet,
                    ),

                    // Share
                    _ControlButton(
                      icon: Icons.share,
                      onTap: _shareStream,
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

class _ControlButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;

  const _ControlButton({
    required this.icon,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.black.withValues(alpha: 0.6),
          shape: BoxShape.circle,
        ),
        child: Icon(
          icon,
          color: AppTheme.white,
          size: 24,
        ),
      ),
    );
  }
}

class _FloatingHeart {
  final int id;
  final double left;

  _FloatingHeart({
    required this.id,
    required this.left,
  });
}

class _FloatingHeartWidget extends StatefulWidget {
  final _FloatingHeart heart;

  const _FloatingHeartWidget({required this.heart});

  @override
  State<_FloatingHeartWidget> createState() => _FloatingHeartWidgetState();
}

class _FloatingHeartWidgetState extends State<_FloatingHeartWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Offset> _offsetAnimation;
  late Animation<double> _opacityAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    );

    _offsetAnimation = Tween<Offset>(
      begin: Offset(0, 0),
      end: const Offset(0, -300),
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));

    _opacityAnimation = Tween<double>(begin: 1.0, end: 0.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOut),
    );

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: widget.heart.left,
      bottom: 100,
      child: ScaleTransition(
        scale: Tween<double>(begin: 1.0, end: 0.3).animate(_controller),
        child: FadeTransition(
          opacity: _opacityAnimation,
          child: SlideTransition(
            position: _offsetAnimation,
            child: const Text(
              '❤️',
              style: TextStyle(fontSize: 40),
            ),
          ),
        ),
      ),
    );
  }
}
