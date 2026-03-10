import 'package:flutter/material.dart';
import '../../config/app_theme.dart';
import '../../utils/responsive.dart';

// ── Mock message model ────────────────────────────────────────────────────────


class _Message {
  final String id;
  final String text;
  final bool isMe;
  final DateTime time;
  final bool isRead;
  final String? replyTo;

  const _Message({
    required this.id,
    required this.text,
    required this.isMe,
    required this.time,
    this.isRead = false,
    this.replyTo,
  });
}

// ── ChatScreen ────────────────────────────────────────────────────────────────

class ChatScreen extends StatefulWidget {
  final String conversationId;
  final String name;
  final String avatar;
  final bool isOnline;
  final bool isGroup;

  const ChatScreen({
    super.key,
    required this.conversationId,
    required this.name,
    required this.avatar,
    required this.isOnline,
    required this.isGroup,
  });

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen>
    with SingleTickerProviderStateMixin {
  final TextEditingController _inputController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final FocusNode _focusNode = FocusNode();

  bool _isTyping = false;
  bool _showEmoji = false;
  _Message? _replyingTo;

  // Mock messages
  late List<_Message> _messages;

  @override
  void initState() {
    super.initState();
    _messages = [
      _Message(id: 'm1', text: 'Hey! Did you see the flooding report on Lekki road?',
          isMe: false, time: DateTime.now().subtract(const Duration(hours: 2)), isRead: true),
      _Message(id: 'm2', text: 'Yes! It\'s really bad. I drove through there this morning.',
          isMe: true, time: DateTime.now().subtract(const Duration(hours: 1, minutes: 55)), isRead: true),
      _Message(id: 'm3', text: 'People need to know about this. Can you post it on Gistly?',
          isMe: false, time: DateTime.now().subtract(const Duration(hours: 1, minutes: 50)), isRead: true),
      _Message(id: 'm4', text: 'Already did! Got 1.2K likes in 30 minutes 🔥',
          isMe: true, time: DateTime.now().subtract(const Duration(hours: 1, minutes: 30)), isRead: true),
      _Message(id: 'm5', text: 'Amazing! The community needs more reporters like you 👏',
          isMe: false, time: DateTime.now().subtract(const Duration(hours: 1)), isRead: true),
      _Message(id: 'm6', text: 'Thanks! We all need to do our part 🙏',
          isMe: true, time: DateTime.now().subtract(const Duration(minutes: 58)), isRead: true),
      _Message(id: 'm7', text: 'There\'s also a gas leak near Yaba market. Have you heard?',
          isMe: false, time: DateTime.now().subtract(const Duration(minutes: 30)), isRead: true),
      _Message(id: 'm8', text: 'No! That\'s serious. Send me the details.',
          isMe: true, time: DateTime.now().subtract(const Duration(minutes: 28)), isRead: true),
      _Message(id: 'm9', text: 'The flooding on Lekki road is getting worse 😟',
          isMe: false, time: DateTime.now().subtract(const Duration(minutes: 3)), isRead: false),
    ];

    _inputController.addListener(() {
      final typing = _inputController.text.isNotEmpty;
      if (typing != _isTyping) setState(() => _isTyping = typing);
    });

    WidgetsBinding.instance.addPostFrameCallback((_) => _scrollToBottom());
  }

  @override
  void dispose() {
    _inputController.dispose();
    _scrollController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  void _scrollToBottom() {
    if (_scrollController.hasClients) {
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    }
  }

  void _sendMessage() {
    final text = _inputController.text.trim();
    if (text.isEmpty) return;
    setState(() {
      _messages.add(_Message(
        id: 'm${_messages.length + 1}',
        text: text,
        isMe: true,
        time: DateTime.now(),
        replyTo: _replyingTo?.text,
        isRead: false,
      ));
      _replyingTo = null;
      _inputController.clear();
    });
    WidgetsBinding.instance.addPostFrameCallback((_) => _scrollToBottom());
  }

  void _setReply(_Message msg) {
    setState(() => _replyingTo = msg);
    _focusNode.requestFocus();
  }

  void _cancelReply() => setState(() => _replyingTo = null);

  String _formatTime(DateTime t) {
    final h = t.hour.toString().padLeft(2, '0');
    final m = t.minute.toString().padLeft(2, '0');
    return '$h:$m';
  }

  String _formatDateSeparator(DateTime t) {
    final now = DateTime.now();
    final diff = now.difference(t);
    if (diff.inDays == 0) return 'Today';
    if (diff.inDays == 1) return 'Yesterday';
    return '${t.day}/${t.month}/${t.year}';
  }

  bool _showDateSeparator(int index) {
    if (index == 0) return true;
    final prev = _messages[index - 1].time;
    final curr = _messages[index].time;
    return prev.day != curr.day ||
        prev.month != curr.month ||
        prev.year != curr.year;
  }

  @override
  Widget build(BuildContext context) {
    final responsive = context.responsive;

    return Scaffold(
      backgroundColor: const Color(0xFFF0F2F5),
      appBar: _buildAppBar(responsive),
      body: Column(
        children: [
          // Messages list
          Expanded(
            child: GestureDetector(
              onTap: () {
                FocusScope.of(context).unfocus();
                if (_showEmoji) setState(() => _showEmoji = false);
              },
              child: ListView.builder(
                controller: _scrollController,
                padding: EdgeInsets.symmetric(
                    horizontal: responsive.sp(12),
                    vertical: responsive.sp(8)),
                itemCount: _messages.length,
                itemBuilder: (_, i) {
                  final msg = _messages[i];
                  return Column(
                    children: [
                      if (_showDateSeparator(i))
                        _DateSeparator(
                          label: _formatDateSeparator(msg.time),
                          responsive: responsive,
                        ),
                      _MessageBubble(
                        message: msg,
                        responsive: responsive,
                        formatTime: _formatTime,
                        onReply: () => _setReply(msg),
                        isGroup: widget.isGroup,
                        senderName: widget.name,
                      ),
                    ],
                  );
                },
              ),
            ),
          ),

          // Typing indicator
          if (!widget.isGroup && widget.isOnline)
            _TypingIndicator(
              name: widget.name.split(' ').first,
              responsive: responsive,
            ),

          // Reply preview
          if (_replyingTo != null)
            _ReplyPreview(
              message: _replyingTo!,
              onCancel: _cancelReply,
              responsive: responsive,
            ),

          // Input bar
          _InputBar(
            controller: _inputController,
            focusNode: _focusNode,
            isTyping: _isTyping,
            onSend: _sendMessage,
            onAttach: () => ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Attachments coming soon'),
                  behavior: SnackBarBehavior.floating)),
            onEmoji: () => setState(() => _showEmoji = !_showEmoji),
            onVoice: () => ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Voice notes coming soon'),
                  behavior: SnackBarBehavior.floating)),
            responsive: responsive,
          ),
        ],
      ),
    );
  }

  AppBar _buildAppBar(Responsive responsive) {
    return AppBar(
      backgroundColor: AppTheme.white,
      elevation: 0,
      leading: IconButton(
        icon: Icon(Icons.arrow_back, color: AppTheme.textPrimary, size: responsive.sp(24)),
        onPressed: () => Navigator.pop(context),
      ),
      titleSpacing: 0,
      title: GestureDetector(
        onTap: () => ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Opening ${widget.name}\'s profile...'),
              behavior: SnackBarBehavior.floating)),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Stack(
              children: [
                CircleAvatar(
                  radius: responsive.sp(18),
                  backgroundColor: AppTheme.greySoft,
                  backgroundImage: NetworkImage(widget.avatar),
                ),
                if (widget.isOnline)
                  Positioned(
                    bottom: 0, right: 0,
                    child: Container(
                      width: responsive.sp(10),
                      height: responsive.sp(10),
                      decoration: BoxDecoration(
                        color: AppTheme.greenPrimary,
                        shape: BoxShape.circle,
                        border: Border.all(color: AppTheme.white, width: 1.5),
                      ),
                    ),
                  ),
              ],
            ),
            SizedBox(width: responsive.sp(10)),
            Flexible(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    widget.name,
                    style: TextStyle(
                        fontSize: responsive.sp(15),
                        fontWeight: FontWeight.w700,
                        color: AppTheme.textPrimary),
                    overflow: TextOverflow.ellipsis,
                  ),
                  Text(
                    widget.isOnline ? 'Active now' : 'Last seen recently',
                    style: TextStyle(
                        fontSize: responsive.sp(11),
                        color: widget.isOnline
                            ? AppTheme.greenPrimary
                            : AppTheme.greyMedium,
                        fontWeight: FontWeight.w500),
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      actions: [
        IconButton(
          icon: Icon(Icons.videocam_outlined,
              color: AppTheme.textPrimary, size: responsive.sp(24)),
          onPressed: () => ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Video call coming soon'),
                behavior: SnackBarBehavior.floating)),
        ),
        IconButton(
          icon: Icon(Icons.call_outlined,
              color: AppTheme.textPrimary, size: responsive.sp(22)),
          onPressed: () => ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Voice call coming soon'),
                behavior: SnackBarBehavior.floating)),
        ),
        IconButton(
          icon: Icon(Icons.more_vert,
              color: AppTheme.textPrimary, size: responsive.sp(22)),
          onPressed: () {},
        ),
      ],
      bottom: PreferredSize(
        preferredSize: const Size.fromHeight(1),
        child: Divider(height: 1, color: AppTheme.greySoft),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Sub-widgets
// ─────────────────────────────────────────────────────────────────────────────

class _DateSeparator extends StatelessWidget {
  final String label;
  final Responsive responsive;
  const _DateSeparator({required this.label, required this.responsive});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: responsive.sp(12)),
      child: Row(
        children: [
          const Expanded(child: Divider()),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: responsive.sp(12)),
            child: Container(
              padding: EdgeInsets.symmetric(
                  horizontal: responsive.sp(12), vertical: responsive.sp(4)),
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.08),
                borderRadius: BorderRadius.circular(responsive.sp(20)),
              ),
              child: Text(label,
                  style: TextStyle(
                      fontSize: responsive.sp(11),
                      color: AppTheme.textSecondary,
                      fontWeight: FontWeight.w500)),
            ),
          ),
          const Expanded(child: Divider()),
        ],
      ),
    );
  }
}

