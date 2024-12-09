import 'package:flutter/material.dart';

class ContactUsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Contact Us'),
      ),
      body: Center(
        child: Text(
          'This is the Contact Us screen.',
          style: TextStyle(fontSize: 18),
        ),
      ),
    );
  }
}
