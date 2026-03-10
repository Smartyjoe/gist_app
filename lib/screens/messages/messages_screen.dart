import 'package:flutter/material.dart';
import '../../config/app_theme.dart';
import '../../utils/responsive.dart';
import 'chat_screen.dart';

// ── Mock data models ──────────────────────────────────────────────────────────

class _Conversation {
  final String id;
  final String name;
  final String avatar;
  final String lastMessage;
  final DateTime lastTime;
  final int unread;
  final bool isOnline;
  final bool isPinned;
  final bool isGroup;
  final bool isMuted;
  final MessageStatus lastStatus;

  const _Conversation({
    required this.id,
    required this.name,
    required this.avatar,
    required this.lastMessage,
    required this.lastTime,
    this.unread = 0,
    this.isOnline = false,
    this.isPinned = false,
    this.isGroup = false,
    this.isMuted = false,
    this.lastStatus = MessageStatus.delivered,
  });
}

enum MessageStatus { sent, delivered, read }

final _mockConversations = [
  _Conversation(
    id: 'c1', name: 'Adewale Johnson',
    avatar: 'https://i.pravatar.cc/150?img=1',
    lastMessage: 'The flooding on Lekki road is getting worse 😟',
    lastTime: DateTime.now().subtract(const Duration(minutes: 3)),
    unread: 5, isOnline: true, isPinned: true,
    lastStatus: MessageStatus.delivered,
  ),
  _Conversation(
    id: 'c2', name: 'Lagos Community Watch',
    avatar: 'https://i.pravatar.cc/150?img=15',
    lastMessage: 'Emeka: Fire service has arrived at Oshodi',
    lastTime: DateTime.now().subtract(const Duration(minutes: 12)),
    unread: 12, isGroup: true, isPinned: true,
    lastStatus: MessageStatus.read,
  ),
  _Conversation(
    id: 'c3', name: 'Chioma Obi',
    avatar: 'https://i.pravatar.cc/150?img=2',
    lastMessage: 'Thank you for the report! Sharing now 🙏',
    lastTime: DateTime.now().subtract(const Duration(hours: 1)),
    unread: 0, isOnline: true,
    lastStatus: MessageStatus.read,
  ),
  _Conversation(
    id: 'c4', name: 'Emeka Okafor',
    avatar: 'https://i.pravatar.cc/150?img=3',
    lastMessage: 'Can you send me the video of the bridge?',
    lastTime: DateTime.now().subtract(const Duration(hours: 2)),
    unread: 1,
    lastStatus: MessageStatus.delivered,
  ),
  _Conversation(
    id: 'c5', name: 'Ikeja Reporters',
    avatar: 'https://i.pravatar.cc/150?img=20',
    lastMessage: 'Fatima: Meeting at 5pm, everyone attend',
    lastTime: DateTime.now().subtract(const Duration(hours: 3)),
    unread: 0, isGroup: true, isMuted: true,
    lastStatus: MessageStatus.read,
  ),
  _Conversation(
    id: 'c6', name: 'Fatima Hassan',
    avatar: 'https://i.pravatar.cc/150?img=4',
    lastMessage: 'Sent you the health alert document 📄',
    lastTime: DateTime.now().subtract(const Duration(hours: 5)),
    unread: 0,
    lastStatus: MessageStatus.read,
  ),
  _Conversation(
    id: 'c7', name: 'Bola Adeyemi',
    avatar: 'https://i.pravatar.cc/150?img=6',
    lastMessage: 'Did you see the bridge situation? Very dangerous',
    lastTime: DateTime.now().subtract(const Duration(hours: 8)),
    unread: 0,
    lastStatus: MessageStatus.sent,
  ),
  _Conversation(
    id: 'c8', name: 'Ngozi Obi',
    avatar: 'https://i.pravatar.cc/150?img=7',
    lastMessage: 'Stay safe everyone! 🙏',
    lastTime: DateTime.now().subtract(const Duration(days: 1)),
    unread: 0, isOnline: false,
    lastStatus: MessageStatus.read,
  ),
  _Conversation(
    id: 'c9', name: 'Surulere Updates',
    avatar: 'https://i.pravatar.cc/150?img=25',
    lastMessage: 'Tunde: No water supply update yet',
    lastTime: DateTime.now().subtract(const Duration(days: 1)),
    unread: 3, isGroup: true,
    lastStatus: MessageStatus.delivered,
  ),
];

