import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class UserDashboard extends StatefulWidget {
  final String token;

  UserDashboard({required this.token});

  @override
  _UserDashboardState createState() => _UserDashboardState();
}

class _UserDashboardState extends State<UserDashboard> {
  int sessionBalance = 0;  
  List<Map<String, dynamic>> sessionHistory = [];
  List<Map<String, dynamic>> availableSessions = [];

  @override
  void initState() {
    super.initState();
    fetchUserData();
    fetchAvailableSessions(); // ✅ Fetch available sessions
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

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      setState(() {
        sessionBalance = data['sessions_balance'] ?? 0;  // ✅ FIXED field name
        sessionHistory = List<Map<String, dynamic>>.from(data["session_history"] ?? []);
      });
    } else {
      print('❌ Failed to fetch session data.');
    }
  }

  /// ✅ Fetch available sessions from `sessions` table
  Future<void> fetchAvailableSessions() async {
    print('🔍 Fetching available sessions');

    final response = await http.get(
      Uri.parse('http://localhost:10000/api/sessions/available'),
      headers: {
        'Authorization': 'Bearer ${widget.token}',
      },
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      setState(() {
        availableSessions = List<Map<String, dynamic>>.from(data["available_sessions"] ?? []);
      });
      print("✅ Available sessions loaded.");
    } else {
      print("❌ Failed to fetch available sessions.");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("User Dashboard")),
      body: Column(
        children: [
          SizedBox(height: 20),
          Text("Session Balance: $sessionBalance", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.blue)),
          SizedBox(height: 20),
          ElevatedButton(
            onPressed: () {},  
            child: Text("📅 Book a Session"),
          ),
          SizedBox(height: 10),
          Expanded(
            child: ListView.builder(
              itemCount: availableSessions.length,
              itemBuilder: (context, index) {
                var session = availableSessions[index];
                return Card(
                  child: ListTile(
                    title: Text("${session['date']} - ${session['time']}"),
                    subtitle: Text("Trainer ID: ${session['trainer_id']}"),
                    trailing: ElevatedButton(
                      onPressed: () {}, 
                      child: Text("Book"),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
