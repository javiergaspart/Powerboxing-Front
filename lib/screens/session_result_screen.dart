import 'package:flutter/material.dart';

class SessionResultScreen extends StatelessWidget {
  final String sessionId;

  // Constructor that takes sessionId as a required parameter
  const SessionResultScreen({Key? key, required this.sessionId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Use the sessionId in your UI
    return Scaffold(
      appBar: AppBar(
        title: Text('Session Results'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            Text('Session Report'),
            SizedBox(height: 20),
            Text('Accuracy: 85%'),
            SizedBox(height: 20),
            Text('Power: 300 W'),
            SizedBox(height: 40),
            Text('Session ID: $sessionId'), // Display sessionId
            SizedBox(height: 40),
            ElevatedButton(
              onPressed: () {
                // Navigate back to the home tab
                Navigator.pop(context);
              },
              child: Text('Back to Dashboard'),
            ),
          ],
        ),
      ),
    );
  }
}
