import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/user_model.dart';
import '../constants/urls.dart';

class AuthService {
  // Login user
  Future<User> login(String email, String password) async {
    try {
      print('🔹 Login called with email: $email');

      final url = Uri.parse('${AppUrls.baseUrl}/auth/login');
      print('🌍 Making POST request to: $url');

      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: json.encode({'email': email, 'password': password}),
      );

      print('📩 Response received: Status Code = ${response.statusCode}');
      print('🔍 Response Headers: ${response.headers}');
      print('📝 Response Body: ${response.body}');

      if (response.statusCode == 200) {
        try {
          var userJson = json.decode(response.body);
          if (userJson['user'] == null) {
            print('⚠️ Warning: "user" field missing in response.');
            throw Exception('Invalid response: Missing user data.');
          }

          User user = User.fromJson(userJson['user']);

          if (user.id.isEmpty) {
            print('⚠️ Warning: User ID is missing from backend response.');
          }

          print('✅ Login successful for user: ${user.username}');
          return user;
        } catch (e) {
          print('❌ Error parsing JSON response: $e');
          throw Exception('Failed to parse login response.');
        }
      } else {
        print('🚨 Login failed with status: ${response.statusCode}');
        print('🛑 Server Response: ${response.body}');
        throw Exception('Login failed: ${response.body}');
      }
    } catch (e) {
      print('❗ Exception during login: $e');
      throw Exception('Login failed: $e');
    }
  }


  // Sign up user with added phone number
  Future<User> signUp(String username, String email, String password) async {
    print('SignUp called with email: $email, username: $username');
    final url = Uri.parse('${AppUrls.baseUrl}/auth/register');
    print('Making POST request to $url');
    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
      },
      body: json.encode({
        'username': username,
        'email': email,
        'password': password,
      }),
    );

    print('Response received: ${response.statusCode}, Body: ${response.body}');
    if (response.statusCode == 201) {
      var userJson = json.decode(response.body);
      User user = User.fromJson(userJson['user']);
      print('SignUp successful for user: $user');
      return user;
    } else {
      print('SignUp failed');
      throw Exception('Failed to sign up');
    }
  }

  // Forgot password - sends a password reset link to the user's email
  Future<void> forgotPassword(String email) async {
    print('ForgotPassword called with email: $email');
    final url = Uri.parse('${AppUrls.baseUrl}/auth/forgot-password');
    print('Making POST request to $url');
    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
      },
      body: json.encode({
        'email': email,
      }),
    );

    print('Response received: ${response.statusCode}, Body: ${response.body}');
    if (response.statusCode != 200) {
      print('Failed to send password reset link');
      throw Exception('Failed to send password reset link');
    }
    print('Password reset link sent successfully');
  }

  // Get user profile
  Future<User> getUserProfile() async {
    print('GetUserProfile called');
    final url = Uri.parse('${AppUrls.baseUrl}/auth/profile');
    print('Making GET request to $url');
    final response = await http.get(
      url,
      headers: {
        'Content-Type': 'application/json',
        // Add your authorization token if needed
      },
    );

    print('Response received: ${response.statusCode}, Body: ${response.body}');
    if (response.statusCode == 200) {
      print('User profile fetched successfully');
      return User.fromJson(json.decode(response.body));
    } else {
      print('Failed to fetch user profile');
      throw Exception('Failed to fetch user profile');
    }
  }

  // Logout user
  Future<void> logout() async {
    print('Logout called');
    final url = Uri.parse('${AppUrls.baseUrl}/auth/logout');
    print('Making POST request to $url');
    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
      },
    );

    print('Response received: ${response.statusCode}, Body: ${response.body}');
    if (response.statusCode != 200) {
      print('Failed to logout');
      throw Exception('Failed to logout');
    }
    print('Logout successful');
  }
}
