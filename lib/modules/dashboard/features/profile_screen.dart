import 'package:flutter/material.dart';
import '../../../core/themes.dart';
import '../../../widgets/custom_button.dart';
import '../../../core/services/auth_service.dart';
import '../../../core/routes.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final _authService = AuthService();
  bool _isLoading = false;
  Map<String, dynamic>? _userData;

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    setState(() => _isLoading = true);
    try {
      final userData = await _authService.getCurrentUser();
      setState(() => _userData = userData);
    } catch (e) {
      print('Error loading user data: $e');
    } finally {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _handleLogout() async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Confirmation'),
        content: const Text('Êtes-vous sûr de vouloir vous déconnecter ?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Annuler'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text(
              'Déconnecter',
              style: TextStyle(color: AppColors.error),
            ),
          ),
        ],
      ),
    );

    if (confirm == true) {
      setState(() => _isLoading = true);
      try {
        await _authService.signOut();
        if (mounted) {
          // Navigate to login and clear navigation stack
          Navigator.pushNamedAndRemoveUntil(
            context, 
            AppRoutes.login,
            (route) => false,
          );
        }
      } catch (e) {
        print('Error during logout: $e');
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Erreur lors de la déconnexion'),
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
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Mon Profil'),
        backgroundColor: AppColors.primary,
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: _handleLogout,
            tooltip: 'Déconnexion',
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Profile Header
            CircleAvatar(
              radius: 50,
              backgroundColor: AppColors.primary.withOpacity(0.1),
              child: Text(
                _userData?['full_name']?[0].toUpperCase() ?? 'U',
                style: const TextStyle(
                  fontSize: 36,
                  color: AppColors.primary,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(height: 16),
            Text(
              _userData?['full_name'] ?? 'Utilisateur',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            Text(
              _userData?['email'] ?? '',
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
            const SizedBox(height: 32),

            // Profile Sections
            _buildSection(
              'Informations personnelles',
              {
                'Nom complet': _userData?['full_name'] ?? 'N/A',
                'Email': _userData?['email'] ?? 'N/A',
                'Téléphone': _userData?['phone'] ?? 'Non renseigné',
                'CIN': _userData?['cin'] ?? 'Non renseigné',
              },
            ),
            const SizedBox(height: 16),
            _buildSection(
              'Adresse',
              {
                'Ville': _userData?['city'] ?? 'Non renseignée',
                'Code postal': _userData?['postal_code'] ?? 'Non renseigné',
                'Pays': _userData?['country'] ?? 'Non renseigné',
              },
            ),
            const SizedBox(height: 32),
            CustomButton(
              text: 'Se déconnecter',
              onPressed: _handleLogout,
              variant: ButtonVariant.secondary,
              icon: Icons.logout,
              size: ButtonSize.large,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSection(String title, Map<String, String> fields) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            ...fields.entries.map((entry) => Padding(
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    width: 120,
                    child: Text(
                      '${entry.key}:',
                      style: const TextStyle(
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ),
                  Expanded(
                    child: Text(
                      entry.value,
                      style: const TextStyle(
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
            )),
          ],
        ),
      ),
    );
  }
} 