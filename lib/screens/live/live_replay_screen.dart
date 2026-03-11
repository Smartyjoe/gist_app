import 'package:flutter/material.dart';
import '../../config/app_theme.dart';
import '../../utils/responsive.dart';

class LiveReplayScreen extends StatefulWidget {
  final String title;
  final int duration;
  final int peakViewers;

  const LiveReplayScreen({
    super.key,
    required this.title,
    required this.duration,
    required this.peakViewers,
  });

  @override
  State<LiveReplayScreen> createState() => _LiveReplayScreenState();
}

class _LiveReplayScreenState extends State<LiveReplayScreen> {
  late double _startHandle;
  late double _endHandle;
  late int _clipStartSeconds;
  late int _clipEndSeconds;

  @override
  void initState() {
    super.initState();
    _startHandle = 0.0;
    _endHandle = 1.0;
    _clipStartSeconds = 0;
    _clipEndSeconds = widget.duration;
  }

  String _formatDuration(int seconds) {
    final minutes = seconds ~/ 60;
    final secs = seconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:${secs.toString().padLeft(2, '0')}';
  }

  int _getClipDuration() {
    return _clipEndSeconds - _clipStartSeconds;
  }

  bool _isClipValid() {
    final clipDuration = _getClipDuration();
    return clipDuration >= 30 && clipDuration <= 60;
  }

