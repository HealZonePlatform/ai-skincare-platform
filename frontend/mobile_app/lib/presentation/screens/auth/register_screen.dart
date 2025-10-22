import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import 'package:ai_skincare_platform/core/constants/app_assets.dart';
import 'package:ai_skincare_platform/core/validation/input_validators.dart';
import 'package:ai_skincare_platform/l10n/app_localizations.dart';
import 'package:ai_skincare_platform/presentation/providers/auth_provider.dart';
import 'package:ai_skincare_platform/presentation/widgets/brand_logo.dart';
import 'package:ai_skincare_platform/presentation/widgets/hz_buttons.dart';
import 'package:ai_skincare_platform/theme/app_theme.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  bool _passwordObscured = true;
  bool _confirmObscured = true;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    final auth = context.read<AuthProvider>();
    final payload = {
      'email': _emailController.text.trim(),
      'password': _passwordController.text.trim(),
    };

    final success = await auth.register(payload);
    if (success && mounted) {
      context.push('/survey/skin-type');
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);

    return Scaffold(
      body: Stack(
        children: [
          const _RegisterBackground(),
          Positioned.fill(
            child: IgnorePointer(
              child: Image.asset(
                AppAssets.onboardingIllustration,
                fit: BoxFit.cover,
                color: Colors.black.withOpacityFraction(0.08),
                colorBlendMode: BlendMode.darken,
                errorBuilder: (_, __, ___) => const SizedBox.shrink(),
              ),
            ),
          ),
          SafeArea(
            child: Align(
              alignment: Alignment.bottomCenter,
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xl, vertical: AppSpacing.xl),
                child: _GlassCard(
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Text(
                          l10n.translate('signUpCta'),
                          style: theme.textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.w600),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: AppSpacing.s),
                        Text(
                          'Trả lời vài câu hỏi và HealZone sẽ cá nhân hóa chu trình chăm sóc da cho bạn.',
                          style: theme.textTheme.bodyMedium?.copyWith(color: AppColors.textSecondary),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: AppSpacing.xl),
                        const Align(child: BrandLogo(size: 72)),
                        const SizedBox(height: AppSpacing.l),
                        HzSecondaryButton(
                          label: 'Đăng ký bằng Google',
                          icon: Icons.g_mobiledata_outlined,
                          onPressed: () {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('OAuth sign-up đang được triển khai.')),
                            );
                          },
                        ),
                        const SizedBox(height: AppSpacing.l),
                        const Divider(),
                        const SizedBox(height: AppSpacing.l),
                        TextFormField(
                          controller: _emailController,
                          keyboardType: TextInputType.emailAddress,
                          decoration: InputDecoration(
                            labelText: l10n.translate('emailLabel'),
                            prefixIcon: const Icon(Icons.mail_outlined),
                          ),
                          validator: InputValidators.email,
                        ),
                        const SizedBox(height: AppSpacing.m),
                        TextFormField(
                          controller: _passwordController,
                          obscureText: _passwordObscured,
                          decoration: InputDecoration(
                            labelText: l10n.translate('passwordLabel'),
                            prefixIcon: const Icon(Icons.lock_outline),
                            suffixIcon: IconButton(
                              icon: Icon(_passwordObscured ? Icons.visibility_off_outlined : Icons.visibility_outlined),
                              onPressed: () => setState(() => _passwordObscured = !_passwordObscured),
                            ),
                          ),
                          validator: (value) => InputValidators.password(value, minLength: 6),
                        ),
                        const SizedBox(height: AppSpacing.m),
                        TextFormField(
                          controller: _confirmPasswordController,
                          obscureText: _confirmObscured,
                          decoration: InputDecoration(
                            labelText: 'Xác nhận mật khẩu',
                            prefixIcon: const Icon(Icons.lock_reset_outlined),
                            suffixIcon: IconButton(
                              icon: Icon(_confirmObscured ? Icons.visibility_off_outlined : Icons.visibility_outlined),
                              onPressed: () => setState(() => _confirmObscured = !_confirmObscured),
                            ),
                          ),
                          validator: (value) => InputValidators.confirmPassword(value, _passwordController.text),
                        ),
                        const SizedBox(height: AppSpacing.l),
                        Consumer<AuthProvider>(
                          builder: (context, auth, _) => HzPrimaryButton(
                            label: l10n.translate('signUpCta'),
                            icon: Icons.check_circle_rounded,
                            onPressed: _submit,
                            isLoading: auth.isLoading,
                          ),
                        ),
                        const SizedBox(height: AppSpacing.m),
                        Consumer<AuthProvider>(
                          builder: (context, auth, _) => AnimatedSwitcher(
                            duration: const Duration(milliseconds: 250),
                            child: auth.errorMessage == null
                                ? const SizedBox.shrink()
                                : Text(
                                    auth.errorMessage!,
                                    key: const ValueKey('register-error'),
                                    style: theme.textTheme.bodySmall?.copyWith(color: AppColors.danger),
                                    textAlign: TextAlign.center,
                                  ),
                          ),
                        ),
                        const SizedBox(height: AppSpacing.l),
                        TextButton(
                          onPressed: () => context.pop(),
                          child: const Text('Đã có tài khoản? Đăng nhập'),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _RegisterBackground extends StatelessWidget {
  const _RegisterBackground();

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFF6F52ED), Color(0xFFF48FB1)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
        Positioned(
          top: 80,
          right: -50,
          child: _GradientCircle(size: 220, colors: [Colors.white.withOpacityFraction(0.18), Colors.white.withOpacityFraction(0.08)]),
        ),
        Positioned(
          bottom: 140,
          left: -40,
          child: _GradientCircle(size: 180, colors: [Colors.white.withOpacityFraction(0.12), Colors.transparent]),
        ),
      ],
    );
  }
}

class _GradientCircle extends StatelessWidget {
  const _GradientCircle({required this.size, required this.colors});

  final double size;
  final List<Color> colors;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: RadialGradient(colors: colors),
      ),
    );
  }
}

class _GlassCard extends StatelessWidget {
  const _GlassCard({required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(AppRadius.l),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
        child: DecoratedBox(
          decoration: BoxDecoration(
            color: Colors.white.withOpacityFraction(0.9),
            borderRadius: BorderRadius.circular(AppRadius.l),
            boxShadow: const [
              BoxShadow(color: Color(0x26000000), blurRadius: 24, offset: Offset(0, 12)),
            ],
          ),
          child: Padding(
            padding: const EdgeInsets.all(AppSpacing.l),
            child: child,
          ),
        ),
      ),
    );
  }
}

