import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import '../theme/app_theme.dart';
import '../models/user_model.dart';
import '../widgets/common_widgets.dart';

// ══════════════════════════════════════════════════════════════
// CHAT LIST SCREEN
// ══════════════════════════════════════════════════════════════
class ChatListScreen extends StatelessWidget {
  const ChatListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final matches = mockProfiles.where((p) => p.aiMatchScore > 85).toList();

    return Container(
      decoration: const BoxDecoration(gradient: AppTheme.darkGradient),
      child: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 8),
              child: Row(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Messages',
                        style: GoogleFonts.playfairDisplay(
                          fontSize: 26,
                          fontWeight: FontWeight.w700,
                          color: AppTheme.textPrimary,
                        ),
                      ),
                      const Text(
                        '8 new matches this week 🎉',
                        style: TextStyle(fontSize: 12, color: AppTheme.textMuted),
                      ),
                    ],
                  ),
                  const Spacer(),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      gradient: AppTheme.primaryGradient,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: const Text(
                      '✉️ Compose',
                      style: TextStyle(color: AppTheme.onPrimary, fontSize: 12, fontWeight: FontWeight.w600),
                    ),
                  ),
                ],
              ),
            ),

            // Search bar
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
              child: Container(
                height: 44,
                decoration: BoxDecoration(
                  color: AppTheme.bgSurface,
                  borderRadius: BorderRadius.circular(22),
                  border: Border.all(color: AppTheme.divider),
                ),
                child: const Row(
                  children: [
                    SizedBox(width: 14),
                    Text('🔍', style: TextStyle(fontSize: 14)),
                    SizedBox(width: 8),
                    Text(
                      'Search conversations...',
                      style: TextStyle(fontSize: 13, color: AppTheme.textMuted),
                    ),
                  ],
                ),
              ),
            ),

            // New matches row
            const Padding(
              padding: EdgeInsets.fromLTRB(20, 12, 0, 8),
              child: SectionHeader(title: 'New Matches'),
            ),
            SizedBox(
              height: 95,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 20),
                itemCount: matches.length,
                separatorBuilder: (_, __) => const SizedBox(width: 14),
                itemBuilder: (ctx, i) => _MatchBubble(
                  profile: matches[i],
                  onTap: () => _openChat(ctx, matches[i]),
                ),
              ),
            ),

            // Conversations
            const Padding(
              padding: EdgeInsets.fromLTRB(20, 16, 20, 8),
              child: SectionHeader(title: 'Conversations'),
            ),

            // Chat list
            Expanded(
              child: ListView.builder(
                itemCount: mockProfiles.length,
                itemBuilder: (ctx, i) {
                  final profile = mockProfiles[i];
                  final msgs = mockChats[profile.id] ?? [];
                  final lastMsg = msgs.isNotEmpty ? msgs.last : null;
                  return _ChatTile(
                    profile: profile,
                    lastMessage: lastMsg?.text ?? 'Say hi! 👋',
                    time: lastMsg != null
                        ? DateFormat('h:mm a').format(lastMsg.time)
                        : '',
                    unreadCount: i == 0 ? 3 : (i == 2 ? 1 : 0),
                    onTap: () => _openChat(ctx, profile),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _openChat(BuildContext context, UserModel profile) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => ChatScreen(profile: profile)),
    );
  }
}

// ── Match Bubble ───────────────────────────────────────────────
class _MatchBubble extends StatelessWidget {
  final UserModel profile;
  final VoidCallback onTap;

  static const Map<String, String> _avatarMap = {
    '1': '👩‍🎨', '2': '👩‍💻', '3': '🎸', '4': '👩‍⚕️', '5': '🏛️',
  };

  static const List<Color> _borderColors = [
    AppTheme.primaryRed,
    AppTheme.primaryRed,
    Color(0xFF10B981),
    Color(0xFF888888),
    AppTheme.primaryRed,
  ];

