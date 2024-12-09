import 'package:flutter/material.dart';

class LocationSelectScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Select Location'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Text(
              'Please select a location for your reservation.',
              style: TextStyle(fontSize: 18),
            ),
            // Add a list or a dropdown to select a location
            Expanded(
              child: ListView(
                children: [
                  ListTile(
                    title: Text('Location 1'),
                    onTap: () {
                      // Navigate to the next screen or pass the selected location
                      Navigator.pushNamed(context, '/calendar');
                    },
                  ),
                  ListTile(
                    title: Text('Location 2'),
                    onTap: () {
                      Navigator.pushNamed(context, '/calendar');
                    },
                  ),
                  // Add more locations as needed
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
