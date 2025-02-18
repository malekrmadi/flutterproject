import 'package:flutter/material.dart';
import '../../core/themes.dart';
import '../../core/database/database_helper.dart';
import '../../widgets/custom_button.dart';

class UserDatabaseScreen extends StatefulWidget {
  const UserDatabaseScreen({super.key});

  @override
  State<UserDatabaseScreen> createState() => _UserDatabaseScreenState();
}

class _UserDatabaseScreenState extends State<UserDatabaseScreen> {
  final DatabaseHelper _db = DatabaseHelper();
  List<Map<String, dynamic>> _users = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadUsers();
  }

  Future<void> _loadUsers() async {
    setState(() => _isLoading = true);
    final db = await _db.database;
    final users = await db.query('users');
    setState(() {
      _users = users;
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('User Database'),
        backgroundColor: AppColors.primary,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _loadUsers,
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _users.isEmpty
              ? const Center(child: Text('No users found'))
              : ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: _users.length,
                  itemBuilder: (context, index) {
                    final user = _users[index];
                    return Card(
                      margin: const EdgeInsets.only(bottom: 16),
                      child: ExpansionTile(
                        leading: CircleAvatar(
                          backgroundColor: AppColors.primary.withOpacity(0.1),
                          child: Text(
                            user['full_name'][0].toUpperCase(),
                            style: const TextStyle(
                              color: AppColors.primary,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        title: Text(user['full_name'] ?? 'N/A'),
                        subtitle: Text(user['email'] ?? 'N/A'),
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                _buildDetailRow('ID:', user['id'].toString()),
                                _buildDetailRow('Phone:', user['phone'] ?? 'N/A'),
                                _buildDetailRow('CIN:', user['cin'] ?? 'N/A'),
                                _buildDetailRow('Address:', user['address'] ?? 'N/A'),
                                _buildDetailRow('City:', user['city'] ?? 'N/A'),
                                _buildDetailRow('Created:', user['created_at'] ?? 'N/A'),
                                const SizedBox(height: 16),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    CustomButton(
                                      text: 'Delete User',
                                      onPressed: () async {
                                        final confirm = await showDialog<bool>(
                                          context: context,
                                          builder: (context) => AlertDialog(
                                            title: const Text('Confirm Delete'),
                                            content: const Text(
                                              'Are you sure you want to delete this user?'
                                            ),
                                            actions: [
                                              TextButton(
                                                onPressed: () => 
                                                  Navigator.pop(context, false),
                                                child: const Text('Cancel'),
                                              ),
                                              TextButton(
                                                onPressed: () => 
                                                  Navigator.pop(context, true),
                                                child: const Text(
                                                  'Delete',
                                                  style: TextStyle(
                                                    color: AppColors.error
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        );

                                        if (confirm == true) {
                                          final db = await _db.database;
                                          await db.delete(
                                            'users',
                                            where: 'id = ?',
                                            whereArgs: [user['id']],
                                          );
                                          _loadUsers();
                                        }
                                      },
                                      variant: ButtonVariant.secondary,
                                      icon: Icons.delete,
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
} 