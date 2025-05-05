import 'package:flutter/material.dart';

class CancellationAndRefundPolicyScreen extends StatelessWidget {
  const CancellationAndRefundPolicyScreen({super.key});

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
          'Cancellation & Refund Policy',
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
        child: SingleChildScrollView(
          child: Text(
            '''Cancellation & Refund Policy
Last updated: April 21, 2025

Excelting Experience Private Limited believes in flexibility and fairness.

1. Session Cancellations - Cancel up to 1 hour before session start. Late cancellations are non-refundable.
2. Refunds - Eligible cancellations are credited back to your session balance. No cash refunds.
3. Trial Sessions - Non-refundable under all circumstances.

For issues, contact: support@powerboxing.fun
            ''',
            style: const TextStyle(color: Colors.white, fontSize: 16),
          ),
        ),
      ),
    );
  }
}
