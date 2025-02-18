class Vehicle {
  final int? id;
  final String brand;
  final String model;
  final String plateNumber;
  final String color;
  final int year;
  final String fuel;
  final String power;
  final int mileage;
  final String registrationDoc;
  final String technicalVisit;
  final String insurance;
  final DateTime createdAt;

  Vehicle({
    this.id,
    required this.brand,
    required this.model,
    required this.plateNumber,
    required this.color,
    required this.year,
    required this.fuel,
    required this.power,
    required this.mileage,
    required this.registrationDoc,
    required this.technicalVisit,
    required this.insurance,
    DateTime? createdAt,
  }) : this.createdAt = createdAt ?? DateTime.now();

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'brand': brand,
      'model': model,
      'plate_number': plateNumber,
      'color': color,
      'year': year,
      'fuel': fuel,
      'power': power,
      'mileage': mileage,
      'registration_doc': registrationDoc,
      'technical_visit': technicalVisit,
      'insurance': insurance,
      'created_at': createdAt.toIso8601String(),
    };
  }

  factory Vehicle.fromMap(Map<String, dynamic> map) {
    return Vehicle(
      id: map['id'],
      brand: map['brand'],
      model: map['model'],
      plateNumber: map['plate_number'],
      color: map['color'],
      year: map['year'],
      fuel: map['fuel'],
      power: map['power'],
      mileage: map['mileage'],
      registrationDoc: map['registration_doc'],
      technicalVisit: map['technical_visit'],
      insurance: map['insurance'],
      createdAt: DateTime.parse(map['created_at']),
    );
  }
} 