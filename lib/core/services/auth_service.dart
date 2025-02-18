import 'package:shared_preferences/shared_preferences.dart';
import '../database/database_helper.dart';

class AuthService {
  static final AuthService _instance = AuthService._internal();
  final DatabaseHelper _db = DatabaseHelper();
  
  factory AuthService() => _instance;
  
  AuthService._internal();

  Future<bool> signUp({
    required String fullName,
    required String email,
    required String password,
    String? phone,
    String? cin,
  }) async {
    try {
      await _db.insertUser({
        'full_name': fullName,
        'email': email,
        'password': password,
        'phone': phone,
        'cin': cin,
      });
      return true;
    } catch (e) {
      print('Error signing up: $e');
      return false;
    }
  }

  Future<bool> signIn(String email, String password) async {
    try {
      final user = await _db.authenticateUser(email, password);
      if (user != null) {
        // Save user session
        final prefs = await SharedPreferences.getInstance();
        await prefs.setInt('user_id', user['id']);
        await prefs.setString('user_email', user['email']);
        await prefs.setString('user_name', user['full_name']);
        return true;
      }
      return false;
    } catch (e) {
      print('Error signing in: $e');
      return false;
    }
  }

  Future<void> signOut() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
  }

  Future<bool> isAuthenticated() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.containsKey('user_id');
  }

  Future<Map<String, dynamic>?> getCurrentUser() async {
    final prefs = await SharedPreferences.getInstance();
    final userId = prefs.getInt('user_id');
    if (userId != null) {
      return await _db.getUserById(userId);
    }
    return null;
  }
} 