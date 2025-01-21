import 'package:faculty_stat_monitoring/widgets/custom_button.dart';
import 'package:faculty_stat_monitoring/widgets/custom_text.dart';
import 'package:faculty_stat_monitoring/widgets/custom_textformfield.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../constants.dart';

class AddFacultyScreen extends StatefulWidget {
  const AddFacultyScreen({super.key});

  @override
  State<StatefulWidget> createState() => _AddFacultyScreenState();
}

class _AddFacultyScreenState extends State<AddFacultyScreen> {
  String _selectedRole = 'Admin';
  List<String> roles = ['Admin', 'Faculty'];
  final _formKey = GlobalKey<FormState>();
  TextEditingController firstnameController = TextEditingController();
  TextEditingController lastnameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  Future<void> registerUser() async {
    final url = Uri.parse('$HOST/api/addfaculty');
    print('URL: $url');

    // Retrieve values from controllers
    String firstname = firstnameController.text.trim();
    String lastname = lastnameController.text.trim();
    String email = emailController.text.trim();
    String password = passwordController.text;

    print('Registering user: $firstname $lastname $email');

    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'firstname': firstname,
        'lastname': lastname,
        'email': email,
        'password': password,
        'role': _selectedRole,
      }),
    );

    print('Response status code: ${response.statusCode}');
    print('Response body: ${response.body}');

    if (response.statusCode == 200) {
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('User registered successfully')));
      Navigator.pushReplacementNamed(context, '/admin-dashboard');
    } else {
      String message = 'Registration Failed';
      try {
        final responseData = jsonDecode(response.body);
        if (responseData['message'] != null) {
          message = responseData['message'];
        }
      } catch (e) {
        print('Error parsing response: $e');
      }
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(message)));
    }
  }

  @override
  void dispose() {
    // Dispose controllers when not needed
    firstnameController.dispose();
    lastnameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: CustomText(
            fontWeight: FontWeight.bold,
            text: 'Add Faculty',
            fontSize: ScreenUtil().setSp(12),
            color: NU_BLUE),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(ScreenUtil().setSp(16)),
        child: Center(
          child: Container(
            color: Colors.white,
            width: ScreenUtil().setWidth(300),
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  CustomTextFormField(
                    height: ScreenUtil().setHeight(10),
                    width: ScreenUtil().setWidth(5),
                    fontSize: ScreenUtil().setSp(12),
                    hintTextSize: ScreenUtil().setSp(12),
                    fontColor: NU_BLUE,
                    controller: firstnameController,
                    onSaved: (value) => firstnameController.text = value!,
                    validator: (value) =>
                        value!.isEmpty ? 'Enter the faculty first name' : null,
                    hintText: 'Enter first name',
                  ),
                  SizedBox(height: ScreenUtil().setHeight(10)),
                  CustomTextFormField(
                    height: ScreenUtil().setHeight(10),
                    width: ScreenUtil().setWidth(5),
                    fontSize: ScreenUtil().setSp(12),
                    hintTextSize: ScreenUtil().setSp(12),
                    fontColor: NU_BLUE,
                    controller: lastnameController,
                    onSaved: (value) => lastnameController.text = value!,
                    validator: (value) =>
                        value!.isEmpty ? 'Enter the faculty last name' : null,
                    hintText: 'Enter last name',
                  ),
                  SizedBox(height: ScreenUtil().setHeight(10)),
                  CustomTextFormField(
                    height: ScreenUtil().setHeight(10),
                    width: ScreenUtil().setWidth(5),
                    fontSize: ScreenUtil().setSp(12),
                    hintTextSize: ScreenUtil().setSp(12),
                    fontColor: NU_BLUE,
                    controller: emailController,
                    onSaved: (value) => emailController.text = value!,
                    validator: (value) =>
                        !value!.contains('@') ? 'Enter a valid email' : null,
                    hintText: 'Enter email',
                  ),
                  SizedBox(height: ScreenUtil().setHeight(10)),
                  CustomTextFormField(
                    height: ScreenUtil().setHeight(10),
                    width: ScreenUtil().setWidth(5),
                    fontSize: ScreenUtil().setSp(12),
                    hintTextSize: ScreenUtil().setSp(12),
                    fontColor: NU_BLUE,
                    controller: passwordController,
                    onSaved: (value) => passwordController.text = value!,
                    isObscure: true,
                    validator: (value) => value!.length < 6
                        ? 'Password must be at least 6 characters'
                        : null,
                    hintText: 'Enter password',
                  ),
                  SizedBox(height: ScreenUtil().setHeight(20)),
                  Container(
                    padding:  EdgeInsets.symmetric(horizontal: ScreenUtil().setWidth(5), vertical: ScreenUtil().setHeight(5)),
                    decoration: BoxDecoration(
                      color: Colors.grey.shade300, 
                      border: Border.all(color:NU_BLUE, width: 1.5),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton<String>(
                        isExpanded: true,
                        value: _selectedRole,
                        items: roles.map((String role) {
                          return DropdownMenuItem<String>(
                            value: role,
                            child: CustomText(
                              text: role,
                              fontSize: ScreenUtil().setSp(9),
                            ),
                          );
                        }).toList(),
                        onChanged: (newRole) {
                          setState(() {
                            _selectedRole = newRole!;
                          });
                        },
                      ),
                    ),
                  ),
                  SizedBox(height: ScreenUtil().setHeight(20)),
                  CustomButton(
                    height: ScreenUtil().setHeight(60),
                    width: ScreenUtil().setWidth(300),
                    fontSize: ScreenUtil().setSp(12),
                    bgColor: NU_BLUE,
                    fontColor: Colors.white,
                    onTap: () => _formKey.currentState!.validate()
                        ? registerUser()
                        : registerUser(),
                    buttonName: 'Add Faculty',
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
