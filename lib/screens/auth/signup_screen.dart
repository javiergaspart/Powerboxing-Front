import 'package:flutter/material.dart';
import '../../services/auth_service.dart';
import '../../models/user_model.dart';
import '../../providers/user_provider.dart' as user_provider;
import '../dashboard/home_screen.dart';
import 'package:provider/provider.dart';

class SignUpScreen extends StatefulWidget {
  @override
  _SignUpScreenState createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final _authService = AuthService();
  final _emailController = TextEditingController();
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isLoading = false;

  Future<void> _signUp() async {
    setState(() {
      _isLoading = true;
    });

    try {
      User user = await _authService.signUp(
        _usernameController.text,
        _emailController.text,
        _passwordController.text,
      );

      Provider.of<user_provider.UserProvider>(context, listen: false).setUser(user);

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => HomeScreen(user: user)),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Signup failed: ${e.toString()}')),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
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
              Text(
                'Create Account',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.w800,
                  fontFamily: 'BebasNeue',
                  color: Color(0xFFF5F5DC),
                  letterSpacing: 1.5,
                ),
              ),
              SizedBox(height: 30),
              SizedBox(
                width: MediaQuery.of(context).size.width * 0.8,
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
                width: MediaQuery.of(context).size.width * 0.8,
                child: TextField(
                  controller: _usernameController,
                  style: TextStyle(fontFamily: 'BebasNeue', fontSize: 18),
                  decoration: InputDecoration(
                    hintText: 'Username',
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
                width: MediaQuery.of(context).size.width * 0.8,
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
              SizedBox(height: 20),
              _isLoading
                  ? Center(child: CircularProgressIndicator())
                  : OutlinedButton(
                onPressed: _signUp,
                style: OutlinedButton.styleFrom(
                  side: BorderSide(color: Color(0xFFF5F5DC)),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  padding: EdgeInsets.symmetric(vertical: 12, horizontal: 30),
                ),
                child: Text(
                  'Sign Up',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'BebasNeue',
                    color: Color(0xFFF5F5DC),
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
