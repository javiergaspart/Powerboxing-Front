import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;

class TrainerDashboard extends StatefulWidget {
  final String trainerId;
  final String token;

  TrainerDashboard({required this.trainerId, required this.token});

  @override
  _TrainerDashboardState createState() => _TrainerDashboardState();
}

class _TrainerDashboardState extends State<TrainerDashboard> {
  List<dynamic> sessions = [];
  Set<String> selectedSessions = {};
  DateTime today = DateTime.now();
  List<List<DateTime>> calendarWeeks = [];
  final List<String> daysOfWeek = ["Mon", "Tue", "Wed", "Thu", "Fri", "Sat", "Sun"];

  @override
  void initState() {
    super.initState();
    _generateCalendar();
    WidgetsBinding.instance.addPostFrameCallback((_) => _fetchAvailability());
  }

  void _generateCalendar() {
    DateTime startOfWeek = today.subtract(Duration(days: today.weekday - 1));
    for (int i = 0; i < 8; i++) {
      List<DateTime> week = [];
      for (int j = 0; j < 7; j++) {
        week.add(startOfWeek.add(Duration(days: (i * 7) + j)));
      }
      calendarWeeks.add(week);
    }
  }

   Future<void> _fetchAvailability() async {
    print("🛠 Trainer ID Received in Dashboard: ${widget.trainerId}");

    if (widget.trainerId.isEmpty || widget.trainerId == "MISSING_ID") {
      print("❌ Trainer ID is empty! Check navigation parameters.");
      return;
    }

    final url = "http://localhost:10000/api/trainer/${widget.trainerId}/sessions";
    print("📡 Fetching sessions from: $url");
    
    try {
      final response = await http.get(
        Uri.parse(url),
        headers: {"Authorization": "Bearer ${widget.token}"},
      );

      print("💎 Response Status: ${response.statusCode}");
      print("💎 Response Body: ${response.body}");

      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        setState(() {
          sessions = data;
          selectedSessions.clear();
          for (var session in sessions) {
            String key = "${session['date']}-${session['time']}";
            selectedSessions.add(key);
          }
        });
        print("✅ Successfully fetched and updated trainer availability.");
      } else {
        print("❌ Error fetching sessions: ${response.statusCode}");
      }
    } catch (error) {
      print("❌ Exception fetching sessions: $error");
    }
  }

 Future<void> _saveAvailability() async {
  if (widget.trainerId.isEmpty) {
    print("❌ Trainer ID is empty! Cannot save sessions.");
    return;
  }

  final url = "http://localhost:10000/api/trainer/sessions/save";
  print("💾 Saving sessions to: $url");

  List<Map<String, dynamic>> sessionData = selectedSessions.map<Map<String, dynamic>>((String key) {
    List<String> parts = key.split('-');

    if (parts.length != 2) {
      print("❌ Error: Invalid session key format: $key");
      return {};
    }

    String datePart = parts[0].trim();
    String timePart = parts[1].trim();

    if (!RegExp(r'^\d{4}-\d{2}-\d{2}$').hasMatch(datePart)) {
      print("❌ Invalid date format detected: $datePart");
      return {};
    }

    if (!RegExp(r'^\d{2}:\d{2}$').hasMatch(timePart)) {
      print("❌ Invalid time format detected: $timePart");
      return {};
    }

    return {
      "trainer_id": widget.trainerId,
      "date": datePart,
      "time": timePart,
      "available_slots": 20  // Default available slots
    };
  }).where((session) => session.isNotEmpty).toList();

  if (sessionData.isEmpty) {
    print("❌ No valid sessions to save!");
    return;
  }

  try {
    final response = await http.post(
      Uri.parse(url),
      headers: {
        "Authorization": "Bearer ${widget.token}",
        "Content-Type": "application/json"
      },
      body: jsonEncode(sessionData),
    );

    print("💾 Response Status: ${response.statusCode}");
    print("💾 Response Body: ${response.body}");

    if (response.statusCode == 200 || response.statusCode == 201) {
      print("✅ Sessions saved successfully!");
      _fetchAvailability();
    } else {
      print("❌ Error saving sessions: ${response.statusCode}");
    }
  } catch (error) {
    print("❌ Exception saving sessions: $error");
  }
}


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Trainer Dashboard")),
      body: SingleChildScrollView(
        child: Column(
          children: [
            for (int weekIndex = 0; weekIndex < 8; weekIndex++)
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Week ${weekIndex + 1} (${DateFormat('dd/MM').format(calendarWeeks[weekIndex].first)} - ${DateFormat('dd/MM').format(calendarWeeks[weekIndex].last)})",
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    Table(
                      columnWidths: {for (var i = 0; i < 7; i++) i: FlexColumnWidth(1)},
                      children: [
                        TableRow(
                          children: calendarWeeks[weekIndex].map((date) => Center(
                            child: Padding(
                              padding: const EdgeInsets.all(4.0),
                              child: Text(
                                "${daysOfWeek[date.weekday - 1]}\n${DateFormat('dd/MM').format(date)}",
                                textAlign: TextAlign.center,
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                            ),
                          )).toList(),
                        ),
                      ],
                    ),
                    Table(
                      columnWidths: {for (var i = 0; i < 7; i++) i: FlexColumnWidth(1)},
                      children: List.generate(13, (index) {
                        return TableRow(
                          children: calendarWeeks[weekIndex].map((date) {
                            String time = "${8 + index}:00";
                            String key = "${DateFormat('yyyy-MM-dd').format(date)}-$time";
                            return GestureDetector(
                              onTap: () {
                                setState(() {
                                  if (selectedSessions.contains(key)) {
                                    selectedSessions.remove(key);
                                  } else {
                                    selectedSessions.add(key);
                                  }
                                });
                              },
                              child: Container(
                                margin: EdgeInsets.all(4),
                                padding: EdgeInsets.all(8),
                                color: date.isBefore(today)
                                    ? Colors.grey
                                    : (selectedSessions.contains(key) ? Colors.blue : Colors.red),
                                child: Center(
                                  child: Text(
                                    time,
                                    style: TextStyle(color: Colors.white),
                                  ),
                                ),
                              ),
                            );
                          }).toList(),
                        );
                      }),
                    ),
                  ],
                ),
              ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _saveAvailability,
        child: Icon(Icons.save),
      ),
    );
  }
}
