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

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  bool _obscured = true;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    final form = _formKey.currentState;
    if (form == null || !form.validate()) return;

    final auth = context.read<AuthProvider>();
    final success = await auth.login(
      _emailController.text.trim(),
      _passwordController.text.trim(),
    );

    if (success && mounted) {
      context.go('/home');
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);

    return Scaffold(
      body: Stack(
        children: [
          const _BackgroundGradient(),
          Positioned.fill(
            child: IgnorePointer(
              child: Image.asset(
                AppAssets.heroWave,
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
                child: _FrostedContainer(
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          l10n.translate('loginTitle'),
                          style: theme.textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.w600),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: AppSpacing.s),
                        Text(
                          l10n.translate('loginSubtitle'),
                          style: theme.textTheme.bodyMedium?.copyWith(color: AppColors.textSecondary),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: AppSpacing.xl),
                        const Align(
                          child: BrandLogo(size: 68),
                        ),
                        const SizedBox(height: AppSpacing.l),
                        HzSecondaryButton(
                          label: 'Tiếp tục với Google',
                          icon: Icons.g_mobiledata_outlined,
                          onPressed: () {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('OAuth sign-in đang được triển khai.')),
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
                          obscureText: _obscured,
                          decoration: InputDecoration(
                            labelText: l10n.translate('passwordLabel'),
                            prefixIcon: const Icon(Icons.lock_outline),
                            suffixIcon: IconButton(
                              icon: Icon(_obscured ? Icons.visibility_off_outlined : Icons.visibility_outlined),
                              onPressed: () => setState(() => _obscured = !_obscured),
                            ),
                          ),
                          validator: InputValidators.password,
                        ),
                        const SizedBox(height: AppSpacing.m),
                        Align(
                          alignment: Alignment.centerRight,
                          child: TextButton(
                            onPressed: () => ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('Tính năng đặt lại mật khẩu sẽ sớm có mặt.')),
                            ),
                            child: const Text('Quên mật khẩu?'),
                          ),
                        ),
                        const SizedBox(height: AppSpacing.l),
                        Consumer<AuthProvider>(
                          builder: (context, auth, _) => HzPrimaryButton(
                            label: l10n.translate('signInCta'),
                            icon: Icons.login_rounded,
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
                                    key: const ValueKey('error-text'),
                                    style: theme.textTheme.bodySmall?.copyWith(color: AppColors.danger),
                                    textAlign: TextAlign.center,
                                  ),
                          ),
                        ),
                        const SizedBox(height: AppSpacing.l),
                        TextButton(
                          onPressed: () => context.push('/auth/signup'),
                          child: const Text('Chưa có tài khoản? Đăng ký ngay'),
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

class _BackgroundGradient extends StatelessWidget {
  const _BackgroundGradient();

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFF8A8E5A), Color(0xFFF4A259)],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
        ),
        Positioned(
          top: 90,
          left: -40,
          child: _BlurBlob(color: Colors.white.withOpacityFraction(0.2), size: 180),
        ),
        Positioned(
          bottom: 160,
          right: -60,
          child: _BlurBlob(color: Colors.white.withOpacityFraction(0.15), size: 210),
        ),
      ],
    );
  }
}

class _BlurBlob extends StatelessWidget {
  const _BlurBlob({required this.color, required this.size});

  final Color color;
  final double size;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(size),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
        child: Container(
          width: size,
          height: size,
          color: color,
        ),
      ),
    );
  }
}

class _FrostedContainer extends StatelessWidget {
  const _FrostedContainer({required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(AppRadius.l),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
        child: Container(
          padding: const EdgeInsets.all(AppSpacing.l),
          decoration: BoxDecoration(
            color: Colors.white.withOpacityFraction(0.86),
            borderRadius: BorderRadius.circular(AppRadius.l),
            boxShadow: const [
              BoxShadow(color: Color(0x2A000000), blurRadius: 20, offset: Offset(0, 8)),
            ],
          ),
          child: child,
        ),
      ),
    );
  }
}

