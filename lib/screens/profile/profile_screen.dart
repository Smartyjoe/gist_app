import 'package:flutter/material.dart';
import '../../models/user.dart';
import '../../config/app_theme.dart';
import '../../utils/responsive.dart';
import 'edit_profile_screen.dart';
import '../settings/settings_screen.dart';

class ProfileScreen extends StatefulWidget {
  final bool isOwnProfile;
  const ProfileScreen({super.key, this.isOwnProfile = true});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  UserProfile _user = UserProfile(
    id: 'user1',
    name: 'Adewale Johnson',
    username: 'adewale_johnson',
    avatar: 'https://i.pravatar.cc/150?img=1',
    bio: 'Community reporter from Lagos 🇳🇬\nMaking neighborhoods safer, one report at a time. #Gistly',
    website: 'https://gistly.app',
    location: 'Lagos, Nigeria',
    email: 'adewale.johnson@example.com',
    phone: '+234 801 234 5678',
    preferredLanguage: 'en',
    postsCount: 45,
    followersCount: 12340,
    followingCount: 567,
    reportsCount: 38,
    isVerified: true,
    joinedAt: DateTime(2023, 1, 15),
  );

  bool _isFollowing = false;
  bool _isGridView = true;

  final List<Map<String, dynamic>> _moments = [
    {'icon': Icons.report_problem, 'label': 'Reports', 'color': Colors.orange},
    {'icon': Icons.local_hospital, 'label': 'Health', 'color': Colors.red},
    {'icon': Icons.park, 'label': 'Environment', 'color': Colors.green},
    {'icon': Icons.celebration, 'label': 'Events', 'color': Colors.purple},
    {'icon': Icons.add, 'label': 'New', 'color': AppTheme.greyMedium},
  ];

