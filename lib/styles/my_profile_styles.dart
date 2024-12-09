import 'package:flutter/material.dart';

class MyProfileStyles {
  static const labelStyle = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.bold,
    color: Colors.black,
  );

  static const inputStyle = TextStyle(
    fontSize: 16,
    color: Colors.black87,
  );

  static const inputDecoration = InputDecoration(
    border: OutlineInputBorder(),
    focusedBorder: OutlineInputBorder(
      borderSide: BorderSide(color: Colors.blueAccent, width: 2.0),
    ),
  );

  static const titleStyle = TextStyle(
    fontSize: 20,
    fontWeight: FontWeight.bold,
    color: Colors.blueAccent,
  );
}
