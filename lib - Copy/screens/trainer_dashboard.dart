import 'package:flutter/material.dart';
import 'trainer_availability_screen.dart';
import 'session_management_screen.dart';

class TrainerDashboard extends StatefulWidget {
  final String token;
  final String trainerId;

  TrainerDashboard({
    required this.token,
    required this.trainerId,
  });

  @override
  _TrainerDashboardState createState() => _TrainerDashboardState();
}

class _TrainerDashboardState extends State<TrainerDashboard> {
  int selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Trainer Dashboard")),
      body: selectedIndex == 0
          ? TrainerAvailabilityScreen() // ✅ No More Wrong Parameters
          : SessionManagementScreen(), // ✅ No More Wrong Parameters
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: selectedIndex,
        onTap: (index) {
          setState(() {
            selectedIndex = index;
          });
        },
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.calendar_today),
            label: "Availability",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.manage_accounts),
            label: "Sessions",
          ),
        ],
      ),
    );
  }
}
