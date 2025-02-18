import '../database/database_helper.dart';
import '../../models/vehicle.dart';

class VehicleService {
  final DatabaseHelper _db = DatabaseHelper();

  Future<int> addVehicle(Vehicle vehicle) async {
    try {
      return await _db.insertVehicle(vehicle.toMap());
    } catch (e) {
      print('Error adding vehicle: $e');
      rethrow;
    }
  }

  Future<List<Vehicle>> getAllVehicles() async {
    try {
      final results = await _db.getAllVehicles();
      return results.map((map) => Vehicle.fromMap(map)).toList();
    } catch (e) {
      print('Error getting vehicles: $e');
      return [];
    }
  }

  Future<Vehicle?> getVehicleByPlate(String plateNumber) async {
    try {
      final result = await _db.getVehicleByPlate(plateNumber);
      if (result != null) {
        return Vehicle.fromMap(result);
      }
      return null;
    } catch (e) {
      print('Error getting vehicle: $e');
      return null;
    }
  }

  Future<void> initializeSampleData() async {
    try {
      await _db.addSampleVehicles();
    } catch (e) {
      print('Error initializing sample data: $e');
    }
  }
} 