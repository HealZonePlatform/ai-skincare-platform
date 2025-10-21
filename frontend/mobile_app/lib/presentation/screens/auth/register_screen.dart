import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import 'package:ai_skincare_platform/core/validation/input_validators.dart';
import 'package:ai_skincare_platform/l10n/app_localizations.dart';
import 'package:ai_skincare_platform/presentation/providers/auth_provider.dart';
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
    final success = await auth.register({
      'email': _emailController.text.trim(),
      'password': _passwordController.text.trim(),
    });
    if (success && mounted) {
      context.push('/survey/skin-type');
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Scaffold(
      appBar: AppBar(title: Text(l10n.translate('signUpCta'))),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(AppSpacing.xl),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    l10n.translate('signUpCta'),
                    style: Theme.of(context).textTheme.headlineSmall,
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: AppSpacing.s),
                  Text(
                    'Answer a few quick questions and HealZone will tailor routines and reminders for you.',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: AppColors.textSecondary),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: AppSpacing.xl),
                  HzSecondaryButton(
                    label: 'Continue with Google',
                    icon: Icons.g_mobiledata_outlined,
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('OAuth sign-up is coming soon.')),
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
                      prefixIcon: const Icon(Icons.email_outlined),
                    ),
                    validator: InputValidators.email,
                  ),
                  const SizedBox(height: AppSpacing.m),
                  TextFormField(
                    controller: _passwordController,
                    obscureText: true,
                    decoration: InputDecoration(
                      labelText: l10n.translate('passwordLabel'),
                      prefixIcon: const Icon(Icons.lock_outline),
                    ),
                    validator: (value) => InputValidators.password(value, minLength: 6),
                  ),
                  const SizedBox(height: AppSpacing.m),
                  TextFormField(
                    controller: _confirmPasswordController,
                    obscureText: true,
                    decoration: const InputDecoration(
                      labelText: 'Confirm password',
                      prefixIcon: Icon(Icons.lock_reset),
                    ),
                    validator: (value) => InputValidators.confirmPassword(value, _passwordController.text),
                  ),
                  const SizedBox(height: AppSpacing.l),
                  Consumer<AuthProvider>(
                    builder: (context, auth, _) => HzPrimaryButton(
                      label: l10n.translate('signUpCta'),
                      icon: Icons.check_circle_outline,
                      onPressed: _submit,
                      isLoading: auth.isLoading,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.l),
                  TextButton(
                    onPressed: () => context.pop(),
                    child: const Text('Already have an account? Sign in'),
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
