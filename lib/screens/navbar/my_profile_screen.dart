import 'package:flutter/material.dart';
import 'package:fitboxing_app/models/user_model.dart';
import 'package:fitboxing_app/providers/user_provider.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import '../../constants/urls.dart';
import 'dart:convert';
import 'package:provider/provider.dart';
import 'package:http_parser/http_parser.dart';
import 'package:mime/mime.dart';
import '../dashboard/home_screen.dart';

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
      Provider.of<UserProvider>(context, listen: false).setUser(newUser);
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
          Provider.of<UserProvider>(context, listen: false).setUser(updatedUser);
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
        backgroundColor: Color(0xFF151718),
        appBar: AppBar(
          backgroundColor: Colors.black,
          leading: IconButton(
            icon: Icon(Icons.arrow_back, color: Colors.white, size: 30, weight: 900),
            onPressed: () {
              if (Navigator.canPop(context)) {
                Navigator.pop(context);
              } else {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => HomeScreen(user: Provider.of<UserProvider>(context, listen: false).user),
                  ),
                );
              }
            },
          ),
          title: Text('My Profile', style: TextStyle(color: Colors.white)),
        ),
        body: Column(
          children: [
            SizedBox(height: 20),
            Center(
              child: Column(
                children: [
                  Container(
                    width: 160,
                    height: 160,
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey.shade300, width: 3),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Consumer<UserProvider>(
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
                  SizedBox(height: 10),
                  Text(
                    widget.user.username.toUpperCase(),
                    style: TextStyle(color: Color(0xFF99C448), fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
            SizedBox(height: 20),
            Expanded(
                child: SingleChildScrollView(
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16.0),
                    child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Username',
                        style: TextStyle(
                          fontFamily: 'Roboto Condensed',
                          fontSize: 20,
                          color: Colors.white,
                        ),
                      ),
                      SizedBox(height: 5),
                      TextField(
                        controller: _nameController,
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: Color(0xFF767575),
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                        ),
                        style: TextStyle(fontSize: 16, color: Colors.white),
                      ),
                      SizedBox(height: 45),
                      Text(
                        'Email',
                        style: TextStyle(
                          fontFamily: 'Roboto Condensed',
                          fontSize: 20,
                          color: Colors.white,
                        ),
                      ),
                      SizedBox(height: 5),
                      TextField(
                        controller: _emailController,
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: Color(0xFF767575),
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                        ),
                        style: TextStyle(fontSize: 16, color: Colors.white),
                      ),
                      SizedBox(height: 45),
                      Text(
                        'Contact',
                        style: TextStyle(
                          fontFamily: 'Roboto Condensed',
                          fontSize: 20,
                          color: Colors.white,
                        ),
                      ),
                      SizedBox(height: 5),
                      TextField(
                        controller: _contactController,
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: Color(0xFF767575),
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                        ),
                        style: TextStyle(fontSize: 16, color: Colors.white),
                      ),
                      SizedBox(height: 45),
                      Text(
                        'Password',
                        style: TextStyle(
                          fontFamily: 'Roboto Condensed',
                          fontSize: 20,
                          color: Colors.white,
                        ),
                      ),
                      SizedBox(height: 5),
                      TextField(
                        controller: _passwordController,
                        obscureText: true,
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: Color(0xFF767575),
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                        ),
                        style: TextStyle(fontSize: 16, color: Colors.white),
                      ),
                      SizedBox(height: 45),
                      Center(
                      child: ElevatedButton(
                        onPressed: _updateProfile,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Color(0xFF99C448),
                          foregroundColor: Colors.white,
                          padding: EdgeInsets.symmetric(vertical: 14, horizontal: 30),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: Text(
                          'Update Profile',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
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
