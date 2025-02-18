import 'package:flutter/material.dart';
import '../../../core/themes.dart';
import '../../../widgets/custom_button.dart';

class AttestationVerificationScreen extends StatefulWidget {
  const AttestationVerificationScreen({super.key});

  @override
  State<AttestationVerificationScreen> createState() => _AttestationVerificationScreenState();
}

class _AttestationVerificationScreenState extends State<AttestationVerificationScreen> {
  bool _isScanning = false;
  bool _hasResult = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Vérification d'attestation"),
        backgroundColor: AppColors.primary,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // QR Scanner area
            Expanded(
              flex: 2,
              child: Container(
                margin: const EdgeInsets.symmetric(vertical: 24),
                decoration: BoxDecoration(
                  border: Border.all(color: AppColors.primary, width: 2),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    if (!_isScanning && !_hasResult)
                      Icon(
                        Icons.qr_code_scanner,
                        size: 100,
                        color: AppColors.primary.withOpacity(0.5),
                      )
                    else if (_hasResult)
                      const Icon(
                        Icons.check_circle,
                        size: 100,
                        color: AppColors.success,
                      ),
                  ],
                ),
              ),
            ),
            // Verification result
            if (_hasResult) ...[
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Attestation vérifiée',
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          color: AppColors.success,
                        ),
                      ),
                      const SizedBox(height: 16),
                      _buildInfoRow('Numéro:', 'ATT-2024-001'),
                      _buildInfoRow('Type:', 'Vente'),
                      _buildInfoRow('Véhicule:', 'Toyota Corolla'),
                      _buildInfoRow('Propriétaire:', 'John Doe'),
                      _buildInfoRow('Date:', '2024-03-15'),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),
            ],
            // Action buttons
            CustomButton(
              text: _isScanning 
                ? 'Arrêter le scan' 
                : _hasResult 
                  ? 'Scanner une autre attestation'
                  : 'Scanner le QR code',
              onPressed: () {
                setState(() {
                  if (_isScanning) {
                    _isScanning = false;
                    _hasResult = true;
                  } else {
                    _isScanning = true;
                    _hasResult = false;
                  }
                });
              },
              icon: _isScanning 
                ? Icons.stop 
                : Icons.qr_code_scanner,
              size: ButtonSize.large,
            ),
            if (!_isScanning) ...[
              const SizedBox(height: 16),
              CustomButton(
                text: 'Vérifier par numéro',
                onPressed: () {
                  // Show manual verification dialog
                  showDialog(
                    context: context,
                    builder: (context) => _ManualVerificationDialog(),
                  );
                },
                variant: ButtonVariant.secondary,
                icon: Icons.search,
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Text(
            label,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(width: 8),
          Text(value),
        ],
      ),
    );
  }
}

class _ManualVerificationDialog extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Vérification manuelle'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            decoration: const InputDecoration(
              hintText: "Numéro d'attestation",
              prefixIcon: Icon(Icons.document_scanner),
            ),
          ),
        ],
      ),
      actions: [
        CustomButton(
          text: 'Annuler',
          onPressed: () => Navigator.pop(context),
          variant: ButtonVariant.text,
        ),
        CustomButton(
          text: 'Vérifier',
          onPressed: () => Navigator.pop(context),
          size: ButtonSize.small,
        ),
      ],
    );
  }
} 