import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:url_launcher/url_launcher.dart' as launcher;
import 'boxer_dashboard.dart'; // Import Boxer Dashboard

class SessionBuyScreen extends StatelessWidget {
  final String token;
  final String userId; // Needed for API calls

  SessionBuyScreen({required this.token, required this.userId});

  Future<void> initiatePayment(BuildContext context, int sessions, int price) async {
    final url = Uri.parse("http://localhost:10000/api/sessions/payment/initiate");
    final response = await http.post(
      url,
      headers: {"Content-Type": "application/json", "Authorization": "Bearer $token"},
      body: jsonEncode({"userId": userId, "sessions": sessions, "amount": price}),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final paymentUrl = data['paymentUrl'];
      if (await launcher.canLaunch(paymentUrl)) {
        await launcher.launch(paymentUrl);
      } else {
        print("Could not launch payment page");
      }
    } else {
      print("Payment initiation failed");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Buy Sessions')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () => initiatePayment(context, 1, 600),
              child: Column(
                children: [
                  Text('1 SESSION - 600 INR', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                  Text('600 INR per session', style: TextStyle(fontSize: 14, color: Colors.grey)),
                ],
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => initiatePayment(context, 5, 2500),
              child: Column(
                children: [
                  Text('5 SESSIONS - 2500 INR', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                  Text('500 INR per session', style: TextStyle(fontSize: 14, color: Colors.grey)),
                ],
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => initiatePayment(context, 10, 4000),
              child: Column(
                children: [
                  Text('10 SESSIONS - 4000 INR', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                  Text('400 INR per session', style: TextStyle(fontSize: 14, color: Colors.grey)),
                ],
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => initiatePayment(context, 20, 7000),
              child: Column(
                children: [
                  Text('20 SESSIONS - 7000 INR', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                  Text('350 INR per session', style: TextStyle(fontSize: 14, color: Colors.grey)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
