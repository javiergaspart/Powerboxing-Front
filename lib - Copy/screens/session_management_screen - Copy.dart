import 'package:flutter/material.dart';

class SessionManagementScreen extends StatefulWidget {
  final String token;
  SessionManagementScreen({required this.token});

  @override
  _SessionManagementScreenState createState() => _SessionManagementScreenState();
}

class _SessionManagementScreenState extends State<SessionManagementScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Session Management")),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("Manage Sessions Here"),
            SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: () {
                // Add logic to start session
              },
              child: Text("Start Session"),
            ),
          ],
        ),
      ),
    );
  }
}
