import 'package:flutter/material.dart';
import '../../widgets/custom_button.dart';
//import '../../core/themes.dart';
import '../../core/routes.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Welcome Back',
                style: Theme.of(context).textTheme.displayLarge,
              ),
              const SizedBox(height: 8),
              Text(
                'Sign in to continue',
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              const SizedBox(height: 32),
              TextField(
                decoration: const InputDecoration(
                  hintText: 'Email',
                  prefixIcon: Icon(Icons.email_outlined),
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                obscureText: true,
                decoration: const InputDecoration(
                  hintText: 'Password',
                  prefixIcon: Icon(Icons.lock_outline),
                ),
              ),
              const SizedBox(height: 24),
              CustomButton(
                text: 'Sign In',
                onPressed: () {
                  // Handle sign in
                  Navigator.pushReplacementNamed(context, AppRoutes.dashboard);
                },
                size: ButtonSize.large,
              ),
              const SizedBox(height: 16),
              CustomButton(
                text: 'Sign In with Google',
                onPressed: () {
                  // Handle Google sign in
                },
                variant: ButtonVariant.secondary,
                icon: Icons.g_mobiledata,
              ),
              const Spacer(),
              Center(
                child: CustomButton(
                  text: "Don't have an account? Sign Up",
                  onPressed: () {
                    Navigator.pushNamed(context, AppRoutes.register);
                  },
                  variant: ButtonVariant.text,
                ),
              ),
              const SizedBox(height: 16),
              Center(
                child: CustomButton(
                  text: "Forgot Password?",
                  onPressed: () {
                    Navigator.pushNamed(context, AppRoutes.forgotPassword);
                  },
                  variant: ButtonVariant.text,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
