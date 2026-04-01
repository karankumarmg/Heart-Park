import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import '../theme/app_theme.dart';
import '../widgets/common_widgets.dart';
import 'auth_screen.dart';

// ══════════════════════════════════════════════════════════════
// SPLASH SCREEN
// ══════════════════════════════════════════════════════════════
class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;
  late Animation<double> _fadeAnim;
  late Animation<double> _scaleAnim;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1400),
    );
    _fadeAnim = CurvedAnimation(parent: _ctrl, curve: Curves.easeOut);
    _scaleAnim = Tween<double>(begin: 0.7, end: 1.0).animate(
      CurvedAnimation(parent: _ctrl, curve: Curves.elasticOut),
    );
    _ctrl.forward();

    Future.delayed(const Duration(milliseconds: 2800), () {
      if (mounted) {
        Navigator.pushReplacement(
          context,
          PageRouteBuilder(
            pageBuilder: (_, __, ___) => const OnboardingScreen(),
            transitionsBuilder: (_, anim, __, child) =>
                FadeTransition(opacity: anim, child: child),
            transitionDuration: const Duration(milliseconds: 600),
          ),
        );
      }
    });
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(gradient: AppTheme.heroGradient),
        child: Center(
          child: FadeTransition(
            opacity: _fadeAnim,
            child: ScaleTransition(
              scale: _scaleAnim,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Logo Icon
                  Container(
                    width: 140,
                    height: 140,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: AppTheme.primaryRed.withValues(alpha: 0.4),
                          blurRadius: 40,
                          spreadRadius: 8,
                        ),
                      ],
                    ),
                    child: ClipOval(
                      child: Image.asset(
                        'assets/images/logo.png',
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  // App Name
                  Text(
                    'HEART PARK',
                    style: GoogleFonts.playfairDisplay(
                      fontSize: 36,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                      letterSpacing: 4,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Where love finds its way',
                    style: GoogleFonts.dmSans(
                      fontSize: 14,
                      color: AppTheme.textMuted,
                      letterSpacing: 2,
                    ),
                  ),
                  const SizedBox(height: 48),
                  // Loading dots
                  SizedBox(
                    width: 60,
                    child: LinearProgressIndicator(
                      backgroundColor: AppTheme.divider,
                      color: AppTheme.primaryRed,
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// ══════════════════════════════════════════════════════════════
// ONBOARDING SCREEN
// ══════════════════════════════════════════════════════════════
class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageCtrl = PageController();
  int _currentPage = 0;

  // ✅ Removed const from list — colors like Color(0xFF...) are const,
  // but AppTheme.primaryPurple / hotPink must exist. We inline safe Color values.
  final List<_OnboardData> _pages = const [
    _OnboardData(
      emoji: '💜',
      title: 'Find Your\nPerfect Match',
      subtitle:
          'AI-powered matching that understands your personality, not just your photos.',
      color: Color(0xFF9B59B6), // purple — replace with AppTheme.primaryPurple if you add it
    ),
    _OnboardData(
      emoji: '👻',
      title: 'Anonymous\nMode',
      subtitle:
          'Explore profiles with full privacy. Reveal yourself only when you feel ready.',
      color: AppTheme.primaryRed,
    ),
    _OnboardData(
      emoji: '💬',
      title: 'Real Connections,\nReal Chats',
      subtitle:
          'Video calls, voice messages, and meaningful conversations — all in one place.',
      color: Color(0xFF7C3AED),
    ),
    _OnboardData(
      emoji: '🌟',
      title: 'Your Story\nStarts Here',
      subtitle:
          'Join 2M+ people who found love, friendship, and everything in between.',
      color: Color(0xFFFF1493), // hotPink — replace with AppTheme.hotPink if you add it
    ),
  ];

  void _next() {
    if (_currentPage < _pages.length - 1) {
      _pageCtrl.nextPage(
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeInOut,
      );
    } else {
      _goHome();
    }
  }

  void _goHome() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => const AuthScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(gradient: AppTheme.heroGradient),
        child: SafeArea(
          child: Column(
            children: [
              // Skip button
              Align(
                alignment: Alignment.topRight,
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: GestureDetector(
                    onTap: _goHome,
                    child: const Text(
                      'Skip',
                      style: TextStyle(
                        color: AppTheme.textMuted,
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),
              ),

              // Page content
              Expanded(
                child: PageView.builder(
                  controller: _pageCtrl,
                  onPageChanged: (i) => setState(() => _currentPage = i),
                  itemCount: _pages.length,
                  itemBuilder: (_, i) => _OnboardPage(data: _pages[i]),
                ),
              ),

              // Bottom section
              Padding(
                padding: const EdgeInsets.fromLTRB(28, 0, 28, 32),
                child: Column(
                  children: [
                    // Indicator
                    AnimatedSmoothIndicator(
                      activeIndex: _currentPage,
                      count: _pages.length,
                      effect: const ExpandingDotsEffect(
                        activeDotColor: AppTheme.primaryRed,
                        dotColor: AppTheme.divider,
                        dotHeight: 8,
                        dotWidth: 8,
                        expansionFactor: 3,
                      ),
                    ),
                    const SizedBox(height: 32),

                    // CTA Button
                    GradientButton(
                      label: _currentPage == _pages.length - 1
                          ? 'Start My Journey 💜'
                          : 'Continue',
                      onTap: _next,
                    ),
                    const SizedBox(height: 16),

                    // Sign in link
                    if (_currentPage == _pages.length - 1)
                      GestureDetector(
                        onTap: _goHome,
                        child: RichText(
                          text: const TextSpan(
                            text: 'Already have an account? ',
                            style: TextStyle(
                              color: AppTheme.textMuted,
                              fontSize: 13,
                            ),
                            children: [
                              TextSpan(
                                text: 'Sign In',
                                style: TextStyle(
                                  color: AppTheme.primaryRed,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _OnboardPage extends StatelessWidget {
  final _OnboardData data;

  const _OnboardPage({required this.data});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 32),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Illustration
          Container(
            width: 180,
            height: 180,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: RadialGradient(
                colors: [
                  AppTheme.primaryRed.withValues(alpha: 0.25),
                  AppTheme.primaryRed.withValues(alpha: 0.05),
                ],
              ),
            ),
            child: const Center(
              child: Text(
                // data.emoji can't be const here since data is a parameter
                // so we keep it non-const at the Text level
                '',
                style: TextStyle(fontSize: 80),
              ),
            ),
          ),
          const SizedBox(height: 40),

          Text(
            data.title,
            textAlign: TextAlign.center,
            style: GoogleFonts.playfairDisplay(
              fontSize: 32,
              fontWeight: FontWeight.w700,
              color: Colors.white,
              height: 1.2,
            ),
          ),
          const SizedBox(height: 16),

          Text(
            data.subtitle,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 15,
              color: AppTheme.textMuted,
              height: 1.6,
            ),
          ),
        ],
      ),
    );
  }
}

class _OnboardData {
  final String emoji;
  final String title;
  final String subtitle;
  final Color color;

  const _OnboardData({
    required this.emoji,
    required this.title,
    required this.subtitle,
    required this.color,
  });
}