import '../database/database_helper.dart';
import '../../models/attestation.dart';

class AttestationService {
  final DatabaseHelper _db = DatabaseHelper();

  Future<int> createAttestation(Attestation attestation) async {
    try {
      return await _db.insertAttestation(attestation.toMap());
    } catch (e) {
      print('Error creating attestation: $e');
      rethrow;
    }
  }

  Future<List<Attestation>> getAttestationsByUser(int userId) async {
    try {
      final results = await _db.getAttestationsByUser(userId);
      return results.map((map) => Attestation.fromMap(map)).toList();
    } catch (e) {
      print('Error getting attestations: $e');
      return [];
    }
  }

  Future<List<Attestation>> getAttestationsByStatus(int userId, String status) async {
    try {
      final results = await _db.getAttestationsByStatus(userId, status);
      return results.map((map) => Attestation.fromMap(map)).toList();
    } catch (e) {
      print('Error getting attestations by status: $e');
      return [];
    }
  }

  Future<Attestation?> getAttestationById(int id) async {
    try {
      final result = await _db.getAttestationById(id);
      if (result != null) {
        return Attestation.fromMap(result);
      }
      return null;
    } catch (e) {
      print('Error getting attestation: $e');
      return null;
    }
  }

  Future<bool> updateAttestation(Attestation attestation) async {
    try {
      final result = await _db.updateAttestation(attestation.toMap());
      return result > 0;
    } catch (e) {
      print('Error updating attestation: $e');
      return false;
    }
  }

  Future<bool> deleteAttestation(int id) async {
    try {
      final db = await _db.database;
      final result = await db.delete(
        'attestations',
        where: 'id = ?',
        whereArgs: [id],
      );
      return result > 0;
    } catch (e) {
      print('Error deleting attestation: $e');
      return false;
    }
  }
} 