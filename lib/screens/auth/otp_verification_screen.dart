import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../dashboard/home_screen.dart';
import '../../providers/user_provider.dart' as user_provider;
import 'dart:convert';
import '../../models/user_model.dart';
import '../../constants/urls.dart';
import 'package:provider/provider.dart';
import './trainer_login_screen.dart';
import 'dart:async';

class OtpVerificationScreen extends StatefulWidget {
  final String sessionId;
  final String phone;
  final String email;
  final String username;

  OtpVerificationScreen({
    required this.sessionId,
    required this.phone,
    required this.email,
    required this.username,
  });

  @override
  _OtpVerificationScreenState createState() => _OtpVerificationScreenState();
}

class _OtpVerificationScreenState extends State<OtpVerificationScreen> {
  final _otpController = TextEditingController();
  bool _isLoading = false;
  bool _isResending = false;
  bool _canResend = true;
  late String _currentSessionId;
  String _selectedCountryCode = '+91';

  @override
  void initState() {
    super.initState();
    _currentSessionId = widget.sessionId;
  }

  Future<void> _verifyAndRegister() async {
    print("Inside");
    setState(() => _isLoading = true);
    final response = await http.post(
      Uri.parse('${AppUrls.baseUrl}/auth/verify-otp-phone/signup'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'sessionId': _currentSessionId,
        'otp': _otpController.text,
      }),
    );
    print('DEBUG: OTP verification response status: ${response.statusCode}');
    print('DEBUG: OTP verification response body: ${response.body}');

      final data = jsonDecode(response.body);
      print('data: $data');
      if (data['Status'] == 'Success') {
      print('DEBUG: OTP verified successfully. User data received.');

      final token = data['token']; // If JWT returned

      print('token: $token');
      print('DEBUG: User set in provider. Navigating to HomeScreen.');

      final registerResponse = await http.post(
        Uri.parse('${AppUrls.baseUrl}/auth/registerUser'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode({
          'phone': widget.phone,
          'email': widget.email,
          'username': widget.username,
        }),
      );
      print('DEBUG: Registration response body: ${registerResponse.body}');

      if (registerResponse.statusCode == 200) {
        final data = jsonDecode(registerResponse.body);
        final user = User.fromJson(data['user']);
        print('user: $user');
        context.read<user_provider.UserProvider>().setUser(user);
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => HomeScreen(user: user)),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Registration failed')),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(data['message'] ?? 'OTP verification failed')),
      );
    }

    setState(() => _isLoading = false);
  }

  Future<void> _resendOtp() async {
    if (!_canResend) return;

    setState(() {
      _isResending = true;
      _canResend = false;
    });

    final response = await http.post(
      Uri.parse('${AppUrls.baseUrl}/auth/send-otp/signup'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'phone': widget.phone,
        'email': widget.email,
        'username': widget.username,
      }),
    );

    final data = jsonDecode(response.body);

    if (response.statusCode == 200 && data['Status'] == 'Success') {
      setState(() {
        _currentSessionId = data['Details']; // Update session ID
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('OTP resent successfully')),
      );

      // Cooldown timer
      Future.delayed(Duration(seconds: 30), () {
        setState(() => _canResend = true);
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(data['message'] ?? 'Failed to resend OTP')),
      );
    }

    setState(() => _isResending = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: _otpController,
              keyboardType: TextInputType.number,
              style: TextStyle(color: Colors.white),
              decoration: InputDecoration(
                hintText: 'Enter OTP',
                hintStyle: TextStyle(color: Colors.white54),
                filled: true,
                fillColor: Colors.grey[800],
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide.none),
              ),
            ),
            const SizedBox(height: 24),
            _isLoading
                ? CircularProgressIndicator()
                : ElevatedButton(
              onPressed: _verifyAndRegister,
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xFF99C448),
                padding: EdgeInsets.symmetric(vertical: 14, horizontal: 40),
              ),
              child: Text('Verify & Register', style: TextStyle(color: Colors.white)),
            ),
            const SizedBox(height: 16),
            TextButton(
              onPressed: _canResend ? _resendOtp : null,
              child: _isResending
                  ? Text('Sending...', style: TextStyle(color: Colors.grey))
                  : Text(
                _canResend ? 'Resend OTP' : 'Please wait...',
                style: TextStyle(color: _canResend ? Colors.white : Colors.grey),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