// ── MessagesScreen ────────────────────────────────────────────────────────────

class MessagesScreen extends StatefulWidget {
  const MessagesScreen({super.key});

  @override
  State<MessagesScreen> createState() => _MessagesScreenState();
}

class _MessagesScreenState extends State<MessagesScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _searchController.addListener(() {
      setState(() => _searchQuery = _searchController.text.toLowerCase());
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  List<_Conversation> _filtered(List<_Conversation> source) {
    if (_searchQuery.isEmpty) return source;
    return source
        .where((c) => c.name.toLowerCase().contains(_searchQuery) ||
            c.lastMessage.toLowerCase().contains(_searchQuery))
        .toList();
  }

  List<_Conversation> get _allConvos => _mockConversations;
  List<_Conversation> get _unread =>
      _mockConversations.where((c) => c.unread > 0).toList();
  List<_Conversation> get _groups =>
      _mockConversations.where((c) => c.isGroup).toList();

  // Active contacts (online users for the top strip)
  List<_Conversation> get _activeContacts =>
      _mockConversations.where((c) => c.isOnline && !c.isGroup).toList();

  String _formatTime(DateTime t) {
    final diff = DateTime.now().difference(t);
    if (diff.inMinutes < 1) return 'now';
    if (diff.inMinutes < 60) return '${diff.inMinutes}m';
    if (diff.inHours < 24) return '${diff.inHours}h';
    if (diff.inDays == 1) return 'Yesterday';
    return '${t.day}/${t.month}';
  }

  void _openChat(_Conversation convo) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => ChatScreen(
          conversationId: convo.id,
          name: convo.name,
          avatar: convo.avatar,
          isOnline: convo.isOnline,
          isGroup: convo.isGroup,
        ),
      ),
    );
    // Mark as read
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final responsive = context.responsive;

    return Scaffold(
      backgroundColor: AppTheme.background,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: AppTheme.white,
        automaticallyImplyLeading: false,
        title: Text('Messages',
            style: TextStyle(
                fontSize: responsive.sp(20),
                fontWeight: FontWeight.w800,
                color: AppTheme.textPrimary)),
        actions: [
          IconButton(
            icon: Icon(Icons.search, color: AppTheme.textPrimary, size: responsive.sp(24)),
            onPressed: () => FocusScope.of(context).requestFocus(FocusNode()),
          ),
          IconButton(
            icon: Icon(Icons.edit_square, color: AppTheme.greenPrimary, size: responsive.sp(24)),
            onPressed: () => ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('New message coming soon'), behavior: SnackBarBehavior.floating)),
          ),
        ],
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(responsive.sp(1)),
          child: Divider(height: 1, color: AppTheme.greySoft),
        ),
      ),
      body: Column(
        children: [
          // ── Search bar ──────────────────────────────────────────────────
          Container(
            color: AppTheme.white,
            padding: EdgeInsets.fromLTRB(
                responsive.sp(12), responsive.sp(8), responsive.sp(12), responsive.sp(8)),
            child: Container(
              height: responsive.sp(38),
              decoration: BoxDecoration(
                color: AppTheme.greySoft.withOpacity(0.6),
                borderRadius: BorderRadius.circular(responsive.sp(10)),
              ),
              child: TextField(
                controller: _searchController,
                decoration: InputDecoration(
                  hintText: 'Search conversations...',
                  hintStyle: TextStyle(
                      fontSize: responsive.sp(13), color: AppTheme.greyMedium),
                  prefixIcon: Icon(Icons.search,
                      size: responsive.sp(18), color: AppTheme.greyMedium),
                  suffixIcon: _searchQuery.isNotEmpty
                      ? IconButton(
                          icon: Icon(Icons.clear,
                              size: responsive.sp(16), color: AppTheme.greyMedium),
                          onPressed: () => _searchController.clear())
                      : null,
                  border: InputBorder.none,
                  focusedBorder: InputBorder.none,
                  contentPadding:
                      EdgeInsets.symmetric(vertical: responsive.sp(10)),
                ),
              ),
            ),
          ),

          // ── Active contacts strip ────────────────────────────────────────
          if (_activeContacts.isNotEmpty && _searchQuery.isEmpty)
            _ActiveContactsStrip(contacts: _activeContacts, responsive: responsive),

          // ── Tab bar ─────────────────────────────────────────────────────
          Container(
            color: AppTheme.white,
            child: TabBar(
              controller: _tabController,
              indicatorColor: AppTheme.greenPrimary,
              indicatorWeight: 2,
              labelColor: AppTheme.greenPrimary,
              unselectedLabelColor: AppTheme.greyMedium,
              labelStyle: TextStyle(
                  fontSize: responsive.sp(13), fontWeight: FontWeight.w700),
              unselectedLabelStyle: TextStyle(
                  fontSize: responsive.sp(13), fontWeight: FontWeight.w500),
              tabs: [
                const Tab(text: 'All'),
                Tab(
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Text('Unread'),
                      if (_unread.isNotEmpty) ...[
                        SizedBox(width: responsive.sp(4)),
                        Container(
                          padding: EdgeInsets.symmetric(
                              horizontal: responsive.sp(5), vertical: responsive.sp(1)),
                          decoration: BoxDecoration(
                            color: AppTheme.greenPrimary,
                            borderRadius: BorderRadius.circular(responsive.sp(10)),
                          ),
                          child: Text('${_unread.length}',
                              style: TextStyle(
                                  color: AppTheme.white,
                                  fontSize: responsive.sp(10),
                                  fontWeight: FontWeight.w700)),
                        ),
                      ],
                    ],
                  ),
                ),
                const Tab(text: 'Groups'),
              ],
            ),
          ),
          Divider(height: 1, color: AppTheme.greySoft),

          // ── Conversation lists ───────────────────────────────────────────
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                _ConversationList(
                  conversations: _filtered(_allConvos),
                  onTap: _openChat,
                  formatTime: _formatTime,
                  responsive: responsive,
                ),
                _ConversationList(
                  conversations: _filtered(_unread),
                  onTap: _openChat,
                  formatTime: _formatTime,
                  responsive: responsive,
                  emptyMessage: 'No unread messages',
                  emptyIcon: Icons.mark_chat_read_outlined,
                ),
                _ConversationList(
                  conversations: _filtered(_groups),
                  onTap: _openChat,
                  formatTime: _formatTime,
                  responsive: responsive,
                  emptyMessage: 'No group chats yet',
                  emptyIcon: Icons.group_outlined,
                ),
              ],
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
                content: Text('New message coming soon'),
                behavior: SnackBarBehavior.floating)),
        backgroundColor: AppTheme.greenPrimary,
        child: const Icon(Icons.edit_outlined, color: AppTheme.white),
      ),
    );
  }
}

