import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  bool isLoading = false;
  String errorMessage = "";

  Future<void> loginUser() async {
    setState(() {
      isLoading = true;
      errorMessage = "";
    });

    try {
      final response = await http.post(
        Uri.parse("http://localhost:10000/api/auth/login"),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "email": emailController.text,
          "password": passwordController.text,
        }),
      );

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        String role = responseData['role'];
        String token = responseData['token'];
        String userId = responseData['userId'] ?? "";

        if (role == "trainer") {
          Navigator.pushReplacementNamed(
            context,
            '/trainer-dashboard',
            arguments: {
              "token": token,
              "trainerId": userId,
            },
          );
        } else if (role == "boxer") {
          Navigator.pushReplacementNamed(
            context,
            '/boxer-dashboard',
            arguments: {
              "token": token,
              "userId": userId,
            },
          );
        } else {
          setState(() {
            errorMessage = "Invalid user role. Contact support.";
          });
        }
      } else {
        setState(() {
          errorMessage = "Invalid email or password.";
        });
      }
    } catch (e) {
      setState(() {
        errorMessage = "Network error: $e";
      });
    }

    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("PowerBoxing Login")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Email", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            TextField(controller: emailController),
            SizedBox(height: 10),
            Text("Password", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            TextField(controller: passwordController, obscureText: true),
            SizedBox(height: 20),
            if (errorMessage.isNotEmpty)
              Text(errorMessage, style: TextStyle(color: Colors.red)),
            SizedBox(height: 20),
            isLoading
                ? CircularProgressIndicator()
                : ElevatedButton(
                    onPressed: loginUser,
                    child: Text("Login"),
                  ),
          ],
        ),
      ),
    );
  }
}
