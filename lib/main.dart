import 'package:flutter/material.dart';
import 'core/routes.dart';
import 'core/themes.dart';

void main() {
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
      initialRoute: '/',
      onGenerateRoute: generateRoute,
    );
  }
}