// ── Active Contacts Strip ─────────────────────────────────────────────────────

class _ActiveContactsStrip extends StatelessWidget {
  final List<_Conversation> contacts;
  final Responsive responsive;

  const _ActiveContactsStrip(
      {required this.contacts, required this.responsive});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppTheme.white,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.fromLTRB(
                responsive.sp(16), responsive.sp(8), 0, responsive.sp(4)),
            child: Text('Active now',
                style: TextStyle(
                    fontSize: responsive.sp(12),
                    fontWeight: FontWeight.w600,
                    color: AppTheme.greyMedium,
                    letterSpacing: 0.3)),
          ),
          SizedBox(
            height: responsive.sp(72),
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: EdgeInsets.symmetric(horizontal: responsive.sp(12)),
              itemCount: contacts.length,
              itemBuilder: (_, i) {
                final c = contacts[i];
                return Padding(
                  padding: EdgeInsets.only(right: responsive.sp(16)),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Stack(
                        children: [
                          CircleAvatar(
                            radius: responsive.sp(22),
                            backgroundColor: AppTheme.greySoft,
                            backgroundImage: NetworkImage(c.avatar),
                          ),
                          Positioned(
                            bottom: 0, right: 0,
                            child: Container(
                              width: responsive.sp(12),
                              height: responsive.sp(12),
                              decoration: BoxDecoration(
                                color: AppTheme.greenPrimary,
                                shape: BoxShape.circle,
                                border: Border.all(
                                    color: AppTheme.white, width: 2),
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: responsive.sp(3)),
                      Text(
                        c.name.split(' ').first,
                        style: TextStyle(
                            fontSize: responsive.sp(10),
                            color: AppTheme.textPrimary,
                            fontWeight: FontWeight.w500),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
          SizedBox(height: responsive.sp(6)),
          Divider(height: 1, color: AppTheme.greySoft),
        ],
      ),
    );
  }
}

// ── Conversation List ─────────────────────────────────────────────────────────

class _ConversationList extends StatelessWidget {
  final List<_Conversation> conversations;
  final void Function(_Conversation) onTap;
  final String Function(DateTime) formatTime;
  final Responsive responsive;
  final String emptyMessage;
  final IconData emptyIcon;

  const _ConversationList({
    required this.conversations,
    required this.onTap,
    required this.formatTime,
    required this.responsive,
    this.emptyMessage = 'No conversations yet',
    this.emptyIcon = Icons.chat_bubble_outline,
  });

  @override
  Widget build(BuildContext context) {
    if (conversations.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(emptyIcon, size: responsive.sp(52), color: AppTheme.greyMedium),
            SizedBox(height: responsive.sp(12)),
            Text(emptyMessage,
                style: TextStyle(
                    fontSize: responsive.sp(15), color: AppTheme.greyMedium)),
          ],
        ),
      );
    }

    // Sort: pinned first
    final pinned = conversations.where((c) => c.isPinned).toList();
    final rest = conversations.where((c) => !c.isPinned).toList();
    final sorted = [...pinned, ...rest];

    return ListView.separated(
      itemCount: sorted.length,
      separatorBuilder: (_, __) =>
          Divider(height: 1, indent: responsive.sp(76), color: AppTheme.greySoft),
      itemBuilder: (_, i) => _ConversationTile(
        conversation: sorted[i],
        onTap: () => onTap(sorted[i]),
        formatTime: formatTime,
        responsive: responsive,
      ),
    );
  }
}

