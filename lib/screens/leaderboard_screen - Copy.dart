import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class LeaderboardScreen extends StatefulWidget {
  @override
  _LeaderboardScreenState createState() => _LeaderboardScreenState();
}

class _LeaderboardScreenState extends State<LeaderboardScreen> {
  List<Map<String, dynamic>> leaderboard = [];
  final String apiUrl = "http://your-backend-url/api/boxer/leaderboard";
  final String authToken = "YOUR_BOXER_AUTH_TOKEN";  // Replace dynamically

  @override
  void initState() {
    super.initState();
    fetchLeaderboard();
  }

  Future<void> fetchLeaderboard() async {
    final response = await http.get(
      Uri.parse(apiUrl),
      headers: {"Authorization": "Bearer $authToken"},
    );

    if (response.statusCode == 200) {
      setState(() {
        leaderboard = List<Map<String, dynamic>>.from(json.decode(response.body)['leaderboard']);
      });
    } else {
      print("Failed to load leaderboard");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: ListView.builder(
            itemCount: leaderboard.length,
            itemBuilder: (context, index) {
              return ListTile(
                title: Text("${leaderboard[index]['boxer_name']}"),
                subtitle: Text("Energy Score: ${leaderboard[index]['energy']}"),
                leading: Text("#${leaderboard[index]['rank']}"),
              );
            },
          ),
        ),
      ],
    );
  }
}
