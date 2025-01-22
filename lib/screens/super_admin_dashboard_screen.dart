import 'dart:async';
import 'package:faculty_stat_monitoring/constants.dart';
import 'package:faculty_stat_monitoring/widgets/custom_text.dart';
import 'package:intl/intl.dart';
import 'package:faculty_stat_monitoring/services/user_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/user.dart';

class SuperAdminDashboardScreen extends StatefulWidget {
  const SuperAdminDashboardScreen({super.key});

  @override
  State<StatefulWidget> createState() => _SuperAdminDashboardScreenState();
}

class _SuperAdminDashboardScreenState extends State<SuperAdminDashboardScreen> {
  final storage = const FlutterSecureStorage();
  List<User> userList = [];
  List<User> adminList = [];
  final ValueNotifier<List<User>> _userListNotifier =
      ValueNotifier<List<User>>([]);
  final ValueNotifier<List<User>> _adminListNotifier =
      ValueNotifier<List<User>>([]);
  bool _isLoading = false; // Track loading state
  Timer? _refreshTimer; // Timer for periodic refresh
  late Timer _timer;
  String _currentTime = '';

  @override
  void initState() {
    super.initState();
    _fetchUsers();
    _startPeriodicRefresh(); // Start the timer
    _updateTime(); // Set initial time
    // Update time every second
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      _updateTime();
    });
  }

  @override
  void dispose() {
    _refreshTimer?.cancel(); // Cancel the timer to prevent memory leaks
    _timer.cancel(); // Cancel timer to prevent memory leaks
    super.dispose();
  }

  void _startPeriodicRefresh() {
    const refreshInterval =
        Duration(seconds: 5); // Set your desired refresh interval
    _refreshTimer = Timer.periodic(refreshInterval, (timer) {
      _fetchUsers();
    });
  }

  void _updateTime() {
    final now = DateTime.now();
    // Format the time using intl package for a nice display, e.g. hh:mm:ss
    final formattedTime = DateFormat('MM/dd/yyyy hh:mm:ss a').format(now);
    setState(() {
      _currentTime = formattedTime;
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
      List<User> fetchedAdmins =
          userService.data.map((json) => User.fromJson(json)).toList();
      fetchedUsers =
          fetchedUsers.where((user) => user.role == 'Faculty').toList();
      fetchedAdmins =
          fetchedAdmins.where((user) => user.role == 'Admin').toList();
      _userListNotifier.value = fetchedUsers;
      _adminListNotifier.value = fetchedAdmins;
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
        backgroundColor: NU_BLUE,
        toolbarHeight: 100,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            CircleAvatar(
              radius: 25,
              backgroundColor: NU_YELLOW,
              backgroundImage: const AssetImage('assets/images/NUShield.png'),
            ),
            const SizedBox(width: 10),
            CustomText(
              text: 'Faculty Status Monitoring',
              fontSize: 25,
              color: NU_YELLOW,
              fontWeight: FontWeight.bold,
            ),
            Spacer(),
            // CustomText(
            //     text: _currentTime,
            //     fontSize: ScreenUtil().setSp(12),
            //     color: Colors.black),
            // Spacer(),
            IconButton(
              icon: const Icon(
                Icons.add,
                color: NU_YELLOW,
              ),
              onPressed: () {
                Navigator.pushNamed(context, '/add-faculty');
              },
            ),
            IconButton(
              icon: const Icon(Icons.logout, color: NU_YELLOW),
              onPressed: () async {
                SharedPreferences prefs = await SharedPreferences.getInstance();
                prefs.setString('jwt_token', 'NoValue');
                // await storage.delete(key: 'jwt_token');
                Navigator.pushReplacementNamed(context, '/login');
              },
            ),
          ],
        ),
      ),
      body: Container(
          color: Colors.white,
          child: Row(
            children: [
              Container(
                width: MediaQuery.sizeOf(context).width * .35,
                child: ValueListenableBuilder<List<User>>(
                  valueListenable: _adminListNotifier,
                  builder: (context, users, child) {
                    if (_isLoading && users.isEmpty) {
                      return const Center(child: CircularProgressIndicator());
                    } else if (users.isEmpty) {
                      return const Center(child: Text('No users found'));
                    } else {
                      return Column(
                        children: [
                          SizedBox(height: 15),
                          CustomText(
                            text: 'Admins',
                            fontSize: ScreenUtil().setSp(9),
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                          ),
                          const SizedBox(height: 3),
                          Container(
                            height: MediaQuery.sizeOf(context).height * .8,
                            child: RefreshIndicator(
                              // Add refresh indicator
                              onRefresh: _fetchUsers,
                              child: ListView.builder(
                                itemCount: users.length,
                                itemBuilder: (context, index) {
                                  User user = users[index];
                                  return ListTile(
                                    title: CustomText(
                                        text:
                                            '${user.firstname} ${user.lastname}',
                                        fontSize: ScreenUtil().setSp(10),
                                        color: Colors.black),
                                    subtitle: Container(
                                      alignment: Alignment.center,
                                      padding: EdgeInsets.all(5),
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(10),
                                        color: _getStatusColor(user.status),
                                      ),
                                      child: CustomText(
                                        text: user.status,
                                        fontSize: ScreenUtil().setSp(6),
                                        color: _getTextColor(user.status),
                                      ),
                                    ),

                                    // Row(
                                    //   children: [
                                    //     CustomText(
                                    //         text: 'Status: ',
                                    //         fontSize: ScreenUtil().setSp(8),
                                    //         color: Colors.black),
                                    //     const SizedBox(width: 10),
                                    //     Container(
                                    //       alignment: Alignment.center,
                                    //       padding: EdgeInsets.all(5),
                                    //       width: 250,
                                    //       decoration: BoxDecoration(
                                    //         borderRadius:
                                    //             BorderRadius.circular(10),
                                    //         color: _getStatusColor(user.status),
                                    //       ),
                                    //       child: CustomText(
                                    //         text: user.status,
                                    //         fontSize: ScreenUtil().setSp(6),
                                    //         color: _getTextColor(user.status),
                                    //       ),
                                    //     ),
                                    //   ],
                                    // ),

                                    // trailing: CustomText(
                                    //     text: user.role,
                                    //     fontSize: ScreenUtil().setSp(5),
                                    //     color: Colors.black),
                                  );
                                },
                              ),
                            ),
                          ),
                        ],
                      );
                    }
                  },
                ),
              ),
              Expanded(
                child: Container(
                  width: MediaQuery.sizeOf(context).width * .65,
                  child: ValueListenableBuilder<List<User>>(
                    valueListenable: _userListNotifier,
                    builder: (context, users, child) {
                      if (_isLoading && users.isEmpty) {
                        return const Center(child: CircularProgressIndicator());
                      } else if (users.isEmpty) {
                        return const Center(child: Text('No users found'));
                      } else {
                        return Column(
                          children: [
                            SizedBox(height: 15),
                            CustomText(
                              text: 'Faculties',
                              fontSize: ScreenUtil().setSp(9),
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                            ),
                            const SizedBox(height: 3),
                            Container(
                              height: MediaQuery.sizeOf(context).height * .8,
                              child: RefreshIndicator(
                                // Add refresh indicator
                                onRefresh: _fetchUsers,
                                child: ListView.builder(
                                  itemCount: users.length,
                                  itemBuilder: (context, index) {
                                    User user = users[index];
                                    return ListTile(
                                      title: CustomText(
                                          text:
                                              '${user.firstname} ${user.lastname}',
                                          fontSize: ScreenUtil().setSp(10),
                                          color: Colors.black),
                                      // subtitle: CustomText(
                                      //     text: 'Status: ${user.status}',
                                      //     fontSize: ScreenUtil().setSp(8),
                                      //     color: Colors.black),
                                      // trailing:
                                      subtitle: Container(
                                        alignment: Alignment.center,
                                        padding: EdgeInsets.all(5),
                                        width: 60,
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                          color: _getStatusColor(user.status),
                                        ),
                                        child: CustomText(
                                          text: user.status,
                                          fontSize: ScreenUtil().setSp(6),
                                          color: _getTextColor(user.status),
                                        ),
                                      ),
                                      // trailing: CustomText(
                                      //     text: user.role,
                                      //     fontSize: ScreenUtil().setSp(5),
                                      //     color: Colors.black),
                                    );
                                  },
                                ),
                              ),
                            )
                          ],
                        );
                      }
                    },
                  ),
                ),
              ),
            ],
          )),
    );
  }

  Color _getStatusColor(String status) {
    const statusColors = {
      'In': STAT_GREEN_IN,
      'Out': STAT_RED_OUT,
      'On Meeting': STAT_ORANGE_MEETING,
      'Out of Office': STAT_YELLOW_OTOFFICE,
      'In Class': STAT_BLUE_INCLASS,
      'On Leave': STAT_RED_ONLEAVE,
    };
    return statusColors[status] ?? Colors.grey.shade400;
  }

  Color _getTextColor(String status) {
    const statusColors = {
      'In': Colors.white,
      'Out': Colors.white,
      'On Meeting': Colors.white,
      'Out of Office': Colors.black,
      'In Class': Colors.white,
      'On Leave': Colors.white,
    };
    return statusColors[status] ?? Colors.black;
  }
}
