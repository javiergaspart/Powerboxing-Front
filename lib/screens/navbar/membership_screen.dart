import 'package:flutter/material.dart';

class MembershipScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Membership'),
      ),
      body: Center(
        child: Text(
          'This is the Membership screen.',
          style: TextStyle(fontSize: 18),
        ),
      ),
    );
  }
}
