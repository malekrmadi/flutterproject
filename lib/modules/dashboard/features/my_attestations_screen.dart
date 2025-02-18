import 'package:flutter/material.dart';
import '../../../core/themes.dart';
import '../../../widgets/custom_button.dart';
import '../../../core/services/attestation_service.dart';
import '../../../core/services/auth_service.dart';
import '../../../models/attestation.dart';
import '../../../core/routes.dart';

class MyAttestationsScreen extends StatefulWidget {
  const MyAttestationsScreen({super.key});

  @override
  State<MyAttestationsScreen> createState() => _MyAttestationsScreenState();
}

class _MyAttestationsScreenState extends State<MyAttestationsScreen> with SingleTickerProviderStateMixin {
  final _attestationService = AttestationService();
  final _authService = AuthService();
  late TabController _tabController;
  bool _isLoading = true;
  List<Attestation> _attestations = [];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _loadAttestations();
  }

  Future<void> _loadAttestations() async {
    setState(() => _isLoading = true);
    try {
      final currentUser = await _authService.getCurrentUser();
      if (currentUser != null) {
        final attestations = await _attestationService.getAttestationsByUser(currentUser['id']);
        setState(() => _attestations = attestations);
      }
    } catch (e) {
      print('Error loading attestations: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Erreur lors du chargement des attestations'),
            backgroundColor: AppColors.error,
          ),
        );
      }
    } finally {
      setState(() => _isLoading = false);
    }
  }

  List<Attestation> _getFilteredAttestations() {
    switch (_tabController.index) {
      case 0: // En cours
        return _attestations.where((a) => a.status.toLowerCase() == 'pending').toList();
      case 1: // Validées
        return _attestations.where((a) => a.status.toLowerCase() == 'validated').toList();
      case 2: // Expirées
        return _attestations.where((a) => 
          a.status.toLowerCase() == 'expired' || 
          a.status.toLowerCase() == 'cancelled'
        ).toList();
      default:
        return [];
    }
  }

  Future<void> _deleteAttestation(Attestation attestation) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Confirmer la suppression'),
        content: const Text('Êtes-vous sûr de vouloir supprimer cette attestation ?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Annuler'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text(
              'Supprimer',
              style: TextStyle(color: AppColors.error),
            ),
          ),
        ],
      ),
    );

    if (confirm == true) {
      try {
        final success = await _attestationService.deleteAttestation(attestation.id!);
        if (success) {
          _loadAttestations();
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Attestation supprimée avec succès'),
                backgroundColor: AppColors.success,
              ),
            );
          }
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Erreur lors de la suppression'),
              backgroundColor: AppColors.error,
            ),
          );
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Mes attestations'),
        backgroundColor: AppColors.primary,
        bottom: TabBar(
          controller: _tabController,
          onTap: (_) => setState(() {}), // Refresh list on tab change
          tabs: const [
            Tab(text: 'En cours'),
            Tab(text: 'Validées'),
            Tab(text: 'Expirées'),
          ],
        ),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : RefreshIndicator(
              onRefresh: _loadAttestations,
              child: _buildAttestationsList(),
            ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () async {
          await Navigator.pushNamed(context, AppRoutes.attestationGenerator);
          _loadAttestations(); // Refresh list after returning
        },
        backgroundColor: AppColors.primary,
        icon: const Icon(Icons.add),
        label: const Text('Nouvelle attestation'),
      ),
    );
  }

  Widget _buildAttestationsList() {
    final filteredAttestations = _getFilteredAttestations();
    
    if (filteredAttestations.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.description_outlined,
              size: 80,
              color: AppColors.primary.withOpacity(0.5),
            ),
            const SizedBox(height: 16),
            Text(
              'Aucune attestation trouvée',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: filteredAttestations.length,
      itemBuilder: (context, index) {
        final attestation = filteredAttestations[index];
        return Card(
          margin: const EdgeInsets.only(bottom: 16),
          child: ExpansionTile(
            leading: _getStatusIcon(attestation.status),
            title: Text('${attestation.type} - ${attestation.plateNumber}'),
            subtitle: Text(
              'Créée le ${attestation.createdAt.toString().substring(0, 10)}',
            ),
            children: [
              Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildDetailRow('Véhicule:', '${attestation.vehicleBrand} ${attestation.vehicleModel}'),
                    _buildDetailRow('Propriétaire:', attestation.ownerName),
                    _buildDetailRow('CIN:', attestation.ownerCin),
                    _buildDetailRow('Statut:', attestation.status),
                    const SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        if (attestation.status.toLowerCase() == 'pending') ...[
                          CustomButton(
                            text: 'Modifier',
                            onPressed: () {
                              // Handle edit
                            },
                            variant: ButtonVariant.text,
                            icon: Icons.edit,
                          ),
                          const SizedBox(width: 8),
                          CustomButton(
                            text: 'Supprimer',
                            onPressed: () => _deleteAttestation(attestation),
                            variant: ButtonVariant.text,
                            icon: Icons.delete,
                          ),
                          const SizedBox(width: 8),
                        ],
                        CustomButton(
                          text: 'Télécharger',
                          onPressed: () {
                            // Handle download
                          },
                          variant: ButtonVariant.secondary,
                          icon: Icons.download,
                          size: ButtonSize.small,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 100,
            child: Text(
              label,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                color: AppColors.textSecondary,
              ),
            ),
          ),
          Expanded(
            child: Text(value),
          ),
        ],
      ),
    );
  }

  Widget _getStatusIcon(String status) {
    IconData iconData;
    Color color;

    switch (status.toLowerCase()) {
      case 'pending':
        iconData = Icons.pending;
        color = AppColors.warning;
        break;
      case 'validated':
        iconData = Icons.check_circle;
        color = AppColors.success;
        break;
      case 'expired':
        iconData = Icons.error;
        color = AppColors.error;
        break;
      case 'cancelled':
        iconData = Icons.cancel;
        color = AppColors.error;
        break;
      default:
        iconData = Icons.info;
        color = AppColors.primary;
    }

    return CircleAvatar(
      backgroundColor: color.withOpacity(0.1),
      child: Icon(iconData, color: color),
    );
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }
} 