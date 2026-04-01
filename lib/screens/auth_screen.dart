import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import '../theme/app_theme.dart';
import '../widgets/common_widgets.dart';
import 'home_screen.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});
  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabCtrl;

  @override
  void initState() {
    super.initState();
    _tabCtrl = TabController(length: 2, vsync: this);
    _tabCtrl.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    _tabCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(gradient: AppTheme.heroGradient),
        child: SafeArea(
          child: SingleChildScrollView(
            child: ConstrainedBox(
              constraints: BoxConstraints(
                minHeight: MediaQuery.of(context).size.height -
                    MediaQuery.of(context).padding.top,
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 28),
                child: Column(
                  children: [
                    const SizedBox(height: 36),
                    _buildLogo(),
                    const SizedBox(height: 36),
                    _buildTabBar(),
                    const SizedBox(height: 28),
                    AnimatedSwitcher(
                      duration: const Duration(milliseconds: 300),
                      child: _tabCtrl.index == 0
                          ? const _LoginForm()
                          : const _RegisterForm(),
                    ),
                    const SizedBox(height: 28),
                    _buildDivider(),
                    const SizedBox(height: 20),
                    _buildGoogleBtn(),
                    const SizedBox(height: 32),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLogo() {
    return Column(
      children: [
        Container(
          width: 80, height: 80,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            boxShadow: [BoxShadow(color: AppTheme.primaryRed.withOpacity(0.45), blurRadius: 28, spreadRadius: 4)],
          ),
          child: ClipOval(child: Image.asset('assets/images/logo.png', fit: BoxFit.cover)),
        ),
        const SizedBox(height: 14),
        Text('HEART PARK', style: GoogleFonts.playfairDisplay(fontSize: 26, fontWeight: FontWeight.w700, color: Colors.white, letterSpacing: 3)),
        const SizedBox(height: 4),
        const Text('Where love finds its way', style: TextStyle(fontSize: 12, color: AppTheme.textMuted, letterSpacing: 1.5)),
      ],
    );
  }

  Widget _buildTabBar() {
    return Container(
      height: 48,
      decoration: BoxDecoration(color: AppTheme.bgCard, borderRadius: BorderRadius.circular(30), border: Border.all(color: AppTheme.divider)),
      child: TabBar(
        controller: _tabCtrl,
        indicator: BoxDecoration(
          gradient: AppTheme.primaryGradient,
          borderRadius: BorderRadius.circular(28),
          boxShadow: [BoxShadow(color: AppTheme.primaryRed.withOpacity(0.4), blurRadius: 10, offset: const Offset(0, 3))],
        ),
        indicatorSize: TabBarIndicatorSize.tab,
        dividerColor: Colors.transparent,
        labelColor: Colors.white,
        unselectedLabelColor: AppTheme.textMuted,
        labelStyle: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
        tabs: const [Tab(text: 'Sign In'), Tab(text: 'Sign Up')],
      ),
    );
  }

  Widget _buildDivider() {
    return Row(children: [
      Expanded(child: Divider(color: AppTheme.divider, thickness: 0.8)),
      Padding(padding: const EdgeInsets.symmetric(horizontal: 14), child: Text('or continue with', style: TextStyle(fontSize: 12, color: AppTheme.textMuted))),
      Expanded(child: Divider(color: AppTheme.divider, thickness: 0.8)),
    ]);
  }

  Widget _buildGoogleBtn() {
    return GestureDetector(
      onTap: () {}, // TODO: Firebase Google Sign-In
      child: Container(
        height: 54,
        decoration: BoxDecoration(color: AppTheme.bgCard, borderRadius: BorderRadius.circular(50), border: Border.all(color: AppTheme.divider)),
        child: const Row(mainAxisAlignment: MainAxisAlignment.center, children: [
          Text('G', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700, color: Color(0xFFDB4437))),
          SizedBox(width: 10),
          Text('Continue with Google', style: TextStyle(color: Colors.white, fontSize: 15, fontWeight: FontWeight.w500)),
        ]),
      ),
    );
  }
}

// ── Login Form ─────────────────────────────────────────────────
class _LoginForm extends StatefulWidget {
  const _LoginForm();
  @override
  State<_LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<_LoginForm> {
  final _formKey = GlobalKey<FormState>();
  final _emailCtrl = TextEditingController();
  final _passCtrl = TextEditingController();
  bool _obscurePass = true;
  bool _isLoading = false;
  bool _rememberMe = false;

  @override
  void dispose() { _emailCtrl.dispose(); _passCtrl.dispose(); super.dispose(); }

  Future<void> _login() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _isLoading = true);
    await Future.delayed(const Duration(milliseconds: 1800));
    if (mounted) {
      setState(() => _isLoading = false);
      Navigator.pushReplacement(context, PageRouteBuilder(
        pageBuilder: (_, __, ___) => const HomeScreen(),
        transitionsBuilder: (_, anim, __, child) => FadeTransition(opacity: anim, child: child),
        transitionDuration: const Duration(milliseconds: 500),
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        _FieldLabel(label: 'Email Address'),
        const SizedBox(height: 8),
        _AuthTextField(controller: _emailCtrl, hint: 'you@example.com', prefixIcon: '✉️', keyboardType: TextInputType.emailAddress,
          validator: (v) { if (v == null || v.isEmpty) return 'Email required'; if (!v.contains('@')) return 'Enter valid email'; return null; }),
        const SizedBox(height: 18),
        _FieldLabel(label: 'Password'),
        const SizedBox(height: 8),
        _AuthTextField(controller: _passCtrl, hint: 'Enter your password', prefixIcon: '🔒', obscureText: _obscurePass,
          suffixIcon: GestureDetector(onTap: () => setState(() => _obscurePass = !_obscurePass),
            child: Icon(_obscurePass ? Icons.visibility_off : Icons.visibility, color: AppTheme.textMuted, size: 20)),
          validator: (v) { if (v == null || v.isEmpty) return 'Password required'; if (v.length < 6) return 'Minimum 6 characters'; return null; }),
        const SizedBox(height: 14),
        Row(children: [
          GestureDetector(
            onTap: () => setState(() => _rememberMe = !_rememberMe),
            child: Row(children: [
              AnimatedContainer(duration: const Duration(milliseconds: 200), width: 20, height: 20,
                decoration: BoxDecoration(gradient: _rememberMe ? AppTheme.primaryGradient : null, color: _rememberMe ? null : AppTheme.bgSurface,
                  borderRadius: BorderRadius.circular(5), border: Border.all(color: _rememberMe ? Colors.transparent : AppTheme.divider)),
                child: _rememberMe ? const Icon(Icons.check, size: 13, color: Colors.white) : null),
              const SizedBox(width: 8),
              const Text('Remember me', style: TextStyle(fontSize: 13, color: AppTheme.textMuted)),
            ]),
          ),
          const Spacer(),
          GestureDetector(
            onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const ForgotPasswordScreen())),
            child: const Text('Forgot Password?', style: TextStyle(fontSize: 13, color: AppTheme.primaryRed, fontWeight: FontWeight.w500))),
        ]),
        const SizedBox(height: 28),
        GradientButton(
          label: _isLoading ? 'Signing in...' : 'Sign In ❤️',
          onTap: _isLoading ? () {} : _login,
          icon: _isLoading ? const SizedBox(width: 18, height: 18, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2)) : null,
        ),
      ]),
    );
  }
}

