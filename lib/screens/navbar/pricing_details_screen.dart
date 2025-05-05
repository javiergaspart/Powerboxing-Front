import 'package:flutter/material.dart';

class PricingDetailsScreen extends StatelessWidget {
  const PricingDetailsScreen({super.key});

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
          'Pricing Details',
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
        child: SingleChildScrollView(
          child: Text(
            '''Pricing Details
Last updated: April 21, 2025

Our pricing is simple and transparent:

- Trial Session: Free (once per user)
- 1 Session: ₹300
- 5 Sessions: ₹1,400
- 10 Sessions: ₹2,600
- 20 Sessions: ₹4,800

GST included where applicable. Prepaid packages only. Refunds follow our Cancellation Policy.
            ''',
            style: const TextStyle(color: Colors.white, fontSize: 16),
          ),
        ),
      ),
    );
  }
}