class _MessageBubble extends StatelessWidget {
  final _Message message;
  final Responsive responsive;
  final String Function(DateTime) formatTime;
  final VoidCallback onReply;
  final bool isGroup;
  final String senderName;

  const _MessageBubble({
    required this.message,
    required this.responsive,
    required this.formatTime,
    required this.onReply,
    required this.isGroup,
    required this.senderName,
  });

  @override
  Widget build(BuildContext context) {
    final isMe = message.isMe;
    final bubbleColor = isMe ? AppTheme.greenPrimary : AppTheme.white;
    final textColor = isMe ? AppTheme.white : AppTheme.textPrimary;

    return GestureDetector(
      onLongPress: onReply,
      child: Padding(
        padding: EdgeInsets.only(bottom: responsive.sp(4)),
        child: Row(
          mainAxisAlignment:
              isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            // Sender avatar (other user only)
            if (!isMe && isGroup)
              Padding(
                padding: EdgeInsets.only(right: responsive.sp(6)),
                child: CircleAvatar(
                  radius: responsive.sp(14),
                  backgroundColor: AppTheme.greySoft,
                  child: Text(senderName[0],
                      style: TextStyle(
                          fontSize: responsive.sp(11),
                          fontWeight: FontWeight.w700,
                          color: AppTheme.greenPrimary)),
                ),
              ),

            // Bubble
            ConstrainedBox(
              constraints: BoxConstraints(
                maxWidth: MediaQuery.of(context).size.width * 0.72,
              ),
              child: Container(
                padding: EdgeInsets.symmetric(
                    horizontal: responsive.sp(12),
                    vertical: responsive.sp(8)),
                decoration: BoxDecoration(
                  color: bubbleColor,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(responsive.sp(16)),
                    topRight: Radius.circular(responsive.sp(16)),
                    bottomLeft: Radius.circular(isMe ? responsive.sp(16) : responsive.sp(4)),
                    bottomRight: Radius.circular(isMe ? responsive.sp(4) : responsive.sp(16)),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 4,
                      offset: const Offset(0, 1),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Sender name for group chats
                    if (!isMe && isGroup)
                      Padding(
                        padding: EdgeInsets.only(bottom: responsive.sp(2)),
                        child: Text(senderName,
                            style: TextStyle(
                                fontSize: responsive.sp(11),
                                fontWeight: FontWeight.w700,
                                color: AppTheme.greenPrimary)),
                      ),

                    // Reply preview
                    if (message.replyTo != null)
                      Container(
                        margin: EdgeInsets.only(bottom: responsive.sp(6)),
                        padding: EdgeInsets.all(responsive.sp(8)),
                        decoration: BoxDecoration(
                          color: isMe
                              ? Colors.white.withOpacity(0.2)
                              : AppTheme.greySoft,
                          borderRadius: BorderRadius.circular(responsive.sp(8)),
                          border: Border(
                            left: BorderSide(
                                color: isMe ? AppTheme.white : AppTheme.greenPrimary,
                                width: 3),
                          ),
                        ),
                        child: Text(
                          message.replyTo!,
                          style: TextStyle(
                              fontSize: responsive.sp(11),
                              color: isMe
                                  ? Colors.white.withOpacity(0.8)
                                  : AppTheme.greyMedium),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),

                    // Message text
                    Text(
                      message.text,
                      style: TextStyle(
                          fontSize: responsive.sp(14),
                          color: textColor,
                          height: 1.4),
                    ),

                    // Time + read receipt
                    SizedBox(height: responsive.sp(3)),
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Text(
                          formatTime(message.time),
                          style: TextStyle(
                              fontSize: responsive.sp(10),
                              color: isMe
                                  ? Colors.white.withOpacity(0.7)
                                  : AppTheme.greyMedium),
                        ),
                        if (isMe) ...[
                          SizedBox(width: responsive.sp(4)),
                          Icon(
                            message.isRead ? Icons.done_all : Icons.check,
                            size: responsive.sp(13),
                            color: message.isRead
                                ? Colors.lightBlueAccent
                                : Colors.white.withOpacity(0.7),
                          ),
                        ],
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _TypingIndicator extends StatefulWidget {
  final String name;
  final Responsive responsive;
  const _TypingIndicator({required this.name, required this.responsive});

  @override
  State<_TypingIndicator> createState() => _TypingIndicatorState();
}

class _TypingIndicatorState extends State<_TypingIndicator>
    with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;
  late Animation<double> _anim;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 800))
      ..repeat(reverse: true);
    _anim = Tween(begin: 0.3, end: 1.0).animate(_ctrl);
  }

  @override
  void dispose() { _ctrl.dispose(); super.dispose(); }

  @override
  Widget build(BuildContext context) {
    final r = widget.responsive;
    return Padding(
      padding: EdgeInsets.fromLTRB(r.sp(16), r.sp(4), r.sp(16), r.sp(4)),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.symmetric(
                horizontal: r.sp(12), vertical: r.sp(8)),
            decoration: BoxDecoration(
              color: AppTheme.white,
              borderRadius: BorderRadius.circular(r.sp(16)),
              boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 4)],
            ),
            child: FadeTransition(
              opacity: _anim,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: List.generate(3, (i) => Padding(
                  padding: EdgeInsets.symmetric(horizontal: r.sp(2)),
                  child: Container(
                    width: r.sp(6), height: r.sp(6),
                    decoration: const BoxDecoration(
                      color: AppTheme.greyMedium, shape: BoxShape.circle),
                  ),
                )),
              ),
            ),
          ),
          SizedBox(width: r.sp(8)),
          Text('${widget.name} is typing...',
              style: TextStyle(
                  fontSize: r.sp(11),
                  color: AppTheme.greyMedium,
                  fontStyle: FontStyle.italic)),
        ],
      ),
    );
  }
}

