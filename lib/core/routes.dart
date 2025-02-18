import 'package:flutter/material.dart';
import '../modules/auth/login_screen.dart';
import '../modules/auth/register_screen.dart';
import '../modules/auth/forgot_password_screen.dart';
import '../modules/splash/splash_screen.dart';
import '../modules/onboarding/onboarding_screen.dart';
import '../modules/dashboard/dashboard_screen.dart';
import '../modules/not_found/not_found_screen.dart'; // Écran 404
// Import feature screens
import '../modules/dashboard/features/user_management_screen.dart';
import '../modules/dashboard/features/attestation_generator_screen.dart';
import '../modules/dashboard/features/attestation_history_screen.dart';
import '../modules/dashboard/features/attestation_verification_screen.dart';
import '../modules/dashboard/features/vehicle_info_screen.dart';
import '../modules/dashboard/features/my_attestations_screen.dart';
import '../modules/dashboard/features/profile_screen.dart';

class AppRoutes {
  static const String splash = '/';
  static const String onboarding = '/onboarding';
  static const String login = '/login';
  static const String register = '/register';
  static const String forgotPassword = '/forgot-password';
  static const String dashboard = '/dashboard';
  
  // Feature routes
  static const String userManagement = '/dashboard/users';
  static const String attestationGenerator = '/dashboard/generate';
  static const String attestationHistory = '/dashboard/history';
  static const String attestationVerification = '/dashboard/verify';
  static const String vehicleInfo = '/dashboard/vehicles';
  static const String myAttestations = '/dashboard/my-attestations';
  static const String profile = '/dashboard/profile';
}

/// Générateur de routes avec gestion des erreurs
Route<dynamic> generateRoute(RouteSettings settings) {
  switch (settings.name) {
    case AppRoutes.splash:
      return MaterialPageRoute(builder: (_) => const SplashScreen());
    case AppRoutes.onboarding:
      return MaterialPageRoute(builder: (_) => const OnboardingScreen());
    case AppRoutes.login:
      return MaterialPageRoute(builder: (_) => const LoginScreen());
    case AppRoutes.register:
      return MaterialPageRoute(builder: (_) => const RegisterScreen());
    case AppRoutes.forgotPassword:
      return MaterialPageRoute(builder: (_) => const ForgotPasswordScreen());
    case AppRoutes.dashboard:
      return MaterialPageRoute(builder: (_) => const DashboardScreen());
      
    // Feature routes
    case AppRoutes.userManagement:
      return MaterialPageRoute(builder: (_) => const UserManagementScreen());
    case AppRoutes.attestationGenerator:
      return MaterialPageRoute(builder: (_) => const AttestationGeneratorScreen());
    case AppRoutes.attestationHistory:
      return MaterialPageRoute(builder: (_) => const AttestationHistoryScreen());
    case AppRoutes.attestationVerification:
      return MaterialPageRoute(builder: (_) => const AttestationVerificationScreen());
    case AppRoutes.vehicleInfo:
      return MaterialPageRoute(builder: (_) => const VehicleInfoScreen());
    case AppRoutes.myAttestations:
      return MaterialPageRoute(builder: (_) => const MyAttestationsScreen());
    case AppRoutes.profile:
      return MaterialPageRoute(builder: (_) => const ProfileScreen());
      
    default:
      return MaterialPageRoute(builder: (_) => const NotFoundScreen());
  }
}
