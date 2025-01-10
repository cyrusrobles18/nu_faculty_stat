// lib/screens/status_update_screen.dart

import 'package:faculty_stat_monitoring/constants.dart';
import 'package:faculty_stat_monitoring/widgets/custom_click_card.dart';
import 'package:faculty_stat_monitoring/widgets/custom_font.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
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
  late SharedPreferences prefs;
  String name = '';
  String status = '';
  Future<void> _updateStatus() async {
    // String? token = await storage.read(key: 'jwt_token');
    prefs = await SharedPreferences.getInstance();
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
    print(jsonDecode(response.body)['currentUser']);
    // status = jsonDecode(response.body)[0]['status'];
    var data = jsonDecode(response.body);
    prefs.setString('data', jsonEncode(data['currentUser']));
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

  Future<void> getInfo() async {
    prefs = await SharedPreferences.getInstance();
    String data = prefs.getString('data') ?? '';
    name = jsonDecode(data)['firstname'];
    status = jsonDecode(data)['status'];
    print(name);
    print(status);
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: getInfo(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          return Scaffold(
            body: Column(
              children: <Widget>[
                Container(
                  padding: EdgeInsets.all(ScreenUtil().setSp(20)),
                  decoration: BoxDecoration(
                    color: NU_BLUE,
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(ScreenUtil().setSp(20)),
                      bottomRight: Radius.circular(ScreenUtil().setSp(20)),
                    ),
                  ),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          CircleAvatar(
                            radius: ScreenUtil().setSp(30),
                            backgroundColor: NU_YELLOW,
                            backgroundImage:
                                AssetImage('assets/images/NUShield.png'),
                          ),
                          IconButton(
                            icon: Icon(
                              Icons.logout,
                              color: NU_YELLOW,
                            ),
                            onPressed: () async {
                              SharedPreferences prefs =
                                  await SharedPreferences.getInstance();
                              prefs.setString('jwt_token', 'NoValue');
                              Navigator.pushReplacementNamed(context, '/login');
                            },
                          ),
                        ],
                      ),
                      SizedBox(height: ScreenUtil().setHeight(10)),
                      Align(
                        alignment: Alignment.bottomLeft,
                        child: CustomFont(
                          text: 'Welcome, $name',
                          fontSize: ScreenUtil().setSp(20),
                          color: NU_YELLOW,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Align(
                        alignment: Alignment.topLeft,
                        child: CustomFont(
                          text: 'Status, $status',
                          fontSize: ScreenUtil().setSp(15),
                          color: NU_YELLOW,
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: ScreenUtil().setHeight(30)),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CustomClickCard(
                      height: ScreenUtil().setHeight(90),
                      width: ScreenUtil().setWidth(110),
                      text: 'In',
                      cardColor: STAT_GREEN,
                      fontColor: Colors.white,
                      fontSize: ScreenUtil().setSp(12),
                      icon: Icon(
                        Icons.punch_clock,
                        color: Colors.white,
                        size: ScreenUtil().setSp(50),
                      ),
                    ),
                    CustomClickCard(
                      height: ScreenUtil().setHeight(90),
                      width: ScreenUtil().setWidth(110),
                      text: 'Out',
                      cardColor: STAT_GREEN,
                      fontColor: Colors.white,
                      fontSize: ScreenUtil().setSp(12),
                      icon: Icon(
                        Icons.punch_clock,
                        color: Colors.white,
                        size: ScreenUtil().setSp(50),
                      ),
                    )
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CustomClickCard(
                      height: ScreenUtil().setHeight(90),
                      width: ScreenUtil().setWidth(110),
                      text: 'In',
                      cardColor: STAT_GREEN,
                      fontColor: Colors.white,
                      fontSize: ScreenUtil().setSp(12),
                      icon: Icon(
                        Icons.punch_clock,
                        color: Colors.white,
                        size: ScreenUtil().setSp(50),
                      ),
                    ),
                    CustomClickCard(
                      height: ScreenUtil().setHeight(90),
                      width: ScreenUtil().setWidth(110),
                      text: 'Out',
                      cardColor: STAT_GREEN,
                      fontColor: Colors.white,
                      fontSize: ScreenUtil().setSp(12),
                      icon: Icon(
                        Icons.punch_clock,
                        color: Colors.white,
                        size: ScreenUtil().setSp(50),
                      ),
                    )
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CustomClickCard(
                      height: ScreenUtil().setHeight(90),
                      width: ScreenUtil().setWidth(110),
                      text: 'In',
                      cardColor: STAT_GREEN,
                      fontColor: Colors.white,
                      fontSize: ScreenUtil().setSp(12),
                      icon: Icon(
                        Icons.punch_clock,
                        color: Colors.white,
                        size: ScreenUtil().setSp(50),
                      ),
                    ),
                    CustomClickCard(
                      height: ScreenUtil().setHeight(90),
                      width: ScreenUtil().setWidth(110),
                      text: 'Out',
                      cardColor: STAT_GREEN,
                      fontColor: Colors.white,
                      fontSize: ScreenUtil().setSp(12),
                      icon: Icon(
                        Icons.punch_clock,
                        color: Colors.white,
                        size: ScreenUtil().setSp(50),
                      ),
                    )
                  ],
                ),
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
                  onPressed: () {
                    _updateStatus();
                  },
                ),
              ],
            ),
          );
        } else {
          return Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        }
      },
    );
  }
}
