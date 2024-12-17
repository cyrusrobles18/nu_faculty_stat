import 'dart:convert';
import 'package:http/http.dart' as http;
import '/constants.dart';

class UserService {
  late List data;
  late String token;

  Future<void> fetchAllUser() async {
    final response = await http.get(
      Uri.parse('$HOST/api/users'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization':
            'Bearer $token', // Pass the token in the Authorization header
      },
    );

    // Log the full response to check what is being returned
    print('Response Status: ${response.statusCode}');
    print('Response Body: ${response.body}');

    // Check if the response is valid JSON (in case it returns HTML error pages)
    try {
      if (response.statusCode == 200) {
        data =
            jsonDecode(response.body); // Decode the JSON if the status is 200
      } else {
        throw Exception('Failed to load data: ${response.statusCode}');
      }
    } catch (e) {
      // Catch FormatException (for HTML responses) and log the error
      print('Error parsing JSON: $e');
      throw Exception('Failed to load users. Response: ${response.body}');
    }
  }
}
