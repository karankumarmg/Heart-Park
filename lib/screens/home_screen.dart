import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../theme/app_theme.dart';
import '../models/user_model.dart';
import '../widgets/common_widgets.dart';
import 'chat_list_screen.dart';
import 'profile_screen.dart';

// ══════════════════════════════════════════════════════════════
// HOME SCREEN (Main Container with Bottom Nav)
// ══════════════════════════════════════════════════════════════
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentTab = 0;

  final List<Widget> _tabs = const [
    DiscoverScreen(),
    ChatListScreen(),
    ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(index: _currentTab, children: _tabs),
      bottomNavigationBar: _BottomNav(
        currentIndex: _currentTab,
        onTap: (i) => setState(() => _currentTab = i),
      ),
    );
  }
}

// ── Bottom Navigation ──────────────────────────────────────────
class _BottomNav extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onTap;

  const _BottomNav({required this.currentIndex, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: AppTheme.bgCard,
        border: Border(
          top: BorderSide(color: AppTheme.divider, width: 0.5),
        ),
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _NavItem(icon: '🔍', label: 'Discover', index: 0, current: currentIndex, onTap: onTap),
              _NavItem(icon: '💬', label: 'Chats', index: 1, current: currentIndex, onTap: onTap),
              _NavItem(icon: '👤', label: 'Profile', index: 2, current: currentIndex, onTap: onTap),
            ],
          ),
        ),
      ),
    );
  }
}

class _NavItem extends StatelessWidget {
  final String icon;
  final String label;
  final int index;
  final int current;
  final ValueChanged<int> onTap;