class _ReplyPreview extends StatelessWidget {
  final _Message message;
  final VoidCallback onCancel;
  final Responsive responsive;

  const _ReplyPreview(
      {required this.message, required this.onCancel, required this.responsive});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppTheme.white,
      padding: EdgeInsets.fromLTRB(responsive.sp(16), responsive.sp(8),
          responsive.sp(8), responsive.sp(8)),
      child: Row(
        children: [
          Container(
            width: 3, height: responsive.sp(36),
            color: AppTheme.greenPrimary,
            margin: EdgeInsets.only(right: responsive.sp(8)),
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  message.isMe ? 'You' : 'Them',
                  style: TextStyle(
                      fontSize: responsive.sp(12),
                      color: AppTheme.greenPrimary,
                      fontWeight: FontWeight.w700),
                ),
                Text(
                  message.text,
                  style: TextStyle(
                      fontSize: responsive.sp(12), color: AppTheme.greyMedium),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          IconButton(
            icon: Icon(Icons.close, size: responsive.sp(18), color: AppTheme.greyMedium),
            onPressed: onCancel,
          ),
        ],
      ),
    );
  }
}

class _InputBar extends StatelessWidget {
  final TextEditingController controller;
  final FocusNode focusNode;
  final bool isTyping;
  final VoidCallback onSend;
  final VoidCallback onAttach;
  final VoidCallback onEmoji;
  final VoidCallback onVoice;
  final Responsive responsive;

