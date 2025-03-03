import 'package:flutter/material.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  void login() {
    // Dummy login function
    Navigator.pushNamed(context, '/user-dashboard', arguments: {
      'userName': 'Test User',
      'token': 'testToken'
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Login")),
      body: Column(
        children: [
          TextField(controller: emailController, decoration: InputDecoration(labelText: "Email")),
          TextField(controller: passwordController, decoration: InputDecoration(labelText: "Password"), obscureText: true),
          ElevatedButton(onPressed: login, child: Text("Login")),
          TextButton(
            onPressed: () => Navigator.pushNamed(context, '/signup'),
            child: Text("Don't have an account? Sign up"), // ✅ Added Sign-Up Button
          ),
        ],
      ),
    );
  }
}
