import 'package:flutter/material.dart';
import 'package:flutter_animated_icons/flutter_animated_icons.dart';
import '../../styles/my_profile_styles.dart';
import '../../widgets/energy_bar_chart.dart';
import 'package:fitboxing_app/models/user_model.dart';
import 'package:fitboxing_app/providers/user_provider.dart' as user_provider; // ✅ Alias to avoid conflict
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import '../../constants/urls.dart';
import 'dart:convert';
import 'package:provider/provider.dart'; // Ensure this is imported

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

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.user.username);
    _emailController = TextEditingController(text: widget.user.email);
    _contactController = TextEditingController(text: widget.user.contact);
  }
  Future<String> uploadImage(File imageFile) async {
    var request = http.MultipartRequest(
      'POST',
      Uri.parse('${AppUrls.uploadProfileImage}/${widget.user.id}'),
    );

    request.files.add(await http.MultipartFile.fromPath('image', imageFile.path));

    var response = await request.send();

    if (response.statusCode == 200) {
      var responseData = await response.stream.bytesToString();
      return jsonDecode(responseData)['imageUrl']; // Get image URL from API
    } else {
      throw Exception("Failed to upload image");
    }
  }

  // Handle profile image update
  void _updateProfileImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);

    if (image != null) {
      File file = File(image.path);
      String imageUrl = await uploadImage(file); // Upload image

      if (imageUrl.isNotEmpty) {
        setState(() {
          final updatedUser = User(
            id: widget.user.id,
            email: widget.user.email,
            username: widget.user.username,
            contact: widget.user.contact,
            profileImage: imageUrl.isNotEmpty ? imageUrl : widget.user.profileImage, // ✅ Only update if valid
            membershipType: widget.user.membershipType,
          );

          Provider.of<user_provider.UserProvider>(context, listen: false).setUser(updatedUser);
        });

        print("Image uploaded: $imageUrl");
      }

    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Text('My Profile'),
            SizedBox(width: 10),
            AnimatedIcon(
              icon: AnimatedIcons.event_add,
              progress: AlwaysStoppedAnimation(1.0),
            ),
          ],
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              // Profile Picture with Edit Icon
              Stack(
                alignment: Alignment.bottomRight,
                children: [
                  CircleAvatar(
                    radius: 60,
                    backgroundImage: widget.user.profileImage != null && widget.user.profileImage!.isNotEmpty
                        ? (widget.user.profileImage!.startsWith('http') // Check if it's a URL
                        ? NetworkImage(widget.user.profileImage!) // ✅ Use NetworkImage for URLs
                        : FileImage(File(widget.user.profileImage!)) as ImageProvider) // ✅ Use FileImage for local paths
                        : AssetImage('assets/images/profile_photo.jpg') as ImageProvider,
                  ),
                  IconButton(
                    onPressed: _updateProfileImage,
                    icon: Icon(Icons.edit, color: Colors.blueAccent),
                    tooltip: 'Edit Profile Image',
                  ),
                ],
              ),
              SizedBox(height: 16),
              // Input Fields
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Name:', style: MyProfileStyles.labelStyle),
                  TextField(
                    controller: _nameController,
                    style: MyProfileStyles.inputStyle,
                    decoration: MyProfileStyles.inputDecoration,
                  ),
                  SizedBox(height: 16),
                  Text('Contact No:', style: MyProfileStyles.labelStyle),
                  TextField(
                    controller: _contactController,
                    style: MyProfileStyles.inputStyle,
                    decoration: MyProfileStyles.inputDecoration,
                  ),
                  SizedBox(height: 16),
                  Text('Email ID:', style: MyProfileStyles.labelStyle),
                  TextField(
                    controller: _emailController,
                    style: MyProfileStyles.inputStyle,
                    decoration: MyProfileStyles.inputDecoration,
                  ),
                ],
              ),
              SizedBox(height: 32),
              // My Averages Section
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('My Averages:', style: MyProfileStyles.titleStyle),
                  SizedBox(height: 16),
                  EnergyBarChart(), // Custom widget for Bar Chart
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
