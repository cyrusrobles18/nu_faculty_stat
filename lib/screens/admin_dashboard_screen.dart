import 'dart:async';

import 'package:faculty_stat_monitoring/services/user_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/user.dart';

class AdminDashboardScreen extends StatefulWidget {
  const AdminDashboardScreen({super.key});

  @override
  State<StatefulWidget> createState() => _AdminDashboardScreenState();
}

class _AdminDashboardScreenState extends State<AdminDashboardScreen> {
  final storage = const FlutterSecureStorage();
  List<User> userList = [];
  final ValueNotifier<List<User>> _userListNotifier =
      ValueNotifier<List<User>>([]);
  bool _isLoading = false; // Track loading state
  Timer? _refreshTimer; // Timer for periodic refresh

  @override
  void initState() {
    super.initState();
    _fetchUsers();
    _startPeriodicRefresh(); // Start the timer
  }

  @override
  void dispose() {
    _refreshTimer?.cancel(); // Cancel the timer to prevent memory leaks
    super.dispose();
  }

  void _startPeriodicRefresh() {
    const refreshInterval =
        Duration(seconds: 5); // Set your desired refresh interval
    _refreshTimer = Timer.periodic(refreshInterval, (timer) {
      _fetchUsers();
    });
  }

  Future<void> _fetchUsers() async {
    if (_isLoading) return; // Prevent multiple concurrent fetches
    _isLoading = true;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('jwt_token');

    if (token == null || token.isEmpty) {
      Navigator.pushReplacementNamed(context, '/login');
      return;
    }

    try {
      UserService userService = UserService();
      userService.token = token;
      await userService.fetchAllUser();
      List<User> fetchedUsers =
          userService.data.map((json) => User.fromJson(json)).toList();
      fetchedUsers =
          fetchedUsers.where((user) => user.role != 'Admin').toList();
      _userListNotifier.value = fetchedUsers; // Update the ValueNotifier
    } catch (e) {
      print('Error fetching users: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error fetching users: $e'),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      _isLoading = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.white,
        title: Image.asset(
          'assets/images/NUCCITLogo.png',
          scale: ScreenUtil().setSp(0.7),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              Navigator.pushNamed(context, '/add-faculty');
            },
          ),
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () async {
              SharedPreferences prefs = await SharedPreferences.getInstance();
              prefs.setString('jwt_token', 'NoValue');
              // await storage.delete(key: 'jwt_token');
              Navigator.pushReplacementNamed(context, '/login');
            },
          ),
        ],
      ),
      body: Container(
        color: Colors.white,
        child: ValueListenableBuilder<List<User>>(
          valueListenable: _userListNotifier,
          builder: (context, users, child) {
            if (_isLoading && users.isEmpty) {
              return const Center(child: CircularProgressIndicator());
            } else if (users.isEmpty) {
              return const Center(child: Text('No users found'));
            } else {
              return RefreshIndicator(
                // Add refresh indicator
                onRefresh: _fetchUsers,
                child: ListView.builder(
                  itemCount: users.length,
                  itemBuilder: (context, index) {
                    User user = users[index];
                    return ListTile(
                      leading: const Icon(Icons.person),
                      title: Text('${user.firstname} ${user.lastname}'),
                      subtitle: Text('Status: ${user.status}'),
                      trailing: Text(user.role),
                    );
                  },
                ),
              );
            }
          },
        ),
      ),
    );
  }
}
