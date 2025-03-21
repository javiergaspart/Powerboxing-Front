import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'boxer_dashboard.dart';
import 'trainer_dashboard.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  String _errorMessage = '';

  Future<void> _login() async {
    final String email = _emailController.text.trim();
    final String password = _passwordController.text.trim();

    if (email.isEmpty || password.isEmpty) {
      setState(() {
        _errorMessage = "Please enter email and password.";
      });
      return;
    }

    try {
      final response = await http.post(
        Uri.parse('http://localhost:10000/api/auth/login'),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({"email": email, "password": password}),
      );

      print("🔍 API Response Code: ${response.statusCode}");
      print("🔍 API Response Body: ${response.body}");

      final responseData = jsonDecode(response.body);

      if (response.statusCode == 200) {
        bool isTrainer = responseData['role'] == 'trainer';
        
        Navigator.pushReplacement(
  context,
  MaterialPageRoute(
    builder: (context) => BoxerDashboard(
      token: responseData['token'],
      userId: responseData['userId'], // ✅ Ensure this is passed
    ),
  ),
);
      } else {
        setState(() {
          _errorMessage = responseData['message'] ?? "Login failed";
        });
      }
    } catch (e) {
      setState(() {
        _errorMessage = "Network error. Please try again.";
      });
      print("❌ Network Error: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Login")),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _emailController,
              decoration: InputDecoration(labelText: "Email"),
            ),
            TextField(
              controller: _passwordController,
              decoration: InputDecoration(labelText: "Password"),
              obscureText: true,
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _login,
              child: Text("Login"),
            ),
            if (_errorMessage.isNotEmpty) ...[
              SizedBox(height: 10),
              Text(_errorMessage, style: TextStyle(color: Colors.red)),
            ]
          ],
        ),
      ),
    );
  }
}
