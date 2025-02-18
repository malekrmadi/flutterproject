import 'package:flutter/material.dart';
import '../../../core/themes.dart';
import '../../../widgets/custom_button.dart';
import '../../../core/services/attestation_service.dart';
import '../../../core/services/auth_service.dart';
import '../../../models/attestation.dart';

class AttestationGeneratorScreen extends StatefulWidget {
  const AttestationGeneratorScreen({super.key});

  @override
  State<AttestationGeneratorScreen> createState() => _AttestationGeneratorScreenState();
}

class _AttestationGeneratorScreenState extends State<AttestationGeneratorScreen> {
  final _formKey = GlobalKey<FormState>();
  final _attestationService = AttestationService();
  final _authService = AuthService();
  bool _isLoading = false;

  final _typeController = TextEditingController();
  final _brandController = TextEditingController();
  final _modelController = TextEditingController();
  final _plateController = TextEditingController();
  final _ownerNameController = TextEditingController();
  final _ownerCinController = TextEditingController();

  Future<void> _generateAttestation() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      final currentUser = await _authService.getCurrentUser();
      if (currentUser == null) {
        throw Exception('User not authenticated');
      }

      final attestation = Attestation(
        type: _typeController.text,
        vehicleBrand: _brandController.text,
        vehicleModel: _modelController.text,
        plateNumber: _plateController.text,
        ownerName: _ownerNameController.text,
        ownerCin: _ownerCinController.text,
        status: 'pending',
        createdBy: currentUser['id'],
      );

      await _attestationService.createAttestation(attestation);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Attestation générée avec succès'),
            backgroundColor: AppColors.success,
          ),
        );
        Navigator.pop(context);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Erreur lors de la génération de l\'attestation'),
            backgroundColor: AppColors.error,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Générer une attestation'),
        backgroundColor: AppColors.primary,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              DropdownButtonFormField<String>(
                value: _typeController.text.isEmpty ? null : _typeController.text,
                decoration: const InputDecoration(
                  labelText: 'Type d\'attestation',
                  prefixIcon: Icon(Icons.description),
                ),
                items: ['Vente', 'Location', 'Prêt'].map((type) {
                  return DropdownMenuItem(
                    value: type,
                    child: Text(type),
                  );
                }).toList(),
                onChanged: (value) {
                  _typeController.text = value ?? '';
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Veuillez sélectionner un type';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _brandController,
                decoration: const InputDecoration(
                  labelText: 'Marque du véhicule',
                  prefixIcon: Icon(Icons.directions_car),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Veuillez entrer la marque';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _modelController,
                decoration: const InputDecoration(
                  labelText: 'Modèle du véhicule',
                  prefixIcon: Icon(Icons.car_repair),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Veuillez entrer le modèle';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _plateController,
                decoration: const InputDecoration(
                  labelText: 'Numéro d\'immatriculation',
                  prefixIcon: Icon(Icons.pin),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Veuillez entrer le numéro d\'immatriculation';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _ownerNameController,
                decoration: const InputDecoration(
                  labelText: 'Nom du propriétaire',
                  prefixIcon: Icon(Icons.person),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Veuillez entrer le nom du propriétaire';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _ownerCinController,
                decoration: const InputDecoration(
                  labelText: 'CIN du propriétaire',
                  prefixIcon: Icon(Icons.badge),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Veuillez entrer le CIN du propriétaire';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 32),
              CustomButton(
                text: 'Générer l\'attestation',
                onPressed: _generateAttestation,
                size: ButtonSize.large,
                isLoading: _isLoading,
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _typeController.dispose();
    _brandController.dispose();
    _modelController.dispose();
    _plateController.dispose();
    _ownerNameController.dispose();
    _ownerCinController.dispose();
    super.dispose();
  }
} 