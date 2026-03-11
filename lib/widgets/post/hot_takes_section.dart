import 'package:flutter/material.dart';
import '../../models/hot_take_model.dart';
import '../../config/app_theme.dart';

class HotTakesSection extends StatefulWidget {
  final String postId;

  const HotTakesSection({
    super.key,
    required this.postId,
  });

  @override
  State<HotTakesSection> createState() => _HotTakesSectionState();
}

class _HotTakesSectionState extends State<HotTakesSection>
    with TickerProviderStateMixin {
  late List<HotTake> _hotTakes;
  bool _isExpanded = false;
  late Map<String, AnimationController> _reactionAnimators;

  @override
  void initState() {
    super.initState();
    _hotTakes = getMockHotTakes(widget.postId);
    _reactionAnimators = {};
    for (final hotTake in _hotTakes) {
      _reactionAnimators[hotTake.id] = AnimationController(
        duration: const Duration(milliseconds: 300),
        vsync: this,
      );
    }
  }

  @override
  void dispose() {
    for (final controller in _reactionAnimators.values) {
      controller.dispose();
    }
    super.dispose();
  }

  void _toggleExpanded() {
    setState(() {
      _isExpanded = !_isExpanded;
    });
  }

  HotTake _findMostReactedHotTake() {
    if (_hotTakes.isEmpty) return _hotTakes.first;
    return _hotTakes.reduce((a, b) {
      final aTotal = a.reactions.values.fold(0, (sum, count) => sum + count);
      final bTotal = b.reactions.values.fold(0, (sum, count) => sum + count);
      return aTotal > bTotal ? a : b;
    });
  }

  void _showAddHotTakeModal(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) => AddHotTakeModal(
        postId: widget.postId,
        onSubmit: (content) {
          setState(() {
            _hotTakes.insert(
              0,
              HotTake(
                id: 'hot_take_${DateTime.now().millisecondsSinceEpoch}',
                postId: widget.postId,
                userId: 'current_user',
                userName: 'Your Name',
                userAvatar: 'https://api.dicebear.com/7.x/avataaars/svg?seed=You',
                content: content,
                reactions: {},
                createdAt: DateTime.now(),
                isLiked: false,
                likes: 0,
              ),
            );
          });
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final mostReactedId = _findMostReactedHotTake().id;

    return Column(
      children: [
        // Collapsed Header
        GestureDetector(
          onTap: _toggleExpanded,
          child: Container(
            padding: const EdgeInsets.symmetric(
              horizontal: AppTheme.spacing16,
              vertical: AppTheme.spacing12,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '🔥 Hot Takes (${_hotTakes.length})',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                ),
                AnimatedRotation(
                  turns: _isExpanded ? 0.5 : 0,
                  duration: const Duration(milliseconds: 300),
                  child: const Icon(Icons.expand_more),
                ),
              ],
            ),
          ),
        ),
        // Expanded Content
        if (_isExpanded)
          Column(
            children: [
              const SizedBox(height: AppTheme.spacing8),
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: _hotTakes.length,
                itemBuilder: (context, index) {
                  final hotTake = _hotTakes[index];
                  final isTopTake = hotTake.id == mostReactedId;

                  return HotTakeCard(
                    hotTake: hotTake,
                    isTopTake: isTopTake,
                    onReactionTap: (reaction) {
                      setState(() {
                        final currentCount =
                            hotTake.reactions[reaction] ?? 0;
                        _hotTakes[index] = hotTake.copyWith(
                          reactions: {
                            ...hotTake.reactions,
                            reaction: currentCount + 1,
                          },
                        );
                      });
                      // Trigger animation
                      _reactionAnimators[hotTake.id]?.forward().then((_) {
                        _reactionAnimators[hotTake.id]?.reverse();
                      });
                    },
                  );
                },
              ),
              const SizedBox(height: AppTheme.spacing16),
              // Add Hot Take Button
              SizedBox(
                width: double.infinity,
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppTheme.spacing16,
                  ),
                  child: OutlinedButton.icon(
                    onPressed: () => _showAddHotTakeModal(context),
                    icon: const Icon(Icons.add),
                    label: const Text('Add Hot Take'),
                  ),
                ),
              ),
              const SizedBox(height: AppTheme.spacing16),
            ],
          ),
      ],
    );
  }
}

