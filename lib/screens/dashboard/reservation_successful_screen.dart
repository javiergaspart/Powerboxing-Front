import 'package:fitboxing_app/screens/dashboard/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../models/user_model.dart';

class ReservationSuccessfulScreen extends StatelessWidget {
  final DateTime reservationDate;
  final User user;

  const ReservationSuccessfulScreen({
    Key? key,
    required this.reservationDate,
    required this.user,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF151718),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                decoration: BoxDecoration(
                  color: Colors.black,
                  borderRadius: BorderRadius.circular(10),
                ),
                padding: EdgeInsets.all(20),
                child: Icon(
                  Icons.check_circle,
                  color: Color(0xFFA6C769),
                  size: 100,
                ),
              ),
              SizedBox(height: 24),
              Text(
                'Successfully Reserved\nyour session!',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFFA6C769),
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 24),
              OutlinedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => HomeScreen(user: user)),
                  );
                },
                style: OutlinedButton.styleFrom(
                  side: BorderSide(color: Color(0xFFA6C769)),
                  padding: EdgeInsets.symmetric(vertical: 12, horizontal: 30),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                ),
                child: Text(
                  'Home',
                  style: TextStyle(color: Color(0xFFA6C769)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}