// ── Register Form ──────────────────────────────────────────────
class _RegisterForm extends StatefulWidget {
  const _RegisterForm();
  @override
  State<_RegisterForm> createState() => _RegisterFormState();
}

class _RegisterFormState extends State<_RegisterForm> {
  final _formKey = GlobalKey<FormState>();
  final _nameCtrl = TextEditingController();
  final _emailCtrl = TextEditingController();
  final _passCtrl = TextEditingController();
  final _confirmCtrl = TextEditingController();
  bool _obscurePass = true, _obscureConfirm = true, _isLoading = false, _agreedToTerms = false;
  String _selectedGender = 'Male';
  DateTime? _dob;
  final List<String> _genders = ['Male', 'Female', 'Non-binary', 'Prefer not to say'];

  @override
  void dispose() { _nameCtrl.dispose(); _emailCtrl.dispose(); _passCtrl.dispose(); _confirmCtrl.dispose(); super.dispose(); }

  Future<void> _pickDOB() async {
    final picked = await showDatePicker(context: context,
      initialDate: DateTime(2000), firstDate: DateTime(1950),
      lastDate: DateTime.now().subtract(const Duration(days: 365 * 18)),
      builder: (ctx, child) => Theme(data: Theme.of(ctx).copyWith(colorScheme: const ColorScheme.dark(primary: AppTheme.primaryRed, surface: AppTheme.bgCard)), child: child!));
    if (picked != null) setState(() => _dob = picked);
  }