  const _NavItem({
    required this.icon,
    required this.label,
    required this.index,
    required this.current,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final bool isActive = index == current;
    return GestureDetector(
      onTap: () => onTap(index),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
        decoration: BoxDecoration(
          gradient: isActive ? AppTheme.primaryGradient : null,
          borderRadius: BorderRadius.circular(24),
        ),
        child: Row(
          children: [
            Text(icon, style: const TextStyle(fontSize: 18)),
            if (isActive) ...[
              const SizedBox(width: 6),
              Text(
                label,
                style: const TextStyle(
                  color: AppTheme.onPrimary,
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

// ══════════════════════════════════════════════════════════════
// DISCOVER SCREEN
// ══════════════════════════════════════════════════════════════
class DiscoverScreen extends StatefulWidget {
  const DiscoverScreen({super.key});

  @override
  State<DiscoverScreen> createState() => _DiscoverScreenState();
}

class _DiscoverScreenState extends State<DiscoverScreen>
    with SingleTickerProviderStateMixin {
  int _currentIndex = 0;
  late AnimationController _swipeCtrl;
  late Animation<Offset> _slideAnim;
  late Animation<double> _rotateAnim;
  String? _swipeDirection;

  @override
  void initState() {
    super.initState();
    _swipeCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 350),
    );
    _slideAnim = Tween<Offset>(
      begin: Offset.zero,
      end: const Offset(1.5, 0),
    ).animate(CurvedAnimation(parent: _swipeCtrl, curve: Curves.easeOut));
    _rotateAnim = Tween<double>(begin: 0, end: 0.3).animate(
      CurvedAnimation(parent: _swipeCtrl, curve: Curves.easeOut),
    );
  }

  @override
  void dispose() {
    _swipeCtrl.dispose();
    super.dispose();
  }

  void _swipe(bool liked) async {
    setState(() => _swipeDirection = liked ? 'right' : 'left');
    _slideAnim = Tween<Offset>(
      begin: Offset.zero,
      end: Offset(liked ? 1.8 : -1.8, -0.2),
    ).animate(CurvedAnimation(parent: _swipeCtrl, curve: Curves.easeOut));
    _rotateAnim = Tween<double>(
      begin: 0,
      end: liked ? 0.3 : -0.3,
    ).animate(CurvedAnimation(parent: _swipeCtrl, curve: Curves.easeOut));

    await _swipeCtrl.forward();
    setState(() {
      _currentIndex = (_currentIndex + 1) % mockProfiles.length;
      _swipeDirection = null;
    });
    _swipeCtrl.reset();
  }

  @override
  Widget build(BuildContext context) {
    final profile = mockProfiles[_currentIndex];
    final nextProfile = mockProfiles[(_currentIndex + 1) % mockProfiles.length];

    return Container(
      decoration: const BoxDecoration(gradient: AppTheme.darkGradient),
      child: SafeArea(
        child: Column(
          children: [
            // Top bar
            _buildTopBar(),
            const SizedBox(height: 8),

            // Card stack
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    // Back card
                    _ProfileCard(
                      profile: nextProfile,
                      scale: 0.93,
                      translateY: 16,
                    ),
                    // Front card
                    AnimatedBuilder(
                      animation: _swipeCtrl,
                      builder: (_, child) => SlideTransition(
                        position: _slideAnim,
                        child: RotationTransition(
                          turns: _rotateAnim,
                          child: child,
                        ),
                      ),
                      child: _ProfileCard(
                        profile: profile,
                        showLikeOverlay: _swipeDirection == 'right',
                        showNopeOverlay: _swipeDirection == 'left',
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Action buttons
            _buildActionRow(profile),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  Widget _buildTopBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      child: Row(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'HEART PARK',
                style: GoogleFonts.playfairDisplay(
                  fontSize: 22,
                  fontWeight: FontWeight.w700,
                  color: AppTheme.onPrimary,
                  letterSpacing: 1,
                ),
              ),
              const Text(
                'Chennai, Tamil Nadu',
                style: TextStyle(fontSize: 12, color: AppTheme.textMuted),
              ),
            ],
          ),
          const Spacer(),
          _IconButton(
            icon: '🔔',
            onTap: () {},
          ),
          const SizedBox(width: 8),
          _IconButton(
            icon: '⚙️',
            onTap: () {},
          ),
        ],
      ),
    );
  }

  Widget _buildActionRow(UserModel profile) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Skip
          _ActionButton(
            emoji: '✕',
            size: 56,
            color: const Color(0xFFEF4444),
            onTap: () => _swipe(false),
          ),
          const SizedBox(width: 16),
          // Super like
          _ActionButton(
            emoji: '⭐',
            size: 50,
            color: const Color(0xFFF59E0B),
            onTap: () {},
          ),
          const SizedBox(width: 16),
          // Like
          _ActionButton(
            emoji: '♥',
            size: 64,
            isGradient: true,
            onTap: () => _swipe(true),
          ),
          const SizedBox(width: 16),
          // Boost
          _ActionButton(
            emoji: '⚡',
            size: 50,
            color: AppTheme.primaryRed,
            onTap: () {},
          ),
        ],
      ),
    );
  }
}

// ── Profile Card ───────────────────────────────────────────────
class _ProfileCard extends StatelessWidget {
  final UserModel profile;
  final double scale;
  final double translateY;
  final bool showLikeOverlay;
  final bool showNopeOverlay;

  const _ProfileCard({
    required this.profile,
    this.scale = 1.0,
    this.translateY = 0,
    this.showLikeOverlay = false,
    this.showNopeOverlay = false,
  });

  // Profile emoji avatar (simulating photo)
  static const Map<String, String> _avatarMap = {
    '1': '👩‍🎨',
    '2': '👩‍💻',
    '3': '🎸',
    '4': '👩‍⚕️',
    '5': '🏛️',
  };

  static const List<List<Color>> _cardColors = [
    [Color(0xFF1A0505), AppTheme.primaryRed],
    [Color(0xFF1A0A0A), Color(0xFFC0392B)],
    [Color(0xFF4A0A0A), Color(0xFFC0392B)],
    [Color(0xFF1A1010), Color(0xFF888888)],
    [Color(0xFF2A0808), Color(0xFFC0392B)],
  ];

  @override
  Widget build(BuildContext context) {
    final colorIdx = int.parse(profile.id) - 1;
    final colors = _cardColors[colorIdx % _cardColors.length];

    return Transform.translate(
      offset: Offset(0, translateY),
      child: Transform.scale(
        scale: scale,
        child: Container(
          width: double.infinity,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: colors,
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(28),
            boxShadow: [
              BoxShadow(
                color: colors[1].withValues(alpha: 0.4),
                blurRadius: 25,
                offset: const Offset(0, 12),
              ),
            ],
          ),
          child: Stack(
            children: [
              // Background decoration
              Positioned(
                top: -30,
                right: -30,
                child: Container(
                  width: 160,
                  height: 160,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white.withValues(alpha: 0.05),
                  ),
                ),
              ),
              Positioned(
                bottom: 80,
                left: -40,
                child: Container(
                  width: 120,
                  height: 120,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white.withValues(alpha: 0.04),
                  ),
                ),
              ),

              // Content
              Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Top row: anon badge + AI score
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        if (profile.isAnonymous) const AnonBadge()
                        else const SizedBox.shrink(),
                        AIMatchBadge(score: profile.aiMatchScore),
                      ],
                    ),

                    // Avatar
                    Expanded(
                      child: Center(
                        child: Container(
                          width: 140,
                          height: 140,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.white.withValues(alpha: 0.15),
                            border: Border.all(
                              color: Colors.white.withValues(alpha: 0.3),
                              width: 2,
                            ),
                          ),
                          child: Center(
                            child: profile.isAnonymous
                                ? const ImageFiltered(
                                    imageFilter: ColorFilter.mode(
                                      Colors.black26,
                                      BlendMode.darken,
                                    ),
                                    child: Text(
                                      '👤',
                                      style: TextStyle(fontSize: 60),
                                    ),
                                  )
                                : Text(
                                    _avatarMap[profile.id] ?? '😊',
                                    style: const TextStyle(fontSize: 70),
                                  ),
                          ),
                        ),
                      ),
                    ),

                    // Name, age, location
                    Row(
                      children: [
                        Text(
                          profile.isAnonymous ? 'Mystery' : profile.name,
                          style: GoogleFonts.playfairDisplay(
                            fontSize: 28,
                            fontWeight: FontWeight.w700,
                            color: AppTheme.onPrimary,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          profile.isAnonymous ? '??' : '${profile.age}',
                          style: const TextStyle(
                            fontSize: 22,
                            color: AppTheme.textSecondary,
                            fontWeight: FontWeight.w300,
                          ),
                        ),
                        const Spacer(),
                        OnlineIndicator(isOnline: profile.isOnline),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        const Text('📍', style: TextStyle(fontSize: 12)),
                        const SizedBox(width: 4),
                        Text(
                          profile.isAnonymous ? 'Somewhere near you' : profile.location,
                          style: const TextStyle(
                            fontSize: 13,
                            color: AppTheme.textSecondary,
                          ),
                        ),
                        const SizedBox(width: 8),
                        const Text('·', style: TextStyle(color: AppTheme.textMuted)),
                        const SizedBox(width: 8),
                        Text(
                          profile.isAnonymous ? '---' : profile.profession,
                          style: const TextStyle(
                            fontSize: 13,
                            color: AppTheme.textSecondary,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),

                    // Bio
                    Text(
                      profile.isAnonymous
                          ? '"I prefer mystery over photos. Let\'s vibe first 💜"'
                          : profile.bio,
                      style: const TextStyle(
                        fontSize: 13,
                        color: AppTheme.textSecondary,
                        height: 1.5,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 12),

                    // Interest chips
                    Wrap(
                      spacing: 6,
                      runSpacing: 6,
                      children: profile.interests.take(4).map((i) =>
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: AppTheme.onPrimary.withValues(alpha: 0.15),
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(
                              color: AppTheme.onPrimary.withValues(alpha: 0.2),
                              width: 1,
                            ),
                          ),
                          child: Text(
                            i,
                            style: const TextStyle(
                              fontSize: 11,
                              color: AppTheme.onPrimary,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ).toList(),
                    ),
                  ],
                ),
              ),

              // Like overlay
              if (showLikeOverlay)
                Positioned.fill(
                  child: Container(
                    decoration: BoxDecoration(
                      color: const Color(0xFF10B981).withValues(alpha: 0.3),
                      borderRadius: BorderRadius.circular(28),
                    ),
                    child: const Center(
                      child: RotationTransition(
                        turns: AlwaysStoppedAnimation(-0.1),
                        child: Text(
                          'LIKE 💜',
                          style: TextStyle(
                            color: Color(0xFF10B981),
                            fontSize: 42,
                            fontWeight: FontWeight.w800,
                            letterSpacing: 3,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),

              // Nope overlay
              if (showNopeOverlay)
                Positioned.fill(
                  child: Container(
                    decoration: BoxDecoration(
                      color: const Color(0xFFEF4444).withValues(alpha: 0.3),
                      borderRadius: BorderRadius.circular(28),
                    ),
                    child: const Center(
                      child: RotationTransition(
                        turns: AlwaysStoppedAnimation(0.1),
                        child: Text(
                          'NOPE ✕',
                          style: TextStyle(
                            color: Color(0xFFEF4444),
                            fontSize: 42,
                            fontWeight: FontWeight.w800,
                            letterSpacing: 3,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

// ── Icon Button ────────────────────────────────────────────────
class _IconButton extends StatelessWidget {
  final String icon;
  final VoidCallback onTap;

  const _IconButton({required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color: AppTheme.bgCard,
          shape: BoxShape.circle,
          border: Border.all(color: AppTheme.divider),
        ),
        child: Center(
          child: Text(icon, style: const TextStyle(fontSize: 16)),
        ),
      ),
    );
  }
}

// ── Action Button ──────────────────────────────────────────────
class _ActionButton extends StatefulWidget {
  final String emoji;
  final double size;
  final Color? color;
  final bool isGradient;
  final VoidCallback onTap;

  const _ActionButton({
    required this.emoji,
    required this.size,
    this.color,
    this.isGradient = false,
    required this.onTap,
  });

  @override
  State<_ActionButton> createState() => _ActionButtonState();
}

class _ActionButtonState extends State<_ActionButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;
  late Animation<double> _scale;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 120),
    );
    _scale = Tween<double>(begin: 1.0, end: 0.88).animate(
      CurvedAnimation(parent: _ctrl, curve: Curves.easeOut),
    );
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => _ctrl.forward(),
      onTapUp: (_) async {
        await _ctrl.reverse();
        widget.onTap();
      },
      onTapCancel: () => _ctrl.reverse(),
      child: ScaleTransition(
        scale: _scale,
        child: Container(
          width: widget.size,
          height: widget.size,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: widget.isGradient ? AppTheme.primaryGradient : null,
            color: widget.isGradient ? null : AppTheme.bgCard,
            border: widget.isGradient
                ? null
                : Border.all(
                    color: widget.color?.withValues(alpha: 0.4) ?? AppTheme.divider,
                    width: 1.5,
                  ),
            boxShadow: [
              BoxShadow(
                color: (widget.isGradient
                    ? AppTheme.primaryRed
                    : (widget.color ?? AppTheme.divider))
                    .withValues(alpha: 0.35),
                blurRadius: widget.isGradient ? 20 : 10,
                offset: const Offset(0, 6),
              ),
            ],
          ),
          child: Center(
            child: Text(
              widget.emoji,
              style: TextStyle(
                fontSize: widget.size * 0.38,
                color: widget.isGradient ? null : widget.color,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
