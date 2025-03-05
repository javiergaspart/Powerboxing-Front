import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:jwt_decoder/jwt_decoder.dart';

class BoxerDashboard extends StatefulWidget {
  final String token;

  BoxerDashboard({required this.token});

  @override
  _BoxerDashboardState createState() => _BoxerDashboardState();
}

class _BoxerDashboardState extends State<BoxerDashboard> {
  int sessionBalance = 0;
  String userId = "";
  final List<String> next7Days = List.generate(7, (index) {
    return DateTime.now().add(Duration(days: index)).toString().substring(0, 10);
  });
  Map<String, List<String>> availableSessions = {};

  @override
  void initState() {
    super.initState();
    if (widget.token.isEmpty) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Navigator.pushReplacementNamed(context, '/');
      });
    } else {
      decodeToken();
    }
  }

  void decodeToken() {
    try {
      Map<String, dynamic> decodedToken = JwtDecoder.decode(widget.token);
      userId = decodedToken["userId"];
      fetchSessionBalance();
      fetchAvailableSessions();
    } catch (e) {
      print("Error decoding token: $e");
    }
  }

  Future<void> fetchSessionBalance() async {
    try {
      final response = await http.get(
        Uri.parse("http://localhost:10000/api/sessions/balance/$userId"),
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer ${widget.token}",
        },
      );
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        setState(() {
          sessionBalance = data["balance"] ?? 0;
        });
      }
    } catch (e) {
      print("Error fetching session balance: $e");
    }
  }

Future<void> fetchAvailableSessions() async {
  try {
    print("🔍 Fetching available sessions...");

    final response = await http.get(
      Uri.parse("http://localhost:10000/api/sessions/available"),
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer ${widget.token}",
      },
    );

    print("🔍 RAW API Response: ${response.body}");

    if (response.statusCode == 200) {
      dynamic decodedData = jsonDecode(response.body);
      print("✅ Decoded API Response: $decodedData");

      if (decodedData is List && decodedData.isNotEmpty) {
        setState(() {
          availableSessions = {};
          DateTime now = DateTime.now();

          for (var session in decodedData) {
            if (session["date"] == null || session["time"] == null) continue; // Skip invalid entries

            String dateStr = session["date"];
            String timeStr = session["time"];
            DateTime sessionDateTime = DateTime.parse("$dateStr $timeStr");

            // Filter: Only keep upcoming sessions (including today, but future times only)
            if (sessionDateTime.isAfter(now)) {
              String formattedDate = dateStr.substring(0, 10);
              if (availableSessions.containsKey(formattedDate)) {
                availableSessions[formattedDate]!.add(timeStr);
              } else {
                availableSessions[formattedDate] = [timeStr];
              }
            }
          }
        });

        print("📆 Available sessions updated: $availableSessions");
      } else {
        print("❌ API returned empty list or unexpected format.");
      }
    } else {
      print("❌ API Error: ${response.statusCode}");
    }
  } catch (e) {
    print("❌ Error fetching available sessions: $e");
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
