import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import 'package:ai_skincare_platform/core/validation/input_validators.dart';
import 'package:ai_skincare_platform/l10n/app_localizations.dart';
import 'package:ai_skincare_platform/presentation/providers/auth_provider.dart';
import 'package:ai_skincare_platform/presentation/widgets/brand_logo.dart';
import 'package:ai_skincare_platform/presentation/widgets/form/requirement_checklist.dart';
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
  final _emailFocus = FocusNode();
  final _passwordFocus = FocusNode();
  final _confirmFocus = FocusNode();

  bool _passwordObscured = true;
  bool _confirmObscured = true;
  bool _emailTouched = false;
  bool _passwordTouched = false;
  bool _confirmTouched = false;
  bool _emailValid = false;
  bool _passwordValid = false;
  bool _confirmValid = false;
  String? _emailError;
  String? _passwordError;
  String? _confirmError;

  bool get _passwordHasMin => _passwordController.text.trim().length >= 6;
  bool get _passwordHasLetter =>
      RegExp(r'[A-Za-z]').hasMatch(_passwordController.text);
  bool get _passwordHasNumber =>
      RegExp(r'[0-9]').hasMatch(_passwordController.text);

  List<RequirementItem> get _passwordRequirements => [
        RequirementItem(label: 'Toi thieu 6 ky tu', met: _passwordHasMin),
        RequirementItem(label: 'Chua chu cai', met: _passwordHasLetter),
        RequirementItem(label: 'Chua so', met: _passwordHasNumber),
      ];

  @override
  void initState() {
    super.initState();
    _emailFocus.addListener(() {
      if (!_emailFocus.hasFocus) _validateEmail();
    });
    _passwordFocus.addListener(() {
      if (!_passwordFocus.hasFocus) _validatePassword();
    });
    _confirmFocus.addListener(() {
      if (!_confirmFocus.hasFocus) _validateConfirm();
    });
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _emailFocus.dispose();
    _passwordFocus.dispose();
    _confirmFocus.dispose();
    super.dispose();
  }

  void _validateEmail() {
    final message = InputValidators.email(_emailController.text.trim());
    setState(() {
      _emailTouched = true;
      _emailError = message;
      _emailValid = message == null;
    });
  }

  void _validatePassword() {
    final message =
        InputValidators.password(_passwordController.text.trim(), minLength: 6);
    final meetsRules = _passwordRequirements.every((item) => item.met);
    setState(() {
      _passwordTouched = true;
      _passwordError = message;
      _passwordValid = message == null && meetsRules;
    });
  }

  void _validateConfirm() {
    final message = InputValidators.confirmPassword(
      _confirmPasswordController.text.trim(),
      _passwordController.text.trim(),
    );
    setState(() {
      _confirmTouched = true;
      _confirmError = message;
      _confirmValid = message == null;
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

  void _onConfirmChanged(String value) {
    final message = InputValidators.confirmPassword(
      value.trim(),
      _passwordController.text.trim(),
    );
    setState(() {
      _confirmTouched = true;
      _confirmError = message;
      _confirmValid = message == null;
    });
  }

  Widget? _statusIcon({required bool touched, required bool valid}) {
    if (!touched) return null;
    return Icon(
      valid ? Icons.check_circle : Icons.error_outline,
      color: valid ? AppColors.success : AppColors.warning,
      size: 20,
    );
  }

  Future<void> _submit() async {
    _validateEmail();
    _validatePassword();
    _validateConfirm();
    if (!_emailValid || !_passwordValid || !_confirmValid) {
      _formKey.currentState?.validate();
      return;
    }

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
    final bottomInset = MediaQuery.of(context).viewInsets.bottom;

    return Scaffold(
      backgroundColor: theme.colorScheme.surface,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: theme.colorScheme.onSurface),
          onPressed: () => context.pop(),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.fromLTRB(AppSpacing.xl, AppSpacing.xl,
              AppSpacing.xl, AppSpacing.xl + bottomInset),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Center(child: BrandLogo(size: 72)),
              const SizedBox(height: AppSpacing.xl),
              Text(
                l10n.translate('signUpCta'),
                style: theme.textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: theme.colorScheme.onSurface,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: AppSpacing.s),
              Text(
                'Tra loi vai cau hoi de HealZone goi y chu trinh cham soc da phu hop.',
                style: theme.textTheme.bodyLarge?.copyWith(
                  color: AppColors.textSecondary,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: AppSpacing.xxl),
              Form(
                key: _formKey,
                autovalidateMode: AutovalidateMode.disabled,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    TextFormField(
                      controller: _emailController,
                      focusNode: _emailFocus,
                      keyboardType: TextInputType.emailAddress,
                      textInputAction: TextInputAction.next,
                      onChanged: _onEmailChanged,
                      onEditingComplete: _validateEmail,
                      decoration: InputDecoration(
                        labelText: l10n.translate('emailLabel'),
                        prefixIcon: const Icon(Icons.mail_outlined),
                        suffixIcon: _statusIcon(
                            touched: _emailTouched, valid: _emailValid),
                        errorText: _emailTouched ? _emailError : null,
                      ),
                      validator: (_) => _emailError,
                      onFieldSubmitted: (_) =>
                          FocusScope.of(context).requestFocus(_passwordFocus),
                    ),
                    const SizedBox(height: AppSpacing.l),
                    TextFormField(
                      controller: _passwordController,
                      focusNode: _passwordFocus,
                      obscureText: _passwordObscured,
                      textInputAction: TextInputAction.next,
                      onChanged: _onPasswordChanged,
                      onEditingComplete: _validatePassword,
                      decoration: InputDecoration(
                        labelText: l10n.translate('passwordLabel'),
                        prefixIcon: const Icon(Icons.lock_outline),
                        errorText: _passwordTouched ? _passwordError : null,
                        suffixIcon: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            if (_passwordTouched)
                              Padding(
                                padding: const EdgeInsets.only(
                                    right: AppSpacing.xs, left: AppSpacing.xs),
                                child: _statusIcon(
                                    touched: _passwordTouched,
                                    valid: _passwordValid),
                              ),
                            IconButton(
                              icon: Icon(_passwordObscured
                                  ? Icons.visibility_off_outlined
                                  : Icons.visibility_outlined),
                              onPressed: () => setState(
                                  () => _passwordObscured = !_passwordObscured),
                            ),
                          ],
                        ),
                      ),
                      validator: (_) => _passwordError,
                      onFieldSubmitted: (_) =>
                          FocusScope.of(context).requestFocus(_confirmFocus),
                    ),
                    const SizedBox(height: AppSpacing.xs),
                    RequirementChecklist(items: _passwordRequirements),
                    const SizedBox(height: AppSpacing.l),
                    TextFormField(
                      controller: _confirmPasswordController,
                      focusNode: _confirmFocus,
                      obscureText: _confirmObscured,
                      textInputAction: TextInputAction.done,
                      onChanged: _onConfirmChanged,
                      onEditingComplete: _validateConfirm,
                      decoration: InputDecoration(
                        labelText: 'Xac nhan mat khau',
                        prefixIcon: const Icon(Icons.lock_reset_outlined),
                        errorText: _confirmTouched ? _confirmError : null,
                        suffixIcon: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            if (_confirmTouched)
                              Padding(
                                padding: const EdgeInsets.only(
                                    right: AppSpacing.xs, left: AppSpacing.xs),
                                child: _statusIcon(
                                  touched: _confirmTouched,
                                  valid: _confirmValid,
                                ),
                              ),
                            IconButton(
                              icon: Icon(_confirmObscured
                                  ? Icons.visibility_off_outlined
                                  : Icons.visibility_outlined),
                              onPressed: () => setState(
                                  () => _confirmObscured = !_confirmObscured),
                            ),
                          ],
                        ),
                      ),
                      validator: (_) => _confirmError,
                      onFieldSubmitted: (_) => _submit(),
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
                                  auth.errorMessage ?? '',
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
                    child:
                        Text('OR', style: TextStyle(color: AppColors.textTertiary)),
                  ),
                  Expanded(child: Divider()),
                ],
              ),
              const SizedBox(height: AppSpacing.xl),
              HzSecondaryButton(
                label: 'Dang ky bang Google',
                icon: Icons.g_mobiledata_outlined,
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                        content:
                            Text('OAuth sign-up dang duoc trien khai.')),
                  );
                },
              ),
              const SizedBox(height: AppSpacing.l),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Da co tai khoan?',
                    style: theme.textTheme.bodyMedium
                        ?.copyWith(color: AppColors.textSecondary),
                  ),
                  TextButton(
                    onPressed: () => context.pop(),
                    child: const Text('Dang nhap'),
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
