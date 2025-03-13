import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class SignupScreen extends StatefulWidget {
  @override
  _SignupScreenState createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  Future<void> signUpUser() async {
    try {
      final response = await http.post(
        Uri.parse("http://localhost:10000/api/auth/signup"),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "name": _nameController.text.trim(),
          "email": _emailController.text.trim(),
          "phone": _phoneController.text.trim(),
          "password": _passwordController.text.trim(),
          "role": "boxer",
          "sessions_balance": 1 // Ensures user starts with 1 session balance
        }),
      );

      if (response.statusCode == 201) {
        final responseData = jsonDecode(response.body);
        final token = responseData["token"];

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Signup successful! Redirecting...")),
        );

        Future.delayed(Duration(seconds: 2), () {
          Navigator.pushReplacementNamed(
            context,
            '/boxer-dashboard',
            arguments: {"token": token}, // Pass token to Boxer Dashboard
          );
        });
      } else {
        final errorMsg = jsonDecode(response.body)["message"] ?? "Signup failed. Please try again.";
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Error: $errorMsg")),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Network error: $e")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Sign Up")),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: _nameController,
              decoration: InputDecoration(labelText: "Name"),
            ),
            TextField(
              controller: _emailController,
              decoration: InputDecoration(labelText: "Email"),
            ),
            TextField(
              controller: _phoneController,
              decoration: InputDecoration(labelText: "Phone"),
            ),
            TextField(
              controller: _passwordController,
              decoration: InputDecoration(labelText: "Password"),
              obscureText: true,
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: signUpUser,
              child: Text("Sign Up"),
            ),
          ],
        ),
      ),
    );
  }
}
