import 'package:flutter/material.dart';

class PrivacyPolicyScreen extends StatelessWidget {
  const PrivacyPolicyScreen({super.key});

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
          'Privacy Policy',
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
        child: SingleChildScrollView(
          child: Text(
            '''Privacy Policy
Last updated: April 21, 2025

Excelting Experience Private Limited values your privacy. This policy explains how we collect, use, and protect your personal data.

1. Data Collected - Name, email, phone number, location, session preferences, device data and IP address.
2. Purpose - Booking sessions, personalizing experience, updates, and legal compliance.
3. Data Sharing - Shared only with service providers or when required by law.
4. Data Security - We use standard encryption and data protection methods.
5. User Rights - You may request access, correction, or deletion of your data.

Contact: privacy@powerboxing.fun

---

Cancellation & Refund Policy
Last updated: April 21, 2025

Excelting Experience Private Limited believes in flexibility and fairness.

1. Session Cancellations - Cancel up to 1 hour before session start. Late cancellations are non-refundable.
2. Refunds - Eligible cancellations are credited back to your session balance. No cash refunds.
3. Trial Sessions - Non-refundable under all circumstances.

For issues, contact: support@powerboxing.fun

---

Shipping & Delivery Policy
Last updated: April 21, 2025

Our services are digital and in-person. We do not ship physical products.
Policy will be updated if physical products are introduced.
            ''',
            style: const TextStyle(color: Colors.white, fontSize: 16),
          ),
        ),
      ),
    );
  }
}