  void _showSaveAsStoryDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Save as Story'),
        content: Text(
          'Save ${_formatDuration(_getClipDuration())} clip to your story?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Clip saved to story'),
                  duration: Duration(seconds: 2),
                ),
              );
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }

  void _showPostAsVideoDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Post as Video'),
        content: Text(
          'Post ${_formatDuration(_getClipDuration())} clip as a video?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Video posted'),
                  duration: Duration(seconds: 2),
                ),
              );
            },
            child: const Text('Post'),
          ),
        ],
      ),
    );
  }

  void _discardClip() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Discard Clip?'),
        content: const Text('Are you sure you want to discard this clip?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              Navigator.of(context).pop();
            },
            child: const Text(
              'Discard',
              style: TextStyle(color: Colors.red),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final responsive = Responsive(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Create Highlight Clip'),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(AppTheme.spacing16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Video timeline thumbnail
              Container(
                width: double.infinity,
                height: responsive.hp(20),
                decoration: BoxDecoration(
                  color: Colors.grey[800],
                  borderRadius: BorderRadius.circular(AppTheme.radiusLarge),
                ),
                child: Center(
                  child: Icon(
                    Icons.play_circle_outline,
                    size: 64,
                    color: Colors.grey[600],
                  ),
                ),
              ),
              SizedBox(height: AppTheme.spacing20),

              // Stream Summary
              Text(
                'Stream Summary',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              SizedBox(height: AppTheme.spacing12),
              _SummaryCard(
                label: 'Title',
                value: widget.title,
              ),
              SizedBox(height: AppTheme.spacing8),
              _SummaryCard(
                label: 'Duration',
                value: _formatDuration(widget.duration),
              ),
              SizedBox(height: AppTheme.spacing8),
              _SummaryCard(
                label: 'Peak Viewers',
                value: widget.peakViewers.toString(),
              ),
              SizedBox(height: AppTheme.spacing8),
              _SummaryCard(
                label: 'Total Hearts',
                value: '1,234 ❤️',
              ),
              SizedBox(height: AppTheme.spacing24),

              // Timeline scrubber
              Text(
                'Select Clip Range',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              SizedBox(height: AppTheme.spacing12),
              Text(
                'Clip duration: ${_formatDuration(_getClipDuration())} (${_getClipDuration()}s)',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: _isClipValid()
                          ? AppTheme.greenPrimary
                          : Colors.red,
                    ),
              ),
              SizedBox(height: AppTheme.spacing12),

              // Timeline with gradient
              Container(
                width: double.infinity,
                height: 60,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(AppTheme.radiusMedium),
                  gradient: LinearGradient(
                    colors: [
                      Colors.grey[800]!,
                      Colors.grey[700]!,
                      Colors.grey[800]!,
                    ],
                  ),
                ),
                child: Stack(
                  children: [
                    // Timeline markers
                    Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: AppTheme.spacing8,
                        vertical: AppTheme.spacing8,
                      ),
                      child: Row(
                        children: List.generate(
                          11,
                          (index) => Expanded(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Container(
                                  width: 1,
                                  height: 8,
                                  color: Colors.grey[600],
                                ),
                                Text(
                                  _formatDuration(
                                    (widget.duration * index ~/ 10),
                                  ),
                                  style: const TextStyle(
                                    fontSize: 8,
                                    color: Colors.grey,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),

                    // Start handle
                    Positioned(
                      left: _startHandle *
                          (MediaQuery.of(context).size.width -
                              AppTheme.spacing32 -
                              24),
                      top: 0,
                      bottom: 0,
                      child: GestureDetector(
                        onHorizontalDragUpdate: (details) {
                          setState(() {
                            _startHandle = (_startHandle +
                                    details.delta.dx /
                                        (MediaQuery.of(context).size.width -
                                            AppTheme.spacing32 -
                                            24))
                                .clamp(0.0, _endHandle - 0.1);
                            _clipStartSeconds =
                                (widget.duration * _startHandle).toInt();
                          });
                        },
                        child: Container(
                          width: 24,
                          decoration: BoxDecoration(
                            color: AppTheme.greenPrimary,
                            borderRadius:
                                BorderRadius.circular(AppTheme.radiusSmall),
                          ),
                          child: const Icon(
                            Icons.arrow_right,
                            size: 16,
                            color: AppTheme.white,
                          ),
                        ),
                      ),
                    ),

                    // End handle
                    Positioned(
                      right: (1 - _endHandle) *
                          (MediaQuery.of(context).size.width -
                              AppTheme.spacing32 -
                              24),
                      top: 0,
                      bottom: 0,
                      child: GestureDetector(
                        onHorizontalDragUpdate: (details) {
                          setState(() {
                            _endHandle = (_endHandle +
                                    details.delta.dx /
                                        (MediaQuery.of(context).size.width -
                                            AppTheme.spacing32 -
                                            24))
                                .clamp(_startHandle + 0.1, 1.0);
                            _clipEndSeconds =
                                (widget.duration * _endHandle).toInt();
                          });
                        },
                        child: Container(
                          width: 24,
                          decoration: BoxDecoration(
                            color: AppTheme.greenPrimary,
                            borderRadius:
                                BorderRadius.circular(AppTheme.radiusSmall),
                          ),
                          child: const Icon(
                            Icons.arrow_left,
                            size: 16,
                            color: AppTheme.white,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: AppTheme.spacing12),
              Text(
                'Drag handles to select clip (min: 30s, max: 60s)',
                style: Theme.of(context).textTheme.bodySmall,
              ),
              SizedBox(height: AppTheme.spacing24),

              // Action buttons
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: _isClipValid() ? _showSaveAsStoryDialog : null,
                      icon: const Icon(Icons.bookmark_add),
                      label: const Text('Save as Story'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: _isClipValid()
                            ? AppTheme.greenPrimary
                            : Colors.grey[400],
                      ),
                    ),
                  ),
                  SizedBox(width: AppTheme.spacing12),
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: _isClipValid() ? _showPostAsVideoDialog : null,
                      icon: const Icon(Icons.video_library),
                      label: const Text('Post as Video'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: _isClipValid()
                            ? AppTheme.greenPrimary
                            : Colors.grey[400],
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: AppTheme.spacing16),

              // Discard button
              SizedBox(
                width: double.infinity,
                child: OutlinedButton.icon(
                  onPressed: _discardClip,
                  icon: const Icon(Icons.delete),
                  label: const Text('Discard'),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: Colors.red,
                    side: const BorderSide(color: Colors.red),
                  ),
                ),
              ),
              SizedBox(height: AppTheme.spacing16),
            ],
          ),
        ),
      ),
    );
  }
}

class _SummaryCard extends StatelessWidget {
  final String label;
  final String value;

  const _SummaryCard({
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: AppTheme.spacing12,
        vertical: AppTheme.spacing12,
      ),
      decoration: BoxDecoration(
        color: AppTheme.white,
        border: Border.all(color: AppTheme.greySoft),
        borderRadius: BorderRadius.circular(AppTheme.radiusMedium),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: AppTheme.textSecondary,
                ),
          ),
          Text(
            value,
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
          ),
        ],
      ),
    );
  }
}
