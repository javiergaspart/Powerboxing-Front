import 'package:flutter/material.dart';
import 'about_us_screen.dart';
import 'contact_us_screen.dart';
import 'pricing_details_screen.dart';
import 'terms_and_conditions_screen.dart';
import 'privacy_policy_screen.dart';

class HelpScreen extends StatelessWidget {
  const HelpScreen({super.key});

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
          'Help & Info',
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(vertical: 12),
        children: [
          _buildHelpTile(context, Icons.info_outline, 'About Us', () {
            Navigator.push(context, MaterialPageRoute(builder: (_) => const AboutUsScreen()));
          }),
          _buildHelpTile(context, Icons.attach_money, 'Pricing Details', () {
            Navigator.push(context, MaterialPageRoute(builder: (_) => const PricingDetailsScreen()));
          }),
          _buildHelpTile(context, Icons.phone, 'Contact Us', () {
            Navigator.push(context, MaterialPageRoute(builder: (_) => const ContactUsScreen()));
          }),
          _buildHelpTile(context, Icons.description, 'Terms & Conditions', () {
            Navigator.push(context, MaterialPageRoute(builder: (_) => const TermsAndConditionsScreen()));
          }),
          _buildHelpTile(context, Icons.lock, 'Privacy Policy', () {
            Navigator.push(context, MaterialPageRoute(builder: (_) => const PrivacyPolicyScreen()));
          }),
        ],
      ),
    );
  }

  Widget _buildHelpTile(BuildContext context, IconData icon, String title, VoidCallback onTap) {
    return ListTile(
      leading: Icon(icon, color: const Color(0xFF400966)),
      title: Text(
        title,
        style: const TextStyle(color: Colors.white, fontSize: 16),
      ),
      trailing: const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.white),
      onTap: onTap,
    );
  }
}