  Future<void> _register() async {
    if (!_formKey.currentState!.validate()) return;
    if (!_agreedToTerms) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Please agree to Terms & Conditions'), backgroundColor: AppTheme.primaryRed));
      return;
    }
    setState(() => _isLoading = true);
    await Future.delayed(const Duration(milliseconds: 2000));
    if (mounted) {
      setState(() => _isLoading = false);
      Navigator.pushReplacement(context, PageRouteBuilder(
        pageBuilder: (_, __, ___) => const HomeScreen(),
        transitionsBuilder: (_, anim, __, child) => FadeTransition(opacity: anim, child: child),
        transitionDuration: const Duration(milliseconds: 500),
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        _FieldLabel(label: 'Full Name'),
        const SizedBox(height: 8),
        _AuthTextField(controller: _nameCtrl, hint: 'Your name', prefixIcon: '👤',
          validator: (v) { if (v == null || v.trim().isEmpty) return 'Name required'; if (v.trim().length < 2) return 'Name too short'; return null; }),
        const SizedBox(height: 16),
        _FieldLabel(label: 'Email Address'),
        const SizedBox(height: 8),
        _AuthTextField(controller: _emailCtrl, hint: 'you@example.com', prefixIcon: '✉️', keyboardType: TextInputType.emailAddress,
          validator: (v) { if (v == null || v.isEmpty) return 'Email required'; if (!v.contains('@')) return 'Enter valid email'; return null; }),
        const SizedBox(height: 16),
        Row(children: [
          Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            _FieldLabel(label: 'Gender'),
            const SizedBox(height: 8),
            Container(height: 52, padding: const EdgeInsets.symmetric(horizontal: 14),
              decoration: BoxDecoration(color: AppTheme.bgSurface, borderRadius: BorderRadius.circular(14), border: Border.all(color: AppTheme.divider)),
              child: DropdownButtonHideUnderline(child: DropdownButton<String>(value: _selectedGender, dropdownColor: AppTheme.bgCard,
                style: const TextStyle(color: Colors.white, fontSize: 13),
                icon: const Icon(Icons.keyboard_arrow_down, color: AppTheme.textMuted, size: 18),
                items: _genders.map((g) => DropdownMenuItem(value: g, child: Text(g))).toList(),
                onChanged: (v) => setState(() => _selectedGender = v!)))),
          ])),
          const SizedBox(width: 12),
          Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            _FieldLabel(label: 'Date of Birth'),
            const SizedBox(height: 8),
            GestureDetector(onTap: _pickDOB,
              child: Container(height: 52, padding: const EdgeInsets.symmetric(horizontal: 14),
                decoration: BoxDecoration(color: AppTheme.bgSurface, borderRadius: BorderRadius.circular(14), border: Border.all(color: AppTheme.divider)),
                child: Row(children: [
                  const Text('🎂', style: TextStyle(fontSize: 16)),
                  const SizedBox(width: 8),
                  Text(_dob == null ? 'Pick date' : '${_dob!.day}/${_dob!.month}/${_dob!.year}',
                    style: TextStyle(fontSize: 12, color: _dob == null ? AppTheme.textMuted : Colors.white)),
                ]))),
          ])),
        ]),
        const SizedBox(height: 16),
        _FieldLabel(label: 'Password'),
        const SizedBox(height: 8),
        _AuthTextField(controller: _passCtrl, hint: 'Min. 6 characters', prefixIcon: '🔒', obscureText: _obscurePass,
          suffixIcon: GestureDetector(onTap: () => setState(() => _obscurePass = !_obscurePass),
            child: Icon(_obscurePass ? Icons.visibility_off : Icons.visibility, color: AppTheme.textMuted, size: 20)),
          validator: (v) { if (v == null || v.isEmpty) return 'Password required'; if (v.length < 6) return 'Minimum 6 characters'; return null; }),
        const SizedBox(height: 16),
        _FieldLabel(label: 'Confirm Password'),
        const SizedBox(height: 8),
        _AuthTextField(controller: _confirmCtrl, hint: 'Re-enter password', prefixIcon: '🔐', obscureText: _obscureConfirm,
          suffixIcon: GestureDetector(onTap: () => setState(() => _obscureConfirm = !_obscureConfirm),
            child: Icon(_obscureConfirm ? Icons.visibility_off : Icons.visibility, color: AppTheme.textMuted, size: 20)),
          validator: (v) { if (v == null || v.isEmpty) return 'Please confirm password'; if (v != _passCtrl.text) return 'Passwords do not match'; return null; }),
        const SizedBox(height: 18),
        _PassStrengthBar(password: _passCtrl.text),
        const SizedBox(height: 18),
        GestureDetector(
          onTap: () => setState(() => _agreedToTerms = !_agreedToTerms),
          child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
            AnimatedContainer(duration: const Duration(milliseconds: 200), width: 20, height: 20,
              decoration: BoxDecoration(gradient: _agreedToTerms ? AppTheme.primaryGradient : null, color: _agreedToTerms ? null : AppTheme.bgSurface,
                borderRadius: BorderRadius.circular(5), border: Border.all(color: _agreedToTerms ? Colors.transparent : AppTheme.divider)),
              child: _agreedToTerms ? const Icon(Icons.check, size: 13, color: Colors.white) : null),
            const SizedBox(width: 10),
            Expanded(child: RichText(text: const TextSpan(text: 'I agree to the ', style: TextStyle(fontSize: 12, color: AppTheme.textMuted),
              children: [
                TextSpan(text: 'Terms of Service', style: TextStyle(color: AppTheme.primaryRed, fontWeight: FontWeight.w500)),
                TextSpan(text: ' and '),
                TextSpan(text: 'Privacy Policy', style: TextStyle(color: AppTheme.primaryRed, fontWeight: FontWeight.w500)),
              ]))),
          ]),
        ),
        const SizedBox(height: 24),
        GradientButton(
          label: _isLoading ? 'Creating account...' : 'Create Account ❤️',
          onTap: _isLoading ? () {} : _register,
          icon: _isLoading ? const SizedBox(width: 18, height: 18, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2)) : null,
        ),
      ]),
    );
  }
}

