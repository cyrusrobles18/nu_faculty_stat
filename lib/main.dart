import 'package:faculty_stat_monitoring/screens/splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'screens/admin_dashboard_screen.dart';
import 'screens/faculty_dashboard_screen.dart';
import 'screens/home_screen.dart';
import 'screens/login_screen.dart';
import 'screens/add_faculty_screen.dart';

void main() => runApp(const FacultyStatMonitoringApp());

class FacultyStatMonitoringApp extends StatelessWidget {
  const FacultyStatMonitoringApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(412, 715),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (_, child) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Faculty Status Monitoring',
          initialRoute: '/splash',
          routes: {
            '/splash': (context) => const SplashScreen(),
            '/login': (context) => const LoginScreen(),
            '/add-faculty': (context) => const AddFacultyScreen(),
            '/home': (context) => const HomeScreen(),
            '/faculty-dashboard': (context) => const FacultyDashboardScreen(),
            '/admin-dashboard': (context) => const AdminDashboardScreen(),
          },
        );
      },
    );
  }
}
