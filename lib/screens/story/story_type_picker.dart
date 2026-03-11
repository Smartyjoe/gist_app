import 'package:flutter/material.dart';
import '../../config/app_theme.dart';
import '../../utils/responsive.dart';

class StoryTypePicker extends StatefulWidget {
  final VoidCallback? onCamera;
  final VoidCallback? onGallery;
  final VoidCallback? onText;
  final VoidCallback? onVoice;
  final VoidCallback? onLive;
  final VoidCallback? onPoll;

  const StoryTypePicker({
    super.key,
    this.onCamera,
    this.onGallery,
    this.onText,
    this.onVoice,
    this.onLive,
    this.onPoll,
  });

  /// Shows the story type picker bottom sheet
  static void show(
    BuildContext context, {
    VoidCallback? onCamera,
    VoidCallback? onGallery,
    VoidCallback? onText,
    VoidCallback? onVoice,
    VoidCallback? onLive,
    VoidCallback? onPoll,
  }) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => StoryTypePicker(
        onCamera: onCamera,
        onGallery: onGallery,
        onText: onText,
        onVoice: onVoice,
        onLive: onLive,
        onPoll: onPoll,
      ),
    );
  }

  @override
  State<StoryTypePicker> createState() => _StoryTypePickerState();
}

class _StoryTypePickerState extends State<StoryTypePicker>
    with SingleTickerProviderStateMixin {
  late AnimationController _pulseController;
  late Animation<double> _pulseAnimation;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    )..repeat(reverse: true);

    _pulseAnimation = Tween<double>(begin: 0.6, end: 1.0).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _pulseController.dispose();
    super.dispose();
  }

  void _handleStoryTypeSelection(VoidCallback? callback) {
    Navigator.pop(context);
    callback?.call();
  }

  @override
  Widget build(BuildContext context) {
    final responsive = Responsive(context);

    return Container(
      decoration: const BoxDecoration(
        color: AppTheme.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(24),
          topRight: Radius.circular(24),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Drag handle
          Padding(
            padding: const EdgeInsets.only(top: AppTheme.spacing16),
            child: Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: AppTheme.greySoft,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          // Title
          Padding(
            padding: const EdgeInsets.symmetric(
              vertical: AppTheme.spacing20,
              horizontal: AppTheme.spacing24,
            ),
            child: Text(
              'Create',
              style: Theme.of(context).textTheme.displaySmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
          ),
          // Grid of story type cards
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: AppTheme.spacing16,
            ),
            child: GridView.count(
              crossAxisCount: 2,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              mainAxisSpacing: AppTheme.spacing16,
              crossAxisSpacing: AppTheme.spacing16,
              childAspectRatio: 1.0,
              children: [
                _StoryTypeCard(
                  label: 'Camera Story',
                  icon: Icons.camera_alt,
                  color: Colors.blue,
                  onTap: () => _handleStoryTypeSelection(widget.onCamera),
                ),
                _StoryTypeCard(
                  label: 'Gallery Story',
                  icon: Icons.photo_library,
                  color: Colors.purple,
                  onTap: () => _handleStoryTypeSelection(widget.onGallery),
                ),
                _StoryTypeCard(
                  label: 'Text Story',
                  icon: Icons.text_fields,
                  color: Colors.orange,
                  onTap: () => _handleStoryTypeSelection(widget.onText),
                ),
                _StoryTypeCard(
                  label: 'Voice Story',
                  icon: Icons.mic,
                  color: AppTheme.greenPrimary,
                  onTap: () => _handleStoryTypeSelection(widget.onVoice),
                ),
                _GoLiveCard(
                  pulseAnimation: _pulseAnimation,
                  onTap: () => _handleStoryTypeSelection(widget.onLive),
                ),
                _StoryTypeCard(
                  label: 'Poll Story',
                  icon: Icons.poll,
                  color: Colors.teal,
                  onTap: () => _handleStoryTypeSelection(widget.onPoll),
                ),
              ],
            ),
          ),
          // Bottom padding
          SizedBox(height: responsive.safeAreaInsets.bottom + AppTheme.spacing16),
        ],
      ),
    );
  }
}

/// Standard story type card widget
class _StoryTypeCard extends StatelessWidget {
  final String label;
  final IconData icon;
  final Color color;
  final VoidCallback onTap;

  const _StoryTypeCard({
    required this.label,
    required this.icon,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final lightColor = color.withOpacity(0.1);

    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(AppTheme.radiusXLarge),
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              lightColor,
              lightColor.withOpacity(0.5),
            ],
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              color: color,
              size: 48,
            ),
            const SizedBox(height: AppTheme.spacing12),
            Text(
              label,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.labelLarge?.copyWith(
                    color: AppTheme.textPrimary,
                  ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Special card for Go Live with pulsing red dot animation
class _GoLiveCard extends StatelessWidget {
  final Animation<double> pulseAnimation;
  final VoidCallback onTap;

  const _GoLiveCard({
    required this.pulseAnimation,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final lightColor = Colors.red.withOpacity(0.1);

    return GestureDetector(
      onTap: onTap,
      child: Stack(
        children: [
          // Main card
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(AppTheme.radiusXLarge),
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  lightColor,
                  lightColor.withOpacity(0.5),
                ],
              ),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.live_tv,
                  color: Colors.red,
                  size: 48,
                ),
                const SizedBox(height: AppTheme.spacing12),
                Text(
                  'Go Live',
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.labelLarge?.copyWith(
                        color: AppTheme.textPrimary,
                      ),
                ),
              ],
            ),
          ),
          // Pulsing red dot in top-right corner
          Positioned(
            top: AppTheme.spacing12,
            right: AppTheme.spacing12,
            child: AnimatedBuilder(
              animation: pulseAnimation,
              builder: (context, child) {
                return Transform.scale(
                  scale: pulseAnimation.value,
                  child: Container(
                    width: 12,
                    height: 12,
                    decoration: BoxDecoration(
                      color: Colors.red,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.red.withOpacity(0.5),
                          blurRadius: 8,
                          spreadRadius: 2,
                        ),
                      ],
                    ),
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
