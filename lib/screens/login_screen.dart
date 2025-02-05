// lib/screens/login_screen.dart

import 'package:faculty_stat_monitoring/constants.dart';
import 'package:faculty_stat_monitoring/widgets/custom_button.dart';
import 'package:faculty_stat_monitoring/widgets/custom_font.dart';
import 'package:faculty_stat_monitoring/widgets/custom_textformfield.dart';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:jwt_decode/jwt_decode.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  String email = '';
  String password = '';
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  final storage = const FlutterSecureStorage();
  String token = '';
  Future<void> loginUser() async {
    final url = Uri.parse('$HOST/api/login');
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'email': email,
        'password': password,
      }),
    );
    print('response' + response.toString());
    print(response.statusCode);
    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      token = data['token'];
      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setString('jwt_token', token);
      // await storage.write(key: 'jwt_token', value: token);

      // Extract role from token
      Map<String, dynamic> payload = Jwt.parseJwt(token);
      String role = payload['role'];

      prefs.setString('email', email);
      prefs.setString('password', password);
      prefs.setString('token', token);
      prefs.setBool('isLoggedIn', true);
      print(prefs.getString('platform'));
      // Navigate based on role
      if (role == 'Admin') {
        Navigator.pushReplacementNamed(context, '/admin-dashboard');
      } else {
        Navigator.pushReplacementNamed(context, '/faculty-dashboard');
      }
    } else {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Login Failed')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(
              height: ScreenUtil().setHeight(50),
            ),
            Align(
              alignment: Alignment.center,
              child: Image.asset(
                'assets/images/NUCCITLogo.png',
              ),
            ),
            SizedBox(
              height: ScreenUtil().setHeight(50),
            ),
            Container(
              width: ScreenUtil().setWidth(300),
              padding: EdgeInsets.all(ScreenUtil().setSp(16)),
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border.all(width: 2, color: NU_BLUE),
                boxShadow: const [
                  BoxShadow(
                    color: Colors.grey,
                    offset: Offset(0.0, 1.0), //(x,y)
                    blurRadius: 6.0,
                  )
                ],
                borderRadius: const BorderRadius.all(
                  Radius.circular(10),
                ),
              ),
              child: Form(
                key: _formKey,
                child: Column(
                  children: <Widget>[
                    Align(
                      alignment: Alignment.centerLeft,
                      child: CustomFont(
                        text: 'Welcome!!',
                        fontSize: ScreenUtil().setSp(20),
                        color: NU_BLUE,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(
                      height: ScreenUtil().setHeight(10),
                    ),
                    CustomTextFormField(
                        height: ScreenUtil().setHeight(10),
                        width: ScreenUtil().setWidth(5),
                        controller: emailController,
                        validator: (value) => !value!.contains('@')
                            ? 'Enter a valid email'
                            : null,
                        onSaved: (value) => email = value!,
                        fontSize: ScreenUtil().setSp(12),
                        fontColor: NU_BLUE,
                        hintTextSize: ScreenUtil().setSp(12),
                        hintText: 'Email'),
                    SizedBox(
                      height: ScreenUtil().setHeight(10),
                    ),
                    CustomTextFormField(
                        height: ScreenUtil().setHeight(10),
                        width: ScreenUtil().setWidth(5),
                        controller: passwordController,
                        isObscure: true,
                        validator: (value) =>
                            value!.isEmpty ? 'Enter your password' : null,
                        onSaved: (value) => password = value!,
                        fontSize: ScreenUtil().setSp(12),
                        fontColor: NU_BLUE,
                        hintTextSize: ScreenUtil().setSp(12),
                        hintText: 'Password'),
                    SizedBox(height: ScreenUtil().setHeight(50)),
                    CustomButton(
                      onTap: () {
                        if (_formKey.currentState!.validate()) {
                          _formKey.currentState!.save();
                          loginUser();
                        }
                      },
                      height: ScreenUtil().setHeight(45),
                      width: ScreenUtil().setWidth(400),
                      buttonName: 'Login',
                      fontSize: ScreenUtil().setSp(11),
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
