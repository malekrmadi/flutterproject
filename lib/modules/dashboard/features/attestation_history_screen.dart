import 'package:flutter/material.dart';
import '../../../core/themes.dart';

class AttestationHistoryScreen extends StatelessWidget {
  const AttestationHistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Historique des attestations'),
        backgroundColor: AppColors.primary,
      ),
      body: const Center(
        child: Text('Attestation History Screen Content'),
      ),
    );
  }
} 