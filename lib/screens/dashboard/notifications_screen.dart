import 'package:flutter/material.dart';

class NotificationsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF151718), // Ensures the background is black
      appBar: AppBar(
        title: Text(
          'Notifications',
          style: TextStyle(color: Colors.white), // Title color white
        ),
        backgroundColor: Colors.black,
        iconTheme: IconThemeData(color: Colors.white), // Back arrow color white
      ),
      body: Center(
        child: Text(
          'No new notifications!',
          style: TextStyle(color: Colors.white, fontSize: 18),
        ),
      ),
    );
  }
}
