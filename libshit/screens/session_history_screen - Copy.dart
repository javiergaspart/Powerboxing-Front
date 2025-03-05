import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class SessionHistoryScreen extends StatefulWidget {
  @override
  _SessionHistoryScreenState createState() => _SessionHistoryScreenState();
}

class _SessionHistoryScreenState extends State<SessionHistoryScreen> {
  List<Map<String, dynamic>> pastSessions = [];
  final String apiUrl = "http://your-backend-url/api/boxer/session-results";
  final String authToken = "YOUR_BOXER_AUTH_TOKEN";  // Replace dynamically

  @override
  void initState() {
    super.initState();
    fetchSessionHistory();
  }

  Future<void> fetchSessionHistory() async {
    final response = await http.get(
      Uri.parse(apiUrl),
      headers: {"Authorization": "Bearer $authToken"},
    );

    if (response.statusCode == 200) {
      setState(() {
        pastSessions = List<Map<String, dynamic>>.from(json.decode(response.body));
      });
    } else {
      print("Failed to load session history");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: ListView.builder(
            itemCount: pastSessions.length,
            itemBuilder: (context, index) {
              return ListTile(
                title: Text("${pastSessions[index]['session_date']} - ${pastSessions[index]['session_time']}"),
                subtitle: Text("Energy Score: ${pastSessions[index]['final_result']['final_energy']}"),
              );
            },
          ),
        ),
      ],
    );
  }
}
