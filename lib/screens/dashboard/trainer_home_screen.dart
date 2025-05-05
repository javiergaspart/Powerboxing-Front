// TrainerHomeScreen.dart
import 'package:flutter/material.dart';
import './trainer_reservation_screen.dart';
import './previous_sessions_screen_trainer.dart'; // Add this import
import './upcoming_sessions_screen.dart'; // Add this import
import '../auth/trainer_login_screen.dart';

class TrainerHomeScreen extends StatelessWidget {
  final String trainerName;

  const TrainerHomeScreen({Key? key, required this.trainerName}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        elevation: 0,
        title: Text(
          'Welcome, $trainerName',
          style: TextStyle(
            color: Color(0xFF99C448),
            fontSize: 22,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.logout, color: Color(0xFF99C448)),
            onPressed: () {
              _confirmLogout(context);  // Show the confirmation alert
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildCard(
              context,
              title: 'My Availability',
              subtitle: 'Manage your slots',
              icon: Icons.access_time,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => TrainerAvailabilityScreen(),
                  ),
                );
              },
            ),
            SizedBox(height: 20),
            _buildCard(
              context,
              title: 'Upcoming Sessions',
              subtitle: 'View and track your sessions',
              icon: Icons.calendar_today,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => UpcomingSessionsScreen(), // Navigate to UpcomingSessionsScreen
                  ),
                );
              },
            ),
            SizedBox(height: 20),
            _buildCard(
              context,
              title: 'Previous Sessions',
              subtitle: 'View past sessions',
              icon: Icons.history,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => PreviousSessionsScreen(),
                  ),
                );
              },
            ),
            SizedBox(height: 20),
            _buildCard(
              context,
              title: 'Participants',
              subtitle: 'Assigned users & numbers',
              icon: Icons.people,
              onTap: () {
                Navigator.pushNamed(context, '/trainer/participants');
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCard(BuildContext context,
      {required String title,
        required String subtitle,
        required IconData icon,
        required VoidCallback onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(18),
        decoration: BoxDecoration(
          color: Colors.grey[850],
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black45,
              blurRadius: 6,
              offset: Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            Icon(icon, size: 34, color: Color(0xFF99C448)),
            SizedBox(width: 20),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title,
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold)),
                SizedBox(height: 4),
                Text(subtitle,
                    style: TextStyle(color: Colors.white54, fontSize: 14)),
              ],
            ),
          ],
        ),
      ),
    );
  }
  void _confirmLogout(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.black,
          title: Text("Confirm Logout", style: TextStyle(color: Colors.white)),
          content: Text("Are you sure you want to log out?", style: TextStyle(color: Colors.grey)),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),  // Close the dialog
              child: Text("Cancel", style: TextStyle(color: Colors.white)),
            ),
            TextButton(
              onPressed: () {
                _logout(context);  // Proceed to logout if confirmed
              },
              child: Text("Logout", style: TextStyle(color: Colors.redAccent)),
            ),
          ],
        );
      },
    );
  }

  void _logout(BuildContext context) {
    // If you have an authentication provider, you can call its logout method here
    // For now, it will just navigate back to the login screen after the confirmation.

    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => TrainerLoginScreen()),  // Replace with your login screen
          (route) => false,  // Remove all previous routes
    );
  }

}
