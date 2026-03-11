import 'package:flutter/material.dart';
import '../../models/story_model.dart';

class StoryViewer extends StatefulWidget {
  final List<StoryModel> stories;
  final int initialIndex;

  const StoryViewer({
    super.key,
    required this.stories,
    this.initialIndex = 0,
  });

  @override
  State<StoryViewer> createState() => _StoryViewerState();
}

class _StoryViewerState extends State<StoryViewer>
    with TickerProviderStateMixin {
  late PageController _pageController;
  late List<AnimationController> _progressControllers;
  int _currentIndex = 0;
  bool _isPaused = false;
  bool _showReplyBox = false;

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.initialIndex;
    _pageController = PageController(initialPage: _currentIndex);
    _initializeProgressControllers();
  }

  void _initializeProgressControllers() {
    _progressControllers = List.generate(
      widget.stories.length,
      (index) => AnimationController(
        duration: Duration(
          seconds: widget.stories[index].type == StoryType.voice
              ? widget.stories[index].duration
              : 5,
        ),
        vsync: this,
      ),
    );

    // Start the first story's progress animation
    if (_progressControllers.isNotEmpty) {
      _progressControllers[_currentIndex].forward();
    }
  }

  @override
  void dispose() {
    for (var controller in _progressControllers) {
      controller.dispose();
    }
    _pageController.dispose();
    super.dispose();
  }

  void _onProgressComplete() {
    if (_currentIndex < widget.stories.length - 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    } else {
      Navigator.pop(context);
    }
  }

  void _pauseProgress() {
    _isPaused = true;
    _progressControllers[_currentIndex].stop();
  }

  void _resumeProgress() {
    _isPaused = false;
    _progressControllers[_currentIndex].forward();
  }

  void _onPageChanged(int index) {
    // Stop current progress
    _progressControllers[_currentIndex].stop();

    setState(() {
      _currentIndex = index;
    });

    // Reset and start new progress
    _progressControllers[index].reset();
    if (!_isPaused) {
      _progressControllers[index].forward();
    }
  }

  void _goToPreviousStory() {
    if (_currentIndex > 0) {
      _pageController.previousPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  void _goToNextStory() {
    if (_currentIndex < widget.stories.length - 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: GestureDetector(
        onVerticalDragEnd: (details) {
          // Swipe down to dismiss
          if (details.primaryVelocity! > 0) {
            Navigator.pop(context);
          }
        },
        child: Stack(
          children: [
            PageView.builder(
              controller: _pageController,
              onPageChanged: _onPageChanged,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: widget.stories.length,
              itemBuilder: (context, index) {
                return _StoryPage(
                  story: widget.stories[index],
                  progressController: _progressControllers[index],
                  onProgressComplete: _onProgressComplete,
                  onTapLeft: _goToPreviousStory,
                  onTapRight: _goToNextStory,
                  onLongPressStart: _pauseProgress,
                  onLongPressEnd: _resumeProgress,
                  onSwipeUp: () {
                    setState(() => _showReplyBox = true);
                  },
                );
              },
            ),
            // Progress bars at top
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              child: SafeArea(
                child: _ProgressBars(
                  count: widget.stories.length,
                  currentIndex: _currentIndex,
                  controllers: _progressControllers,
                ),
              ),
            ),
            // Reply box at bottom
            if (_showReplyBox)
              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: _ReplyBox(
                  userName: widget.stories[_currentIndex].userName,
                  onClose: () {
                    setState(() => _showReplyBox = false);
                  },
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class _StoryPage extends StatefulWidget {
  final StoryModel story;
  final AnimationController progressController;
  final VoidCallback onProgressComplete;
  final VoidCallback onTapLeft;
  final VoidCallback onTapRight;
  final VoidCallback onLongPressStart;
  final VoidCallback onLongPressEnd;
  final VoidCallback onSwipeUp;

  const _StoryPage({
    required this.story,
    required this.progressController,
    required this.onProgressComplete,
    required this.onTapLeft,
    required this.onTapRight,
    required this.onLongPressStart,
    required this.onLongPressEnd,
    required this.onSwipeUp,
  });

  @override
  State<_StoryPage> createState() => _StoryPageState();
}

class _StoryPageState extends State<_StoryPage>
    with TickerProviderStateMixin {
  bool _hasVoted = false;
  String? _userVote;

  @override
  void initState() {
    super.initState();
    widget.progressController.addListener(_onProgressChanged);
  }

  @override
  void dispose() {
    widget.progressController.removeListener(_onProgressChanged);
    super.dispose();
  }

  void _onProgressChanged() {
    if (widget.progressController.isCompleted) {
      widget.onProgressComplete();
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onVerticalDragUpdate: (details) {
        if (details.primaryDelta! < -10) {
          widget.onSwipeUp();
        }
      },
      child: Stack(
        children: [
          // Background/Content based on story type
          _buildStoryContent(),

          // Dark overlay at top and bottom
          if (widget.story.type == StoryType.camera ||
              widget.story.type == StoryType.gallery)
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.center,
                  colors: [Colors.black.withValues(alpha: 0.5), Colors.transparent],
                ),
              ),
            ),
          if (widget.story.type == StoryType.camera ||
              widget.story.type == StoryType.gallery)
            Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                height: 100,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.center,
                    end: Alignment.bottomCenter,
                    colors: [Colors.transparent, Colors.black.withValues(alpha: 0.5)],
                  ),
                ),
              ),
            ),

          // User info at top
          Positioned(
            top: 60,
            left: 16,
            right: 16,
            child: _UserHeader(
              avatar: widget.story.userAvatar,
              name: widget.story.userName,
              time: widget.story.formattedTime,
            ),
          ),

          // Poll if exists
          if (widget.story.poll != null)
            _PollWidget(
              poll: widget.story.poll!,
              onVote: (option) {
                setState(() {
                  _hasVoted = true;
                  _userVote = option;
                });
              },
              hasVoted: _hasVoted,
              userVote: _userVote,
            ),

          // Reactions at bottom
          Positioned(
            bottom: 80,
            left: 0,
            right: 0,
            child: _ReactionBar(story: widget.story),
          ),

          // Left and right tap areas
          Positioned(
            left: 0,
            top: 0,
            bottom: 0,
            width: MediaQuery.of(context).size.width * 0.3,
            child: GestureDetector(
              onLongPressStart: (_) => widget.onLongPressStart(),
              onLongPressEnd: (_) => widget.onLongPressEnd(),
              onTap: widget.onTapLeft,
              child: const SizedBox.expand(),
            ),
          ),
          Positioned(
            right: 0,
            top: 0,
            bottom: 0,
            width: MediaQuery.of(context).size.width * 0.3,
            child: GestureDetector(
              onLongPressStart: (_) => widget.onLongPressStart(),
              onLongPressEnd: (_) => widget.onLongPressEnd(),
              onTap: widget.onTapRight,
              child: const SizedBox.expand(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStoryContent() {
    switch (widget.story.type) {
      case StoryType.text:
        return _TextStoryContent(story: widget.story);
      case StoryType.camera:
      case StoryType.gallery:
        return _ImageStoryContent(mediaUrl: widget.story.mediaUrl);
      case StoryType.voice:
        return _VoiceStoryContent(story: widget.story);
      case StoryType.live:
        return _ImageStoryContent(mediaUrl: widget.story.mediaUrl);
    }
  }
}

class _TextStoryContent extends StatefulWidget {
  final StoryModel story;

  const _TextStoryContent({required this.story});

  @override
  State<_TextStoryContent> createState() => _TextStoryContentState();
}

class _TextStoryContentState extends State<_TextStoryContent>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: _buildBackgroundDecoration(),
      child: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Text(
            widget.story.content ?? '',
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 32,
              fontWeight: FontWeight.bold,
              color: Colors.white,
              height: 1.4,
            ),
          ),
        ),
      ),
    );
  }

  BoxDecoration _buildBackgroundDecoration() {
    if (widget.story.background == null) {
      return const BoxDecoration(
        color: Color(0xFF42A5F5),
      );
    }

    final bg = widget.story.background!;
    if (bg.type == 'solid') {
      return BoxDecoration(color: bg.colors.first);
    } else {
      return BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: bg.colors,
        ),
      );
    }
  }
}

