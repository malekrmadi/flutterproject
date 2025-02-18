import 'package:flutter/material.dart';
import '../../../core/themes.dart';

class AttestationGeneratorScreen extends StatelessWidget {
  const AttestationGeneratorScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Génération d'attestations"),
        backgroundColor: AppColors.primary,
      ),
      body: const Center(
        child: Text('Attestation Generator Screen Content'),
      ),
    );
  }
} 