  final List<Color> _mockPosts = [
    Colors.teal, Colors.orange, Colors.purple,
    Colors.blue, Colors.green, Colors.red,
    Colors.amber, Colors.indigo, Colors.cyan,
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  void _openSettings() async {
    await Navigator.push(context, MaterialPageRoute(builder: (_) => const SettingsScreen()));
  }

  void _openEditProfile() async {
    final updated = await Navigator.push<UserProfile>(
      context,
      MaterialPageRoute(builder: (_) => EditProfileScreen(user: _user)),
    );
    if (updated != null) setState(() => _user = updated);
  }

  void _showMenuPanel() {
    final responsive = context.responsive;
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (ctx) => Container(
        decoration: BoxDecoration(
          color: AppTheme.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(responsive.sp(20))),
        ),
        child: SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(height: responsive.sp(12)),
              Container(
                width: responsive.sp(40), height: responsive.sp(4),
                decoration: BoxDecoration(
                  color: AppTheme.greyMedium.withOpacity(0.4),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              SizedBox(height: responsive.sp(8)),
              _menuItem(ctx, Icons.settings_outlined, 'Settings', () { Navigator.pop(ctx); _openSettings(); }, responsive),
              _menuItem(ctx, Icons.bookmark_outline, 'Saved Posts', () => Navigator.pop(ctx), responsive),
              _menuItem(ctx, Icons.bar_chart_outlined, 'Activity', () => Navigator.pop(ctx), responsive),
              _menuItem(ctx, Icons.archive_outlined, 'Archive', () => Navigator.pop(ctx), responsive),
              _menuItem(ctx, Icons.auto_stories_outlined, 'Highlights', () => Navigator.pop(ctx), responsive),
              _menuItem(ctx, Icons.help_outline, 'Help', () => Navigator.pop(ctx), responsive),
              SizedBox(height: responsive.sp(8)),
            ],
          ),
        ),
      ),
    );
  }

  Widget _menuItem(BuildContext ctx, IconData icon, String label, VoidCallback onTap, Responsive r) {
    return ListTile(
      leading: Icon(icon, color: AppTheme.textPrimary, size: r.sp(22)),
      title: Text(label, style: TextStyle(fontSize: r.sp(15), fontWeight: FontWeight.w500)),
      onTap: onTap,
    );
  }

  void _openFollowersList() => _showUserList('Followers', _user.followersCount);
  void _openFollowingList() => _showUserList('Following', _user.followingCount);

  void _showUserList(String title, int count) {
    final responsive = context.responsive;
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => DraggableScrollableSheet(
        initialChildSize: 0.75,
        minChildSize: 0.5,
        maxChildSize: 0.95,
        builder: (_, controller) => Container(
          decoration: BoxDecoration(
            color: AppTheme.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(responsive.sp(20))),
          ),
          child: Column(
            children: [
              SizedBox(height: responsive.sp(12)),
              Container(
                width: responsive.sp(40), height: responsive.sp(4),
                decoration: BoxDecoration(color: AppTheme.greyMedium.withOpacity(0.4), borderRadius: BorderRadius.circular(2)),
              ),
              Padding(
                padding: EdgeInsets.all(responsive.sp(16)),
                child: Text(title, style: TextStyle(fontSize: responsive.sp(17), fontWeight: FontWeight.w700)),
              ),
              Divider(height: 1, color: AppTheme.greySoft),
              Expanded(
                child: ListView.builder(
                  controller: controller,
                  itemCount: count.clamp(0, 20),
                  itemBuilder: (_, i) => ListTile(
                    leading: CircleAvatar(
                      radius: responsive.sp(20),
                      backgroundColor: AppTheme.greySoft,
                      backgroundImage: NetworkImage('https://i.pravatar.cc/80?img=${i + 2}'),
                    ),
                    title: Text('User ${i + 1}',
                        style: TextStyle(fontWeight: FontWeight.w600, fontSize: responsive.sp(14))),
                    subtitle: Text('@user_${i + 1}',
                        style: TextStyle(fontSize: responsive.sp(12), color: AppTheme.greyMedium)),
                    trailing: title == 'Followers'
                        ? OutlinedButton(
                            onPressed: () {},
                            style: OutlinedButton.styleFrom(
                              foregroundColor: AppTheme.textPrimary,
                              side: const BorderSide(color: AppTheme.greySoft),
                              padding: EdgeInsets.symmetric(horizontal: responsive.sp(16)),
                              minimumSize: Size(0, responsive.sp(32)),
                            ),
                            child: Text('Follow', style: TextStyle(fontSize: responsive.sp(13))),
                          )
                        : null,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _viewProfileImage() {
    if (_user.avatar == null) return;
    Navigator.push(context, MaterialPageRoute(
      builder: (_) => _ProfileImageViewer(imageUrl: _user.avatar!),
    ));
  }

  void _shareProfile() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Sharing @${_user.username}\'s profile...'), behavior: SnackBarBehavior.floating),
    );
  }

  @override
  Widget build(BuildContext context) {
    final responsive = context.responsive;

    return Scaffold(
      backgroundColor: AppTheme.background,
      body: NestedScrollView(
        headerSliverBuilder: (ctx, innerBoxIsScrolled) => [
          // App Bar
          SliverAppBar(
            backgroundColor: AppTheme.white,
            elevation: 0,
            floating: true,
            snap: true,
            automaticallyImplyLeading: false,
            title: Text(_user.username,
                style: TextStyle(fontSize: responsive.sp(17), fontWeight: FontWeight.w700, color: AppTheme.textPrimary)),
            centerTitle: true,
            actions: [
              IconButton(
                icon: Icon(Icons.menu, color: AppTheme.textPrimary, size: responsive.sp(26)),
                onPressed: _showMenuPanel,
              ),
            ],
          ),

          // Profile content
          SliverToBoxAdapter(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildHeaderRow(responsive),
                _buildBioSection(responsive),
                _buildActionButtons(responsive),
                _buildMomentsRow(responsive),
                Divider(height: 1, color: AppTheme.greySoft),
              ],
            ),
          ),

          // Pinned Tab Bar
          SliverPersistentHeader(
            pinned: true,
            delegate: _TabBarDelegate(
              tabBar: TabBar(
                controller: _tabController,
                indicatorColor: AppTheme.textPrimary,
                indicatorWeight: 1.5,
                labelColor: AppTheme.textPrimary,
                unselectedLabelColor: AppTheme.greyMedium,
                tabs: const [
                  Tab(icon: Icon(Icons.grid_on)),
                  Tab(icon: Icon(Icons.videocam_outlined)),
                  Tab(icon: Icon(Icons.headphones_outlined)),
                  Tab(icon: Icon(Icons.person_pin_outlined)),
                ],
              ),
              background: AppTheme.white,
              responsive: responsive,
              isGridView: _isGridView,
              onToggleView: () => setState(() => _isGridView = !_isGridView),
            ),
          ),
        ],
        body: TabBarView(
          controller: _tabController,
          children: [
            _buildPostsTab(responsive),
            _buildEmptyTab(responsive, Icons.videocam_outlined, 'No videos yet'),
            _buildEmptyTab(responsive, Icons.headphones_outlined, 'No audio yet'),
            _buildEmptyTab(responsive, Icons.person_pin_outlined, 'No tagged posts'),
          ],
        ),
      ),
    );
  }

  Widget _buildHeaderRow(Responsive responsive) {
    return Container(
      color: AppTheme.white,
      padding: EdgeInsets.fromLTRB(responsive.sp(16), responsive.sp(16), responsive.sp(16), 0),
      child: Row(
        children: [
          // Avatar with green ring
          GestureDetector(
            onTap: _viewProfileImage,
            child: Stack(
              children: [
                Container(
                  width: responsive.sp(88),
                  height: responsive.sp(88),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: const LinearGradient(
                      colors: [AppTheme.greenPrimary, AppTheme.greenDark],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(2.5),
                    child: CircleAvatar(
                      backgroundColor: AppTheme.greySoft,
                      backgroundImage: _user.avatar != null ? NetworkImage(_user.avatar!) : null,
                      child: _user.avatar == null
                          ? Icon(Icons.person, size: responsive.sp(40), color: AppTheme.greyMedium)
                          : null,
                    ),
                  ),
                ),
                if (_user.isVerified)
                  Positioned(
                    bottom: 2, right: 2,
                    child: Container(
                      padding: EdgeInsets.all(responsive.sp(3)),
                      decoration: BoxDecoration(
                        color: AppTheme.greenPrimary,
                        shape: BoxShape.circle,
                        border: Border.all(color: AppTheme.white, width: 1.5),
                      ),
                      child: Icon(Icons.check, color: AppTheme.white, size: responsive.sp(11)),
                    ),
                  ),
              ],
            ),
          ),

          SizedBox(width: responsive.sp(20)),

          // Stats
          Expanded(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildStatItem('Posts', _user.postsCount, () {}, responsive),
                _buildStatItem('Followers', _user.followersCount, _openFollowersList, responsive),
                _buildStatItem('Following', _user.followingCount, _openFollowingList, responsive),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatItem(String label, int value, VoidCallback onTap, Responsive responsive) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Text(UserProfile.formatCount(value),
              style: TextStyle(fontSize: responsive.sp(18), fontWeight: FontWeight.w800, color: AppTheme.textPrimary)),
          SizedBox(height: responsive.sp(2)),
          Text(label, style: TextStyle(fontSize: responsive.sp(12), color: AppTheme.textSecondary)),
        ],
      ),
    );
  }

  Widget _buildBioSection(Responsive responsive) {
    return Container(
      color: AppTheme.white,
      padding: EdgeInsets.fromLTRB(responsive.sp(16), responsive.sp(12), responsive.sp(16), responsive.sp(8)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(_user.name,
                  style: TextStyle(fontSize: responsive.sp(15), fontWeight: FontWeight.w700, color: AppTheme.textPrimary)),
              if (_user.isVerified) ...[
                SizedBox(width: responsive.sp(4)),
                Icon(Icons.verified, color: AppTheme.greenPrimary, size: responsive.sp(16)),
              ],
            ],
          ),
          Text('@${_user.username}',
              style: TextStyle(fontSize: responsive.sp(13), color: AppTheme.greyMedium)),
          if (_user.bio != null) ...[
            SizedBox(height: responsive.sp(6)),
            Text(_user.bio!,
                style: TextStyle(fontSize: responsive.sp(14), color: AppTheme.textPrimary, height: 1.4)),
          ],
          if (_user.website != null) ...[
            SizedBox(height: responsive.sp(4)),
            Row(
              children: [
                Icon(Icons.link, size: responsive.sp(14), color: AppTheme.greenPrimary),
                SizedBox(width: responsive.sp(4)),
                Text(_user.website!,
                    style: TextStyle(fontSize: responsive.sp(13), color: AppTheme.greenPrimary, fontWeight: FontWeight.w500)),
              ],
            ),
          ],
          if (_user.location != null) ...[
            SizedBox(height: responsive.sp(2)),
            Row(
              children: [
                Icon(Icons.location_on_outlined, size: responsive.sp(14), color: AppTheme.greyMedium),
                SizedBox(width: responsive.sp(4)),
                Text(_user.location!, style: TextStyle(fontSize: responsive.sp(13), color: AppTheme.greyMedium)),
              ],
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildActionButtons(Responsive responsive) {
    return Container(
      color: AppTheme.white,
      padding: EdgeInsets.fromLTRB(responsive.sp(16), responsive.sp(4), responsive.sp(16), responsive.sp(12)),
      child: Row(
        children: [
          if (widget.isOwnProfile) ...[
            Expanded(child: _ActionButton(label: 'Edit Profile', onTap: _openEditProfile, responsive: responsive)),
            SizedBox(width: responsive.sp(8)),
            Expanded(child: _ActionButton(label: 'Share Profile', onTap: _shareProfile, responsive: responsive)),
          ] else ...[
            Expanded(
              child: _FollowButton(
                isFollowing: _isFollowing,
                onTap: () => setState(() => _isFollowing = !_isFollowing),
                responsive: responsive,
              ),
            ),
            SizedBox(width: responsive.sp(8)),
            Expanded(child: _ActionButton(label: 'Message', onTap: () {}, responsive: responsive)),
            SizedBox(width: responsive.sp(8)),
            _ActionButton(label: '', icon: Icons.share_outlined, onTap: _shareProfile, responsive: responsive, compact: true),
          ],
        ],
      ),
    );
  }

  Widget _buildMomentsRow(Responsive responsive) {
    return Container(
      color: AppTheme.white,
      padding: EdgeInsets.only(bottom: responsive.sp(12)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.fromLTRB(responsive.sp(16), responsive.sp(4), 0, responsive.sp(10)),
            child: Text('Moments',
                style: TextStyle(fontSize: responsive.sp(13), fontWeight: FontWeight.w600,
                    color: AppTheme.textSecondary, letterSpacing: 0.4)),
          ),
          SizedBox(
            height: responsive.sp(90),
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: EdgeInsets.symmetric(horizontal: responsive.sp(12)),
              itemCount: _moments.length,
              itemBuilder: (_, i) {
                final m = _moments[i];
                return Padding(
                  padding: EdgeInsets.symmetric(horizontal: responsive.sp(6)),
                  child: GestureDetector(
                    onTap: () => ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Opening ${m['label']} moment...'), behavior: SnackBarBehavior.floating)),
                    child: Column(
                      children: [
                        Container(
                          width: responsive.sp(60),
                          height: responsive.sp(60),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(color: (m['color'] as Color).withOpacity(0.6), width: 2),
                            color: (m['color'] as Color).withOpacity(0.1),
                          ),
                          child: Icon(m['icon'] as IconData, color: m['color'] as Color, size: responsive.sp(26)),
                        ),
                        SizedBox(height: responsive.sp(4)),
                        Text(m['label'] as String,
                            style: TextStyle(fontSize: responsive.sp(11), color: AppTheme.textSecondary)),
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

  Widget _buildPostsTab(Responsive responsive) {
    if (_isGridView) {
      return GridView.builder(
        padding: EdgeInsets.zero,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
          crossAxisSpacing: 1.5,
          mainAxisSpacing: 1.5,
        ),
        itemCount: _mockPosts.length,
        itemBuilder: (_, i) => GestureDetector(
          onTap: () => ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Opening post ${i + 1}...'), behavior: SnackBarBehavior.floating)),
          child: Container(
            color: _mockPosts[i].withOpacity(0.55),
            child: Center(child: Icon(Icons.image, color: Colors.white.withOpacity(0.7), size: responsive.sp(32))),
          ),
        ),
      );
    }

    return ListView.builder(
      padding: EdgeInsets.symmetric(vertical: responsive.sp(8)),
      itemCount: _mockPosts.length,
      itemBuilder: (_, i) => Container(
        margin: EdgeInsets.fromLTRB(responsive.sp(16), 0, responsive.sp(16), responsive.sp(12)),
        decoration: BoxDecoration(
          color: AppTheme.white,
          borderRadius: BorderRadius.circular(responsive.sp(12)),
          border: Border.all(color: AppTheme.greySoft),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: responsive.sp(200),
              decoration: BoxDecoration(
                color: _mockPosts[i].withOpacity(0.55),
                borderRadius: BorderRadius.vertical(top: Radius.circular(responsive.sp(12))),
              ),
              child: Center(child: Icon(Icons.image, color: Colors.white.withOpacity(0.7), size: responsive.sp(48))),
            ),
            Padding(
              padding: EdgeInsets.all(responsive.sp(12)),
              child: Text('Post ${i + 1} content goes here...',
                  style: TextStyle(fontSize: responsive.sp(14), color: AppTheme.textPrimary)),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyTab(Responsive responsive, IconData icon, String message) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: responsive.sp(48), color: AppTheme.greyMedium),
          SizedBox(height: responsive.sp(12)),
          Text(message, style: TextStyle(fontSize: responsive.sp(15), color: AppTheme.greyMedium)),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Sub-widgets
// ─────────────────────────────────────────────────────────────────────────────

class _ActionButton extends StatelessWidget {
  final String label;
  final IconData? icon;
  final VoidCallback onTap;
  final Responsive responsive;
  final bool compact;

  const _ActionButton({
    required this.label,
    required this.onTap,
    required this.responsive,
    this.icon,
    this.compact = false,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(responsive.sp(8)),
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: responsive.sp(compact ? 10 : 12),
          vertical: responsive.sp(8),
        ),
        decoration: BoxDecoration(
          color: AppTheme.greySoft.withOpacity(0.5),
          borderRadius: BorderRadius.circular(responsive.sp(8)),
          border: Border.all(color: AppTheme.greySoft),
        ),
        child: Center(
          child: icon != null
              ? Icon(icon, size: responsive.sp(18), color: AppTheme.textPrimary)
              : Text(label,
                  style: TextStyle(fontSize: responsive.sp(13), fontWeight: FontWeight.w600, color: AppTheme.textPrimary)),
        ),
      ),
    );
  }
}

class _FollowButton extends StatefulWidget {
  final bool isFollowing;
  final VoidCallback onTap;
  final Responsive responsive;

  const _FollowButton({required this.isFollowing, required this.onTap, required this.responsive});

  @override
  State<_FollowButton> createState() => _FollowButtonState();
}

class _FollowButtonState extends State<_FollowButton> with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;
  late Animation<double> _scale;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(vsync: this, duration: const Duration(milliseconds: 150));
    _scale = Tween(begin: 1.0, end: 0.93).animate(CurvedAnimation(parent: _ctrl, curve: Curves.easeIn));
  }

  @override
  void dispose() { _ctrl.dispose(); super.dispose(); }

  void _handleTap() async {
    await _ctrl.forward();
    await _ctrl.reverse();
    widget.onTap();
  }

  @override
  Widget build(BuildContext context) {
    final r = widget.responsive;
    return GestureDetector(
      onTap: _handleTap,
      child: ScaleTransition(
        scale: _scale,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 250),
          curve: Curves.easeInOut,
          padding: EdgeInsets.symmetric(vertical: r.sp(8)),
          decoration: BoxDecoration(
            color: widget.isFollowing ? AppTheme.white : AppTheme.greenPrimary,
            borderRadius: BorderRadius.circular(r.sp(8)),
            border: Border.all(color: widget.isFollowing ? AppTheme.greySoft : AppTheme.greenPrimary),
          ),
          child: Center(
            child: Text(
              widget.isFollowing ? 'Following' : 'Follow',
              style: TextStyle(
                fontSize: r.sp(13),
                fontWeight: FontWeight.w700,
                color: widget.isFollowing ? AppTheme.textPrimary : AppTheme.white,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _ProfileImageViewer extends StatelessWidget {
  final String imageUrl;
  const _ProfileImageViewer({required this.imageUrl});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: GestureDetector(
        onTap: () => Navigator.pop(context),
        child: Center(
          child: Image.network(imageUrl, fit: BoxFit.contain),
        ),
      ),
    );
  }
}

class _TabBarDelegate extends SliverPersistentHeaderDelegate {
  final TabBar tabBar;
  final Color background;
  final Responsive responsive;
  final bool isGridView;
  final VoidCallback onToggleView;

  const _TabBarDelegate({
    required this.tabBar,
    required this.background,
    required this.responsive,
    required this.isGridView,
    required this.onToggleView,
  });

  @override
  double get minExtent => tabBar.preferredSize.height;
  @override
  double get maxExtent => tabBar.preferredSize.height;

  @override
  Widget build(BuildContext context, double shrinkOffset, bool overlapsContent) {
    return Container(
      color: background,
      child: Stack(
        children: [
          tabBar,
          Positioned(
            right: 0, top: 0, bottom: 0,
            child: IconButton(
              icon: Icon(
                isGridView ? Icons.view_agenda_outlined : Icons.grid_on,
                size: responsive.sp(20),
                color: AppTheme.textPrimary,
              ),
              onPressed: onToggleView,
            ),
          ),
        ],
      ),
    );
  }

  @override
  bool shouldRebuild(_TabBarDelegate old) =>
      old.isGridView != isGridView || old.tabBar != tabBar;
}
