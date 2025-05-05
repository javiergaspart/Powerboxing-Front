import 'package:flutter/material.dart';
import '../../services/trainer_auth_service.dart';
import '../../models/trainer.dart';
import './login_screen.dart';
import '../dashboard/trainer_home_screen.dart';
import '../../providers/trainer_provider.dart';
import 'package:provider/provider.dart';
import 'dart:async';


class TrainerLoginScreen extends StatefulWidget {
  @override
  _TrainerLoginScreenState createState() => _TrainerLoginScreenState();
}

class _TrainerLoginScreenState extends State<TrainerLoginScreen> {
  final _authService = TrainerAuthService();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isLoading = false;

  Future<void> _login() async {
    setState(() => _isLoading = true);
    try {
      Trainer trainer = await _authService.loginTrainer(
        _emailController.text.trim(),
        _passwordController.text,
      );

      // 🔥 Save trainer in provider
      final trainerProvider = Provider.of<TrainerProvider>(context, listen: false);
      trainerProvider.setTrainer(trainer);

      if (!mounted) return;

      Navigator.pushReplacement(
        context,
        PageRouteBuilder(
          pageBuilder: (_, __, ___) => TrainerHomeScreen(trainerName: trainer.name),
          transitionsBuilder: (_, anim, __, child) =>
              FadeTransition(opacity: anim, child: child),
          transitionDuration: const Duration(milliseconds: 100),
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Trainer login failed: ${e.toString()}')),
      );
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    // ... use same layout from LoginScreen
    // Replace _authService.login -> _authService.loginTrainer
    // And HomeScreen -> TrainerHomeScreen
    // You already did this nicely in your main login, so reuse and modify it here
    return Scaffold(
      backgroundColor: Colors.black,
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(height: 100),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Image.asset(
                'assets/images/login_banner.jpeg',
                width: MediaQuery.of(context).size.width * 0.7,
                fit: BoxFit.cover,
              ),
            ),
            SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
              child: Column(
                children: [
                  _buildInputField(_emailController, "Email"),
                  SizedBox(height: 20),
                  _buildInputField(_passwordController, "Password", isPassword: true),
                  SizedBox(height: 40),
                  _isLoading
                      ? CircularProgressIndicator()
                      : ElevatedButton(
                    onPressed: _login,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xFF99C448),
                      padding: EdgeInsets.symmetric(vertical: 14, horizontal: 40),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: Text(
                      'Trainer Log In',
                      style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.white),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 20),
            TextButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => LoginScreen()),
                );
              },
              child: Text(
                "Log In as a User!",
                style: TextStyle(
                  color: Color(0xFF99C448),
                  fontSize: 16,
                  decoration: TextDecoration.underline, // cute underline like a hyperlink
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInputField(TextEditingController controller, String hint, {bool isPassword = false}) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey[600],
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Color(0xFF8C8C8C),
            blurRadius: 4,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: TextField(
        controller: controller,
        obscureText: isPassword,
        style: TextStyle(color: Colors.white),
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: TextStyle(color: Colors.white54),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide.none,
          ),
          filled: true,
          fillColor: Colors.grey[800],
        ),
      ),
    );
  }
}