// ── Forgot Password ────────────────────────────────────────────
class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});
  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final _emailCtrl = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false, _emailSent = false;

  Future<void> _sendReset() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _isLoading = true);
    await Future.delayed(const Duration(milliseconds: 1500));
    if (mounted) setState(() { _isLoading = false; _emailSent = true; });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(gradient: AppTheme.heroGradient),
        child: SafeArea(child: Padding(padding: const EdgeInsets.symmetric(horizontal: 28),
          child: Column(children: [
            const SizedBox(height: 16),
            Align(alignment: Alignment.centerLeft,
              child: GestureDetector(onTap: () => Navigator.pop(context),
                child: Container(width: 40, height: 40,
                  decoration: BoxDecoration(color: AppTheme.bgCard, shape: BoxShape.circle, border: Border.all(color: AppTheme.divider)),
                  child: const Icon(Icons.arrow_back_ios, color: Colors.white, size: 16)))),
            const SizedBox(height: 40),
            if (!_emailSent) ...[
              Container(width: 80, height: 80,
                decoration: BoxDecoration(color: AppTheme.primaryRed.withOpacity(0.15), shape: BoxShape.circle,
                  border: Border.all(color: AppTheme.primaryRed.withOpacity(0.4), width: 1.5)),
                child: const Center(child: Text('🔑', style: TextStyle(fontSize: 36)))),
              const SizedBox(height: 24),
              Text('Forgot Password?', style: GoogleFonts.playfairDisplay(fontSize: 26, fontWeight: FontWeight.w700, color: Colors.white)),
              const SizedBox(height: 10),
              const Text("Enter your email and we'll send a reset link.", textAlign: TextAlign.center,
                style: TextStyle(fontSize: 14, color: AppTheme.textMuted, height: 1.6)),
              const SizedBox(height: 36),
              Form(key: _formKey, child: Column(children: [
                _AuthTextField(controller: _emailCtrl, hint: 'your@email.com', prefixIcon: '✉️', keyboardType: TextInputType.emailAddress,
                  validator: (v) { if (v == null || v.isEmpty) return 'Email required'; if (!v.contains('@')) return 'Enter valid email'; return null; }),
                const SizedBox(height: 24),
                GradientButton(label: _isLoading ? 'Sending...' : 'Send Reset Link', onTap: _isLoading ? () {} : _sendReset,
                  icon: _isLoading ? const SizedBox(width: 18, height: 18, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2)) : null),
              ])),
            ] else ...[
              Container(width: 90, height: 90,
                decoration: BoxDecoration(color: const Color(0xFF10B981).withOpacity(0.15), shape: BoxShape.circle,
                  border: Border.all(color: const Color(0xFF10B981).withOpacity(0.5), width: 2)),
                child: const Center(child: Text('✅', style: TextStyle(fontSize: 40)))),
              const SizedBox(height: 24),
              Text('Email Sent!', style: GoogleFonts.playfairDisplay(fontSize: 26, fontWeight: FontWeight.w700, color: Colors.white)),
              const SizedBox(height: 12),
              Text('Reset link sent to\n${_emailCtrl.text}', textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 14, color: AppTheme.textMuted, height: 1.6)),
              const SizedBox(height: 36),
              GradientButton(label: 'Back to Sign In', onTap: () => Navigator.pop(context)),
              const SizedBox(height: 16),
              GestureDetector(onTap: () => setState(() => _emailSent = false),
                child: const Text('Resend email', style: TextStyle(color: AppTheme.primaryRed, fontSize: 14, fontWeight: FontWeight.w500))),
            ],
          ]),
        )),
      ),
    );
  }
}

