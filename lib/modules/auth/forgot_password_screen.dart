import 'package:flutter/material.dart';
import '../../widgets/custom_button.dart';
import '../../core/routes.dart';
import '../../core/themes.dart';

class ForgotPasswordScreen extends StatelessWidget {
  const ForgotPasswordScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.textPrimary),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Reset Password',
                style: Theme.of(context).textTheme.displayLarge,
              ),
              const SizedBox(height: 8),
              Text(
                'Enter your email address to receive a password reset link',
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              const SizedBox(height: 32),
              TextField(
                decoration: const InputDecoration(
                  hintText: 'Email',
                  prefixIcon: Icon(Icons.email_outlined),
                ),
                keyboardType: TextInputType.emailAddress,
              ),
              const SizedBox(height: 24),
              CustomButton(
                text: 'Send Reset Link',
                onPressed: () {
                  // Handle password reset
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Reset link sent to your email'),
                      backgroundColor: AppColors.success,
                    ),
                  );
                  Future.delayed(
                    const Duration(seconds: 2),
                    () => Navigator.pushReplacementNamed(context, AppRoutes.login),
                  );
                },
                size: ButtonSize.large,
              ),
              const Spacer(),
              Center(
                child: CustomButton(
                  text: "Remember your password? Sign In",
                  onPressed: () {
                    Navigator.pushReplacementNamed(context, AppRoutes.login);
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
