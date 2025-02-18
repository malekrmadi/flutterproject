import 'package:flutter/material.dart';
import '../../../core/themes.dart';
import '../../../widgets/custom_button.dart';
import '../../../core/services/vehicle_service.dart';
import '../../../models/vehicle.dart';

class VehicleInfoScreen extends StatefulWidget {
  const VehicleInfoScreen({super.key});

  @override
  State<VehicleInfoScreen> createState() => _VehicleInfoScreenState();
}

class _VehicleInfoScreenState extends State<VehicleInfoScreen> {
  final _vehicleService = VehicleService();
  final _searchController = TextEditingController();
  Vehicle? _currentVehicle;
  bool _isLoading = false;
  bool _isInitialized = false;

  @override
  void initState() {
    super.initState();
    _initializeSampleData();
  }

  Future<void> _initializeSampleData() async {
    if (!_isInitialized) {
      await _vehicleService.initializeSampleData();
      _isInitialized = true;
    }
  }

  Future<void> _searchVehicle() async {
    if (_searchController.text.isEmpty) return;

    setState(() => _isLoading = true);
    try {
      final vehicle = await _vehicleService.getVehicleByPlate(_searchController.text.toUpperCase());
      setState(() => _currentVehicle = vehicle);
      
      if (vehicle == null && mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Aucun véhicule trouvé. Essayez avec: 123 ABC 45 ou 456 DEF 78'),
            backgroundColor: AppColors.warning,
            duration: Duration(seconds: 4),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Erreur lors de la recherche'),
            backgroundColor: AppColors.error,
          ),
        );
      }
    } finally {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _addNewVehicle() async {
    // Add vehicle form implementation
    final result = await showDialog<Vehicle>(
      context: context,
      builder: (context) => _AddVehicleDialog(),
    );

    if (result != null) {
      try {
        await _vehicleService.addVehicle(result);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Véhicule ajouté avec succès'),
            backgroundColor: AppColors.success,
          ),
        );
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Erreur lors de l\'ajout du véhicule'),
            backgroundColor: AppColors.error,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Informations Véhicule'),
        backgroundColor: AppColors.primary,
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: _addNewVehicle,
            tooltip: 'Ajouter un véhicule',
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _searchController,
                    decoration: const InputDecoration(
                      hintText: "Numéro d'immatriculation",
                      prefixIcon: Icon(Icons.directions_car),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                CustomButton(
                  text: 'Rechercher',
                  onPressed: _searchVehicle,
                  size: ButtonSize.medium,
                  isLoading: _isLoading,
                ),
              ],
            ),
            const SizedBox(height: 24),
            if (_isLoading)
              const Center(child: CircularProgressIndicator())
            else if (_currentVehicle != null)
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildVehicleHeader(_currentVehicle!),
                      const SizedBox(height: 24),
                      _buildInfoSection(
                        'Informations techniques',
                        {
                          'Année': _currentVehicle!.year.toString(),
                          'Carburant': _currentVehicle!.fuel,
                          'Puissance': _currentVehicle!.power,
                          'Kilométrage': '${_currentVehicle!.mileage} km',
                          'Couleur': _currentVehicle!.color,
                        },
                      ),
                      const SizedBox(height: 24),
                      _buildInfoSection(
                        'Documents',
                        {
                          'Carte grise': _currentVehicle!.registrationDoc,
                          'Contrôle technique': _currentVehicle!.technicalVisit,
                          'Assurance': _currentVehicle!.insurance,
                        },
                      ),
                      const SizedBox(height: 24),
                      CustomButton(
                        text: 'Télécharger le rapport',
                        onPressed: () {
                          // Handle report download
                        },
                        variant: ButtonVariant.secondary,
                        icon: Icons.download,
                      ),
                    ],
                  ),
                ),
              )
            else
              Expanded(
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.search,
                        size: 80,
                        color: AppColors.primary.withOpacity(0.5),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'Entrez un numéro d\'immatriculation\npour voir les informations du véhicule',
                        textAlign: TextAlign.center,
                        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildVehicleHeader(Vehicle vehicle) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            const Icon(Icons.directions_car, size: 48, color: AppColors.primary),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '${vehicle.brand} ${vehicle.model}',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  Text(
                    vehicle.plateNumber,
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoSection(String title, Map<String, String> info) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 16),
            ...info.entries.map((entry) => Padding(
              padding: const EdgeInsets.symmetric(vertical: 4),
              child: Row(
                children: [
                  Text(
                    '${entry.key}:',
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      color: AppColors.textSecondary,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(entry.value),
                ],
              ),
            )),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }
}

class _AddVehicleDialog extends StatefulWidget {
  @override
  State<_AddVehicleDialog> createState() => _AddVehicleDialogState();
}

class _AddVehicleDialogState extends State<_AddVehicleDialog> {
  final _formKey = GlobalKey<FormState>();
  final _brandController = TextEditingController();
  final _modelController = TextEditingController();
  final _plateController = TextEditingController();
  final _colorController = TextEditingController();
  final _yearController = TextEditingController();
  final _fuelController = TextEditingController();
  final _powerController = TextEditingController();
  final _mileageController = TextEditingController();
  final _registrationController = TextEditingController();
  final _technicalVisitController = TextEditingController();
  final _insuranceController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Ajouter un véhicule'),
      content: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                controller: _brandController,
                decoration: const InputDecoration(labelText: 'Marque'),
                validator: (value) => value?.isEmpty ?? true ? 'Champ requis' : null,
              ),
              TextFormField(
                controller: _modelController,
                decoration: const InputDecoration(labelText: 'Modèle'),
                validator: (value) => value?.isEmpty ?? true ? 'Champ requis' : null,
              ),
              TextFormField(
                controller: _plateController,
                decoration: const InputDecoration(labelText: 'Immatriculation'),
                validator: (value) => value?.isEmpty ?? true ? 'Champ requis' : null,
              ),
              // Add other fields...
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Annuler'),
        ),
        TextButton(
          onPressed: () {
            if (_formKey.currentState?.validate() ?? false) {
              final vehicle = Vehicle(
                brand: _brandController.text,
                model: _modelController.text,
                plateNumber: _plateController.text.toUpperCase(),
                color: _colorController.text,
                year: int.tryParse(_yearController.text) ?? 2000,
                fuel: _fuelController.text,
                power: _powerController.text,
                mileage: int.tryParse(_mileageController.text) ?? 0,
                registrationDoc: _registrationController.text,
                technicalVisit: _technicalVisitController.text,
                insurance: _insuranceController.text,
              );
              Navigator.pop(context, vehicle);
            }
          },
          child: const Text('Ajouter'),
        ),
      ],
    );
  }

  @override
  void dispose() {
    _brandController.dispose();
    _modelController.dispose();
    _plateController.dispose();
    _colorController.dispose();
    _yearController.dispose();
    _fuelController.dispose();
    _powerController.dispose();
    _mileageController.dispose();
    _registrationController.dispose();
    _technicalVisitController.dispose();
    _insuranceController.dispose();
    super.dispose();
  }
} 