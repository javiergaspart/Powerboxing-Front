import 'package:flutter/material.dart';
import 'otp_verification_screen.dart';
import 'package:http/http.dart' as http;
import '../../constants/urls.dart';
import 'dart:convert';

class SignupInputScreen extends StatefulWidget {
  @override
  _SignupInputScreenState createState() => _SignupInputScreenState();
}

class _SignupInputScreenState extends State<SignupInputScreen> {
  final _phoneController = TextEditingController();
  final _emailController = TextEditingController();
  final _usernameController = TextEditingController();

  bool _isLoading = false;
  String _selectedCountryCode = '+91';

  Future<void> _sendOtp() async {
    setState(() => _isLoading = true);

    final response = await http.post(
      Uri.parse('${AppUrls.baseUrl}/auth/send-otp/signup'), // Correct endpoint
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'phone': '$_selectedCountryCode${_phoneController.text.trim()}',
        'email': _emailController.text.trim(),
        'username': _usernameController.text.trim(),
      }),
    );

    final data = jsonDecode(response.body);

    if (response.statusCode == 200 && data['Status'] == 'Success') {
      final sessionId = data['Details'];

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => OtpVerificationScreen(
            sessionId: sessionId,
            phone: '$_selectedCountryCode${_phoneController.text.trim()}',
            email: _emailController.text.trim(),
            username: _usernameController.text.trim(),
          ),
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(data['message'] ?? 'Failed to send OTP')),
      );
    }

    setState(() => _isLoading = false);
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
            _buildTextField(_usernameController, 'Username'),
            const SizedBox(height: 16),
            _buildTextField(_emailController, 'Email'),
            const SizedBox(height: 16),
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
                    _phoneController,
                    'Enter 10-digit Number',
                    keyboard: TextInputType.number,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 32),
            _isLoading
                ? CircularProgressIndicator()
                : ElevatedButton(
              onPressed: _sendOtp,
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xFF99C448),
                padding: EdgeInsets.symmetric(vertical: 14, horizontal: 40),
              ),
              child: Text('Send OTP', style: TextStyle(color: Colors.white)),
            ),
            const SizedBox(height: 20),
            TextButton(
              onPressed: () => Navigator.pop(context), // Go back to Login
              child: const Text(
                'Back to Login',
                style: TextStyle(color: Colors.white, fontSize: 16),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField(TextEditingController controller, String hint, {TextInputType keyboard = TextInputType.text}) {
    return TextField(
      controller: controller,
      keyboardType: keyboard,
      style: TextStyle(color: Colors.white),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: TextStyle(color: Colors.white54),
        filled: true,
        fillColor: Colors.grey[800],
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide.none),
      ),
    );
  }
}
