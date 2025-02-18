import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'dart:async';
import 'package:crypto/crypto.dart';
import 'dart:convert';
import 'package:flutter/widgets.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  static Database? _database;

  factory DatabaseHelper() => _instance;

  DatabaseHelper._internal();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    // Ensure Flutter bindings are initialized
    WidgetsFlutterBinding.ensureInitialized();

    String path = join(await getDatabasesPath(), 'attestation_app.db');

    return await openDatabase(
      path,
      version: 1,
      onCreate: _createDb,
    );
  }

  Future<void> _createDb(Database db, int version) async {
    // Users table
    await db.execute('''
      CREATE TABLE IF NOT EXISTS users(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        full_name TEXT NOT NULL,
        email TEXT UNIQUE NOT NULL,
        password TEXT NOT NULL,
        phone TEXT,
        cin TEXT,
        address TEXT,
        city TEXT,
        postal_code TEXT,
        country TEXT,
        created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
      )
    ''');

    // Attestations table
    await db.execute('''
      CREATE TABLE IF NOT EXISTS attestations(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        type TEXT NOT NULL,
        vehicle_brand TEXT NOT NULL,
        vehicle_model TEXT NOT NULL,
        plate_number TEXT NOT NULL,
        owner_name TEXT NOT NULL,
        owner_cin TEXT NOT NULL,
        status TEXT NOT NULL,
        created_by INTEGER NOT NULL,
        created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
        FOREIGN KEY (created_by) REFERENCES users (id)
      )
    ''');

    // Vehicles table
    await db.execute('''
      CREATE TABLE IF NOT EXISTS vehicles(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        brand TEXT NOT NULL,
        model TEXT NOT NULL,
        plate_number TEXT UNIQUE NOT NULL,
        color TEXT NOT NULL,
        year INTEGER NOT NULL,
        fuel TEXT NOT NULL,
        power TEXT NOT NULL,
        mileage INTEGER NOT NULL,
        registration_doc TEXT NOT NULL,
        technical_visit TEXT NOT NULL,
        insurance TEXT NOT NULL,
        created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
      )
    ''');
  }

  // User methods
  String _hashPassword(String password) {
    var bytes = utf8.encode(password);
    var digest = sha256.convert(bytes);
    return digest.toString();
  }

  Future<int> insertUser(Map<String, dynamic> user) async {
    Database db = await database;
    user['password'] = _hashPassword(user['password']);
    return await db.insert('users', user);
  }

  Future<Map<String, dynamic>?> authenticateUser(String email, String password) async {
    Database db = await database;
    String hashedPassword = _hashPassword(password);
    
    List<Map<String, dynamic>> result = await db.query(
      'users',
      where: 'email = ? AND password = ?',
      whereArgs: [email, hashedPassword],
    );

    if (result.isNotEmpty) {
      return result.first;
    }
    return null;
  }

  Future<Map<String, dynamic>?> getUserById(int id) async {
    Database db = await database;
    List<Map<String, dynamic>> result = await db.query(
      'users',
      where: 'id = ?',
      whereArgs: [id],
    );
    
    if (result.isNotEmpty) {
      return result.first;
    }
    return null;
  }

  Future<int> updateUser(Map<String, dynamic> user) async {
    Database db = await database;
    return await db.update(
      'users',
      user,
      where: 'id = ?',
      whereArgs: [user['id']],
    );
  }

  // Attestation methods
  Future<int> insertAttestation(Map<String, dynamic> attestation) async {
    Database db = await database;
    return await db.insert('attestations', attestation);
  }

  Future<List<Map<String, dynamic>>> getAttestationsByUser(int userId) async {
    Database db = await database;
    return await db.query(
      'attestations',
      where: 'created_by = ?',
      whereArgs: [userId],
      orderBy: 'created_at DESC',
    );
  }

  Future<List<Map<String, dynamic>>> getAttestationsByStatus(int userId, String status) async {
    Database db = await database;
    return await db.query(
      'attestations',
      where: 'created_by = ? AND status = ?',
      whereArgs: [userId, status],
      orderBy: 'created_at DESC',
    );
  }

  Future<Map<String, dynamic>?> getAttestationById(int id) async {
    Database db = await database;
    List<Map<String, dynamic>> result = await db.query(
      'attestations',
      where: 'id = ?',
      whereArgs: [id],
    );
    
    if (result.isNotEmpty) {
      return result.first;
    }
    return null;
  }

  Future<int> updateAttestation(Map<String, dynamic> attestation) async {
    Database db = await database;
    return await db.update(
      'attestations',
      attestation,
      where: 'id = ?',
      whereArgs: [attestation['id']],
    );
  }

  // Vehicle methods
  Future<int> insertVehicle(Map<String, dynamic> vehicle) async {
    Database db = await database;
    return await db.insert('vehicles', vehicle);
  }

  Future<List<Map<String, dynamic>>> getAllVehicles() async {
    Database db = await database;
    return await db.query('vehicles', orderBy: 'created_at DESC');
  }

  Future<Map<String, dynamic>?> getVehicleByPlate(String plateNumber) async {
    Database db = await database;
    List<Map<String, dynamic>> results = await db.query(
      'vehicles',
      where: 'plate_number = ?',
      whereArgs: [plateNumber],
    );
    if (results.isNotEmpty) {
      return results.first;
    }
    return null;
  }

  Future<void> addSampleVehicles() async {
    final vehicles = [
      {
        'brand': 'Toyota',
        'model': 'Corolla',
        'plate_number': '123 ABC 45',
        'color': 'Gris métallique',
        'year': 2020,
        'fuel': 'Diesel',
        'power': '110 ch',
        'mileage': 45000,
        'registration_doc': 'Valide jusqu\'au 12/2025',
        'technical_visit': 'Valide jusqu\'au 06/2024',
        'insurance': 'À jour',
      },
      {
        'brand': 'Dacia',
        'model': 'Logan',
        'plate_number': '456 DEF 78',
        'color': 'Blanc',
        'year': 2019,
        'fuel': 'Essence',
        'power': '95 ch',
        'mileage': 65000,
        'registration_doc': 'Valide jusqu\'au 10/2024',
        'technical_visit': 'Valide jusqu\'au 03/2024',
        'insurance': 'À jour',
      },
    ];

    final db = await database;
    for (var vehicle in vehicles) {
      try {
        await db.insert('vehicles', vehicle);
      } catch (e) {
        // Skip if vehicle already exists (due to unique plate_number)
        print('Vehicle might already exist: $e');
      }
    }
  }
} 