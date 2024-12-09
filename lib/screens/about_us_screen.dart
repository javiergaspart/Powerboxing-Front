import 'package:flutter/material.dart';

class AboutUsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('About Us'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Text(
              'Welcome to Fitboxing!',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),
            Text(
              'We are dedicated to providing top-notch fitness services through boxing-based training. Our goal is to help you achieve your fitness goals while having fun!',
              style: TextStyle(fontSize: 18),
            ),
            SizedBox(height: 20),
            Text(
              'For more information, contact us at support@fitboxing.com.',
              style: TextStyle(fontSize: 18),
            ),
            // Add more info or a button to navigate back
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);  // Go back to the previous screen
              },
              child: Text('Go Back'),
            ),
          ],
        ),
      ),
    );
  }
}
