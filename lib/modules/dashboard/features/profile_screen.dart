import 'package:flutter/material.dart';
import '../../../core/themes.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Mon profil'),
        backgroundColor: AppColors.primary,
      ),
      body: const Center(
        child: Text('Profile Screen Content'),
      ),
    );
  }
} 