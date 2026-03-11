import 'package:flutter/material.dart';
import '../../models/story_model.dart';
import '../../config/app_theme.dart';
import '../../utils/responsive.dart';

enum StoryMode { text, voice }

class StoryCreatorScreen extends StatefulWidget {
  final StoryType storyType;

  const StoryCreatorScreen({
    super.key,
    required this.storyType,
  });

  @override
  State<StoryCreatorScreen> createState() => _StoryCreatorScreenState();
}

class _StoryCreatorScreenState extends State<StoryCreatorScreen>
    with TickerProviderStateMixin {
  late TextEditingController _textController;
  late StoryBackground _selectedBackground;
  late bool _isBold;
  late bool _isItalic;
  late double _fontSize;
  late AnimationController _pulseController;
  late AnimationController _waveController;
  late bool _isRecording;
  late int _recordingSeconds;

  @override
  void initState() {
    super.initState();
    _textController = TextEditingController();
    _selectedBackground = StoryModel.backgroundOptions.first;
    _isBold = false;
    _isItalic = false;
    _fontSize = 24.0;
    _isRecording = false;
    _recordingSeconds = 0;

    _pulseController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    )..repeat();

    _waveController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    )..repeat();
  }

  @override
  void dispose() {
    _textController.dispose();
    _pulseController.dispose();
    _waveController.dispose();
    super.dispose();
  }

  void _toggleRecording() {
    setState(() {
      _isRecording = !_isRecording;
      if (_isRecording) {
        _recordingSeconds = 0;
      }
    });

    if (_isRecording) {
      _simulateRecording();
    }
  }

  void _simulateRecording() async {
    while (_isRecording && _recordingSeconds < 30) {
      await Future.delayed(const Duration(seconds: 1));
      if (mounted && _isRecording) {
        setState(() {
          _recordingSeconds++;
        });
      }
    }
    if (mounted && _recordingSeconds >= 30) {
      setState(() {
        _isRecording = false;
      });
    }
  }

  void _shareStory() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          widget.storyType == StoryType.text
              ? 'Text story shared!'
              : 'Voice story shared!',
        ),
      ),
    );
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final responsive = Responsive(context);

    if (widget.storyType == StoryType.text) {
      return _buildTextStoryMode(context, responsive);
    } else {
      return _buildVoiceStoryMode(context, responsive);
    }
  }

  Widget _buildTextStoryMode(BuildContext context, Responsive responsive) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: const Text('Text Story'),
        actions: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Center(
              child: TextButton(
                onPressed:
                    _textController.text.isEmpty ? null : _handleTextStoryNext,
                child: const Text('Next'),
              ),
            ),
          ),
        ],
      ),
      body: Stack(
        children: [
          // Background preview
          Container(
            decoration: _getBackgroundDecoration(_selectedBackground),
          ),
          // Main content
          Column(
            children: [
              Expanded(
                child: Center(
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: responsive.horizontalPadding,
                    ),
                    child: TextField(
                      controller: _textController,
                      maxLength: 150,
                      maxLines: null,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: _fontSize,
                        fontWeight: _isBold ? FontWeight.bold : FontWeight.normal,
                        fontStyle:
                            _isItalic ? FontStyle.italic : FontStyle.normal,
                        color: AppTheme.textPrimary,
                      ),
                      decoration: InputDecoration(
                        hintText: 'Share your story...',
                        hintStyle: TextStyle(
                          fontSize: _fontSize,
                          color: AppTheme.greyMedium,
                        ),
                        border: InputBorder.none,
                        counterText: '',
                      ),
                      onChanged: (value) {
                        setState(() {});
                      },
                    ),
                  ),
                ),
              ),
              // Character counter
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Text(
                  '${_textController.text.length}/150',
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ),
              const SizedBox(height: 16.0),
              // Text style options
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _StyleToggleButton(
                      icon: Icons.format_bold,
                      isActive: _isBold,
                      onPressed: () {
                        setState(() {
                          _isBold = !_isBold;
                        });
                      },
                    ),
                    const SizedBox(width: 12.0),
                    _StyleToggleButton(
                      icon: Icons.format_italic,
                      isActive: _isItalic,
                      onPressed: () {
                        setState(() {
                          _isItalic = !_isItalic;
                        });
                      },
                    ),
                    const SizedBox(width: 12.0),
                    PopupMenuButton<double>(
                      initialValue: _fontSize,
                      onSelected: (value) {
                        setState(() {
                          _fontSize = value;
                        });
                      },
                      itemBuilder: (context) => [
                        const PopupMenuItem(value: 18.0, child: Text('Small')),
                        const PopupMenuItem(value: 24.0, child: Text('Medium')),
                        const PopupMenuItem(value: 32.0, child: Text('Large')),
                      ],
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12.0,
                          vertical: 8.0,
                        ),
                        decoration: BoxDecoration(
                          border: Border.all(color: AppTheme.greySoft),
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                        child: const Icon(Icons.text_fields),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16.0),
              // Background picker
              SizedBox(
                height: 80.0,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  itemCount: StoryModel.backgroundOptions.length,
                  itemBuilder: (context, index) {
                    final bg = StoryModel.backgroundOptions[index];
                    final isSelected = bg.label == _selectedBackground.label;
                    return Padding(
                      padding: const EdgeInsets.only(right: 12.0),
                      child: GestureDetector(
                        onTap: () {
                          setState(() {
                            _selectedBackground = bg;
                          });
                        },
                        child: Container(
                          width: 70.0,
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: isSelected
                                  ? AppTheme.greenPrimary
                                  : AppTheme.greySoft,
                              width: isSelected ? 3.0 : 1.0,
                            ),
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                          child: Container(
                            decoration: _getBackgroundDecoration(bg),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(height: 16.0),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildVoiceStoryMode(BuildContext context, Responsive responsive) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: const Text('Voice Story'),
        centerTitle: true,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              AppTheme.greenPrimary.withValues(alpha: 0.3),
              AppTheme.greenDark.withValues(alpha: 0.3),
            ],
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // Timer display
            Padding(
              padding: EdgeInsets.only(top: responsive.verticalPadding),
              child: Text(
                '${_recordingSeconds.toString().padLeft(2, '0')}:00',
                style: Theme.of(context).textTheme.displaySmall?.copyWith(
                      color: AppTheme.textPrimary,
                    ),
              ),
            ),
            // Waveform visualization
            if (_isRecording)
              Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: responsive.horizontalPadding,
                ),
                child: _WaveformVisualizer(
                  controller: _waveController,
                  isRecording: _isRecording,
                ),
              )
            else
              Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: responsive.horizontalPadding,
                ),
                child: Text(
                  _recordingSeconds > 0
                      ? 'Recording ready to play'
                      : 'Ready to record',
                  style: Theme.of(context).textTheme.bodyLarge,
                  textAlign: TextAlign.center,
                ),
              ),
            // Record button
            Center(
              child: GestureDetector(
                onTap: _isRecording || _recordingSeconds >= 30
                    ? null
                    : _toggleRecording,
                child: ScaleTransition(
                  scale: Tween<double>(
                    begin: 1.0,
                    end: 1.08,
                  ).animate(
                    CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
                  ),
                  child: Container(
                    width: 100.0,
                    height: 100.0,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: _isRecording
                          ? Colors.red
                          : AppTheme.greenPrimary,
                      boxShadow: [
                        BoxShadow(
                          color: (_isRecording ? Colors.red : AppTheme.greenPrimary)
                              .withValues(alpha: 0.5),
                          blurRadius: 16.0,
                          spreadRadius: 4.0,
                        ),
                      ],
                    ),
                    child: Icon(
                      _isRecording ? Icons.stop : Icons.mic,
                      color: AppTheme.white,
                      size: 40.0,
                    ),
                  ),
                ),
              ),
            ),
            // Action buttons
            Padding(
              padding: EdgeInsets.all(responsive.verticalPadding),
              child: Column(
                children: [
                  if (_recordingSeconds > 0)
                    ElevatedButton(
                      onPressed: _isRecording ? null : _toggleRecording,
                      child: const Text('Re-record'),
                    ),
                  const SizedBox(height: 12.0),
                  ElevatedButton.icon(
                    onPressed: _recordingSeconds == 0 ? null : _shareStory,
                    icon: const Icon(Icons.share),
                    label: const Text('Share as Story'),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _handleTextStoryNext() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Story Preview'),
        content: Container(
          width: 300.0,
          height: 400.0,
          decoration: _getBackgroundDecoration(_selectedBackground),
          child: Center(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                _textController.text,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: _fontSize,
                  fontWeight: _isBold ? FontWeight.bold : FontWeight.normal,
                  fontStyle: _isItalic ? FontStyle.italic : FontStyle.normal,
                  color: AppTheme.textPrimary,
                ),
              ),
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Back'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop();
              _shareStory();
            },
            child: const Text('Share Story'),
          ),
        ],
      ),
    );
  }

  BoxDecoration _getBackgroundDecoration(StoryBackground background) {
    if (background.type == 'solid') {
      return BoxDecoration(
        color: background.colors.first,
      );
    } else {
      return BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: background.colors,
        ),
      );
    }
  }
}

