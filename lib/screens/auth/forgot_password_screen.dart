import 'package:flutter/material.dart';
import 'package:fitboxing_app/services/password_service.dart'; // Ensure this file exists

class ForgotPasswordScreen extends StatefulWidget {
  @override
  _ForgotPasswordScreenState createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _otpController = TextEditingController();
  final TextEditingController _newPasswordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();

  bool _otpSent = false;
  String _error = '';
  String _success = '';

  Future<void> _sendOtp() async {
    String email = _emailController.text;
    var response = await PasswordService.sendResetOTP(email);

    if (response['success']) {
      setState(() {
        _otpSent = true;
        _success = 'OTP sent successfully';
        _error = '';
      });
    } else {
      setState(() {
        _error = response['message'] ?? 'Error sending OTP';
        _success = '';
      });
    }
  }

  Future<void> _resetPassword() async {
    String email = _emailController.text;
    String otp = _otpController.text;
    String newPassword = _newPasswordController.text;
    String confirmPassword = _confirmPasswordController.text;

    if (newPassword != confirmPassword) {
      setState(() {
        _error = 'Passwords do not match';
        _success = '';
      });
      return;
    }

    var response = await PasswordService.resetPassword(email, otp, newPassword);

    if (response['success']) {
      setState(() {
        _success = 'Password reset successfully';
        _error = '';
      });
      Future.delayed(Duration(seconds: 2), () {
        Navigator.pushReplacementNamed(context, '/login');
      });
    } else {
      setState(() {
        _error = response['message'] ?? 'Error resetting password';
        _success = '';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Text("Forgot Password", style: TextStyle(color: Colors.white)),
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      backgroundColor: Color(0xFF151718),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(vertical: 20, horizontal: 15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildTextField('Email', _emailController, false),
            if (_otpSent) ...[
              _buildTextField('OTP', _otpController, false),
              _buildTextField('New Password', _newPasswordController, true),
              _buildTextField('Confirm Password', _confirmPasswordController, true),
            ],
            SizedBox(height: 10),
            if (_error.isNotEmpty) Text(_error, style: TextStyle(color: Colors.red)),
            if (_success.isNotEmpty) Text(_success, style: TextStyle(color: Color(0xFF99C448))),
            SizedBox(height: 20),
            Center(
              child: ElevatedButton(
                onPressed: _otpSent ? _resetPassword : _sendOtp,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.transparent,
                  side: BorderSide(color: Color(0xFF9ACD32)),
                  padding: EdgeInsets.symmetric(vertical: 15, horizontal: 50),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                ),
                child: Text(
                  _otpSent ? 'Reset Password' : 'Send OTP',
                  style: TextStyle(color: Color(0xFF9ACD32), fontSize: 18),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField(String label, TextEditingController controller, bool obscureText) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: TextStyle(color: Colors.white, fontSize: 16),
          ),
          SizedBox(height: 5),
          TextField(
            controller: controller,
            obscureText: obscureText,
            style: TextStyle(color: Colors.white, fontSize: 16),
            decoration: InputDecoration(
              filled: true,
              fillColor: Color(0xFF555555),
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
            ),
          ),
        ],
      ),
    );
  }
}
