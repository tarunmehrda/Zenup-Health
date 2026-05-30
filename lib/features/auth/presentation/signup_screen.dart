// File: signup_screen.dart
// Purpose: Wrapper that redirects/instantiates the unified LoginScreen starting in SignUp mode.

import 'package:flutter/material.dart';
import 'login_screen.dart';

class SignupScreen extends StatelessWidget {
  const SignupScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const LoginScreen(startInSignupMode: true);
  }
}