class _StyleToggleButton extends StatelessWidget {
  final IconData icon;
  final bool isActive;
  final VoidCallback onPressed;

  const _StyleToggleButton({
    required this.icon,
    required this.isActive,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        padding: const EdgeInsets.all(8.0),
        decoration: BoxDecoration(
          color: isActive ? AppTheme.greenPrimary : AppTheme.greySoft,
          borderRadius: BorderRadius.circular(8.0),
        ),
        child: Icon(
          icon,
          color: isActive ? AppTheme.white : AppTheme.textSecondary,
          size: 24.0,
        ),
      ),
    );
  }
}

class _WaveformVisualizer extends StatelessWidget {
  final AnimationController controller;
  final bool isRecording;

  const _WaveformVisualizer({
    required this.controller,
    required this.isRecording,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 100.0,
      child: AnimatedBuilder(
        animation: controller,
        builder: (context, child) {
          return Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(
              12,
              (index) {
                final progress = controller.value;
                final offset = (index / 12 - progress) % 1.0;
                final height = 20.0 + (50.0 * (1 - (offset * 2).abs().clamp(0, 1)));

                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 4.0),
                  child: Container(
                    width: 4.0,
                    height: height,
                    decoration: BoxDecoration(
                      color: AppTheme.greenPrimary,
                      borderRadius: BorderRadius.circular(2.0),
                    ),
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}
