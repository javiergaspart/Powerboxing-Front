import 'package:fitboxing_app/screens/dashboard/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../models/user_model.dart'; // Ensure you import the User model

class ReservationSuccessfulScreen extends StatelessWidget {
  final DateTime reservationDate;
  final User user; // Add User object to the constructor

  const ReservationSuccessfulScreen({
    Key? key,
    required this.reservationDate,
    required this.user, // Accept the user as a parameter
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Reservation Successful')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Icon(Icons.check_circle, color: Colors.green, size: 100),
            SizedBox(height: 16),
            Text(
              'Session Successfully Booked!',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 16),
            Text(
              'Your session is confirmed for:',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 8),
            Text(
              DateFormat.yMMMMd().add_jm().format(reservationDate),
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 32),
            ElevatedButton(
              onPressed: () {
                // Navigate to dashboard, passing the user object
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => HomeScreen(user: user)), // Navigate to SignUpScreen
                );
              },
              child: Text('Go to Home'),
            ),
          ],
        ),
      ),
    );
  }
}
