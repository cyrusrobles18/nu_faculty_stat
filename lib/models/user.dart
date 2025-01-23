// lib/models/user.dart

class User {
  final int id;
  final String firstname;
  final String lastname;
  final String email;
  final String status;
  final String role;
  final String password;

  User({
    required this.id,
    required this.firstname,
    required this.lastname,
    required this.email,
    required this.status,
    required this.role,
    required this.password,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      firstname: json['firstname'],
      lastname: json['lastname'],
      email: json['email'],
      status: json['status'],
      role: json['role'],
      password: json['password'],
    );
  }
}
