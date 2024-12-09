import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SettingsScreen extends StatefulWidget {
  @override
  _SettingsScreenState createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  final _formKey = GlobalKey<FormState>();
  final FlutterSecureStorage _secureStorage = FlutterSecureStorage();

  // Dummy data for profile (replace with actual user data)
  String _name = "Shruti Verma";
  String _email = "vermaashruti28@example.com";
  String _location = "Hyderabad";
  String _password = "********"; // Don't show the actual password for security reasons
  File? _profileImage;

  // Function to pick a new profile picture
  Future<void> _pickProfileImage() async {
    final ImagePicker _picker = ImagePicker();
    final XFile? pickedFile = await _picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _profileImage = File(pickedFile.path);
      });
    }
  }

  // Log out function
  Future<void> _logOut() async {
    await _secureStorage.delete(key: 'auth_token'); // Delete the token from secure storage
    Navigator.pushReplacementNamed(context, '/login'); // Redirect to login screen
  }

  // Function to save profile updates (you'll need to integrate it with your backend or local storage)
  Future<void> _saveProfile() async {
    if (_formKey.currentState?.validate() ?? false) {
      _formKey.currentState?.save();

      // You can make an API call here to save the updated user data
      print("Profile Updated: $_name, $_email, $_location, $_password");

      // Show a success message
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Profile updated successfully!')));
    }
  }

  // Function to change password (implement your password change logic here)
  Future<void> _changePassword() async {
    // Show a dialog or navigate to a password change screen
    print("Change Password button clicked");
    // Implement password change logic here
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Settings'),
        actions: [
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: _logOut,
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Profile Picture
                Center(
                  child: GestureDetector(
                    onTap: _pickProfileImage,
                    child: CircleAvatar(
                      radius: 50,
                      backgroundImage: _profileImage != null
                          ? FileImage(_profileImage!)
                          : NetworkImage('https://via.placeholder.com/150') as ImageProvider,
                    ),
                  ),
                ),
                SizedBox(height: 20),

                // Name TextField
                TextFormField(
                  initialValue: _name,
                  decoration: InputDecoration(labelText: 'Name'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your name';
                    }
                    return null;
                  },
                  onSaved: (newValue) => _name = newValue!,
                ),
                SizedBox(height: 20),

                // Email TextField
                TextFormField(
                  initialValue: _email,
                  decoration: InputDecoration(labelText: 'Email'),
                  enabled: false, // Email should not be editable
                ),
                SizedBox(height: 20),

                // Location Dropdown
                DropdownButtonFormField<String>(
                  value: _location,
                  decoration: InputDecoration(labelText: 'Location'),
                  items: ['Hyderabad', 'Bengaluru'].map((location) {
                    return DropdownMenuItem<String>(
                      value: location,
                      child: Text(location),
                    );
                  }).toList(),
                  onChanged: (newValue) {
                    setState(() {
                      _location = newValue!;
                    });
                  },
                ),
                SizedBox(height: 20),

                // Password TextField
                TextFormField(
                  initialValue: _password,
                  decoration: InputDecoration(labelText: 'Password'),
                  obscureText: true,
                  onSaved: (newValue) => _password = newValue!,
                ),
                SizedBox(height: 20),

                // Save Profile Button
                ElevatedButton(
                  onPressed: _saveProfile,
                  child: Text('Save Profile'),
                ),
                SizedBox(height: 20),

                // Change Password Button
                ElevatedButton(
                  onPressed: _changePassword,
                  child: Text('Change Password'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
