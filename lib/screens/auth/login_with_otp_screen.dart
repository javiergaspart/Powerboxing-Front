import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../../providers/user_provider.dart' as user_provider;
import 'dart:convert';
import '../../models/user_model.dart';
import '../../constants/urls.dart';
import 'package:provider/provider.dart';
import '../dashboard/home_screen.dart';
import './trainer_login_screen.dart';
import 'dart:async';

class LoginWithOtpScreen extends StatefulWidget {
  @override
  _LoginWithOtpScreenState createState() => _LoginWithOtpScreenState();
}

class _LoginWithOtpScreenState extends State<LoginWithOtpScreen> {
  final _phoneController = TextEditingController();
  final _otpController = TextEditingController();


  bool _isLoading = false;
  bool _otpSent = false;
  String? _sessionId;
  bool _canResendOtp = false;
  Timer? _resendTimer;
  String _selectedCountryCode = '+91';


  Future<void> _sendOtp() async {
    setState(() => _isLoading = true);
    final response = await http.post(
      Uri.parse('${AppUrls.baseUrl}/auth/send-otp-phone'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'phone': '$_selectedCountryCode${_phoneController.text}'}),
    );
    final data = jsonDecode(response.body);
    if (data['Status'] == 'Success') {
      setState(() {
        _sessionId = data['Details'];
        _otpSent = true;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('OTP sent successfully')),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to send OTP')),
      );
    }
    _resendTimer?.cancel();
    _canResendOtp = false;
    _resendTimer = Timer(const Duration(seconds: 10), () {
      if (mounted) {
        setState(() {
          _canResendOtp = true;
        });
      }
    });
    setState(() => _isLoading = false);
  }

  Future<void> _resendOtp() async {
    await _sendOtp();
  }


  Future<void> _verifyOtp() async {
    if (_sessionId == null) {
      print('DEBUG: sessionId is null. Aborting OTP verification.');
      return;
    }

    setState(() => _isLoading = true);
    print('DEBUG: Verifying OTP...');

    try {
      final response = await http.post(
        Uri.parse('${AppUrls.baseUrl}/auth/verify-otp-phone'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'sessionId': _sessionId,
          'otp': _otpController.text,
          'phone': '$_selectedCountryCode${_phoneController.text}',
        }),
      );

      print('DEBUG: OTP verification response status: ${response.statusCode}');
      print('DEBUG: OTP verification response body: ${response.body}');

      final data = jsonDecode(response.body);
      print('Data: $data');

      if (data['Status'] == 'Success') {
        print('DEBUG: OTP verified successfully. User data received.');

        final userJson = data['user'];
        final user = User.fromJson(userJson);

        if (!mounted) {
          print('DEBUG: Widget is no longer mounted. Aborting navigation.');
          return;
        }

        context.read<user_provider.UserProvider>().setUser(user);
        print('DEBUG: User set in provider. Navigating to HomeScreen: $user');

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => HomeScreen(user: user)),
        );
      } else {
        print('DEBUG: OTP verification failed or user not returned.');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Invalid OTP')),
        );
      }
    } catch (e) {
      print('DEBUG: Exception during OTP verification: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Something went wrong.')),
      );
    }

    if (mounted) setState(() => _isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 100),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Image.asset(
                'assets/images/login_banner.jpeg',
                width: MediaQuery.of(context).size.width * 0.7,
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
              child: Column(
                children: [
                  Row(
                    children: [
                      Expanded(
                        flex: 2,
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                          decoration: BoxDecoration(
                            color: Colors.grey[800],
                            borderRadius: BorderRadius.circular(10),
                            boxShadow: const [
                              BoxShadow(
                                color: Color(0xFF8C8C8C),
                                blurRadius: 4,
                                offset: Offset(0, 3),
                              ),
                            ],
                          ),
                          child: DropdownButtonHideUnderline(
                            child: DropdownButton<String>(
                              value: _selectedCountryCode,
                              dropdownColor: Colors.grey[900],
                              style: const TextStyle(color: Colors.white, fontSize: 16),
                              items: <String>['+91', '+1', '+44', '+61', '+971']
                                  .map<DropdownMenuItem<String>>((String value) {
                                return DropdownMenuItem<String>(
                                  value: value,
                                  child: Text(value),
                                );
                              }).toList(),
                              onChanged: (String? newValue) {
                                setState(() {
                                  _selectedCountryCode = newValue!;
                                });
                              },
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        flex: 5,
                        child: _buildTextField(
                          controller: _phoneController,
                          hintText: 'Enter 10-digit Number',
                          keyboardType: TextInputType.number,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  if (_otpSent)
                    _buildTextField(
                      controller: _otpController,
                      hintText: 'Enter OTP',
                      keyboardType: TextInputType.number,
                    ),
                  const SizedBox(height: 40),
                  _isLoading
                      ? const CircularProgressIndicator()
                      : ElevatedButton(
                    onPressed: _otpSent ? _verifyOtp : _sendOtp,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF99C448),
                      padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 40),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: Text(
                      _otpSent ? 'Verify OTP' : 'Send OTP',
                      style: const TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  if (_otpSent)
                    TextButton(
                      onPressed: _canResendOtp ? _resendOtp : null,
                      child: Text(
                        'Resend OTP',
                        style: TextStyle(
                          color: _canResendOtp ? Colors.white : Colors.grey,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  const SizedBox(height: 20),
                  if (!_otpSent)
                    Column(
                      children: [
                        TextButton(
                          onPressed: () => Navigator.pushNamed(context, '/signup'),
                          child: const Text(
                            'Don’t have an account? Sign Up',
                            style: TextStyle(color: Colors.white, fontSize: 16),
                          ),
                        ),
                        TextButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => TrainerLoginScreen()),
                            );
                          },
                          child: Text(
                            "Login as Trainer",
                            style: TextStyle(
                              color: Color(0xFF99C448),
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String hintText,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey[600],
        borderRadius: BorderRadius.circular(10),
        boxShadow: const [
          BoxShadow(
            color: Color(0xFF8C8C8C),
            blurRadius: 4,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: TextField(
        controller: controller,
        keyboardType: keyboardType,
        style: const TextStyle(color: Colors.white),
        decoration: InputDecoration(
          hintText: hintText,
          hintStyle: const TextStyle(color: Colors.white54),
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
