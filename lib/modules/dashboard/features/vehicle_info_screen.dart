import 'package:flutter/material.dart';
import '../../../core/themes.dart';

class VehicleInfoScreen extends StatelessWidget {
  const VehicleInfoScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Accès aux infos véhicules'),
        backgroundColor: AppColors.primary,
      ),
      body: const Center(
        child: Text('Vehicle Info Screen Content'),
      ),
    );
  }
} 