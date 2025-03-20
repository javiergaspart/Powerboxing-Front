import 'package:flutter/material.dart';
import 'package:fitboxing_app/models/user_model.dart';
import 'package:fitboxing_app/providers/user_provider.dart' as user_provider;
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import '../../constants/urls.dart';
import 'dart:convert';
import 'package:provider/provider.dart';
import 'package:http_parser/http_parser.dart';
import 'package:mime/mime.dart';

class MyProfileScreen extends StatefulWidget {
  final User user;

  const MyProfileScreen({Key? key, required this.user}) : super(key: key);

  @override
  State<MyProfileScreen> createState() => _MyProfileScreenState();
}

class _MyProfileScreenState extends State<MyProfileScreen> {
  late TextEditingController _nameController;
  late TextEditingController _emailController;
  late TextEditingController _contactController;
  late TextEditingController _passwordController;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.user.username);
    _emailController = TextEditingController(text: widget.user.email);
    _contactController = TextEditingController(text: widget.user.phone);
    _passwordController = TextEditingController();
  }

  Future<void> _updateProfile() async {
    final updatedUser = {
      "username": _nameController.text,
      "email": _emailController.text,
      "phone": _contactController.text,
      if (_passwordController.text.isNotEmpty) "password": _passwordController.text,
    };

    var uri = Uri.parse("${AppUrls.updateProfile}/${widget.user.id}");
    var response = await http.put(
      uri,
      headers: {"Content-Type": "application/json"},
      body: jsonEncode(updatedUser),
    );

    if (response.statusCode == 200) {
      var responseData = jsonDecode(response.body);
      final newUser = widget.user.copyWith(
        username: responseData['user']['username'],
        email: responseData['user']['email'],
        phone: responseData['user']['phone'],
      );
      Provider.of<user_provider.UserProvider>(context, listen: false).setUser(newUser);
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Profile updated successfully!")));
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Failed to update profile.")));
    }
  }

  Future<String> uploadImage(File imageFile) async {
    var uri = Uri.parse("${AppUrls.updateProfileImage}/${widget.user.id}");
    var request = http.MultipartRequest('POST', uri);
    String? mimeType = lookupMimeType(imageFile.path) ?? 'image/jpeg';

    request.files.add(
      await http.MultipartFile.fromPath(
        'image',
        imageFile.path,
        contentType: MediaType.parse(mimeType),
      ),
    );

    var response = await request.send();

    if (response.statusCode == 200) {
      var responseData = await response.stream.bytesToString();
      var decodedData = jsonDecode(responseData);
      return decodedData['user']['profileImage'];
    } else {
      throw Exception("Failed to upload image: \${response.statusCode}");
    }
  }

  void _updateProfileImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);

    if (image != null) {
      File file = File(image.path);
      try {
        String imageUrl = await uploadImage(file);
        if (imageUrl.isNotEmpty) {
          final updatedUser = widget.user.copyWith(profileImage: imageUrl);
          Provider.of<user_provider.UserProvider>(context, listen: false).setUser(updatedUser);
        }
      } catch (e) {
        print("Error updating image: $e");
      }
    }
  }

  Future<bool> _onWillPop() async {
    return true;
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        backgroundColor: Color(0xFF0A3D2D),
        appBar: AppBar(
          backgroundColor: Color(0xFF0A3D2D),
          leading: IconButton(
            icon: Icon(Icons.arrow_back, color: Colors.white, size: 30, weight: 900),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
          title: Text('My Profile', style: TextStyle(color: Colors.white)),
        ),
        body: Column(
          children: [
            SizedBox(height: 20),
            Center(
              child: Container(
                width: 120,
                height: 120,
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey.shade300, width: 3),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Consumer<user_provider.UserProvider>(
                  builder: (context, userProvider, child) {
                    final user = userProvider.user;
                    return ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: (user?.profileImage ?? '').isNotEmpty
                          ? (user!.profileImage!.startsWith('http')
                          ? Image.network(user.profileImage!, width: 100, height: 100, fit: BoxFit.cover)
                          : Image.network('http://10.0.2.2:5173/fitboxing${user.profileImage!}', width: 100, height: 100, fit: BoxFit.cover))
                          : Image.asset('assets/images/anonymous.png', width: 100, height: 100, fit: BoxFit.cover),
                    );
                  },
                ),
              ),
            ),
            SizedBox(height: 20),
            Expanded(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      TextField(
                        controller: _nameController,
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: Color(0xFFF5F5DC),
                          labelText: 'Username',
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                          floatingLabelBehavior: FloatingLabelBehavior.auto, // Hides label when text is entered
                        ),
                      ),
                      SizedBox(height: 10),
                      TextField(
                        controller: _emailController,
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: Color(0xFFF5F5DC),
                          labelText: 'Email',
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                          floatingLabelBehavior: FloatingLabelBehavior.auto, // Hides label when text is entered
                        ),
                      ),
                      SizedBox(height: 10),
                      TextField(
                        controller: _contactController,
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: Color(0xFFF5F5DC),
                          labelText: 'Contact',
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                          floatingLabelBehavior: FloatingLabelBehavior.auto, // Hides label when text is entered
                        ),
                      ),
                      SizedBox(height: 10),
                      TextField(
                        controller: _passwordController,
                        obscureText: true,
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: Color(0xFFF5F5DC),
                          labelText: 'Password',
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                          floatingLabelBehavior: FloatingLabelBehavior.auto, // Hides label when text is entered
                        ),
                      ),
                      SizedBox(height: 20),
                      ElevatedButton(
                        onPressed: _updateProfile,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Color(0xFF0A3D2D),
                          foregroundColor: Color(0xFFF5F5DC),
                          padding: EdgeInsets.symmetric(vertical: 16, horizontal: 32),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                            side: BorderSide(color: Color(0xFFF5F5DC)),
                          ),
                        ),
                        child: Text('Update Profile', style: TextStyle(fontSize: 18)),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