  const _MatchBubble({required this.profile, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final idx = int.parse(profile.id) - 1;
    final borderColor = _borderColors[idx % _borderColors.length];
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Stack(
            children: [
              Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: LinearGradient(
                    colors: [
                      borderColor.withValues(alpha: 0.3),  // ✅ fixed
                      borderColor.withValues(alpha: 0.1),  // ✅ fixed
                    ],
                  ),
                  border: Border.all(
                    color: borderColor,
                    width: 2.5,
                  ),
                ),
                child: Center(
                  child: Text(
                    _avatarMap[profile.id] ?? '😊',
                    style: const TextStyle(fontSize: 26),
                  ),
                ),
              ),
              if (profile.isOnline)
                const Positioned(           // ✅ const added
                  bottom: 2,
                  right: 2,
                  child: OnlineIndicator(isOnline: true),
                ),
            ],
          ),
          const SizedBox(height: 5),
          Text(
            profile.name.length > 7
                ? profile.name.substring(0, 7)
                : profile.name,
            style: const TextStyle(
              fontSize: 11,
              color: AppTheme.textMuted,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}

// ── Chat Tile ──────────────────────────────────────────────────
class _ChatTile extends StatelessWidget {
  final UserModel profile;
  final String lastMessage;
  final String time;
  final int unreadCount;
  final VoidCallback onTap;

  static const Map<String, String> _avatarMap = {
    '1': '👩‍🎨', '2': '👩‍💻', '3': '🎸', '4': '👩‍⚕️', '5': '🏛️',
  };

  const _ChatTile({
    required this.profile,
    required this.lastMessage,
    required this.time,
    required this.unreadCount,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        child: Row(
          children: [
            // Avatar
            Stack(
              children: [
                Container(
                  width: 54,
                  height: 54,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: AppTheme.bgSurface,
                    border: Border.all(color: AppTheme.divider),
                  ),
                  child: Center(
                    child: profile.isAnonymous
                        ? const Text('👤', style: TextStyle(fontSize: 24))
                        : Text(
                            _avatarMap[profile.id] ?? '😊',
                            style: const TextStyle(fontSize: 26),
                          ),
                  ),
                ),
                if (profile.isOnline)
                  const Positioned(           // ✅ const added
                    bottom: 2, right: 2,
                    child: OnlineIndicator(isOnline: true),
                  ),
              ],
            ),
            const SizedBox(width: 14),

            // Details
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        profile.isAnonymous ? 'Anonymous' : profile.name,
                        style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                          color: AppTheme.textPrimary,
                        ),
                      ),
                      const SizedBox(width: 6),
                      AIMatchBadge(score: profile.aiMatchScore),
                      const Spacer(),
                      Text(
                        time,
                        style: const TextStyle(
                          fontSize: 11,
                          color: AppTheme.textMuted,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          profile.isAnonymous
                              ? '👻 Identity hidden'
                              : lastMessage,
                          style: TextStyle(
                            fontSize: 13,
                            color: unreadCount > 0
                                ? AppTheme.textSecondary
                                : AppTheme.textMuted,
                            fontWeight: unreadCount > 0
                                ? FontWeight.w500
                                : FontWeight.w400,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      if (unreadCount > 0) ...[
                        const SizedBox(width: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 7, vertical: 2,
                          ),
                          decoration: BoxDecoration(
                            gradient: AppTheme.primaryGradient,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Text(
                            '$unreadCount',
                            style: const TextStyle(
                              color: AppTheme.textPrimary,
                              fontSize: 11,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                      ],
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

// ══════════════════════════════════════════════════════════════
// CHAT SCREEN (Individual)
// ══════════════════════════════════════════════════════════════
class ChatScreen extends StatefulWidget {
  final UserModel profile;

  const ChatScreen({super.key, required this.profile});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _msgCtrl = TextEditingController();
  final ScrollController _scrollCtrl = ScrollController();
  late List<ChatMessage> _messages;
  bool _isTyping = false;

  static const Map<String, String> _avatarMap = {
    '1': '👩‍🎨', '2': '👩‍💻', '3': '🎸', '4': '👩‍⚕️', '5': '🏛️',
  };

  static const List<String> _autoReplies = [
    'Haha that\'s so true! 😂',
    'Tell me more! 👀',
    'We should meet up sometime ☕',
    'Omg same! 🙌',
    'That\'s such a vibe 💜',
    'You seem really interesting!',
    'I love that about you 😊',
  ];

  @override
  void initState() {
    super.initState();
    _messages = List.from(mockChats[widget.profile.id] ?? []);
    WidgetsBinding.instance.addPostFrameCallback((_) => _scrollToBottom());
  }

  void _scrollToBottom() {
    if (_scrollCtrl.hasClients) {
      _scrollCtrl.animateTo(
        _scrollCtrl.position.maxScrollExtent,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    }
  }

  void _sendMessage() async {
    final text = _msgCtrl.text.trim();
    if (text.isEmpty) return;

    setState(() {
      _messages.add(ChatMessage(
        id: DateTime.now().toString(),
        senderId: 'me',
        text: text,
        time: DateTime.now(),
      ));
      _isTyping = true;
    });
    _msgCtrl.clear();
    WidgetsBinding.instance.addPostFrameCallback((_) => _scrollToBottom());

    // Auto reply
    await Future.delayed(const Duration(milliseconds: 1500));
    if (mounted) {
      setState(() {
        _isTyping = false;
        _messages.add(ChatMessage(
          id: DateTime.now().toString(),
          senderId: widget.profile.id,
          text: _autoReplies[DateTime.now().millisecond % _autoReplies.length],
          time: DateTime.now(),
        ));
      });
      WidgetsBinding.instance.addPostFrameCallback((_) => _scrollToBottom());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.bgDark,
      appBar: _buildAppBar(),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              controller: _scrollCtrl,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              itemCount: _messages.length + (_isTyping ? 1 : 0),
              itemBuilder: (_, i) {
                if (_isTyping && i == _messages.length) {
                  return _TypingIndicator();
                }
                final msg = _messages[i];
                final isMe = msg.senderId == 'me';
                return _MessageBubble(message: msg, isMe: isMe);
              },
            ),
          ),
          _buildInputBar(),
        ],
      ),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      backgroundColor: AppTheme.bgCard,
      leading: GestureDetector(
        onTap: () => Navigator.pop(context),
        child: const Icon(Icons.arrow_back_ios, color: AppTheme.textPrimary, size: 20),
      ),
      title: Row(
        children: [
          Container(
            width: 38,
            height: 38,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: AppTheme.bgSurface,
              border: Border.all(color: AppTheme.divider),
            ),
            child: Center(
              child: Text(
                widget.profile.isAnonymous
                    ? '👻'
                    : (_avatarMap[widget.profile.id] ?? '😊'),
                style: const TextStyle(fontSize: 18),
              ),
            ),
          ),
          const SizedBox(width: 10),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                widget.profile.isAnonymous ? 'Anonymous' : widget.profile.name,
                style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
              ),
              Row(
                children: [
                  OnlineIndicator(isOnline: widget.profile.isOnline, size: 8),
                  const SizedBox(width: 4),
                  Text(
                    widget.profile.isOnline ? 'Online now' : 'Last seen recently',
                    style: TextStyle(
                      fontSize: 11,
                      color: widget.profile.isOnline
                          ? const Color(0xFF10B981)
                          : AppTheme.textMuted,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
      actions: [
        GestureDetector(
          onTap: () {},
          child: Container(
            margin: const EdgeInsets.only(right: 8),
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              gradient: AppTheme.primaryGradient,
              borderRadius: BorderRadius.circular(20),
            ),
            child: const Text(
              '📹 Video',
              style: TextStyle(
                color: AppTheme.onPrimary,
                fontSize: 12,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildInputBar() {
    return Container(
      padding: EdgeInsets.fromLTRB(
        16, 10, 16,
        MediaQuery.of(context).viewInsets.bottom + 16,
      ),
      decoration: const BoxDecoration(
        color: AppTheme.bgCard,
        border: Border(top: BorderSide(color: AppTheme.divider, width: 0.5)),
      ),
      child: Row(
        children: [
          GestureDetector(
            onTap: () {},
            child: const Text('😊', style: TextStyle(fontSize: 22)),
          ),
          const SizedBox(width: 10),

          Expanded(
            child: Container(
              constraints: const BoxConstraints(minHeight: 40, maxHeight: 100),
              decoration: BoxDecoration(
                color: AppTheme.bgSurface,
                borderRadius: BorderRadius.circular(22),
                border: Border.all(color: AppTheme.divider),
              ),
              child: TextField(
                controller: _msgCtrl,
                style: const TextStyle(color: AppTheme.textPrimary, fontSize: 14),
                maxLines: null,
                decoration: const InputDecoration(
                  hintText: 'Type a message...',
                  hintStyle: TextStyle(color: AppTheme.textMuted, fontSize: 14),
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                ),
                onSubmitted: (_) => _sendMessage(),
              ),
            ),
          ),
          const SizedBox(width: 10),

          // Send button
          GestureDetector(
            onTap: _sendMessage,
            child: Container(
              width: 42,
              height: 42,
              decoration: BoxDecoration(
                gradient: AppTheme.primaryGradient,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: AppTheme.primaryRed.withValues(alpha: 0.4),  // ✅ fixed
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: const Center(
                child: Text('➤', style: TextStyle(color: AppTheme.onPrimary, fontSize: 16)),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ── Message Bubble ─────────────────────────────────────────────
class _MessageBubble extends StatelessWidget {
  final ChatMessage message;
  final bool isMe;

  const _MessageBubble({required this.message, required this.isMe});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        mainAxisAlignment:
            isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Container(
            constraints: BoxConstraints(
              maxWidth: MediaQuery.of(context).size.width * 0.72,
            ),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            decoration: BoxDecoration(
              gradient: isMe ? AppTheme.primaryGradient : null,
              color: isMe ? null : AppTheme.bgSurface,
              borderRadius: BorderRadius.only(
                topLeft: const Radius.circular(18),
                topRight: const Radius.circular(18),
                bottomLeft: Radius.circular(isMe ? 18 : 4),
                bottomRight: Radius.circular(isMe ? 4 : 18),
              ),
              border: isMe
                  ? null
                  : Border.all(color: AppTheme.divider, width: 0.5),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  message.text,
                  style: TextStyle(
                    color: isMe
                        ? AppTheme.onPrimary  // Dark text on gradient
                        : AppTheme.textPrimary,  // Dark text on light bg
                    fontSize: 14,
                    height: 1.4,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  DateFormat('h:mm a').format(message.time),
                  style: TextStyle(
                    fontSize: 10,
                    color: isMe
                        ? AppTheme.textSecondary  // Muted on gradient
                        : AppTheme.textMuted,
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

// ── Typing Indicator ───────────────────────────────────────────
class _TypingIndicator extends StatefulWidget {
  @override
  State<_TypingIndicator> createState() => _TypingIndicatorState();
}

class _TypingIndicatorState extends State<_TypingIndicator>
    with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: AppTheme.bgSurface,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(18),
                topRight: Radius.circular(18),
                bottomRight: Radius.circular(18),
                bottomLeft: Radius.circular(4),
              ),
              border: Border.all(color: AppTheme.divider, width: 0.5),
            ),
            child: Row(
              children: List.generate(3, (i) {
                return AnimatedBuilder(
                  animation: _ctrl,
                  builder: (_, __) => Container(
                    margin: const EdgeInsets.symmetric(horizontal: 3),
                    width: 7,
                    height: 7,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: AppTheme.primaryRed.withValues(  // ✅ fixed
                        alpha: 0.4 + (_ctrl.value * 0.6 * (i == 1 ? 1 : 0.7)),
                      ),
                    ),
                  ),
                );
              }),
            ),
          ),
        ],
      ),
    );
  }
}