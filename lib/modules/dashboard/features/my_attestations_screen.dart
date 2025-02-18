import 'package:flutter/material.dart';
import '../../../core/themes.dart';

class MyAttestationsScreen extends StatelessWidget {
  const MyAttestationsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Mes attestations'),
        backgroundColor: AppColors.primary,
      ),
      body: const Center(
        child: Text('My Attestations Screen Content'),
      ),
    );
  }
} 