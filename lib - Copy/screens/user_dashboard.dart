import 'package:flutter/material.dart';

class UserDashboard extends StatelessWidget {
  final String userName;
  final String token;

  UserDashboard({required this.userName, required this.token});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("User Dashboard")),
      body: Center(
        child: Column(
          children: [
            Text("Welcome, $userName"),
            Text("Session Balance: 10"),
            ElevatedButton(
              onPressed: () {},
              child: Text("Book a Session"),
            ),
            ElevatedButton(
              onPressed: () {},
              child: Text("Buy More Sessions"),
            ),
          ],
        ),
      ),
    );
  }
}
