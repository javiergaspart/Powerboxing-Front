import 'package:flutter/material.dart';

class TermsAndConditionsScreen extends StatelessWidget {
  const TermsAndConditionsScreen({super.key});

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
          'Terms & Conditions',
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
        child: SingleChildScrollView(
          child: Text(
            '''Terms and Conditions
Last updated: April 21, 2025

Welcome to Powerboxing, operated by Excelting Experience Private Limited.
By accessing or using our website https://powerboxing.fun, mobile application, or services, you agree to comply with and be bound by the following terms and conditions. Please read them carefully.

1. Use of Services - You agree to use the services only for lawful purposes.
2. Intellectual Property - All content is the intellectual property of Excelting Experience Pvt. Ltd.
3. User Conduct - You agree to provide accurate information and maintain confidentiality of your credentials.
4. Limitation of Liability - We are not liable for any damages resulting from the use or inability to use our services.
5. Changes to Terms - We reserve the right to modify these Terms at any time.
6. Governing Law - These terms are governed by the laws of India.

For queries, contact us at: support@powerboxing.fun
            ''',
            style: const TextStyle(color: Colors.white, fontSize: 16),
          ),
        ),
      ),
    );
  }
}
