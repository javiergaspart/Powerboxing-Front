import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/user_model.dart';
import '../constants/urls.dart';

class AuthService {
  // Login user
  Future<User> login(String email, String password) async {
    print('Login called with email: $email');
    final url = Uri.parse('${AppUrls.baseUrl}/auth/login');
    print('Making POST request to $url');
    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
      },
      body: json.encode({
        'email': email,
        'password': password,
      }),
    );

    print('Response received: ${response.statusCode}, Body: ${response.body}');
    if (response.statusCode == 200) {
      var userJson = json.decode(response.body);
      User user = User.fromJson(userJson['user']);
      print('Login successful');
      return user;
    } else {
      print('Login failed');
      throw Exception('Failed to login');
    }
  }

  // Sign up user
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
    // If you are storing the user's session or token (e.g., in SharedPreferences or SecureStorage),
    // you can clear that data here. For example:

    // Example of clearing stored data (using shared preferences):
    // final prefs = await SharedPreferences.getInstance();
    // await prefs.remove('user_token');

    // If there is a need to make a request to the backend to invalidate the session:
    final url = Uri.parse('${AppUrls.baseUrl}/auth/logout');
    print('Making POST request to $url');
    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
        // Include any authorization headers (e.g., token) if needed
      },
    );

    print('Response received: ${response.statusCode}, Body: ${response.body}');
    if (response.statusCode != 200) {
      print('Failed to logout');
      throw Exception('Failed to logout');
    }
    print('Logout successful');
    // Optionally clear any local user data here
    // await prefs.clear(); // Clear all saved data if needed
  }
}
