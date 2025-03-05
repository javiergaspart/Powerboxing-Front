import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class BoxerDashboard extends StatefulWidget {
  final String token;

  BoxerDashboard({required this.token});

  @override
  _BoxerDashboardState createState() => _BoxerDashboardState();
}

class _BoxerDashboardState extends State<BoxerDashboard> {
  int sessionBalance = 1;
  int selectedDayIndex = 0;
  final List<String> next7Days = List.generate(7, (index) {
    return DateTime.now().add(Duration(days: index)).toString().substring(0, 10);
  });

  Map<String, List<String>> availableSessions = {};

  @override
  void initState() {
    super.initState();

    print("🚀 Received Token in BoxerDashboard: '${widget.token}'");

    if (widget.token.isEmpty) {
      print("❌ ERROR: Token is empty in BoxerDashboard. Redirecting to login.");
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Navigator.pushReplacementNamed(context, '/');
      });
    } else {
      fetchAvailableSessions();
    }
  }

  Future<void> fetchAvailableSessions() async {
    try {
      print("🔍 Using Token for API Call: '${widget.token}'");

      final response = await http.get(
        Uri.parse("http://localhost:10000/api/sessions/available"),
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer ${widget.token}",
        },
      );

      print("🔍 Raw API Response: ${response.body}");

      if (response.statusCode == 200) {
        dynamic decodedData = jsonDecode(response.body);
        
        if (decodedData is List) {
          print("✅ API returned a List instead of a Map. Converting...");
          setState(() {
            availableSessions = {};
            for (var session in decodedData) {
              for (var slot in session["available_slots"]) {
                if (slot["date"] != null && slot["time"] != null) {
                  availableSessions.putIfAbsent(slot["date"], () => []).add(slot["time"]);
                }
              }
            }
          });
        } else {
          print("❌ Unexpected response type: ${decodedData.runtimeType}");
        }
      } else {
        print("❌ API Error: ${response.statusCode} - ${response.body}");
      }
    } catch (e) {
      print("❌ Error fetching sessions from MongoDB: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 7,
      child: Scaffold(
        appBar: AppBar(title: Text("PowerBoxing - Boxer Dashboard")),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Session Balance: $sessionBalance", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {},
                  child: Text("Buy Sessions"),
                ),
                SizedBox(height: 20),
                Text("Book a Session", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                SizedBox(height: 10),
                TabBar(
                  isScrollable: true,
                  tabs: next7Days.map((day) => Tab(text: day)).toList(),
                ),
                SizedBox(height: 10),
                Container(
                  height: 200,
                  child: TabBarView(
                    children: next7Days.map((day) {
                      final sessions = availableSessions[day] ?? [];
                      return sessions.isNotEmpty
                          ? ListView(
                              children: sessions.map((session) => ListTile(
                                    title: Text(session),
                                    trailing: ElevatedButton(
                                      onPressed: () {},
                                      child: Text("Book"),
                                    ),
                                  )).toList(),
                            )
                          : Center(child: Text("No sessions available"));
                    }).toList(),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
