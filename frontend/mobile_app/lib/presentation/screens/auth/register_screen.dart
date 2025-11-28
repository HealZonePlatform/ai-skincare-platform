import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

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
      backgroundColor: AppColors.surface,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.textPrimary),
          onPressed: () => context.pop(),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(AppSpacing.xl),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Center(child: BrandLogo(size: 72)),
              const SizedBox(height: AppSpacing.xl),
              Text(
                l10n.translate('signUpCta'),
                style: theme.textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: AppSpacing.s),
              Text(
                'Trả lời vài câu hỏi và HealZone sẽ cá nhân hóa chu trình chăm sóc da cho bạn.',
                style: theme.textTheme.bodyLarge?.copyWith(
                  color: AppColors.textSecondary,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: AppSpacing.xxl),
              Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    TextFormField(
                      controller: _emailController,
                      keyboardType: TextInputType.emailAddress,
                      decoration: InputDecoration(
                        labelText: l10n.translate('emailLabel'),
                        prefixIcon: const Icon(Icons.mail_outlined),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(AppRadius.m),
                        ),
                      ),
                      validator: InputValidators.email,
                    ),
                    const SizedBox(height: AppSpacing.l),
                    TextFormField(
                      controller: _passwordController,
                      obscureText: _passwordObscured,
                      decoration: InputDecoration(
                        labelText: l10n.translate('passwordLabel'),
                        prefixIcon: const Icon(Icons.lock_outline),
                        suffixIcon: IconButton(
                          icon: Icon(_passwordObscured
                              ? Icons.visibility_off_outlined
                              : Icons.visibility_outlined),
                          onPressed: () => setState(
                              () => _passwordObscured = !_passwordObscured),
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(AppRadius.m),
                        ),
                      ),
                      validator: (value) =>
                          InputValidators.password(value, minLength: 6),
                    ),
                    const SizedBox(height: AppSpacing.l),
                    TextFormField(
                      controller: _confirmPasswordController,
                      obscureText: _confirmObscured,
                      decoration: InputDecoration(
                        labelText: 'Xác nhận mật khẩu',
                        prefixIcon: const Icon(Icons.lock_reset_outlined),
                        suffixIcon: IconButton(
                          icon: Icon(_confirmObscured
                              ? Icons.visibility_off_outlined
                              : Icons.visibility_outlined),
                          onPressed: () => setState(
                              () => _confirmObscured = !_confirmObscured),
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(AppRadius.m),
                        ),
                      ),
                      validator: (value) => InputValidators.confirmPassword(
                          value, _passwordController.text),
                    ),
                    const SizedBox(height: AppSpacing.xl),
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
                            : Container(
                                padding: const EdgeInsets.all(AppSpacing.m),
                                decoration: BoxDecoration(
                                  color:
                                      AppColors.danger.withValues(alpha: 0.1),
                                  borderRadius:
                                      BorderRadius.circular(AppRadius.m),
                                ),
                                child: Text(
                                  auth.errorMessage!,
                                  key: const ValueKey('register-error'),
                                  style: theme.textTheme.bodySmall
                                      ?.copyWith(color: AppColors.danger),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: AppSpacing.xl),
              const Row(
                children: [
                  Expanded(child: Divider()),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: AppSpacing.m),
                    child: Text('OR',
                        style: TextStyle(color: AppColors.textTertiary)),
                  ),
                  Expanded(child: Divider()),
                ],
              ),
              const SizedBox(height: AppSpacing.xl),
              HzSecondaryButton(
                label: 'Đăng ký bằng Google',
                icon: Icons.g_mobiledata_outlined,
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                        content: Text('OAuth sign-up đang được triển khai.')),
                  );
                },
              ),
              const SizedBox(height: AppSpacing.l),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text("Đã có tài khoản?"),
                  TextButton(
                    onPressed: () => context.pop(),
                    child: const Text('Đăng nhập'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
