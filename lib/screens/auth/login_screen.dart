import 'package:flutter/material.dart';
import '../../services/auth_service.dart';
import '../../models/user_model.dart';
import '../../providers/user_provider.dart' as user_provider;
import '../dashboard/home_screen.dart';
import './signup_screen.dart';
import 'package:provider/provider.dart';
import 'dart:async';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> with SingleTickerProviderStateMixin {
  final _authService = AuthService();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isLoading = false;
  late Timer _smileyTimer;
  String _currentSmiley = '🙂';

  @override
  void initState() {
    super.initState();
    _smileyTimer = Timer.periodic(Duration(seconds: 1), (timer) {
      setState(() {
        _currentSmiley = _currentSmiley == '🙂' ? '🙃' : '🙂';
      });
    });
  }

  @override
  void dispose() {
    _smileyTimer.cancel();
    super.dispose();
  }

  Future<void> _login() async {
    setState(() => _isLoading = true);
    try {
      User user = await _authService.login(
        _emailController.text,
        _passwordController.text,
      );
      Provider.of<user_provider.UserProvider>(context, listen: false).setUser(user);
      Navigator.pushReplacement(
        context,
        PageRouteBuilder(
          pageBuilder: (_, __, ___) => HomeScreen(user: user),
          transitionsBuilder: (_, anim, __, child) {
            return FadeTransition(opacity: anim, child: child);
          },
          transitionDuration: Duration(milliseconds: 100),
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Login failed: ${e.toString()}')),
      );
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF0A3D2D),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
            Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Welcome Back',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.w800,
                  fontFamily: 'BebasNeue',
                  color: Color(0xFFF5F5DC),
                  letterSpacing: 1.5,
                ),
              ),
              SizedBox(width: 10),
              Text(
                _currentSmiley,
                style: TextStyle(fontSize: 30),
              ),
            ],
          ),
          SizedBox(height: 20),
          SizedBox(
            width: MediaQuery.of(context).size.width * 0.7,
            child: TextField(
              controller: _emailController,
              style: TextStyle(fontFamily: 'BebasNeue', fontSize: 18),
              decoration: InputDecoration(
                hintText: 'Email',
                hintStyle: TextStyle(color: Colors.black54),
                filled: true,
                fillColor: Color(0xFFF5F5DC),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
          ),
          SizedBox(height: 15),
          SizedBox(
            width: MediaQuery.of(context).size.width * 0.7,
            child: TextField(
              controller: _passwordController,
              obscureText: true,
              style: TextStyle(fontFamily: 'BebasNeue', fontSize: 18),
              decoration: InputDecoration(
                hintText: 'Password',
                hintStyle: TextStyle(color: Colors.black54),
                filled: true,
                fillColor: Color(0xFFF5F5DC),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
          ),
          SizedBox(height: 30),
          _isLoading
              ? Center(child: CircularProgressIndicator())
              : OutlinedButton(
            onPressed: _login,
            style: OutlinedButton.styleFrom(
              foregroundColor: Color(0xFFF5F5DC),
              side: BorderSide(color: Color(0xFFF5F5DC), width: 2),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              padding: EdgeInsets.symmetric(vertical: 12, horizontal: 40),
            ),
            child: Text(
              'Login',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                fontFamily: 'BebasNeue',
              ),
            ),
          ),
          SizedBox(height: 10),
          TextButton(
            onPressed: () {
              Navigator.pushNamed(context, '/forgot-password');
            },
            child: Text(
              'Forgot Password?',
              style: TextStyle(
                color: Color(0xFFF5F5DC),
                fontFamily: 'BebasNeue',
                fontSize: 18,
              ),
            ),
          ),
          TextButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => SignUpScreen()),
              );
            },
            child: Text(
                "Don't have an account? Sign Up",
            style: TextStyle(
                color: Color(0xFFF5F5DC),
            fontFamily: 'BebasNeue',
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      ],
    ),
    ),
    ),
    );
  }
}