// ── Conversation Tile ─────────────────────────────────────────────────────────

class _ConversationTile extends StatelessWidget {
  final _Conversation conversation;
  final VoidCallback onTap;
  final String Function(DateTime) formatTime;
  final Responsive responsive;

  const _ConversationTile({
    required this.conversation,
    required this.onTap,
    required this.formatTime,
    required this.responsive,
  });

  Widget _statusIcon(Responsive r) {
    switch (conversation.lastStatus) {
      case MessageStatus.sent:
        return Icon(Icons.check, size: r.sp(13), color: AppTheme.greyMedium);
      case MessageStatus.delivered:
        return Icon(Icons.done_all, size: r.sp(13), color: AppTheme.greyMedium);
      case MessageStatus.read:
        return Icon(Icons.done_all, size: r.sp(13), color: AppTheme.greenPrimary);
    }
  }

  @override
  Widget build(BuildContext context) {
    final c = conversation;
    final hasUnread = c.unread > 0;

    return InkWell(
      onTap: onTap,
      child: Container(
        color: c.isPinned ? AppTheme.greenPrimary.withOpacity(0.03) : null,
        padding: EdgeInsets.symmetric(
            horizontal: responsive.sp(16), vertical: responsive.sp(10)),
        child: Row(
          children: [
            // Avatar with online dot / group icon
            Stack(
              children: [
                CircleAvatar(
                  radius: responsive.sp(26),
                  backgroundColor: AppTheme.greySoft,
                  backgroundImage: NetworkImage(c.avatar),
                ),
                if (c.isOnline && !c.isGroup)
                  Positioned(
                    bottom: 1, right: 1,
                    child: Container(
                      width: responsive.sp(12),
                      height: responsive.sp(12),
                      decoration: BoxDecoration(
                        color: AppTheme.greenPrimary,
                        shape: BoxShape.circle,
                        border: Border.all(color: AppTheme.white, width: 2),
                      ),
                    ),
                  ),
                if (c.isGroup)
                  Positioned(
                    bottom: 0, right: 0,
                    child: Container(
                      padding: EdgeInsets.all(responsive.sp(2)),
                      decoration: BoxDecoration(
                        color: Colors.blue,
                        shape: BoxShape.circle,
                        border: Border.all(color: AppTheme.white, width: 1.5),
                      ),
                      child: Icon(Icons.group,
                          color: Colors.white, size: responsive.sp(9)),
                    ),
                  ),
              ],
            ),

            SizedBox(width: responsive.sp(12)),

            // Name + message preview
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      if (c.isPinned)
                        Padding(
                          padding: EdgeInsets.only(right: responsive.sp(4)),
                          child: Icon(Icons.push_pin,
                              size: responsive.sp(11), color: AppTheme.greyMedium),
                        ),
                      Expanded(
                        child: Text(
                          c.name,
                          style: TextStyle(
                            fontSize: responsive.sp(14),
                            fontWeight: hasUnread ? FontWeight.w700 : FontWeight.w600,
                            color: AppTheme.textPrimary,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      SizedBox(width: responsive.sp(8)),
                      Text(
                        formatTime(c.lastTime),
                        style: TextStyle(
                          fontSize: responsive.sp(11),
                          color: hasUnread ? AppTheme.greenPrimary : AppTheme.greyMedium,
                          fontWeight: hasUnread ? FontWeight.w600 : FontWeight.w400,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: responsive.sp(3)),
                  Row(
                    children: [
                      // Read receipt for sent messages
                      if (!c.isGroup && c.unread == 0)
                        Padding(
                          padding: EdgeInsets.only(right: responsive.sp(3)),
                          child: _statusIcon(responsive),
                        ),
                      if (c.isMuted)
                        Padding(
                          padding: EdgeInsets.only(right: responsive.sp(3)),
                          child: Icon(Icons.volume_off_outlined,
                              size: responsive.sp(12), color: AppTheme.greyMedium),
                        ),
                      Expanded(
                        child: Text(
                          c.lastMessage,
                          style: TextStyle(
                            fontSize: responsive.sp(12),
                            color: hasUnread
                                ? AppTheme.textPrimary
                                : AppTheme.greyMedium,
                            fontWeight: hasUnread
                                ? FontWeight.w600
                                : FontWeight.w400,
                          ),
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                        ),
                      ),
                      SizedBox(width: responsive.sp(8)),
                      // Unread badge
                      if (hasUnread)
                        Container(
                          padding: EdgeInsets.symmetric(
                              horizontal: responsive.sp(6),
                              vertical: responsive.sp(2)),
                          decoration: BoxDecoration(
                            color: c.isMuted
                                ? AppTheme.greyMedium
                                : AppTheme.greenPrimary,
                            borderRadius:
                                BorderRadius.circular(responsive.sp(10)),
                          ),
                          child: Text(
                            c.unread > 99 ? '99+' : '${c.unread}',
                            style: TextStyle(
                                color: AppTheme.white,
                                fontSize: responsive.sp(10),
                                fontWeight: FontWeight.w700),
                          ),
                        ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
