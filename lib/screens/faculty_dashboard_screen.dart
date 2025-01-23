// lib/screens/status_update_screen.dart

import 'dart:async';

import 'package:faculty_stat_monitoring/constants.dart';
import 'package:faculty_stat_monitoring/models/user.dart';
import 'package:faculty_stat_monitoring/widgets/custom_click_card.dart';
import 'package:faculty_stat_monitoring/widgets/custom_dialogs.dart';
import 'package:faculty_stat_monitoring/widgets/custom_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../widgets/custom_button.dart';
import '../widgets/custom_pulse_icon.dart';
import '../widgets/custom_textformfield.dart';

class FacultyDashboardScreen extends StatefulWidget {
  const FacultyDashboardScreen({super.key});

  @override
  State<StatefulWidget> createState() => _FacultyDashboardScreenState();
}

class _FacultyDashboardScreenState extends State<FacultyDashboardScreen> {
  TextEditingController inputController = TextEditingController();
  String _selectedStatus = 'Out';
  final List<String> statuses = ['In', 'Out', 'On Meeting', 'Out of Office'];
  final storage = const FlutterSecureStorage();
  late SharedPreferences prefs;
  String name = '';
  String status = '';
  late User user;
  Timer? _refreshTimer;
  var data;

  @override
  void initState() {
    super.initState();
  }

