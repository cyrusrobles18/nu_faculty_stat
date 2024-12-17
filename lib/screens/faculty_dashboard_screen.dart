// lib/screens/status_update_screen.dart

import 'package:faculty_stat_monitoring/constants.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

class FacultyDashboardScreen extends StatefulWidget {
  const FacultyDashboardScreen({super.key});

  @override
  State<StatefulWidget> createState() => _FacultyDashboardScreenState();
}

class _FacultyDashboardScreenState extends State<FacultyDashboardScreen> {
  String _selectedStatus = 'Out';
  List<String> statuses = ['In', 'Out', 'On Meeting', 'Out of Office'];
  final storage = const FlutterSecureStorage();

  Future<void> _updateStatus() async {
    // String? token = await storage.read(key: 'jwt_token');
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('jwt_token');
    if (token == null) {
      Navigator.pushReplacementNamed(context, '/success');
      return;
    }

    final url = Uri.parse('$HOST/api/status');
    final response = await http.put(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode({'status': _selectedStatus}),
    );

    if (response.statusCode == 200) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Status updated')));
    } else if (response.statusCode == 401) {
      // Unauthorized, handle accordingly
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Please log in')));
    } else if (response.statusCode == 403) {
      // Forbidden, handle accordingly
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Access denied')));
    } else {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Failed to update status')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Update Status'),
        automaticallyImplyLeading: false,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            DropdownButton<String>(
              value: _selectedStatus,
              items: statuses.map((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
              onChanged: (newStatus) {
                setState(() {
                  _selectedStatus = newStatus!;
                });
              },
            ),
            SizedBox(height: 20),
            ElevatedButton(
              child: Text('Update Status'),
              onPressed: _updateStatus,
            ),
            IconButton(
              icon: Icon(Icons.logout),
              onPressed: () async {
                SharedPreferences prefs = await SharedPreferences.getInstance();
                prefs.setString('jwt_token', 'NoValue');
                Navigator.pushReplacementNamed(context, '/login');
              },
            ),
          ],
        ),
      ),
    );
  }
}
