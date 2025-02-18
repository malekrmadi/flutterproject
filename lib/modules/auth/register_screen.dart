import 'package:flutter/material.dart';
import '../../widgets/custom_button.dart';
//import '../../core/themes.dart';
import '../../core/routes.dart';

class RegisterScreen extends StatelessWidget {
  const RegisterScreen({super.key});

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
                'Create Account',
                style: Theme.of(context).textTheme.displayLarge,
              ),
              const SizedBox(height: 8),
              Text(
                'Sign up to get started',
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              const SizedBox(height: 32),
              TextField(
                decoration: const InputDecoration(
                  hintText: 'Full Name',
                  prefixIcon: Icon(Icons.person_outline),
                ),
              ),
              const SizedBox(height: 16),
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
                text: 'Sign Up',
                onPressed: () {
                  // Handle registration
                  Navigator.pushReplacementNamed(context, AppRoutes.dashboard);
                },
                size: ButtonSize.large,
              ),
              const SizedBox(height: 16),
              CustomButton(
                text: 'Sign Up with Google',
                onPressed: () {
                  // Handle Google sign up
                },
                variant: ButtonVariant.secondary,
                icon: Icons.g_mobiledata,
              ),
              const Spacer(),
              Center(
                child: CustomButton(
                  text: "Already have an account? Sign In",
                  onPressed: () {
                    Navigator.pushNamed(context, AppRoutes.login);
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
