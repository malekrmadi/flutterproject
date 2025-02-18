import 'package:flutter/material.dart';
import '../../widgets/feature_card.dart';
import '../../core/themes.dart';
import '../../core/routes.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 180.0,
            floating: false,
            pinned: true,
            backgroundColor: AppColors.primary,
            flexibleSpace: FlexibleSpaceBar(
              title: Text(
                'Dashboard',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  color: AppColors.background,
                ),
              ),
              background: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topRight,
                    end: Alignment.bottomLeft,
                    colors: [
                      AppColors.primary,
                      AppColors.primaryDark,
                    ],
                  ),
                ),
              ),
            ),
          ),
          SliverPadding(
            padding: const EdgeInsets.all(16.0),
            sliver: SliverGrid(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                mainAxisSpacing: 16.0,
                crossAxisSpacing: 16.0,
                childAspectRatio: 1.0,
              ),
              delegate: SliverChildListDelegate([
                FeatureCard(
                  title: "Gestion des utilisateurs",
                  icon: Icons.people,
                  onTap: () => Navigator.pushNamed(
                    context,
                    AppRoutes.userManagement,
                  ),
                ),
                FeatureCard(
                  title: "Génération d'attestations",
                  icon: Icons.file_copy,
                  onTap: () => Navigator.pushNamed(
                    context,
                    AppRoutes.attestationGenerator,
                  ),
                ),
                FeatureCard(
                  title: "Historique des attestations",
                  icon: Icons.history,
                  onTap: () => Navigator.pushNamed(
                    context,
                    AppRoutes.attestationHistory,
                  ),
                ),
                FeatureCard(
                  title: "Vérification d'attestation",
                  icon: Icons.verified,
                  onTap: () => Navigator.pushNamed(
                    context,
                    AppRoutes.attestationVerification,
                  ),
                ),
                FeatureCard(
                  title: "Accès aux infos véhicules",
                  icon: Icons.directions_car,
                  onTap: () => Navigator.pushNamed(
                    context,
                    AppRoutes.vehicleInfo,
                  ),
                ),
                FeatureCard(
                  title: "Consulter mes attestations",
                  icon: Icons.assignment,
                  onTap: () => Navigator.pushNamed(
                    context,
                    AppRoutes.myAttestations,
                  ),
                ),
                FeatureCard(
                  title: "Modifier mon profil",
                  icon: Icons.person,
                  onTap: () => Navigator.pushNamed(
                    context,
                    AppRoutes.profile,
                  ),
                ),
              ]),
            ),
          ),
        ],
      ),
    );
  }
}
