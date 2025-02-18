import 'package:flutter/material.dart';
import '../../widgets/custom_button.dart';
import '../../core/themes.dart';
import '../../core/routes.dart';
import '../../core/services/auth_service.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isLoading = false;
  final _authService = AuthService();

  Future<void> _handleSignIn() async {
    if (_formKey.currentState!.validate()) {
      setState(() => _isLoading = true);
      
      final success = await _authService.signIn(
        _emailController.text,
        _passwordController.text,
      );

      setState(() => _isLoading = false);

      if (success) {
        Navigator.pushReplacementNamed(context, AppRoutes.dashboard);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Email ou mot de passe incorrect'),
            backgroundColor: AppColors.error,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Form(
            key: _formKey,
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
                TextFormField(
                  controller: _emailController,
                  decoration: const InputDecoration(
                    hintText: 'Email',
                    prefixIcon: Icon(Icons.email_outlined),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your email';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _passwordController,
                  obscureText: true,
                  decoration: const InputDecoration(
                    hintText: 'Password',
                    prefixIcon: Icon(Icons.lock_outline),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your password';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 24),
                CustomButton(
                  text: 'Sign In',
                  onPressed: _handleSignIn,
                  size: ButtonSize.large,
                  isLoading: _isLoading,
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
                const SizedBox(height: 16),
                Center(
                  child: CustomButton(
                    text: "View User Database",
                    onPressed: () {
                      Navigator.pushNamed(context, AppRoutes.userDatabase);
                    },
                    variant: ButtonVariant.text,
                    icon: Icons.dangerous,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }
}