  Future<User> getInfo() async {
    try {
      prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('jwt_token');
      final id = prefs.getInt('id');
      if (token == null ||
          token == 'NoValue' ||
          id == null ||
          token == 'NoValue') {
        Navigator.pushReplacementNamed(context, '/success');
      }
      final url = Uri.parse('$HOST/api/users/$id');
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      print(response.body);

      if (response.statusCode == 200) {
        var body = jsonDecode(response.body);
        user = User(
            id: body['currentUser']['id'],
            firstname: body['currentUser']['firstname'],
            lastname: body['currentUser']['lastname'],
            email: body['currentUser']['email'],
            status: body['currentUser']['status'],
            role: body['currentUser']['role'],
            password: body['currentUser']['password']);

        status = user.status;
        print(status);
        name = user.firstname;
        print(name);
        return user;
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Failed to getinfo')),
        );
      }
    } catch (e) {}
    return User(
        id: 0,
        firstname: '',
        lastname: '',
        email: '',
        status: status,
        role: '',
        password: '');
  }

  @override
  void dispose() {
    super.dispose();
  }

  Future<void> _updateStatus() async {
    final token = prefs.getString('jwt_token');
    if (token == null || token == 'NoValue') {
      Navigator.pushReplacementNamed(context, '/success');
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
    // ignore: use_build_context_synchronously
    showLoadingDialog(context);
    if (response.statusCode == 200) {
      final body = jsonDecode(response.body);
      print(data);
      user = User(
          id: body['currentUser']['id'],
          firstname: body['currentUser']['firstname'],
          lastname: body['currentUser']['lastname'],
          email: body['currentUser']['email'],
          status: body['currentUser']['status'],
          role: body['currentUser']['role'],
          password: body['currentUser']['password']);
      Navigator.pop(context);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to update status')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: <Widget>[
          FutureBuilder<User>(
            future: getInfo(),
            builder: (BuildContext context, AsyncSnapshot snapshot) {
              if (snapshot.hasData) {
                return Container(
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
                                const AssetImage('assets/images/NUShield.png'),
                          ),
                          IconButton(
                            icon: const Icon(Icons.logout, color: NU_YELLOW),
                            onPressed: () async {
                              final prefs =
                                  await SharedPreferences.getInstance();
                              prefs.setString('jwt_token', 'NoValue');
                              Navigator.pushReplacementNamed(context, '/login');
                            },
                          ),
                        ],
                      ),
                      SizedBox(height: ScreenUtil().setHeight(10)),
                      Align(
                        alignment: Alignment.topLeft,
                        child: CustomText(
                          text: 'Welcome, ${user.firstname}',
                          fontSize: ScreenUtil().setSp(20),
                          color: NU_YELLOW,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Align(
                        alignment: Alignment.topLeft,
                        child: CustomText(
                          text: 'Status: ${user.status}',
                          fontSize: ScreenUtil().setSp(15),
                          color: NU_YELLOW,
                        ),
                      ),
                    ],
                  ),
                );
              } else {
                return Container(
                    padding: EdgeInsets.all(ScreenUtil().setSp(20)),
                    decoration: BoxDecoration(
                      color: NU_BLUE,
                      borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(ScreenUtil().setSp(20)),
                        bottomRight: Radius.circular(ScreenUtil().setSp(20)),
                      ),
                    ),
                    child: Center(child: CustomPulseIcon()));
              }
            },
          ),
          SizedBox(height: ScreenUtil().setHeight(30)),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CustomClickCard(
                height: ScreenUtil().setHeight(130),
                width: ScreenUtil().setWidth(150),
                text: 'In',
                cardColor: STAT_GREEN_IN,
                fontColor: Colors.white,
                fontSize: ScreenUtil().setSp(12),
                icon: Icon(
                  Icons.punch_clock,
                  color: Colors.white,
                  size: ScreenUtil().setSp(50),
                ),
                onTap: () {
                  setState(() {
                    _selectedStatus = 'In';
                    showConfirmDialog(
                      context,
                      'Confirm',
                      'Are you sure to want updated you status to $_selectedStatus',
                      () {
                        setState(() {
                          _updateStatus();
                        });
                      },
                    );
                  });
                },
              ),
              CustomClickCard(
                height: ScreenUtil().setHeight(130),
                width: ScreenUtil().setWidth(150),
                text: 'Out',
                cardColor: STAT_RED_OUT,
                fontColor: Colors.white,
                fontSize: ScreenUtil().setSp(12),
                icon: Icon(
                  Icons.directions_walk,
                  color: Colors.white,
                  size: ScreenUtil().setSp(50),
                ),
                onTap: () {
                  setState(() {
                    _selectedStatus = 'Out';
                    showConfirmDialog(
                      context,
                      'Confirm',
                      'Are you sure to want updated you status to $_selectedStatus',
                      () {
                        setState(() {
                          _updateStatus();
                        });
                      },
                    );
                  });
                },
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CustomClickCard(
                height: ScreenUtil().setHeight(130),
                width: ScreenUtil().setWidth(150),
                text: 'On Meeting',
                cardColor: STAT_ORANGE_MEETING,
                fontColor: Colors.white,
                fontSize: ScreenUtil().setSp(12),
                icon: Icon(
                  Icons.meeting_room,
                  color: Colors.white,
                  size: ScreenUtil().setSp(50),
                ),
                onTap: () {
                  setState(() {
                    _selectedStatus = 'On Meeting';
                    showConfirmDialog(
                      context,
                      'Confirm',
                      'Are you sure to want updated you status to $_selectedStatus',
                      () {
                        setState(() {
                          _updateStatus();
                        });
                      },
                    );
                  });
                },
              ),
              CustomClickCard(
                height: ScreenUtil().setHeight(130),
                width: ScreenUtil().setWidth(150),
                text: 'Out of Office',
                cardColor: STAT_YELLOW_OTOFFICE,
                fontColor: Colors.black54,
                fontSize: ScreenUtil().setSp(12),
                icon: Icon(
                  Icons.business,
                  color: Colors.black54,
                  size: ScreenUtil().setSp(50),
                ),
                onTap: () {
                  setState(() {
                    _selectedStatus = 'Out of Office';
                    showConfirmDialog(
                      context,
                      'Confirm',
                      'Are you sure to want updated you status to $_selectedStatus',
                      () {
                        setState(() {
                          _updateStatus();
                        });
                      },
                    );
                  });
                },
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CustomClickCard(
                height: ScreenUtil().setHeight(130),
                width: ScreenUtil().setWidth(150),
                text: 'In Class',
                cardColor: STAT_BLUE_INCLASS,
                fontColor: Colors.white,
                fontSize: ScreenUtil().setSp(12),
                icon: Icon(
                  Icons.class_,
                  color: Colors.white,
                  size: ScreenUtil().setSp(50),
                ),
                onTap: () {
                  setState(() {
                    _selectedStatus = 'In Class';
                    showConfirmDialog(
                      context,
                      'Confirm',
                      'Are you sure to want updated you status to $_selectedStatus',
                      () {
                        setState(() {
                          _updateStatus();
                        });
                      },
                    );
                  });
                },
              ),
              CustomClickCard(
                height: ScreenUtil().setHeight(130),
                width: ScreenUtil().setWidth(150),
                text: 'On Leave',
                cardColor: STAT_RED_ONLEAVE,
                fontColor: Colors.white,
                fontSize: ScreenUtil().setSp(12),
                icon: Icon(
                  Icons.exit_to_app,
                  color: Colors.white,
                  size: ScreenUtil().setSp(50),
                ),
                onTap: () {
                  setState(() {
                    _selectedStatus = 'On Leave';
                    showConfirmDialog(
                      context,
                      'Confirm',
                      'Are you sure to want updated you status to $_selectedStatus',
                      () {
                        setState(() {
                          _updateStatus();
                        });
                      },
                    );
                  });
                },
              ),
            ],
          ),
          SizedBox(height: ScreenUtil().setHeight(20)),
          CustomButton(
            onTap: () => _showInputDialog(context, inputController),
            height: ScreenUtil().setHeight(50),
            width: ScreenUtil().setWidth(310),
            buttonName: 'Custom Status',
            fontSize: ScreenUtil().setSp(12),
          )
          // DropdownButton<String>(
          //   value: _selectedStatus,
          //   items: statuses.map((String value) {
          //     return DropdownMenuItem<String>(
          //       value: value,
          //       child: Text(value),
          //     );
          //   }).toList(),
          //   onChanged: (newStatus) {
          //     setState(() {
          //       _selectedStatus = newStatus!;
          //     });
          //     _updateStatus(); // Trigger status update immediately
          //   },
          // ),
          // SizedBox(height: 20),
          // ElevatedButton(
          //   child: const Text('Update Status'),
          //   onPressed: () async {
          //     await _updateStatus();
          //   },
          // ),
        ],
      ),
    );
  }

  void _showInputDialog(
      BuildContext context, TextEditingController inputController) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: CustomText(
            text: 'Custom Status',
            fontSize: 12,
            color: NU_BLUE,
          ),
          content: CustomTextFormField(
            height: ScreenUtil().setHeight(10),
            width: ScreenUtil().setWidth(5),
            fontSize: ScreenUtil().setSp(12),
            hintTextSize: ScreenUtil().setSp(12),
            fontColor: NU_BLUE,
            controller: inputController,
            onSaved: (value) => inputController.text = value!,
            validator: (value) => value!.isEmpty ? 'Enter custom status' : null,
            hintText: 'Enter custom status',
          ),
          actions: [
            OutlinedButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
              child: const CustomText(
                text: 'Cancel',
                fontSize: 12,
                color: NU_BLUE,
              ),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: NU_BLUE,
              ),
              onPressed: () {
                String inputValue = inputController.text;
                print('User input: $inputValue');
                _selectedStatus = inputValue;
                showConfirmDialog(
                  context,
                  'Confirm',
                  'Are you sure to want updated you status to $_selectedStatus',
                  () {
                    setState(() {
                      _updateStatus();
                    });
                    Navigator.pop(context);
                  },
                );
              },
              child: CustomText(
                text: 'Submit',
                fontSize: 12,
                color: NU_YELLOW,
              ),
            ),
          ],
        );
      },
    );
  }
}
