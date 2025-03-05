import 'package:flutter/material.dart';

class SessionBuyScreen extends StatelessWidget {
  final String token;

  SessionBuyScreen({required this.token});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Buy Sessions')),
      body: Center(child: Text("Buy Sessions Page")),
    );
  }
}
