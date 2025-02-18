import 'package:flutter/material.dart';
import '../../../core/themes.dart';

class UserManagementScreen extends StatelessWidget {
  const UserManagementScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Gestion des utilisateurs'),
        backgroundColor: AppColors.primary,
      ),
      body: const Center(
        child: Text('User Management Screen Content'),
      ),
    );
  }
} 