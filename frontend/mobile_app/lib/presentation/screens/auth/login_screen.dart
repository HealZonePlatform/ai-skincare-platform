import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import 'package:ai_skincare_platform/core/constants/app_assets.dart';
import 'package:ai_skincare_platform/core/validation/input_validators.dart';
import 'package:ai_skincare_platform/l10n/app_localizations.dart';
import 'package:ai_skincare_platform/presentation/providers/auth_provider.dart';
import 'package:ai_skincare_platform/presentation/widgets/brand_logo.dart';
import 'package:ai_skincare_platform/presentation/widgets/form/requirement_checklist.dart';
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
  final _emailFocus = FocusNode();
  final _passwordFocus = FocusNode();

  bool _emailTouched = false;
  bool _passwordTouched = false;
  bool _emailValid = false;
  bool _passwordValid = false;
  String? _emailError;
  String? _passwordError;
  bool _obscured = true;

  @override
  void initState() {
    super.initState();
    _emailFocus.addListener(() {
      if (!_emailFocus.hasFocus) {
        _validateEmail();
      }
    });
    _passwordFocus.addListener(() {
      if (!_passwordFocus.hasFocus) {
        _validatePassword();
      }
    });
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _emailFocus.dispose();
    _passwordFocus.dispose();
    super.dispose();
  }

  bool get _passwordHasMin => _passwordController.text.trim().length >= 6;
  bool get _passwordHasNumber =>
      RegExp(r'[0-9]').hasMatch(_passwordController.text);
  bool get _passwordHasLetter =>
      RegExp(r'[A-Za-z]').hasMatch(_passwordController.text);

  List<RequirementItem> get _passwordRequirements => [
        RequirementItem(label: 'Toi thieu 6 ky tu', met: _passwordHasMin),
        RequirementItem(label: 'Chua chu cai', met: _passwordHasLetter),
        RequirementItem(label: 'Chua so', met: _passwordHasNumber),
      ];

  void _validateEmail() {
    final message = InputValidators.email(_emailController.text.trim());
    setState(() {
      _emailTouched = true;
      _emailError = message;
      _emailValid = message == null;
    });
  }

  void _validatePassword() {
    final message = InputValidators.password(
      _passwordController.text.trim(),
      minLength: 6,
    );
    final meetsRules = _passwordRequirements.every((item) => item.met);
    setState(() {
      _passwordTouched = true;
      _passwordError = message;
      _passwordValid = message == null && meetsRules;
    });
  }

  void _onEmailChanged(String value) {
    final message = InputValidators.email(value.trim());
    setState(() {
      _emailTouched = true;
      _emailError = message;
      _emailValid = message == null;
    });
  }

  void _onPasswordChanged(String value) {
    final message = InputValidators.password(value.trim(), minLength: 6);
    final meetsRules = _passwordRequirements.every((item) => item.met);
    setState(() {
      _passwordTouched = true;
      _passwordError = message;
      _passwordValid = message == null && meetsRules;
    });
  }

  Future<void> _submit() async {
    _validateEmail();
    _validatePassword();
    if (!_emailValid || !_passwordValid) {
      _formKey.currentState?.validate();
      return;
    }

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
    final theme = Theme.of(context);
    final bottomInset = MediaQuery.of(context).viewInsets.bottom;
    return Scaffold(
      backgroundColor: theme.colorScheme.surface,
      resizeToAvoidBottomInset: true,
      body: Stack(
        children: [
          const _AuthBackground(),
          SafeArea(
            child: LayoutBuilder(
              builder: (context, constraints) {
                final isWide = constraints.maxWidth >= 960;
                final horizontal = isWide ? AppSpacing.xl * 1.5 : AppSpacing.l;

                return Align(
                  alignment: Alignment.topCenter,
                  child: SingleChildScrollView(
                    padding: EdgeInsets.fromLTRB(
                      horizontal,
                      AppSpacing.xl,
                      horizontal,
                      AppSpacing.xl + bottomInset,
                    ),
                    child: ConstrainedBox(
                      constraints: const BoxConstraints(maxWidth: 1100),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          if (isWide)
                            const Expanded(flex: 5, child: _HeroPanel()),
                          if (isWide) const SizedBox(width: AppSpacing.xl),
                          Expanded(
                            flex: 5,
                            child: _LoginCard(
                              formKey: _formKey,
                              emailController: _emailController,
                              passwordController: _passwordController,
                              obscured: _obscured,
                              emailError: _emailError,
                              passwordError: _passwordError,
                              emailTouched: _emailTouched,
                              passwordTouched: _passwordTouched,
                              emailValid: _emailValid,
                              passwordValid: _passwordValid,
                              passwordRequirements: _passwordRequirements,
                              emailFocusNode: _emailFocus,
                              passwordFocusNode: _passwordFocus,
                              onEmailChanged: _onEmailChanged,
                              onPasswordChanged: _onPasswordChanged,
                              onBlurEmail: _validateEmail,
                              onBlurPassword: _validatePassword,
                              onToggleObscured: () =>
                                  setState(() => _obscured = !_obscured),
                              onSubmit: _submit,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _LoginCard extends StatelessWidget {
  const _LoginCard({
    required GlobalKey<FormState> formKey,
    required TextEditingController emailController,
    required TextEditingController passwordController,
    required this.emailError,
    required this.passwordError,
    required this.emailTouched,
    required this.passwordTouched,
    required this.emailValid,
    required this.passwordValid,
    required this.passwordRequirements,
    required this.emailFocusNode,
    required this.passwordFocusNode,
    required this.onEmailChanged,
    required this.onPasswordChanged,
    required this.onBlurEmail,
    required this.onBlurPassword,
    required this.obscured,
    required this.onToggleObscured,
    required this.onSubmit,
  })  : _formKey = formKey,
        _emailController = emailController,
        _passwordController = passwordController;

  final GlobalKey<FormState> _formKey;
  final TextEditingController _emailController;
  final TextEditingController _passwordController;
  final String? emailError;
  final String? passwordError;
  final bool emailTouched;
  final bool passwordTouched;
  final bool emailValid;
  final bool passwordValid;
  final List<RequirementItem> passwordRequirements;
  final FocusNode emailFocusNode;
  final FocusNode passwordFocusNode;
  final ValueChanged<String> onEmailChanged;
  final ValueChanged<String> onPasswordChanged;
  final VoidCallback onBlurEmail;
  final VoidCallback onBlurPassword;
  final bool obscured;
  final VoidCallback onToggleObscured;
  final VoidCallback onSubmit;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final surface = theme.colorScheme.surface;
    final borderColor = theme.dividerColor.withValues(alpha: 0.8);
    return Container(
      padding: const EdgeInsets.all(AppSpacing.xl),
      decoration: BoxDecoration(
        color: surface,
        borderRadius: BorderRadius.circular(AppRadius.xl),
        border: Border.all(color: borderColor),
        boxShadow: AppShadows.medium,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              const BrandLogo(compact: true, size: 36),
              const SizedBox(width: AppSpacing.s),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      l10n.translate('loginTitle'),
                      style: theme.textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.w700,
                        color: theme.colorScheme.onSurface,
                      ),
                    ),
                    Text(
                      l10n.translate('loginSubtitle'),
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.xl),
          Form(
            key: _formKey,
            autovalidateMode: AutovalidateMode.disabled,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                TextFormField(
                  controller: _emailController,
                  focusNode: emailFocusNode,
                  keyboardType: TextInputType.emailAddress,
                  textInputAction: TextInputAction.next,
                  autofillHints: const [AutofillHints.email],
                  onChanged: onEmailChanged,
                  onEditingComplete: onBlurEmail,
                  decoration: InputDecoration(
                    labelText: l10n.translate('emailLabel'),
                    hintText: 'you@example.com',
                    prefixIcon: const Icon(Icons.mail_outlined),
                    suffixIcon:
                        _statusIcon(isTouched: emailTouched, isValid: emailValid),
                    errorText: emailTouched ? emailError : null,
                  ),
                  validator: (_) => emailError,
                  onFieldSubmitted: (_) =>
                      FocusScope.of(context).requestFocus(passwordFocusNode),
                ),
                const SizedBox(height: AppSpacing.l),
                TextFormField(
                  controller: _passwordController,
                  focusNode: passwordFocusNode,
                  obscureText: obscured,
                  textInputAction: TextInputAction.done,
                  autofillHints: const [AutofillHints.password],
                  onChanged: onPasswordChanged,
                  onEditingComplete: onBlurPassword,
                  onFieldSubmitted: (_) => onSubmit(),
                  decoration: InputDecoration(
                    labelText: l10n.translate('passwordLabel'),
                    prefixIcon: const Icon(Icons.lock_outline),
                    errorText: passwordTouched ? passwordError : null,
                    suffixIcon: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        if (passwordTouched)
                          Padding(
                            padding: const EdgeInsets.only(
                                right: AppSpacing.xs, left: AppSpacing.xs),
                            child: _statusIcon(
                              isTouched: passwordTouched,
                              isValid: passwordValid,
                            ),
                          ),
                        IconButton(
                          tooltip: obscured ? 'Show password' : 'Hide password',
                          icon: Icon(obscured
                              ? Icons.visibility_off_outlined
                              : Icons.visibility_outlined),
                          onPressed: onToggleObscured,
                        ),
                      ],
                    ),
                  ),
                  validator: (_) => passwordError,
                ),
                const SizedBox(height: AppSpacing.xs),
                RequirementChecklist(items: passwordRequirements),
                Align(
                  alignment: Alignment.centerRight,
                  child: TextButton(
                    onPressed: () => ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content:
                            Text('Tính năng đặt lại mật khẩu sẽ sớm có mặt.'),
                      ),
                    ),
                    child: const Text(
                      'Quên mật khẩu?',
                      style: TextStyle(color: AppColors.primary),
                    ),
                  ),
                ),
                const SizedBox(height: AppSpacing.m),
                Consumer<AuthProvider>(
                  builder: (context, auth, _) => HzPrimaryButton(
                    label: l10n.translate('signInCta'),
                    icon: Icons.login_rounded,
                    onPressed: onSubmit,
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
                              color: AppColors.danger.withValues(alpha: 0.08),
                              borderRadius: BorderRadius.circular(AppRadius.m),
                            ),
                            child: Text(
                              auth.errorMessage!,
                              key: const ValueKey('error-text'),
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
          Row(
            children: [
              const Expanded(child: Divider()),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: AppSpacing.m),
                child: Text(
                  'hoặc',
                  style: theme.textTheme.bodySmall
                      ?.copyWith(color: AppColors.textTertiary),
                ),
              ),
              const Expanded(child: Divider()),
            ],
          ),
          const SizedBox(height: AppSpacing.xl),
          HzSecondaryButton(
            label: 'Tiếp tục với Google',
            icon: Icons.g_mobiledata_outlined,
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('OAuth Google đang được triển khai.'),
                ),
              );
            },
          ),
          const SizedBox(height: AppSpacing.l),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Chưa có tài khoản?',
                style: theme.textTheme.bodyMedium
                    ?.copyWith(color: AppColors.textSecondary),
              ),
              TextButton(
                onPressed: () => context.push('/auth/signup'),
                child: const Text('Đăng ký ngay'),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget? _statusIcon({required bool isTouched, required bool isValid}) {
    if (!isTouched) return null;
    return Icon(
      isValid ? Icons.check_circle : Icons.error_outline,
      color: isValid ? AppColors.success : AppColors.warning,
      size: 20,
    );
  }
}

class _HeroPanel extends StatelessWidget {
  const _HeroPanel();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final gradient =
        isDark ? AppColors.primaryGradient : AppColors.primaryGradient;
    return Container(
      padding: const EdgeInsets.all(AppSpacing.xl),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(AppRadius.xl),
        gradient: gradient,
        boxShadow: AppShadows.strong,
        image: DecorationImage(
          image: const AssetImage(AppAssets.heroWave),
          fit: BoxFit.cover,
          colorFilter: ColorFilter.mode(
            (isDark ? AppColors.darkOverlay : AppColors.overlay)
                .withValues(alpha: 0.2),
            BlendMode.darken,
          ),
          onError: (_, __) {},
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(AppRadius.full),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
              child: Container(
                padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.l, vertical: AppSpacing.s),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(AppRadius.full),
                  border:
                      Border.all(color: Colors.white.withValues(alpha: 0.3)),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.eco_outlined, color: Colors.white),
                    const SizedBox(width: AppSpacing.s),
                    Text(
                      'AI skincare, always-on sync',
                      style: theme.textTheme.labelMedium
                          ?.copyWith(color: Colors.white),
                    ),
                  ],
                ),
              ),
            ),
          ),
          const Spacer(),
          Text(
            'Giu chu trinh skincare gan gang.',
            style: theme.textTheme.displaySmall?.copyWith(
              color: Colors.white,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: AppSpacing.s),
          Text(
            'Dong bo lien tuc, ket qua quet va goi y san pham ro rang.',
            style: theme.textTheme.bodyLarge
                ?.copyWith(color: Colors.white.withValues(alpha: 0.9)),
          ),
          const SizedBox(height: AppSpacing.xl),
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(AppSpacing.m),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.18),
                  shape: BoxShape.circle,
                  border:
                      Border.all(color: Colors.white.withValues(alpha: 0.3)),
                ),
                child:
                    const Icon(Icons.shield_moon_outlined, color: Colors.white),
              ),
              const SizedBox(width: AppSpacing.m),
              Expanded(
                child: Text(
                  'Bao mat du lieu, ho tro da nen tang (web & mobile).',
                  style: theme.textTheme.bodyMedium
                      ?.copyWith(color: Colors.white.withValues(alpha: 0.9)),
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.m),
          Container(
            padding: const EdgeInsets.all(AppSpacing.l),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(AppRadius.l),
              border: Border.all(color: Colors.white.withValues(alpha: 0.25)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Toi uu cho web preview',
                  style: theme.textTheme.titleSmall?.copyWith(
                      color: Colors.white, fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: AppSpacing.xs),
                Text(
                  'Trai nghiem muot tren Chrome voi hieu ung nhe va card ro rang.',
                  style: theme.textTheme.bodySmall
                      ?.copyWith(color: Colors.white.withValues(alpha: 0.9)),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _AuthBackground extends StatelessWidget {
  const _AuthBackground();

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final gradient = isDark
        ? const LinearGradient(
            colors: [Color(0xFF1B1C18), Color(0xFF10110E)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          )
        : const LinearGradient(
            colors: [Color(0xFFFBF9F3), Color(0xFFF2F0E8)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          );
    return Stack(
      children: [
        Container(
          decoration: BoxDecoration(
            gradient: gradient,
          ),
        ),
        Positioned(
          top: -120,
          left: -80,
          child: Container(
            width: 260,
            height: 260,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: AppColors.primary.withValues(alpha: 0.08),
            ),
          ),
        ),
        Positioned(
          right: -60,
          top: 40,
          child: Container(
            width: 220,
            height: 220,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: AppColors.secondary.withValues(alpha: 0.08),
            ),
          ),
        ),
      ],
    );
  }
}
