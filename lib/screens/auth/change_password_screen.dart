import 'package:flutter/material.dart';
import 'package:fitboxing_app/services/password_service.dart'; // Make sure this file exists and has the relevant methods.

class ChangePasswordScreen extends StatefulWidget {
  final String userId; // Assuming userId is passed in

  ChangePasswordScreen({required this.userId});

  @override
  _ChangePasswordScreenState createState() => _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends State<ChangePasswordScreen> {
  final TextEditingController _currentPasswordController = TextEditingController();
  final TextEditingController _newPasswordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();

  String _error = '';
  String _success = '';

  Future<void> _handleChangePassword() async {
    String currentPassword = _currentPasswordController.text;
    String newPassword = _newPasswordController.text;
    String confirmPassword = _confirmPasswordController.text;

    if (newPassword != confirmPassword) {
      setState(() {
        _error = 'New passwords do not match';
        _success = '';
      });
      return;
    }

    setState(() {
      _error = '';
      _success = '';
    });

    // Assuming you have a method to call the backend service.
    var response = await PasswordService.changePassword(widget.userId, currentPassword, newPassword);

    if (response['success']) {
      setState(() {
        _success = 'Password changed successfully!';
      });
    } else {
      setState(() {
        _error = response['message'] ?? 'An error occurred';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        iconTheme: IconThemeData(color: Colors.white),
        title: Text("Change Password", style: TextStyle(color: Colors.white)),
      ),
      backgroundColor: Color(0xFF121212),
      body: SingleChildScrollView( // Wrap the body in a SingleChildScrollView to prevent overflow
        padding: EdgeInsets.symmetric(vertical: 20, horizontal: 15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Forgot your Password or want to change it? No problem! Just keep in mind that your password must contain at least 6 letters.',
              style: TextStyle(color: Color(0xFF9ACD32), fontSize: 14),
            ),
            SizedBox(height: 20),
            _buildTextField('Current Password', _currentPasswordController),
            _buildTextField('New Password', _newPasswordController),
            _buildTextField('Confirm Password', _confirmPasswordController),
            SizedBox(height: 10),
            if (_error.isNotEmpty) ...[
              Text(_error, style: TextStyle(color: Colors.red)),
              SizedBox(height: 10),
            ],
            if (_success.isNotEmpty) ...[
              Text(_success, style: TextStyle(color: Color(0xFF99C448))),
              SizedBox(height: 10),
            ],
            // Centering the button and increasing its size
            Center(
              child: ElevatedButton(
                onPressed: _handleChangePassword,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.transparent,
                  side: BorderSide(color: Color(0xFF9ACD32)),
                  padding: EdgeInsets.symmetric(vertical: 15, horizontal: 50), // Larger padding
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                ),
                child: Text('Submit', style: TextStyle(color: Color(0xFF9ACD32), fontSize: 18)), // Increased font size
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField(String label, TextEditingController controller) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: TextStyle(color: Colors.white, fontSize: 16), // Increased font size
          ),
          SizedBox(height: 5),
          TextField(
            controller: controller,
            obscureText: true,
            style: TextStyle(color: Colors.white, fontSize: 16), // Increased font size
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
