import 'package:flutter/material.dart';
import '../../models/post.dart';
import '../../widgets/common/custom_app_bar.dart';
import '../../widgets/story/status_stories.dart';
import '../../widgets/post/post_card.dart';
import '../../config/app_theme.dart';
import '../../utils/responsive.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final ScrollController _scrollController = ScrollController();
  
  // Mock data - In production, this would come from a provider/API
  final List<Post> _stories = [
    Post(
      id: '1',
      userId: 'user1',
      userName: 'Adewale',
      userAvatar: 'https://i.pravatar.cc/150?img=1',
      content: 'Road flooding at Lekki',
      type: PostType.status,
      category: 'Infrastructure',
      createdAt: DateTime.now().subtract(const Duration(hours: 2)),
      expiresAt: DateTime.now().add(const Duration(hours: 22)),
    ),
    Post(
      id: '2',
      userId: 'user2',
      userName: 'Chioma',
      userAvatar: 'https://i.pravatar.cc/150?img=2',
      content: 'Power outage update',
      type: PostType.status,
      category: 'Utilities',
      createdAt: DateTime.now().subtract(const Duration(hours: 5)),
      expiresAt: DateTime.now().add(const Duration(hours: 19)),
    ),
  ];

  final List<Post> _posts = [
    Post(
      id: '3',
      userId: 'user3',
      userName: 'Emeka Okafor',
      userAvatar: 'https://i.pravatar.cc/150?img=3',
      content: 'Major road flooding on Lekki-Epe Expressway. Traffic at standstill. Please avoid this route if possible.',
      type: PostType.video,
      priority: PostPriority.highRisk,
      category: 'Infrastructure',
      tags: ['flooding', 'traffic', 'lekki'],
      location: 'Lekki-Epe Expressway, Lagos',
      latitude: 6.4531,
      longitude: 3.6014,
      mediaUrl: 'https://example.com/video.mp4',
      thumbnailUrl: 'https://picsum.photos/400/300',
      mediaDuration: 45,
      likes: 234,
      comments: 56,
      shares: 89,
      createdAt: DateTime.now().subtract(const Duration(hours: 3)),
      language: 'en',
    ),
    Post(
      id: '4',
      userId: 'user4',
      userName: 'Fatima Hassan',
      userAvatar: 'https://i.pravatar.cc/150?img=4',
      content: 'The local health center has run out of essential medications. This is affecting many residents who need regular prescriptions.',
      type: PostType.text,
      priority: PostPriority.normal,
      category: 'Health',
      tags: ['health', 'medication', 'emergency'],
      location: 'Kano State Health Center',
      latitude: 12.0022,
      longitude: 8.5920,
      likes: 145,
      comments: 32,
      shares: 67,
      isLiked: true,
      createdAt: DateTime.now().subtract(const Duration(hours: 5)),
      language: 'en',
    ),
    Post(
      id: '5',
      userId: 'user5',
      userName: 'Adeola Williams',
      userAvatar: 'https://i.pravatar.cc/150?img=5',
      content: 'EMERGENCY: Fire outbreak at the market. Fire service has been contacted. Everyone please stay away from the area.',
      type: PostType.audio,
      priority: PostPriority.emergency,
      category: 'Emergency',
      tags: ['fire', 'emergency', 'market'],
      location: 'Oshodi Market, Lagos',
      latitude: 6.5449,
      longitude: 3.3364,
      mediaUrl: 'https://example.com/audio.mp3',
      mediaDuration: 35,
      likes: 567,
      comments: 123,
      shares: 234,
      createdAt: DateTime.now().subtract(const Duration(minutes: 45)),
      language: 'en',
    ),
  ];

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final responsive = context.responsive;

    return Scaffold(
      backgroundColor: AppTheme.background,
      appBar: CustomAppBar(
        title: 'Community Reporter',
        actions: [
          IconButton(
            icon: Icon(Icons.search, size: responsive.sp(24)),
            onPressed: () {
              // Navigate to search
            },
          ),
          IconButton(
            icon: Icon(Icons.filter_list, size: responsive.sp(24)),
            onPressed: () {
              _showFilterSheet(context);
            },
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: _handleRefresh,
        color: AppTheme.greenPrimary,
        child: CustomScrollView(
          controller: _scrollController,
          slivers: [
            // Status Stories
            SliverToBoxAdapter(
              child: StatusStories(
                stories: _stories,
                onAddStory: () {
                  // Navigate to create story
                },
              ),
            ),
            
            // Divider
            SliverToBoxAdapter(
              child: Container(
                height: 8,
                color: AppTheme.greySoft.withOpacity(0.5),
              ),
            ),
            
            // Posts List
            SliverList(
              delegate: SliverChildBuilderDelegate(
                (context, index) {
                  final post = _posts[index];
                  return PostCard(
                    post: post,
                    onLike: () => _handleLike(post),
                    onComment: () => _handleComment(post),
                    onShare: () => _handleShare(post),
                    onTranslate: () => _handleTranslate(post),
                  );
                },
                childCount: _posts.length,
              ),
            ),
            
            // Loading indicator
            SliverToBoxAdapter(
              child: Padding(
                padding: EdgeInsets.all(responsive.sp(AppTheme.spacing16)),
                child: const Center(
                  child: CircularProgressIndicator(
                    color: AppTheme.greenPrimary,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _handleRefresh() async {
    // Simulate API call
    await Future.delayed(const Duration(seconds: 1));
    if (mounted) {
      setState(() {
        // Refresh data
      });
    }
  }

  void _handleLike(Post post) {
    setState(() {
      final index = _posts.indexWhere((p) => p.id == post.id);
      if (index != -1) {
        _posts[index] = post.copyWith(
          isLiked: !post.isLiked,
          likes: post.isLiked ? post.likes - 1 : post.likes + 1,
        );
      }
    });
  }

  void _handleComment(Post post) {
    // Navigate to comments screen
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Opening comments...')),
    );
  }

  void _handleShare(Post post) {
    // Show share options
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Share post...')),
    );
  }

  void _handleTranslate(Post post) {
    // Show translation modal
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Translating post...')),
    );
  }

  void _showFilterSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppTheme.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Filter Posts',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            const SizedBox(height: 16),
            // Add filter options here
            ElevatedButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Apply Filters'),
            ),
          ],
        ),
      ),
    );
  }
}
