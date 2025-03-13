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

  Map<String, List<Map<String, String>>> availableSessions = {}; // ✅ Store as a List (No Duplicates)

  @override
  void initState() {
    super.initState();
    decodeToken();
  }

  void decodeToken() {
    try {
      Map<String, dynamic> decodedToken = JwtDecoder.decode(widget.token);
      userId = decodedToken.containsKey("userId") ? decodedToken["userId"] : decodedToken["_id"];
      print("🆔 Decoded User ID: $userId");
      fetchSessionBalance();
      fetchAvailableSessions();
    } catch (e) {
      print("❌ Error decoding token: $e");
    }
  }

  Future<void> fetchSessionBalance() async {
    try {
      print("🔄 Fetching session balance for user: $userId");

      final response = await http.get(
        Uri.parse("http://localhost:10000/api/sessions/balance/$userId"),
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer ${widget.token}",
        },
      );

      print("🔄 RAW API Response (Balance): ${response.body}");

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        setState(() {
          sessionBalance = data["balance"] ?? 0;
        });
        print("✅ Updated session balance: $sessionBalance");
      } else {
        print("❌ Failed to fetch session balance. Status: ${response.statusCode}");
      }
    } catch (e) {
      print("❌ Error fetching session balance: $e");
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
        List<dynamic> decodedData = jsonDecode(response.body);
        setState(() {
          availableSessions.clear();
          for (var session in decodedData) {
            String dateStr = session["date"];
            String timeStr = session["time"];
            String sessionId = session["_id"];

            if (!availableSessions.containsKey(dateStr)) {
              availableSessions[dateStr] = [];
            }

            bool alreadyExists = availableSessions[dateStr]!.any((s) => s["time"] == timeStr);

            if (!alreadyExists) {
              availableSessions[dateStr]!.add({
                "time": timeStr,
                "sessionId": sessionId,
              });
            }
          }

          // ✅ Sort sessions by time (Ascending Order)
          availableSessions.forEach((date, sessions) {
            sessions.sort((a, b) => a["time"]!.compareTo(b["time"]!));
          });
        });

        print("✅ Filtered & Sorted Available Sessions: $availableSessions");
      } else {
        print("❌ API Error: ${response.statusCode}");
      }
    } catch (e) {
      print("❌ Error fetching available sessions: $e");
    }
  }

  Future<void> bookSession(String date, String sessionId) async {
    try {
      print("📅 Booking session on $date for sessionId: $sessionId...");

      final response = await http.post(
        Uri.parse("http://localhost:10000/api/sessions/book"),
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer ${widget.token}",
        },
        body: jsonEncode({
          "userId": userId,
          "sessionId": sessionId,
        }),
      );

      if (response.statusCode == 200) {
        print("✅ Session booked successfully!");
        fetchSessionBalance();
        fetchAvailableSessions();
      } else {
        print("❌ Booking failed: ${response.body}");
      }
    } catch (e) {
      print("❌ Error booking session: $e");
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
                Text("Session Balance: $sessionBalance",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
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
                  height: 300,
                  child: TabBarView(
                    children: next7Days.map((day) {
                      final sessions = availableSessions[day] ?? [];
                      return sessions.isNotEmpty
                          ? ListView(
                              children: sessions.map((session) => ListTile(
                                    title: Text(session["time"] ?? ""),
                                    trailing: ElevatedButton(
                                      onPressed: () async {
                                        await bookSession(day, session["sessionId"]!);
                                      },
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
