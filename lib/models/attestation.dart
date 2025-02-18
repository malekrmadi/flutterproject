class Attestation {
  final int? id;
  final String type;
  final String vehicleBrand;
  final String vehicleModel;
  final String plateNumber;
  final String ownerName;
  final String ownerCin;
  final String status;
  final int createdBy;
  final DateTime createdAt;

  Attestation({
    this.id,
    required this.type,
    required this.vehicleBrand,
    required this.vehicleModel,
    required this.plateNumber,
    required this.ownerName,
    required this.ownerCin,
    required this.status,
    required this.createdBy,
    DateTime? createdAt,
  }) : this.createdAt = createdAt ?? DateTime.now();

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'type': type,
      'vehicle_brand': vehicleBrand,
      'vehicle_model': vehicleModel,
      'plate_number': plateNumber,
      'owner_name': ownerName,
      'owner_cin': ownerCin,
      'status': status,
      'created_by': createdBy,
      'created_at': createdAt.toIso8601String(),
    };
  }

  factory Attestation.fromMap(Map<String, dynamic> map) {
    return Attestation(
      id: map['id'],
      type: map['type'],
      vehicleBrand: map['vehicle_brand'],
      vehicleModel: map['vehicle_model'],
      plateNumber: map['plate_number'],
      ownerName: map['owner_name'],
      ownerCin: map['owner_cin'],
      status: map['status'],
      createdBy: map['created_by'],
      createdAt: DateTime.parse(map['created_at']),
    );
  }
} 