  const _InputBar({
    required this.controller,
    required this.focusNode,
    required this.isTyping,
    required this.onSend,
    required this.onAttach,
    required this.onEmoji,
    required this.onVoice,
    required this.responsive,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppTheme.white,
      padding: EdgeInsets.fromLTRB(
          responsive.sp(8),
          responsive.sp(8),
          responsive.sp(8),
          responsive.sp(8) + MediaQuery.of(context).padding.bottom),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          // Attach
          IconButton(
            icon: Icon(Icons.add_circle_outline,
                color: AppTheme.greenPrimary, size: responsive.sp(26)),
            onPressed: onAttach,
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(),
          ),
          SizedBox(width: responsive.sp(6)),

          // Text field
          Expanded(
            child: Container(
              constraints: BoxConstraints(maxHeight: responsive.sp(120)),
              decoration: BoxDecoration(
                color: AppTheme.greySoft.withOpacity(0.5),
                borderRadius: BorderRadius.circular(responsive.sp(24)),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  // Emoji
                  Padding(
                    padding: EdgeInsets.only(
                        left: responsive.sp(8), bottom: responsive.sp(8)),
                    child: GestureDetector(
                      onTap: onEmoji,
                      child: Icon(Icons.emoji_emotions_outlined,
                          color: AppTheme.greyMedium, size: responsive.sp(22)),
                    ),
                  ),
                  SizedBox(width: responsive.sp(4)),
                  Expanded(
                    child: TextField(
                      controller: controller,
                      focusNode: focusNode,
                      maxLines: null,
                      keyboardType: TextInputType.multiline,
                      textCapitalization: TextCapitalization.sentences,
                      style: TextStyle(
                          fontSize: responsive.sp(14),
                          color: AppTheme.textPrimary),
                      decoration: InputDecoration(
                        hintText: 'Message...',
                        hintStyle: TextStyle(
                            fontSize: responsive.sp(14),
                            color: AppTheme.greyMedium),
                        border: InputBorder.none,
                        focusedBorder: InputBorder.none,
                        contentPadding: EdgeInsets.symmetric(
                            vertical: responsive.sp(10)),
                      ),
                    ),
                  ),
                  // Camera
                  Padding(
                    padding: EdgeInsets.only(
                        right: responsive.sp(8), bottom: responsive.sp(8)),
                    child: Icon(Icons.camera_alt_outlined,
                        color: AppTheme.greyMedium, size: responsive.sp(22)),
                  ),
                ],
              ),
            ),
          ),
          SizedBox(width: responsive.sp(6)),

          // Send / Voice
          AnimatedSwitcher(
            duration: const Duration(milliseconds: 200),
            child: isTyping
                ? GestureDetector(
                    key: const ValueKey('send'),
                    onTap: onSend,
                    child: Container(
                      width: responsive.sp(42),
                      height: responsive.sp(42),
                      decoration: const BoxDecoration(
                        color: AppTheme.greenPrimary,
                        shape: BoxShape.circle,
                      ),
                      child: Icon(Icons.send_rounded,
                          color: AppTheme.white, size: responsive.sp(20)),
                    ),
                  )
                : GestureDetector(
                    key: const ValueKey('voice'),
                    onTap: onVoice,
                    child: Container(
                      width: responsive.sp(42),
                      height: responsive.sp(42),
                      decoration: const BoxDecoration(
                        color: AppTheme.greenPrimary,
                        shape: BoxShape.circle,
                      ),
                      child: Icon(Icons.mic_none_rounded,
                          color: AppTheme.white, size: responsive.sp(22)),
                    ),
                  ),
          ),
        ],
      ),
    );
  }
}
