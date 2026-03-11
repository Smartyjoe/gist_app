import 'package:flutter/material.dart';
import '../../models/post.dart';
import '../../widgets/common/gistly_app_bar.dart';
import '../../widgets/story/status_stories.dart';
import '../../widgets/post/post_card.dart';
import '../../widgets/home/live_discovery_section.dart';
import '../../config/app_theme.dart';
import '../../utils/responsive.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin {
  final ScrollController _scrollController = ScrollController();
  late TabController _feedTabController;

  String _selectedCategory = 'All';

  final List<String> _categories = [
    'All', 'Emergency', 'Infrastructure', 'Health', 'Security', 'Environment', 'Utilities',
  ];

  // ── Mock stories ────────────────────────────────────────────────────────────

  final List<Post> _stories = [
    Post(id: 's1', userId: 'u1', userName: 'Adewale', userAvatar: 'https://i.pravatar.cc/150?img=1',
      content: 'Road flooding at Lekki', type: PostType.status, category: 'Infrastructure',
      createdAt: DateTime.now().subtract(const Duration(hours: 2)),
      expiresAt: DateTime.now().add(const Duration(hours: 22))),
    Post(id: 's2', userId: 'u2', userName: 'Chioma', userAvatar: 'https://i.pravatar.cc/150?img=2',
      content: 'Power outage update', type: PostType.status, category: 'Utilities',
      createdAt: DateTime.now().subtract(const Duration(hours: 5)),
      expiresAt: DateTime.now().add(const Duration(hours: 19))),
    Post(id: 's3', userId: 'u3', userName: 'Emeka', userAvatar: 'https://i.pravatar.cc/150?img=3',
      content: 'Market fire report', type: PostType.status, category: 'Emergency',
      createdAt: DateTime.now().subtract(const Duration(hours: 1)),
      expiresAt: DateTime.now().add(const Duration(hours: 23))),
    Post(id: 's4', userId: 'u4', userName: 'Fatima', userAvatar: 'https://i.pravatar.cc/150?img=4',
      content: 'Health alert', type: PostType.status, category: 'Health',
      createdAt: DateTime.now().subtract(const Duration(minutes: 30)),
      expiresAt: DateTime.now().add(const Duration(hours: 23, minutes: 30))),
    Post(id: 's5', userId: 'u5', userName: 'Adeola', userAvatar: 'https://i.pravatar.cc/150?img=5',
      content: 'Security update', type: PostType.status, category: 'Security',
      createdAt: DateTime.now().subtract(const Duration(hours: 3)),
      expiresAt: DateTime.now().add(const Duration(hours: 21))),
  ];

  // ── Mock posts ───────────────────────────────────────────────────────────────

  final List<Post> _allPosts = [
    Post(id: '1', userId: 'u3', userName: 'Emeka Okafor',
      userAvatar: 'https://i.pravatar.cc/150?img=3',
      content: 'Major road flooding on Lekki-Epe Expressway. Traffic at standstill. Please avoid this route if possible. Emergency services are on the way.',
      type: PostType.video, priority: PostPriority.highRisk, category: 'Infrastructure',
      tags: ['flooding', 'traffic', 'lekki'], location: 'Lekki-Epe Expressway, Lagos',
      latitude: 6.4531, longitude: 3.6014,
      mediaUrl: 'https://example.com/video.mp4', thumbnailUrl: 'https://picsum.photos/seed/flood/400/300',
      mediaDuration: 45, likes: 1234, comments: 256, shares: 489,
      createdAt: DateTime.now().subtract(const Duration(hours: 1))),

    Post(id: '2', userId: 'u5', userName: 'Adeola Williams',
      userAvatar: 'https://i.pravatar.cc/150?img=5',
      content: 'EMERGENCY: Fire outbreak at Oshodi Market. Fire service has been contacted. Everyone please stay away from the area. Residents are being evacuated.',
      type: PostType.audio, priority: PostPriority.emergency, category: 'Emergency',
      tags: ['fire', 'emergency', 'market', 'oshodi'], location: 'Oshodi Market, Lagos',
      latitude: 6.5449, longitude: 3.3364,
      mediaUrl: 'https://example.com/audio.mp3', mediaDuration: 35,
      likes: 2567, comments: 423, shares: 734,
      createdAt: DateTime.now().subtract(const Duration(minutes: 22))),

    Post(id: '3', userId: 'u4', userName: 'Fatima Hassan',
      userAvatar: 'https://i.pravatar.cc/150?img=4',
      content: 'The local health center in Kano has run out of essential medications. This is critically affecting residents who need daily prescriptions. Authorities need to respond urgently.',
      type: PostType.text, priority: PostPriority.normal, category: 'Health',
      tags: ['health', 'medication', 'kano'], location: 'Kano State Health Center',
      latitude: 12.0022, longitude: 8.5920,
      likes: 845, comments: 132, shares: 267, isLiked: true,
      createdAt: DateTime.now().subtract(const Duration(hours: 3))),

    Post(id: '4', userId: 'u6', userName: 'Bola Adeyemi',
      userAvatar: 'https://i.pravatar.cc/150?img=6',
      content: 'The bridge on Agege road has developed a dangerous crack. Engineers should inspect this immediately before a disaster happens. I have reported to the local government.',
      type: PostType.video, priority: PostPriority.highRisk, category: 'Infrastructure',
      tags: ['bridge', 'safety', 'agege'], location: 'Agege, Lagos',
      thumbnailUrl: 'https://picsum.photos/seed/bridge/400/300',
      mediaUrl: 'https://example.com/bridge.mp4', mediaDuration: 28,
      likes: 432, comments: 87, shares: 156,
      createdAt: DateTime.now().subtract(const Duration(hours: 5))),

    Post(id: '5', userId: 'u7', userName: 'Ngozi Obi',
      userAvatar: 'https://i.pravatar.cc/150?img=7',
      content: 'Armed robbery reported near Lekki toll gate. Police have been alerted. Residents should stay indoors until further notice. Stay safe everyone.',
      type: PostType.text, priority: PostPriority.emergency, category: 'Security',
      tags: ['robbery', 'security', 'lekki'], location: 'Lekki Toll Gate, Lagos',
      likes: 1876, comments: 345, shares: 678,
      createdAt: DateTime.now().subtract(const Duration(minutes: 45))),

    Post(id: '6', userId: 'u8', userName: 'Tunde Bakare',
      userAvatar: 'https://i.pravatar.cc/150?img=8',
      content: 'Black smoke coming from a factory in Apapa for the past 3 hours. The air quality in the surrounding area is terrible. Environmental agency needs to investigate.',
      type: PostType.video, priority: PostPriority.highRisk, category: 'Environment',
      tags: ['pollution', 'apapa', 'environment'],
      location: 'Apapa, Lagos', latitude: 6.4499, longitude: 3.3614,
      thumbnailUrl: 'https://picsum.photos/seed/smoke/400/300',
      mediaUrl: 'https://example.com/smoke.mp4', mediaDuration: 62,
      likes: 567, comments: 98, shares: 201,
      createdAt: DateTime.now().subtract(const Duration(hours: 2))),

    Post(id: '7', userId: 'u9', userName: 'Amina Yusuf',
      userAvatar: 'https://i.pravatar.cc/150?img=9',
      content: 'No water supply in Surulere for 3 days now. LAWMA has not responded to our calls. This is unacceptable. We need urgent attention from the water board.',
      type: PostType.text, priority: PostPriority.normal, category: 'Utilities',
      tags: ['water', 'surulere', 'utilities'], location: 'Surulere, Lagos',
      likes: 234, comments: 67, shares: 89,
      createdAt: DateTime.now().subtract(const Duration(hours: 8))),

    Post(id: '8', userId: 'u10', userName: 'Chidi Okeke',
      userAvatar: 'https://i.pravatar.cc/150?img=10',
      content: 'Suspected cholera cases in Ajegunle. The local hospital is overwhelmed. We need immediate medical support and clean water distribution in this community.',
      type: PostType.text, priority: PostPriority.emergency, category: 'Health',
      tags: ['cholera', 'health', 'ajegunle'], location: 'Ajegunle, Lagos',
      likes: 1123, comments: 289, shares: 445,
      createdAt: DateTime.now().subtract(const Duration(minutes: 35))),
  ];

  List<Post> get _filteredPosts {
    if (_selectedCategory == 'All') return _allPosts;
    return _allPosts.where((p) => p.category == _selectedCategory).toList();
  }

  @override
  void initState() {
    super.initState();
    _feedTabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _feedTabController.dispose();
    super.dispose();
  }

  void _scrollToTop() {
    _scrollController.animateTo(0,
        duration: const Duration(milliseconds: 300), curve: Curves.easeOut);
  }

  Future<void> _handleRefresh() async {
    await Future.delayed(const Duration(milliseconds: 1200));
    if (mounted) setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final responsive = context.responsive;
    final posts = _filteredPosts;

    return Scaffold(
      backgroundColor: AppTheme.background,
      appBar: GistlyAppBar(
        onLogoTap: _scrollToTop,
        unreadMessages: 3,
      ),
      body: RefreshIndicator(
        onRefresh: _handleRefresh,
        color: AppTheme.greenPrimary,
        child: CustomScrollView(
          controller: _scrollController,
          slivers: [
            // ── Stories ─────────────────────────────────────────────────────
            SliverToBoxAdapter(
              child: StatusStories(
                stories: _stories,
                onAddStory: () => ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Create story coming soon!'),
                      behavior: SnackBarBehavior.floating)),
              ),
            ),

            // ── Feed tabs ────────────────────────────────────────────────────
            SliverPersistentHeader(
              pinned: true,
              delegate: _FeedTabBarDelegate(
                child: Container(
                  color: AppTheme.white,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Divider(height: 1, thickness: 1, color: AppTheme.greySoft),
                      TabBar(
                        controller: _feedTabController,
                        indicatorColor: AppTheme.greenPrimary,
                        indicatorWeight: 2,
                        labelColor: AppTheme.greenPrimary,
                        unselectedLabelColor: AppTheme.greyMedium,
                        labelStyle: TextStyle(
                            fontSize: responsive.sp(13), fontWeight: FontWeight.w700),
                        unselectedLabelStyle: TextStyle(
                            fontSize: responsive.sp(13), fontWeight: FontWeight.w500),
                        tabs: const [
                          Tab(text: 'For You'),
                          Tab(text: 'Following'),
                          Tab(text: 'Nearby'),
                        ],
                        onTap: (_) => setState(() {}),
                      ),
                      // Category filter strip
                      SizedBox(
                        height: responsive.sp(36),
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          padding: EdgeInsets.symmetric(
                              horizontal: responsive.sp(12), vertical: responsive.sp(4)),
                          itemCount: _categories.length,
                          itemBuilder: (_, i) {
                            final cat = _categories[i];
                            final isSelected = _selectedCategory == cat;
                            return GestureDetector(
                              onTap: () => setState(() => _selectedCategory = cat),
                              child: AnimatedContainer(
                                duration: const Duration(milliseconds: 200),
                                margin: EdgeInsets.only(right: responsive.sp(6)),
                                padding: EdgeInsets.symmetric(
                                    horizontal: responsive.sp(12), vertical: responsive.sp(2)),
                                decoration: BoxDecoration(
                                  color: isSelected
                                      ? AppTheme.greenPrimary
                                      : AppTheme.greySoft.withOpacity(0.6),
                                  borderRadius: BorderRadius.circular(responsive.sp(20)),
                                ),
                                child: Text(
                                  cat,
                                  style: TextStyle(
                                    fontSize: responsive.sp(11),
                                    fontWeight: FontWeight.w600,
                                    color: isSelected ? AppTheme.white : AppTheme.textPrimary,
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                      Divider(height: 1, thickness: 1, color: AppTheme.greySoft),
                    ],
                  ),
                ),
                height: responsive.sp(92),
              ),
            ),

            // ── Live Discovery (contextual) ──────────────────────────────────
            SliverToBoxAdapter(
              child: LiveDiscoverySection(),
            ),

            // ── Posts or empty state ─────────────────────────────────────────
            posts.isEmpty
                ? SliverFillRemaining(
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.article_outlined,
                              size: responsive.sp(48), color: AppTheme.greyMedium),
                          SizedBox(height: responsive.sp(12)),
                          Text('No posts in this category',
                              style: TextStyle(
                                  fontSize: responsive.sp(15), color: AppTheme.greyMedium)),
                        ],
                      ),
                    ),
                  )
                : SliverList(
                    delegate: SliverChildBuilderDelegate(
                      (context, index) => PostCard(post: posts[index]),
                      childCount: posts.length,
                    ),
                  ),

            // ── End of feed indicator ────────────────────────────────────────
            if (posts.isNotEmpty)
              SliverToBoxAdapter(
                child: Padding(
                  padding: EdgeInsets.symmetric(
                      vertical: responsive.sp(24), horizontal: responsive.sp(16)),
                  child: Row(
                    children: [
                      const Expanded(child: Divider()),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: responsive.sp(12)),
                        child: Text(
                          "You're all caught up!",
                          style: TextStyle(
                              fontSize: responsive.sp(12), color: AppTheme.greyMedium),
                        ),
                      ),
                      const Expanded(child: Divider()),
                    ],
                  ),
                ),
              ),

            SliverToBoxAdapter(child: SizedBox(height: responsive.sp(16))),
          ],
        ),
      ),
    );
  }
}

// ── Pinned header delegate ─────────────────────────────────────────────────────

class _FeedTabBarDelegate extends SliverPersistentHeaderDelegate {
  final Widget child;
  final double height;

  const _FeedTabBarDelegate({required this.child, required this.height});

  @override
  double get minExtent => height;
  @override
  double get maxExtent => height;

  @override
  Widget build(BuildContext context, double shrinkOffset, bool overlapsContent) {
    return SizedBox.expand(child: child);
  }

  @override
  bool shouldRebuild(_FeedTabBarDelegate old) => true;
}
