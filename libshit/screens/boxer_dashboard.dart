import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class BoxerDashboard extends StatefulWidget {
  final String token;
  final String userId;

  BoxerDashboard({required this.token, required this.userId});

  @override
  _BoxerDashboardState createState() => _BoxerDashboardState();
}

class _BoxerDashboardState extends State<BoxerDashboard> {
  int sessionBalance = 0;
  Map<String, List<Map<String, dynamic>>> availableSessions = {};
  Map<String, dynamic> upcomingSession = {};
  List<dynamic> sessionHistory = [];

  @override
  void initState() {
    super.initState();
    fetchSessionBalance();
    fetchAvailableSessions();
    fetchUpcomingSession();
    fetchSessionHistory();
  }

  Future<void> fetchSessionBalance() async {
    try {
      final response = await http.get(
        Uri.parse("http://localhost:10000/api/sessions/balance/${widget.userId}"),
        headers: {"Authorization": "Bearer ${widget.token}"},
      );

      if (response.statusCode == 200) {
        setState(() {
          sessionBalance = jsonDecode(response.body)['balance'];
        });
      }
    } catch (e) {
      print("❌ Error fetching session balance: $e");
    }
  }

  Future<void> fetchAvailableSessions() async {
    try {
      final response = await http.get(
        Uri.parse("http://localhost:10000/api/sessions/available"),
        headers: {"Authorization": "Bearer ${widget.token}"},
      );

      if (response.statusCode == 200) {
        dynamic decodedData = jsonDecode(response.body);
        setState(() {
          availableSessions = {};
          for (var session in decodedData) {
            String sessionDate = session["date"].substring(0, 10);
            availableSessions.putIfAbsent(sessionDate, () => []).add({
              "id": session["_id"],
              "time": session["time"],
            });
          }
        });
      }
    } catch (e) {
      print("❌ Error fetching available sessions: $e");
    }
  }

  Future<void> fetchUpcomingSession() async {
    try {
      final response = await http.get(
        Uri.parse("http://localhost:10000/api/sessions/upcoming/${widget.userId}"),
        headers: {"Authorization": "Bearer ${widget.token}"},
      );

      if (response.statusCode == 200) {
        setState(() {
          upcomingSession = jsonDecode(response.body) ?? {};
        });
      }
    } catch (e) {
      print("❌ Error fetching upcoming session: $e");
    }
  }

  Future<void> fetchSessionHistory() async {
    try {
      final response = await http.get(
        Uri.parse("http://localhost:10000/api/sessions/history/${widget.userId}"),
        headers: {"Authorization": "Bearer ${widget.token}"},
      );

      if (response.statusCode == 200) {
        setState(() {
          sessionHistory = jsonDecode(response.body) ?? [];
        });
      }
    } catch (e) {
      print("❌ Error fetching session history: $e");
    }
  }

  Future<void> bookSession(String sessionId) async {
    try {
      final response = await http.post(
        Uri.parse("http://localhost:10000/api/sessions/book"),
        headers: {
          "Authorization": "Bearer ${widget.token}",
          "Content-Type": "application/json"
        },
        body: jsonEncode({"userId": widget.userId, "sessionId": sessionId}),
      );

      if (response.statusCode == 200) {
        fetchSessionBalance();
        fetchUpcomingSession();
        fetchSessionHistory();
        fetchAvailableSessions();
      }
    } catch (e) {
      print("❌ Error booking session: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("PowerBoxing - Boxer Dashboard")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Session Balance: $sessionBalance", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            SizedBox(height: 10),
            ElevatedButton(
              onPressed: () {},
              child: Text("Buy Sessions"),
            ),
            SizedBox(height: 20),
            if (upcomingSession.isNotEmpty) ...[
              Text("Upcoming Session:", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              Text("Date: ${upcomingSession['date'] ?? 'N/A'}"),
              Text("Time: ${upcomingSession['time'] ?? 'N/A'}"),
              SizedBox(height: 20),
            ],
          ],
        ),
      ),
    );
  }
}
