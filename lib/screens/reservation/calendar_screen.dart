import 'package:flutter/material.dart';

class CalendarScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Select Date'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Text(
              'Please select a date for your reservation.',
              style: TextStyle(fontSize: 18),
            ),
            // You can use a DatePicker or a calendar widget
            ElevatedButton(
              onPressed: () {
                // Navigate to the payment screen after date selection
                Navigator.pushNamed(context, '/payment');
              },
              child: Text('Select Date and Proceed'),
            ),
          ],
        ),
      ),
    );
  }
}