class _ImageStoryContent extends StatelessWidget {
  final String? mediaUrl;

  const _ImageStoryContent({required this.mediaUrl});

  @override
  Widget build(BuildContext context) {
    if (mediaUrl == null || mediaUrl!.isEmpty) {
      return Container(color: Colors.black);
    }

    return Container(
      color: Colors.black,
      child: Image.network(
        mediaUrl!,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) {
          return Container(
            color: Colors.black,
            child: const Center(
              child: Icon(Icons.broken_image, color: Colors.white54),
            ),
          );
        },
      ),
    );
  }
}

class _VoiceStoryContent extends StatefulWidget {
  final StoryModel story;

  const _VoiceStoryContent({required this.story});

  @override
  State<_VoiceStoryContent> createState() => _VoiceStoryContentState();
}

class _VoiceStoryContentState extends State<_VoiceStoryContent>
    with SingleTickerProviderStateMixin {
  late AnimationController _pulseController;
  final List<double> waveformData = List.generate(
    30,
    (i) => 0.3 + (i % 5) * 0.14,
  );

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      duration: const Duration(seconds: 1),
      vsync: this,
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Colors.purple.withValues(alpha: 0.3),
            Colors.blue.withValues(alpha: 0.3),
          ],
        ),
      ),
      child: Center(
        child: ScaleTransition(
          scale: Tween(begin: 1.0, end: 1.1).animate(
            CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 100,
                height: 100,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white.withValues(alpha: 0.2),
                  border: Border.all(color: Colors.white, width: 2),
                ),
                child: const Icon(Icons.mic, color: Colors.white, size: 50),
              ),
              const SizedBox(height: 32),
              SizedBox(
                height: 80,
                width: 250,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: List.generate(
                    waveformData.length,
                    (index) => Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 2.0),
                      child: ScaleTransition(
                        scale: Tween(
                          begin: 0.3,
                          end: waveformData[index],
                        ).animate(
                          CurvedAnimation(
                            parent: _pulseController,
                            curve: Curves.easeInOut,
                          ),
                        ),
                        alignment: Alignment.center,
                        child: Container(
                          width: 4,
                          height: 60,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(2),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 24),
              Text(
                widget.story.content ?? 'Voice Message',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _UserHeader extends StatelessWidget {
  final String? avatar;
  final String name;
  final String time;

  const _UserHeader({
    required this.avatar,
    required this.name,
    required this.time,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        CircleAvatar(
          radius: 20,
          backgroundColor: Colors.white.withValues(alpha: 0.3),
          backgroundImage:
              avatar != null ? NetworkImage(avatar!) : null,
          child: avatar == null
              ? const Icon(Icons.person, color: Colors.white)
              : null,
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                name,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              ),
              Text(
                time,
                style: TextStyle(
                  color: Colors.white.withValues(alpha: 0.7),
                  fontSize: 12,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _ProgressBars extends StatelessWidget {
  final int count;
  final int currentIndex;
  final List<AnimationController> controllers;

  const _ProgressBars({
    required this.count,
    required this.currentIndex,
    required this.controllers,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 8.0),
      child: Row(
        children: List.generate(
          count,
          (index) {
            return Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 4.0),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(2),
                  child: LinearProgressIndicator(
                    minHeight: 3,
                    backgroundColor: Colors.white.withValues(alpha: 0.3),
                    valueColor: AlwaysStoppedAnimation<Color>(
                      index == currentIndex
                          ? Colors.white
                          : index < currentIndex
                              ? Colors.white
                              : Colors.white.withValues(alpha: 0.5),
                    ),
                    value: index == currentIndex
                        ? controllers[index].value
                        : index < currentIndex
                            ? 1.0
                            : 0.0,
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

class _ReactionBar extends StatefulWidget {
  final StoryModel story;

  const _ReactionBar({required this.story});

  @override
  State<_ReactionBar> createState() => _ReactionBarState();
}

class _ReactionBarState extends State<_ReactionBar>
    with TickerProviderStateMixin {
  final List<String> reactions = ['❤️', '🔥', '😮', '😢', '😂'];
  final List<String> reactionNames = [
    'heart',
    'fire',
    'wow',
    'sad',
    'laugh'
  ];
  late List<AnimationController> _floatingControllers;

  @override
  void initState() {
    super.initState();
    _floatingControllers = List.generate(
      5,
      (_) => AnimationController(
        duration: const Duration(milliseconds: 800),
        vsync: this,
      ),
    );
  }

  @override
  void dispose() {
    for (var controller in _floatingControllers) {
      controller.dispose();
    }
    super.dispose();
  }

  void _showFloatingEmoji(int index) {
    _floatingControllers[index].forward(from: 0.0).then((_) {
      _floatingControllers[index].reverse();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(
        reactions.length,
        (index) {
          final reaction = reactions[index];
          final count = widget.story.reactions[reaction] ?? 0;

          return Expanded(
            child: GestureDetector(
              onTap: () => _showFloatingEmoji(index),
              child: Column(
                children: [
                  ScaleTransition(
                    scale: Tween(begin: 1.0, end: 1.3).animate(
                      CurvedAnimation(
                        parent: _floatingControllers[index],
                        curve: Curves.easeOut,
                      ),
                    ),
                    child: Text(
                      reaction,
                      style: const TextStyle(fontSize: 28),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    count > 0 ? count.toString() : '0',
                    style: TextStyle(
                      color: Colors.white.withValues(alpha: 0.7),
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

class _PollWidget extends StatefulWidget {
  final StoryPoll poll;
  final Function(String) onVote;
  final bool hasVoted;
  final String? userVote;

  const _PollWidget({
    required this.poll,
    required this.onVote,
    required this.hasVoted,
    required this.userVote,
  });

  @override
  State<_PollWidget> createState() => _PollWidgetState();
}

class _PollWidgetState extends State<_PollWidget>
    with TickerProviderStateMixin {
  late AnimationController _fillAController;
  late AnimationController _fillBController;

  @override
  void initState() {
    super.initState();
    _fillAController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );
    _fillBController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );
  }

  @override
  void dispose() {
    _fillAController.dispose();
    _fillBController.dispose();
    super.dispose();
  }

  void _vote(String option) {
    widget.onVote(option);
    if (option == 'A') {
      _fillAController.forward();
    } else {
      _fillBController.forward();
    }
  }

  @override
  Widget build(BuildContext context) {
    final totalVotes = widget.poll.totalVotes;
    final percentA = widget.poll.percentageA;
    final percentB = widget.poll.percentageB;

    return Center(
      child: Container(
        width: MediaQuery.of(context).size.width * 0.8,
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.black.withValues(alpha: 0.7),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              widget.poll.question,
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 24),
            _PollOption(
              label: widget.poll.optionA,
              percentage: percentA,
              isSelected: widget.userVote == 'A',
              onTap: widget.hasVoted ? null : () => _vote('A'),
              fillAnimation: _fillAController,
              hasVoted: widget.hasVoted,
            ),
            const SizedBox(height: 12),
            _PollOption(
              label: widget.poll.optionB,
              percentage: percentB,
              isSelected: widget.userVote == 'B',
              onTap: widget.hasVoted ? null : () => _vote('B'),
              fillAnimation: _fillBController,
              hasVoted: widget.hasVoted,
            ),
            if (widget.hasVoted) ...[
              const SizedBox(height: 16),
              Text(
                '$totalVotes votes',
                style: TextStyle(
                  color: Colors.white.withValues(alpha: 0.7),
                  fontSize: 12,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _PollOption extends StatelessWidget {
  final String label;
  final double percentage;
  final bool isSelected;
  final VoidCallback? onTap;
  final AnimationController fillAnimation;
  final bool hasVoted;

  const _PollOption({
    required this.label,
    required this.percentage,
    required this.isSelected,
    required this.onTap,
    required this.fillAnimation,
    required this.hasVoted,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Stack(
        alignment: Alignment.centerLeft,
        children: [
          AnimatedBuilder(
            animation: fillAnimation,
            builder: (context, child) {
              final displayPercent = hasVoted
                  ? percentage
                  : (fillAnimation.value * percentage);
              return Container(
                width: double.infinity,
                height: 48,
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: isSelected
                        ? Colors.white
                        : Colors.white.withValues(alpha: 0.3),
                    width: 2,
                  ),
                ),
                child: FractionallySizedBox(
                  widthFactor: displayPercent / 100,
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.2),
                      borderRadius: BorderRadius.circular(6),
                    ),
                  ),
                ),
              );
            },
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    label,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                if (hasVoted)
                  Text(
                    '${percentage.toStringAsFixed(0)}%',
                    style: TextStyle(
                      color: Colors.white.withValues(alpha: 0.8),
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _ReplyBox extends StatefulWidget {
  final String userName;
  final VoidCallback onClose;

  const _ReplyBox({
    required this.userName,
    required this.onClose,
  });

  @override
  State<_ReplyBox> createState() => _ReplyBoxState();
}

class _ReplyBoxState extends State<_ReplyBox> {
  late TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.black.withValues(alpha: 0.8),
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(16),
          topRight: Radius.circular(16),
        ),
      ),
      padding: EdgeInsets.only(
        left: 16,
        right: 16,
        top: 16,
        bottom: MediaQuery.of(context).viewInsets.bottom + 16,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _controller,
                  style: const TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                    hintText: 'Reply to ${widget.userName}...',
                    hintStyle:
                        TextStyle(color: Colors.white.withValues(alpha: 0.5)),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(24),
                      borderSide: BorderSide(
                        color: Colors.white.withValues(alpha: 0.3),
                      ),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(24),
                      borderSide: BorderSide(
                        color: Colors.white.withValues(alpha: 0.3),
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(24),
                      borderSide: const BorderSide(
                        color: Colors.white,
                        width: 2,
                      ),
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 12,
                    ),
                  ),
                  cursorColor: Colors.white,
                ),
              ),
              const SizedBox(width: 8),
              GestureDetector(
                onTap: () {
                  // Send message
                  _controller.clear();
                  widget.onClose();
                },
                child: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.send,
                    color: Colors.black,
                    size: 20,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
