/// File: signup_screen.dart
/// Purpose: Prompts users to register a new account on Zenup Health.
library features;

import 'package:flutter/material.dart';
import '../../../app/theme/app_colors.dart';
import '../../../app/theme/app_spacing.dart';
import '../../../app/router/app_routes.dart';
import '../../../shared/widgets/z_button.dart';
import '../../../shared/widgets/z_input_field.dart';
import '../../../core/utils/validators.dart';
import '../domain/auth_notifier.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _authNotifier = AuthNotifier();

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _authNotifier.dispose();
    super.dispose();
  }

  void _onSignup() async {
    if (_formKey.currentState!.validate()) {
      final success = await _authNotifier.register(
        _nameController.text,
        _emailController.text,
        _passwordController.text,
      );
      if (mounted) {
        if (success) {
          Navigator.of(context).pushReplacementNamed(AppRoutes.profileSetup);
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(_authNotifier.errorMessage ?? 'Registration failed'),
              backgroundColor: AppColors.error,
            ),
          );
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark ? AppColors.backgroundStart : AppColors.lightBackgroundStart,
      appBar: AppBar(
        iconTheme: IconThemeData(
          color: isDark ? AppColors.textPrimary : AppColors.lightTextPrimary,
        ),
      ),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(AppSpacing.lg),
            child: Form(
              key: _formKey,
              child: ListenableBuilder(
                listenable: _authNotifier,
                builder: (context, child) {
                  return Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Text(
                        'Create Account',
                        textAlign: TextAlign.center,
                        style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                              color: isDark ? AppColors.textPrimary : AppColors.lightTextPrimary,
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                      const SizedBox(height: AppSpacing.xs),
                      Text(
                        'Join us and start tracking your path to health',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: isDark ? AppColors.textSecondary : AppColors.lightTextSecondary,
                        ),
                      ),
                      const SizedBox(height: AppSpacing.xl),
                      ZInputField(
                        labelText: 'Full Name',
                        hintText: 'John Doe',
                        controller: _nameController,
                        prefixIcon: Icons.person_outline_rounded,
                        validator: Validators.validateName,
                      ),
                      const SizedBox(height: AppSpacing.md),
                      ZInputField(
                        labelText: 'Email Address',
                        hintText: 'name@example.com',
                        controller: _emailController,
                        prefixIcon: Icons.email_outlined,
                        keyboardType: TextInputType.emailAddress,
                        validator: Validators.validateEmail,
                      ),
                      const SizedBox(height: AppSpacing.md),
                      ZInputField(
                        labelText: 'Password',
                        hintText: 'Minimum 6 characters',
                        controller: _passwordController,
                        prefixIcon: Icons.lock_outline_rounded,
                        isPassword: true,
                        validator: Validators.validatePassword,
                      ),
                      const SizedBox(height: AppSpacing.lg),
                      ZButton(
                        label: 'Sign Up',
                        isLoading: _authNotifier.isLoading,
                        onPressed: _onSignup,
                      ),
                      const SizedBox(height: AppSpacing.xl),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "Already have an account? ",
                            style: TextStyle(
                              color: isDark ? AppColors.textSecondary : AppColors.lightTextSecondary,
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              Navigator.of(context).pop();
                            },
                            child: const Text(
                              'Login',
                              style: TextStyle(
                                color: AppColors.primary,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  );
                },
              ),
            ),
          ),
        ),
      ),
    );
  }
}
