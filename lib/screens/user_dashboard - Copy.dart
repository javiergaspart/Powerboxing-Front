import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class UserDashboard extends StatefulWidget {
  final String userName;
  final String token;

  UserDashboard({required this.userName, required this.token});

  @override
  _UserDashboardState createState() => _UserDashboardState();
}

class _UserDashboardState extends State<UserDashboard> {
  int sessionBalance = 0;

  @override
  void initState() {
    super.initState();
    fetchUserData();
  }

  Future<void> fetchUserData() async {
    print('🔍 Fetching session balance with token: ${widget.token}');

    final response = await http.get(
      Uri.parse('http://localhost:10000/api/boxer/me'),
      headers: {
        'Authorization': 'Bearer ${widget.token}',  // Ensure token is passed correctly
      },
    );

    print('🔍 API Response Code: ${response.statusCode}');
    print('🔍 API Response Body: ${response.body}');

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      setState(() {
        sessionBalance = data['sessions_balance'] ?? 0;
      });
    } else {
      print('❌ Failed to fetch session balance. Status Code: ${response.statusCode}');
      print('❌ Response Body: ${response.body}');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('User Dashboard')),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              'Welcome to PowerBoxing, ${widget.userName}!',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 10),
            Text(
              'Session Balance: $sessionBalance',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.green),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, '/book-session');
              },
              child: Text('Book a Session'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, '/buy-sessions');
              },
              child: Text('Buy Sessions'),
            ),
            SizedBox(height: 30),
            Text(
              'Session History',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            Text('No session history available.', style: TextStyle(color: Colors.grey)),
          ],
        ),
      ),
    );
  }
}