/// HotTakeCard - individual hot take display
class HotTakeCard extends StatefulWidget {
  final HotTake hotTake;
  final bool isTopTake;
  final Function(HotTakeReaction) onReactionTap;

  const HotTakeCard({
    super.key,
    required this.hotTake,
    this.isTopTake = false,
    required this.onReactionTap,
  });

  @override
  State<HotTakeCard> createState() => _HotTakeCardState();
}

class _HotTakeCardState extends State<HotTakeCard>
    with SingleTickerProviderStateMixin {
  bool _isExpanded = false;
  late AnimationController _expandController;

  @override
  void initState() {
    super.initState();
    _expandController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
  }

  @override
  void dispose() {
    _expandController.dispose();
    super.dispose();
  }

  void _toggleExpanded() {
    setState(() {
      _isExpanded = !_isExpanded;
      if (_isExpanded) {
        _expandController.forward();
      } else {
        _expandController.reverse();
      }
    });
  }

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

  @override
  Widget build(BuildContext context) {
    final isLong = widget.hotTake.content.length > 120;

    return Container(
      margin: const EdgeInsets.symmetric(
        horizontal: AppTheme.spacing16,
        vertical: AppTheme.spacing8,
      ),
      decoration: BoxDecoration(
        color: AppTheme.white,
        border: Border.all(color: AppTheme.greySoft),
        borderRadius: BorderRadius.circular(AppTheme.radiusMedium),
      ),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(AppTheme.spacing12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // User info with top take badge
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        CircleAvatar(
                          radius: 18,
                          backgroundImage:
                              NetworkImage(widget.hotTake.userAvatar),
                        ),
                        const SizedBox(width: AppTheme.spacing8),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              widget.hotTake.userName,
                              style: Theme.of(context)
                                  .textTheme
                                  .titleMedium
                                  ?.copyWith(fontWeight: FontWeight.w600),
                            ),
                            Text(
                              _formatTime(widget.hotTake.createdAt),
                              style: Theme.of(context).textTheme.bodySmall,
                            ),
                          ],
                        ),
                      ],
                    ),
                    if (widget.isTopTake)
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: AppTheme.spacing8,
                          vertical: AppTheme.spacing4,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.orange.shade50,
                          borderRadius:
                              BorderRadius.circular(AppTheme.radiusMedium),
                          border: Border.all(
                            color: Colors.orange.shade200,
                          ),
                        ),
                        child: Text(
                          '🔥 Top Take',
                          style: Theme.of(context).textTheme.bodySmall
                              ?.copyWith(
                                color: Colors.orange.shade700,
                                fontWeight: FontWeight.w600,
                              ),
                        ),
                      ),
                  ],
                ),
                const SizedBox(height: AppTheme.spacing12),
                // Opinion text with see more
                AnimatedSize(
                  duration: const Duration(milliseconds: 300),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.hotTake.content,
                        maxLines: _isExpanded ? null : 3,
                        overflow: _isExpanded
                            ? TextOverflow.visible
                            : TextOverflow.ellipsis,
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                      if (isLong)
                        GestureDetector(
                          onTap: _toggleExpanded,
                          child: Padding(
                            padding: const EdgeInsets.only(
                              top: AppTheme.spacing4,
                            ),
                            child: Text(
                              _isExpanded ? 'See less' : 'See more',
                              style: Theme.of(context)
                                  .textTheme
                                  .bodySmall
                                  ?.copyWith(
                                    color: AppTheme.greenPrimary,
                                    fontWeight: FontWeight.w600,
                                  ),
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          // Reactions row
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: AppTheme.spacing12,
              vertical: AppTheme.spacing8,
            ),
            decoration: BoxDecoration(
              color: AppTheme.background,
              borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(AppTheme.radiusMedium),
                bottomRight: Radius.circular(AppTheme.radiusMedium),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildReactionButton(
                  context,
                  emoji: '🔥',
                  label: 'Fire',
                  count: widget.hotTake.reactions[HotTakeReaction.fire] ?? 0,
                  reaction: HotTakeReaction.fire,
                ),
                _buildReactionButton(
                  context,
                  emoji: '👍',
                  label: 'Agree',
                  count: widget.hotTake.reactions[HotTakeReaction.agree] ?? 0,
                  reaction: HotTakeReaction.agree,
                ),
                _buildReactionButton(
                  context,
                  emoji: '👎',
                  label: 'Disagree',
                  count:
                      widget.hotTake.reactions[HotTakeReaction.disagree] ?? 0,
                  reaction: HotTakeReaction.disagree,
                ),
                _buildReactionButton(
                  context,
                  emoji: '🤯',
                  label: 'Mind Blown',
                  count:
                      widget.hotTake.reactions[HotTakeReaction.mindBlown] ?? 0,
                  reaction: HotTakeReaction.mindBlown,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildReactionButton(
    BuildContext context, {
    required String emoji,
    required String label,
    required int count,
    required HotTakeReaction reaction,
  }) {
    return GestureDetector(
      onTap: () {
        widget.onReactionTap(reaction);
      },
      child: AnimatedScale(
        duration: const Duration(milliseconds: 200),
        scale: count > 0 ? 1.0 : 0.95,
        child: Column(
          children: [
            Text(
              emoji,
              style: const TextStyle(fontSize: 20),
            ),
            const SizedBox(height: AppTheme.spacing4),
            Row(
              children: [
                Text(
                  label,
                  style: Theme.of(context).textTheme.bodySmall,
                ),
                const SizedBox(width: AppTheme.spacing4),
                if (count > 0)
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppTheme.spacing4,
                      vertical: AppTheme.spacing2,
                    ),
                    decoration: BoxDecoration(
                      color: AppTheme.greenPrimary.withValues(alpha: 0.1),
                      borderRadius:
                          BorderRadius.circular(AppTheme.radiusSmall),
                    ),
                    child: Text(
                      count.toString(),
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: AppTheme.greenPrimary,
                            fontWeight: FontWeight.w600,
                          ),
                    ),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

/// AddHotTakeModal - modal for adding new hot takes
class AddHotTakeModal extends StatefulWidget {
  final String postId;
  final Function(String) onSubmit;

  const AddHotTakeModal({
    super.key,
    required this.postId,
    required this.onSubmit,
  });

  @override
  State<AddHotTakeModal> createState() => _AddHotTakeModalState();
}

class _AddHotTakeModalState extends State<AddHotTakeModal> {
  late TextEditingController _contentController;
  bool _isSubmitting = false;

  @override
  void initState() {
    super.initState();
    _contentController = TextEditingController();
  }

  @override
  void dispose() {
    _contentController.dispose();
    super.dispose();
  }

  void _submit() async {
    if (_contentController.text.trim().isEmpty) return;

    setState(() {
      _isSubmitting = true;
    });

    // Simulate submission delay
    await Future.delayed(const Duration(milliseconds: 500));

    if (mounted) {
      widget.onSubmit(_contentController.text.trim());
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    final contentLength = _contentController.text.length;

    return SingleChildScrollView(
      child: Container(
        padding: EdgeInsets.only(
          left: AppTheme.spacing16,
          right: AppTheme.spacing16,
          top: AppTheme.spacing16,
          bottom: MediaQuery.of(context).viewInsets.bottom +
              AppTheme.spacing16,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Handle
            Center(
              child: Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: AppTheme.greySoft,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            const SizedBox(height: AppTheme.spacing16),
            // Title
            Text(
              'Add Your Hot Take',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            const SizedBox(height: AppTheme.spacing16),
            // TextField
            TextField(
              controller: _contentController,
              maxLength: 200,
              maxLines: 4,
              minLines: 2,
              decoration: InputDecoration(
                hintText: 'What\'s your hot take?',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(AppTheme.radiusMedium),
                ),
                counterText: '$contentLength/200',
                contentPadding: const EdgeInsets.all(AppTheme.spacing12),
              ),
              onChanged: (_) {
                setState(() {});
              },
            ),
            const SizedBox(height: AppTheme.spacing16),
            // Submit button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _isSubmitting || contentLength == 0
                    ? null
                    : _submit,
                child: _isSubmitting
                    ? const SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          valueColor: AlwaysStoppedAnimation(
                            AppTheme.white,
                          ),
                        ),
                      )
                    : const Text('Post Hot Take'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
