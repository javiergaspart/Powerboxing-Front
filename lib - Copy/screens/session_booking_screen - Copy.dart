import 'package:flutter/material.dart';

class SessionBookingScreen extends StatelessWidget {
  final String token;

  SessionBookingScreen({required this.token});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Book a Session')),
      body: Center(child: Text("Session Booking Page")),
    );
  }
}
