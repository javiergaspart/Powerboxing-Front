import 'package:flutter/material.dart';
import 'package:flutter_animated_icons/flutter_animated_icons.dart';
import '../../styles/my_profile_styles.dart';
import '../../widgets/energy_bar_chart.dart';
import '../../models/user_model.dart';

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

  void _updateProfileImage() {
    // Logic to update the profile image from the device
    print("Edit profile image tapped!");
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
                    backgroundImage: widget.user.profileImage != null
                        ? NetworkImage(widget.user.profileImage!)
                        : AssetImage('assets/images/default_profile.png') as ImageProvider,
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
