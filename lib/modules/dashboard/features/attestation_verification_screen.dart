import 'package:flutter/material.dart';
import '../../../core/themes.dart';

class AttestationVerificationScreen extends StatelessWidget {
  const AttestationVerificationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Vérification d'attestation"),
        backgroundColor: AppColors.primary,
      ),
      body: const Center(
        child: Text('Attestation Verification Screen Content'),
      ),
    );
  }
} 