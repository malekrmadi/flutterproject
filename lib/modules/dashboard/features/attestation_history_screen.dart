import 'package:flutter/material.dart';
import '../../../core/themes.dart';
import '../../../widgets/custom_button.dart';
import '../../../core/services/attestation_service.dart';
import '../../../core/services/auth_service.dart';
import '../../../models/attestation.dart';

class AttestationHistoryScreen extends StatefulWidget {
  const AttestationHistoryScreen({super.key});

  @override
  State<AttestationHistoryScreen> createState() => _AttestationHistoryScreenState();
}

class _AttestationHistoryScreenState extends State<AttestationHistoryScreen> {
  final _attestationService = AttestationService();
  final _authService = AuthService();
  final _searchController = TextEditingController();
  
  List<Attestation> _attestations = [];
  List<Attestation> _filteredAttestations = [];
  bool _isLoading = true;
  String _selectedStatusFilter = 'Tous';

  @override
  void initState() {
    super.initState();
    _loadAttestations();
  }

  Future<void> _loadAttestations() async {
    setState(() => _isLoading = true);
    try {
      final currentUser = await _authService.getCurrentUser();
      if (currentUser != null) {
        final attestations = await _attestationService.getAttestationsByUser(currentUser['id']);
        setState(() {
          _attestations = attestations;
          _applyFilters();
        });
      }
    } catch (e) {
      print('Error loading attestations: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Erreur lors du chargement des attestations'),
          backgroundColor: AppColors.error,
        ),
      );
    } finally {
      setState(() => _isLoading = false);
    }
  }

  void _applyFilters() {
    var filtered = List<Attestation>.from(_attestations);
    
    // Apply status filter
    if (_selectedStatusFilter != 'Tous') {
      filtered = filtered.where((a) => a.status == _selectedStatusFilter.toLowerCase()).toList();
    }

    // Apply search filter
    if (_searchController.text.isNotEmpty) {
      final query = _searchController.text.toLowerCase();
      filtered = filtered.where((a) => 
        a.plateNumber.toLowerCase().contains(query) ||
        a.ownerName.toLowerCase().contains(query) ||
        a.ownerCin.toLowerCase().contains(query)
      ).toList();
    }

    setState(() => _filteredAttestations = filtered);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Historique des attestations'),
        backgroundColor: AppColors.primary,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                // Search bar
                TextField(
                  controller: _searchController,
                  decoration: const InputDecoration(
                    hintText: 'Rechercher une attestation',
                    prefixIcon: Icon(Icons.search),
                  ),
                  onChanged: (_) => _applyFilters(),
                ),
                const SizedBox(height: 16),
                // Status filter
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      'Tous',
                      'En cours',
                      'Validée',
                      'Expirée',
                      'Annulée'
                    ].map((status) => Padding(
                      padding: const EdgeInsets.only(right: 8),
                      child: ChoiceChip(
                        label: Text(status),
                        selected: _selectedStatusFilter == status,
                        onSelected: (selected) {
                          if (selected) {
                            setState(() {
                              _selectedStatusFilter = status;
                              _applyFilters();
                            });
                          }
                        },
                      ),
                    )).toList(),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: _isLoading
                ? const Center(child: CircularProgressIndicator())
                : _filteredAttestations.isEmpty
                    ? const Center(child: Text('Aucune attestation trouvée'))
                    : ListView.builder(
                        itemCount: _filteredAttestations.length,
                        itemBuilder: (context, index) {
                          final attestation = _filteredAttestations[index];
                          return Card(
                            margin: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 8,
                            ),
                            child: ExpansionTile(
                              leading: _getStatusIcon(attestation.status),
                              title: Text('${attestation.type} - ${attestation.plateNumber}'),
                              subtitle: Text(
                                'Créée le ${attestation.createdAt.toString().substring(0, 10)}',
                              ),
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(16.0),
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
                                          CustomButton(
                                            text: 'Voir PDF',
                                            onPressed: () {
                                              // Handle PDF view
                                            },
                                            variant: ButtonVariant.text,
                                            icon: Icons.visibility,
                                          ),
                                          const SizedBox(width: 8),
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
                      ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _loadAttestations,
        backgroundColor: AppColors.primary,
        icon: const Icon(Icons.refresh),
        label: const Text('Actualiser'),
      ),
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
      case 'en cours':
        iconData = Icons.pending;
        color = AppColors.warning;
        break;
      case 'validated':
      case 'validée':
        iconData = Icons.check_circle;
        color = AppColors.success;
        break;
      case 'expired':
      case 'expirée':
        iconData = Icons.error;
        color = AppColors.error;
        break;
      case 'cancelled':
      case 'annulée':
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
    _searchController.dispose();
    super.dispose();
  }
} 