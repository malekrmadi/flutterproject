import 'package:flutter/material.dart';
import 'core/routes.dart';
import 'core/themes.dart';
//import 'core/services/auth_service.dart';
import 'modules/splash/splash_screen.dart';
import 'core/database/database_helper.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Initialize database
  await DatabaseHelper().database;
  
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'My App',
      theme: AppTheme.lightTheme,
      home: const SplashScreen(), // Start with splash screen
      onGenerateRoute: generateRoute,
    );
  }
}
