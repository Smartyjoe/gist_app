import 'dart:async';
import 'package:flutter/material.dart';
import '../../models/voice_model.dart';
import '../../widgets/voice/voice_waveform.dart';
import '../../config/app_theme.dart';
import '../../utils/responsive.dart';

enum RecordingState { idle, recording, preview, sending }

class VoiceReplySheet extends StatefulWidget {
  final String postId;
  final Function(VoiceReply) onSend;

  const VoiceReplySheet({
    super.key,
    required this.postId,
    required this.onSend,
  });

  @override
  State<VoiceReplySheet> createState() => _VoiceReplySheetState();
}

class _VoiceReplySheetState extends State<VoiceReplySheet>
    with TickerProviderStateMixin {

  RecordingState _state = RecordingState.idle;
  int _recordingSeconds = 0;
  late Timer _recordingTimer;
  late AnimationController _waveformController;
  late List<double> _waveformBars;
  late List<double> _recordedWaveform;

  @override
  void initState() {
    super.initState();
    _waveformBars = List.generate(20, (_) => 0.1);
    _recordedWaveform = [];
    _waveformController = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );
  }

  @override
  void dispose() {
    _recordingTimer.cancel();
    _waveformController.dispose();
    super.dispose();
  }

  void _startRecording() {
    setState(() {
      _state = RecordingState.recording;
      _recordingSeconds = 0;
      _waveformBars = List.generate(20, (_) => 0.1);
      _recordedWaveform = [];
    });

    _recordingTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        _recordingSeconds++;
        // Animate waveform bars randomly
        _waveformBars = List.generate(
          20,
          (_) => 0.1 + (0.3 + 0.6 * (0.3 + 0.7 * DateTime.now().millisecond % 1000 / 1000)),
        );
        // Stop at max 20 seconds
        if (_recordingSeconds >= 20) {
          _stopRecording();
        }
      });
    });

    _waveformController.repeat();
  }

  void _stopRecording() {
    _recordingTimer.cancel();
    _waveformController.stop();

    // Convert animated bars to recorded waveform (simplified)
    _recordedWaveform = List.generate(30, (i) {
      final index = (i * 20 ~/ 30);
      return index < _waveformBars.length ? _waveformBars[index] : 0.5;
    });

    setState(() {
      _state = RecordingState.preview;
    });
  }

  void _reRecord() {
    setState(() {
      _state = RecordingState.idle;
      _recordingSeconds = 0;
      _waveformBars = List.generate(20, (_) => 0.1);
      _recordedWaveform = [];
    });
  }

  void _sendVoiceReply() async {
    setState(() {
      _state = RecordingState.sending;
    });

    // Simulate sending delay
    await Future.delayed(const Duration(milliseconds: 500));

    final voiceReply = VoiceReply(
      id: 'voice_${DateTime.now().millisecondsSinceEpoch}',
      postId: widget.postId,
      userId: 'current_user',
      userName: 'Your Name',
      userAvatar: 'https://api.dicebear.com/7.x/avataaars/svg?seed=You',
      durationSeconds: _recordingSeconds,
      createdAt: DateTime.now(),
      likes: 0,
      isLiked: false,
      waveformData: _recordedWaveform.isEmpty 
        ? VoiceReply.generateMockWaveform()
        : _recordedWaveform,
    );

    widget.onSend(voiceReply);

    if (mounted) {
      Navigator.pop(context);
    }
  }

  String _formatTime(int seconds) {
    final minutes = seconds ~/ 60;
    final secs = seconds % 60;
    return '$minutes:${secs.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    final responsive = Responsive(context);
    
    return Container(
      decoration: const BoxDecoration(
        color: AppTheme.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(AppTheme.radiusLarge),
          topRight: Radius.circular(AppTheme.radiusLarge),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Drag Handle
          Padding(
            padding: const EdgeInsets.only(top: AppTheme.spacing12),
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
            padding: const EdgeInsets.symmetric(vertical: AppTheme.spacing16),
            child: Text(
              'Voice Reply',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
          ),
          // Record Button
          GestureDetector(
            onTap: _state == RecordingState.idle ? _startRecording : null,
            child: Container(
              width: responsive.wp(40),
              height: responsive.wp(40),
              decoration: BoxDecoration(
                color: _state == RecordingState.recording
                    ? Colors.red
                    : AppTheme.greySoft,
                shape: BoxShape.circle,
              ),
              child: Center(
                child: Container(
                  width: responsive.wp(35),
                  height: responsive.wp(35),
                  decoration: BoxDecoration(
                    color: _state == RecordingState.recording
                        ? Colors.red.shade700
                        : AppTheme.greySoft,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.mic,
                    color: AppTheme.white,
                    size: responsive.wp(15),
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: AppTheme.spacing20),
          // Waveform Visualization
          Container(
            height: 60,
            margin: const EdgeInsets.symmetric(horizontal: AppTheme.spacing16),
            decoration: BoxDecoration(
              color: AppTheme.background,
              borderRadius: BorderRadius.circular(AppTheme.radiusMedium),
            ),
            child: _state == RecordingState.recording
                ? _buildAnimatedWaveform()
                : _state == RecordingState.preview
                    ? _buildStaticWaveform()
                    : Center(
                        child: Text(
                          'Tap mic to start recording',
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                      ),
          ),
          const SizedBox(height: AppTheme.spacing16),
          // Recording Timer
          Text(
            _formatTime(_recordingSeconds),
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: AppTheme.spacing24),
          // Action Buttons
          if (_state == RecordingState.recording)
            ElevatedButton.icon(
              onPressed: _stopRecording,
              icon: const Icon(Icons.stop),
              label: const Text('Stop'),
            )
          else if (_state == RecordingState.preview)
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton.icon(
                  onPressed: _reRecord,
                  icon: const Icon(Icons.refresh),
                  label: const Text('Re-record'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppTheme.greyMedium,
                    foregroundColor: AppTheme.white,
                  ),
                ),
                ElevatedButton.icon(
                  onPressed: _sendVoiceReply,
                  icon: const Icon(Icons.send),
                  label: const Text('Send'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppTheme.greenPrimary,
                  ),
                ),
              ],
            ),
          const SizedBox(height: AppTheme.spacing20),
        ],
      ),
    );
  }

  Widget _buildAnimatedWaveform() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppTheme.spacing16),
      child: Center(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: List.generate(
            20,
            (index) => AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              width: 3,
              height: 30 + (_waveformBars[index] * 20),
              decoration: BoxDecoration(
                color: AppTheme.greenPrimary,
                borderRadius: BorderRadius.circular(1.5),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildStaticWaveform() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppTheme.spacing16),
      child: Center(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: List.generate(
            20,
            (index) {
              final barHeight = 30 + (_recordedWaveform.isNotEmpty
                  ? _recordedWaveform[
                          (index * _recordedWaveform.length ~/ 20)
                              .clamp(0, _recordedWaveform.length - 1)] *
                      20
                  : 0.5 * 20);
              return Container(
                width: 3,
                height: barHeight,
                decoration: BoxDecoration(
                  color: AppTheme.greenPrimary,
                  borderRadius: BorderRadius.circular(1.5),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}

/// VoiceReplyListItem - displays voice replies in comment threads
class VoiceReplyListItem extends StatelessWidget {
  final VoiceReply voiceReply;
  final VoidCallback onPlayTap;
  final VoidCallback onLikeTap;
  final bool isPlaying;

  const VoiceReplyListItem({
    super.key,
    required this.voiceReply,
    required this.onPlayTap,
    required this.onLikeTap,
    this.isPlaying = false,
  });

  String _formatTime(DateTime time) {
    final now = DateTime.now();
    final difference = now.difference(time);

    if (difference.inMinutes < 1) {
      return 'now';
    } else if (difference.inHours < 1) {
      return '${difference.inMinutes}m ago';
    } else if (difference.inDays < 1) {
      return '${difference.inHours}h ago';
    } else if (difference.inDays < 7) {
      return '${difference.inDays}d ago';
    } else {
      return '${difference.inDays ~/ 7}w ago';
    }
  }

  String _formatDuration(int seconds) {
    final minutes = seconds ~/ 60;
    final secs = seconds % 60;
    return '$minutes:${secs.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border(
          left: BorderSide(
            color: AppTheme.greenPrimary,
            width: 4,
          ),
        ),
      ),
      padding: const EdgeInsets.all(AppTheme.spacing12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // User info
          Row(
            children: [
              CircleAvatar(
                radius: 18,
                backgroundImage: NetworkImage(voiceReply.userAvatar),
              ),
              const SizedBox(width: AppTheme.spacing8),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      voiceReply.userName,
                      style: Theme.of(context)
                          .textTheme
                          .titleMedium
                          ?.copyWith(fontWeight: FontWeight.w600),
                    ),
                    Text(
                      _formatTime(voiceReply.createdAt),
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: AppTheme.spacing12),
          // Waveform and Play Button
          Row(
            children: [
              // Play button
              GestureDetector(
                onTap: onPlayTap,
                child: Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: AppTheme.greenPrimary,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    isPlaying ? Icons.pause : Icons.play_arrow,
                    color: AppTheme.white,
                    size: 20,
                  ),
                ),
              ),
              const SizedBox(width: AppTheme.spacing12),
              // Waveform
              Expanded(
                child: VoiceWaveform(
                  waveformData: voiceReply.waveformData,
                  height: 40,
                  isPlaying: isPlaying,
                ),
              ),
              const SizedBox(width: AppTheme.spacing12),
              // Duration pill
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppTheme.spacing8,
                  vertical: AppTheme.spacing4,
                ),
                decoration: BoxDecoration(
                  color: AppTheme.background,
                  borderRadius: BorderRadius.circular(AppTheme.radiusMedium),
                ),
                child: Text(
                  _formatDuration(voiceReply.durationSeconds),
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppTheme.spacing12),
          // Like button and count
          GestureDetector(
            onTap: onLikeTap,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  voiceReply.isLiked ? Icons.favorite : Icons.favorite_outline,
                  color: voiceReply.isLiked ? Colors.red : AppTheme.greyMedium,
                  size: 18,
                ),
                const SizedBox(width: AppTheme.spacing4),
                Text(
                  '${voiceReply.likes}',
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
