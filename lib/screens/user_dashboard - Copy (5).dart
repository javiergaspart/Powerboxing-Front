import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'book_session.dart';

class UserDashboard extends StatefulWidget {
  final String token;

  UserDashboard({required this.token});

  @override
  _UserDashboardState createState() => _UserDashboardState();
}

class _UserDashboardState extends State<UserDashboard> {
  int sessionBalance = 0;
  List<Map<String, dynamic>> sessionHistory = [];

  @override
  void initState() {
    super.initState();
    fetchUserData();
  }

  /// ✅ Fetch user session balance and history
  Future<void> fetchUserData() async {
    print('🔍 Fetching user data with token: ${widget.token}');

    final response = await http.get(
      Uri.parse('http://localhost:10000/api/boxer/me'),  // ✅ FIXED Endpoint
      headers: {
        'Authorization': 'Bearer ${widget.token}',
      },
    );

    print('🔍 API Response Code: ${response.statusCode}');
    print('🔍 API Response Body: ${response.body}');

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      setState(() {
        sessionBalance = data['sessions_balance'] ?? 0;
        sessionHistory = List<Map<String, dynamic>>.from(data["session_history"] ?? []);
      });
    } else {
      print('❌ Failed to fetch session data. Status Code: ${response.statusCode}');
      print('❌ Response Body: ${response.body}');
    }
  }

  /// ✅ Display session history
  Widget buildSessionHistory() {
    if (sessionHistory.isEmpty) {
      return Padding(
        padding: const EdgeInsets.all(8.0),
        child: Text("No session history available.", style: TextStyle(fontSize: 16, fontStyle: FontStyle.italic)),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: 20),
        Text("📜 Session History", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
        SizedBox(height: 10),
        Column(
          children: sessionHistory.map((session) {
            return Card(
              elevation: 2,
              margin: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
              child: ListTile(
                title: Text("${session['date']} - Trainer: ${session['trainer_name']}"),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Punching Station: ${session['station']}'),
                    Text('Power: ${session['power']}'),
                    Text('Accuracy: ${session['accuracy']}'),
                    Text('Energy: ${session['energy']}'),
                  ],
                ),
                leading: Icon(Icons.fitness_center, color: Colors.green),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("User Dashboard")),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            SizedBox(height: 20),
            Text("Welcome,", style: TextStyle(fontSize: 24)),
            SizedBox(height: 10),
            Text("Session Balance: $sessionBalance", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.blue)),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => BookSessionScreen(token: widget.token),
                  ),
                );
              },
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.calendar_today, size: 18),
                  SizedBox(width: 8),
                  Text('Book a Session'),
                ],
              ),
            ),
            SizedBox(height: 10),
            ElevatedButton(
              onPressed: () {},
              child: Text("💰 Buy More Sessions"),
            ),
            SizedBox(height: 30),
            Expanded(
              child: SingleChildScrollView(
                child: Padding(
                  padding: EdgeInsets.all(10.0),
                  child: buildSessionHistory(),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
