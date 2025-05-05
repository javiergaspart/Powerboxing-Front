import 'package:flutter/material.dart';

class AboutUsScreen extends StatelessWidget {
  const AboutUsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF151718),
      appBar: AppBar(
        backgroundColor: const Color(0xFF151718),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'About Us',
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
        child: SingleChildScrollView(
          child: Text(
            '''About Us

Excelting Experience Private Limited is the company behind Powerboxing.
We deliver innovative fitness experiences combining functional training, rhythm-based boxing, and IoT tracking.

Website: https://powerboxing.fun
Email: info@powerboxing.fun
Registered in Hyderabad, Telangana.
            ''',
            style: const TextStyle(color: Colors.white, fontSize: 16),
          ),
        ),
      ),
    );
  }
}
