import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../theme/app_theme.dart';
import '../widgets/common_widgets.dart';

// ══════════════════════════════════════════════════════════════
// PROFILE SCREEN
// ══════════════════════════════════════════════════════════════
class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  bool _anonMode = false;

  final List<String> _interests = [
    'Travel', 'Music', 'Coffee', 'Books',
    'Tech', 'Movies', 'Fitness', 'Art',
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(gradient: AppTheme.darkGradient),
      child: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              _buildHeader(),
              _buildStats(),
              _buildAboutSection(),
              _buildInterestsSection(),
              _buildAnonToggle(),
              _buildSettings(),
              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Stack(
      children: [
        // Background gradient hero
        Container(
          height: 220,
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFF2A0808), AppTheme.primaryRed, AppTheme.primaryRed],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),

        // Decorative circles
        Positioned(
          top: -20, right: -20,
          child: Container(
            width: 120, height: 120,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.white.withValues(alpha: 0.07),
            ),
          ),
        ),
        Positioned(
          bottom: 20, left: -30,
          child: Container(
            width: 90, height: 90,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.white.withValues(alpha: 0.05),
            ),
          ),
        ),

        // Content
        Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'My Profile',
                    style: GoogleFonts.playfairDisplay(
                      fontSize: 22,
                      fontWeight: FontWeight.w700,
                      color: AppTheme.onPrimary,
                    ),
                  ),
                  GestureDetector(
                    onTap: () {},
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
                      decoration: BoxDecoration(
                        color: AppTheme.onPrimary.withValues(alpha: 0.2),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: AppTheme.onPrimary.withValues(alpha: 0.3),
                          width: 1,
                        ),
                      ),
                      child: Text(
                        '✏️ Edit Profile',
                        style: TextStyle(
                          color: AppTheme.onPrimary,
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              // Avatar
              Stack(
                children: [
                  Container(
                    width: 80,
                    height: 80,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: AppTheme.onPrimary.withValues(alpha: 0.15),
                      border: Border.all(color: AppTheme.onPrimary, width: 2.5),
                    ),
                    child: const Center(
                      child: Text('🧑‍💻', style: TextStyle(fontSize: 38)),
                    ),
                  ),
                  Positioned(
                    bottom: 0, right: 0,
                    child: Container(
                      width: 24, height: 24,
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        color: Color(0xFF10B981),
                      ),
                      child: const Center(
                        child: Text('✓', style: TextStyle(color: Colors.white, fontSize: 12)),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Text(
                'Rahul Kumar',
                style: TextStyle(
                  color: AppTheme.onPrimary,
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                '28 · Software Engineer · Madurai, TN',
                style: TextStyle(color: AppTheme.textSecondary, fontSize: 12),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildStats() {
    return const Padding(
      padding: EdgeInsets.fromLTRB(20, 20, 20, 0),
      child: Row(
        children: [
          _StatCard(value: '47', label: 'Likes Given'),
          SizedBox(width: 10),
          _StatCard(value: '12', label: 'Matches'),
          SizedBox(width: 10),
          _StatCard(value: '8', label: 'Chats'),
          SizedBox(width: 10),
          _StatCard(value: '94%', label: 'Match Rate'),
        ],
      ),
    );
  }

  Widget _buildAboutSection() {
    return const Padding(
      padding: EdgeInsets.fromLTRB(20, 20, 20, 0),
      child: GlassCard(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SectionHeader(title: 'About Me'),
            SizedBox(height: 12),
            Text(
              '"Software engineer by day, foodie by night. Looking for someone to explore new restaurants with 🍜 and maybe watch too many movies 🎬"',
              style: TextStyle(
                fontSize: 14,
                color: AppTheme.textSecondary,
                height: 1.6,
                fontStyle: FontStyle.italic,
              ),
            ),
            SizedBox(height: 14),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                _InfoChip(icon: '🎓', label: 'BE Computer Science'),
                _InfoChip(icon: '💼', label: 'Software Engineer'),
                _InfoChip(icon: '🌍', label: 'Speaks Tamil, English'),
                _InfoChip(icon: '🐾', label: 'Dog person'),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInterestsSection() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
      child: GlassCard(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SectionHeader(title: 'My Interests', action: 'Edit'),
            const SizedBox(height: 12),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: _interests.map((i) =>
                InterestChip(label: i, selected: true),
              ).toList(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAnonToggle() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
      child: GlassCard(
        child: Row(
          children: [
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                gradient: AppTheme.primaryGradient,
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Center(
                child: Text('👻', style: TextStyle(fontSize: 22)),
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Anonymous Mode',
                    style: TextStyle(
                      color: AppTheme.textPrimary,
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Text(
                    'Hide your identity while browsing',
                    style: TextStyle(fontSize: 12, color: AppTheme.textMuted),
                  ),
                ],
              ),
            ),
           Switch(
            value: _anonMode,
            onChanged: (v) => setState(() => _anonMode = v),
            activeThumbColor: AppTheme.primaryRed,
            activeTrackColor: AppTheme.primaryRed.withValues(alpha: 0.5),
            inactiveTrackColor: AppTheme.divider,
          ),
          ],
        ),
      ),
    );
  }

  Widget _buildSettings() {
    const settings = [
      _SettingItem(icon: '🔔', label: 'Notifications', sublabel: 'New matches & messages'),
      _SettingItem(icon: '🔒', label: 'Privacy & Safety', sublabel: 'Control your data'),
      _SettingItem(icon: '💎', label: 'Heart Park Premium', sublabel: 'Unlock unlimited likes', isHighlight: true),
      _SettingItem(icon: '📊', label: 'Profile Boost', sublabel: 'Be seen by more people'),
      _SettingItem(icon: '🆘', label: 'Help & Support', sublabel: 'FAQs and contact us'),
      _SettingItem(icon: '🚪', label: 'Sign Out', sublabel: '', isDanger: true),
    ];

    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
      child: GlassCard(
        padding: const EdgeInsets.all(0),
        child: Column(
          children: settings.asMap().entries.map((e) {
            final idx = e.key;
            final item = e.value;
            return Column(
              children: [
                _SettingRow(item: item),
                if (idx < settings.length - 1)
                  const Divider(
                    color: AppTheme.divider,
                    height: 0.5,
                    indent: 60,
                  ),
              ],
            );
          }).toList(),
        ),
      ),
    );
  }
}

// ── Sub-widgets ────────────────────────────────────────────────

class _StatCard extends StatelessWidget {
  final String value;
  final String label;

  const _StatCard({required this.value, required this.label});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 14),
        decoration: BoxDecoration(
          color: AppTheme.bgCard,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppTheme.divider),
        ),
        child: Column(
          children: [
            ShaderMask(
              shaderCallback: (bounds) =>
                  AppTheme.primaryGradient.createShader(bounds),
              child: Text(
                value,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w800,
                  color: Colors.white,
                ),
              ),
            ),
            const SizedBox(height: 3),
            Text(
              label,
              style: const TextStyle(
                fontSize: 9,
                color: AppTheme.textMuted,
                fontWeight: FontWeight.w500,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}

class _InfoChip extends StatelessWidget {
  final String icon;
  final String label;

  const _InfoChip({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: AppTheme.bgSurface,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppTheme.divider),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(icon, style: const TextStyle(fontSize: 12)),
          const SizedBox(width: 5),
          Text(
            label,
            style: const TextStyle(
              fontSize: 12,
              color: Colors.white70,
              fontWeight: FontWeight.w400,
            ),
          ),
        ],
      ),
    );
  }
}

class _SettingItem {
  final String icon;
  final String label;
  final String sublabel;
  final bool isHighlight;
  final bool isDanger;

  const _SettingItem({
    required this.icon,
    required this.label,
    required this.sublabel,
    this.isHighlight = false,
    this.isDanger = false,
  });
}

class _SettingRow extends StatelessWidget {
  final _SettingItem item;

  const _SettingRow({required this.item});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {},
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 13),
        child: Row(
          children: [
            Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                color: item.isHighlight
                    ? AppTheme.primaryRed.withValues(alpha: 0.2)
                    : AppTheme.bgSurface,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Center(
                child: Text(item.icon, style: const TextStyle(fontSize: 16)),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item.label,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: item.isDanger
                          ? const Color(0xFFEF4444)
                          : item.isHighlight
                          ? AppTheme.primaryRed
                          : AppTheme.textPrimary,
                    ),
                  ),
                  if (item.sublabel.isNotEmpty)
                    Text(
                      item.sublabel,
                      style: const TextStyle(
                        fontSize: 11, color: AppTheme.textMuted,
                      ),
                    ),
                ],
              ),
            ),
            if (!item.isDanger)
              const Icon(
                Icons.arrow_forward_ios,
                size: 13,
                color: AppTheme.textMuted,
              ),
          ],
        ),
      ),
    );
  }
}