// ── Shared Widgets ─────────────────────────────────────────────
class _FieldLabel extends StatelessWidget {
  final String label;
  const _FieldLabel({required this.label});
  @override
  Widget build(BuildContext context) => Text(label,
    style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w500, color: AppTheme.textMuted, letterSpacing: 0.3));
}

class _AuthTextField extends StatelessWidget {
  final TextEditingController controller;
  final String hint, prefixIcon;
  final bool obscureText;
  final Widget? suffixIcon;
  final TextInputType? keyboardType;
  final String? Function(String?)? validator;

  const _AuthTextField({required this.controller, required this.hint, required this.prefixIcon,
    this.obscureText = false, this.suffixIcon, this.keyboardType, this.validator});

  @override
  Widget build(BuildContext context) => TextFormField(
    controller: controller, obscureText: obscureText,
    keyboardType: keyboardType, validator: validator,
    style: const TextStyle(color: Colors.white, fontSize: 14),
    decoration: InputDecoration(hintText: hint,
      prefixIcon: Padding(padding: const EdgeInsets.all(14), child: Text(prefixIcon, style: const TextStyle(fontSize: 16))),
      suffixIcon: suffixIcon != null ? Padding(padding: const EdgeInsets.only(right: 12), child: suffixIcon) : null,
      errorStyle: const TextStyle(color: AppTheme.primaryRed, fontSize: 11)));
}

class _PassStrengthBar extends StatelessWidget {
  final String password;
  const _PassStrengthBar({required this.password});

  int get _strength {
    if (password.isEmpty) return 0;
    int s = 0;
    if (password.length >= 6) s++;
    if (password.length >= 10) s++;
    if (password.contains(RegExp(r'[A-Z]'))) s++;
    if (password.contains(RegExp(r'[0-9]'))) s++;
    if (password.contains(RegExp(r'[!@#$%^&*]'))) s++;
    return s;
  }

  Color get _color => _strength <= 1 ? const Color(0xFFEF4444) : _strength <= 2 ? const Color(0xFFF59E0B) : _strength <= 3 ? const Color(0xFF10B981) : const Color(0xFF059669);
  String get _label => _strength <= 1 ? 'Weak' : _strength <= 2 ? 'Fair' : _strength <= 3 ? 'Good' : 'Strong 💪';

  @override
  Widget build(BuildContext context) {
    if (password.isEmpty) return const SizedBox.shrink();
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
        const Text('Password strength', style: TextStyle(fontSize: 11, color: AppTheme.textMuted)),
        Text(_label, style: TextStyle(fontSize: 11, color: _color, fontWeight: FontWeight.w600)),
      ]),
      const SizedBox(height: 6),
      Row(children: List.generate(5, (i) => Expanded(
        child: AnimatedContainer(duration: const Duration(milliseconds: 300), height: 4,
          margin: EdgeInsets.only(right: i < 4 ? 4 : 0),
          decoration: BoxDecoration(color: i < _strength ? _color : AppTheme.divider, borderRadius: BorderRadius.circular(4)))))),
    ]);
  }
}