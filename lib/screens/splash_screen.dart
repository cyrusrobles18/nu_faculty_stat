import 'dart:async';
import 'package:faculty_stat_monitoring/constants.dart';
import 'package:faculty_stat_monitoring/widgets/loading.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:jwt_decode/jwt_decode.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    getIsLogin();
    super.initState();
  }

  void getIsLogin() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    const storage = FlutterSecureStorage();
    bool isLoggedIn = prefs.getBool('isLoggedIn') ?? false;
    String email = prefs.getString('email') ?? 'NoValue';
    String password = prefs.getString('password') ?? 'NoValue';
    String token = prefs.getString('token') ?? 'NoValue';

    print('$isLoggedIn\n$email\n$password\n$token\n');

    if (isLoggedIn || token != 'NoValue') {
      final url = Uri.parse('$HOST/login');
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'email': email,
          'password': password,
        }),
      );

      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        token = data['token'];

        await storage.write(key: 'jwt_token', value: token);

        // Extract role from token
        Map<String, dynamic> payload = Jwt.parseJwt(token);
        String role = payload['role'];
        SharedPreferences prefs = await SharedPreferences.getInstance();
        prefs.setString('email', email);
        prefs.setString('password', password);
        prefs.setString('token', token);
        prefs.setBool('isLoggedIn', true);
        // Navigate based on role
        if (role == 'Admin') {
          Timer(
            const Duration(seconds: 2),
            () => Navigator.pushReplacementNamed(context, '/admin-dashboard'),
          );
        } else {
          Timer(
            const Duration(seconds: 2),
            () => Navigator.pushReplacementNamed(context, '/faculty-dashboard'),
          );
        }
      } else {
        Timer(
          const Duration(seconds: 2),
          () => Navigator.popAndPushNamed(context, '/login'),
        );
      }
    } else {
      Timer(
        const Duration(seconds: 2),
        () => Navigator.popAndPushNamed(context, '/login'),
      );
    }
    // Timer(
    //   const Duration(seconds: 2),
    //   () => Navigator.popAndPushNamed(context, '/login'),
    // );
    // if (Platform.isAndroid) {
    //   prefs.setString('platform', 'android');
    // } else if (Platform.isIOS) {
    //   prefs.setString('platform', 'iOs');
    // } else if (kIsWeb) {
    //   prefs.setString('platform', 'web');
    // }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SizedBox(
        height: ScreenUtil().screenHeight,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Align(
            //   alignment: Alignment.center,
            //   child: Image.asset(
            //     'assets/images/NUCCITLogoX3.jpg',
            //     scale: ScreenUtil().setSp(2.5),
            //   ),
            // ),
            CircleAvatar(
              radius: ScreenUtil().setSp(20),
              backgroundColor: NU_YELLOW,
              backgroundImage: const AssetImage('assets/images/NUShield.png'),
            ),
            SizedBox(
              height: ScreenUtil().setHeight(70),
            ),
            Align(
              alignment: Alignment.center,
              child: genericLoading,
            ),
          ],
        ),
      ),
    );
  }
}
