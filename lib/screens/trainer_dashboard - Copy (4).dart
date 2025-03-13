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
  DateTime today = DateTime.now();
  List<List<DateTime>> calendarWeeks = [];

  @override
  void initState() {
    super.initState();
    _generateCalendar();
    _fetchAvailability();
  }

  void _generateCalendar() {
    DateTime startOfWeek = today.subtract(Duration(days: today.weekday - 1)); // Get Monday of current week
    for (int i = 0; i < 8; i++) {
      List<DateTime> week = [];
      for (int j = 0; j < 7; j++) {
        week.add(startOfWeek.add(Duration(days: (i * 7) + j)));
      }
      calendarWeeks.add(week);
    }
  }

  Future<void> _fetchAvailability() async {
    try {
      final response = await http.get(Uri.parse("http://localhost:10000/api/sessions/${widget.trainerId}"));

      print("📥 API Response for Sessions: ${response.body}");

      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);

        if (data is! List) {
          print("🚨 API response is not a list: $data");
          return;
        }

        setState(() {
          sessions = data.map((session) {
            return {
              ...session,
              "date": _parseDate(session["date"]),
              "available_slots": int.tryParse(session["available_slots"].toString()) ?? 0,
            };
          }).toList();
        });
      } else {
        print("❌ Error fetching sessions: ${response.statusCode}");
      }
    } catch (error) {
      print("❌ Exception: $error");
    }
  }

  String _parseDate(dynamic date) {
    if (date == null || date == "N/A") {
      return "N/A";
    }
    try {
      return DateFormat('yyyy-MM-dd').format(DateTime.parse(date));
    } catch (e) {
      return "Invalid Date";
    }
  }

  bool _isPastDate(DateTime date) {
    return date.isBefore(today);
  }

  bool _isSessionAvailable(DateTime date, String time) {
    return sessions.any((session) =>
        session["date"] == DateFormat('yyyy-MM-dd').format(date) &&
        session["time"] == time &&
        session["available_slots"] > 0);
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
                      border: TableBorder.all(),
                      columnWidths: const {
                        0: FlexColumnWidth(1),
                        1: FlexColumnWidth(1),
                        2: FlexColumnWidth(1),
                        3: FlexColumnWidth(1),
                        4: FlexColumnWidth(1),
                        5: FlexColumnWidth(1),
                        6: FlexColumnWidth(1),
                      },
                      children: [
                        TableRow(
                          children: calendarWeeks[weekIndex].map((date) {
                            return Container(
                              padding: EdgeInsets.all(8),
                              color: _isPastDate(date) ? Colors.grey[300] : Colors.white,
                              child: Center(
                                child: Text(
                                  "${DateFormat('E dd/MM').format(date)}", // Format: "Mon 11/03"
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                    color: _isPastDate(date) ? Colors.grey : Colors.black,
                                  ),
                                ),
                              ),
                            );
                          }).toList(),
                        ),
                        for (int hour = 8; hour <= 20; hour++)
                          TableRow(
                            children: calendarWeeks[weekIndex].map((date) {
                              bool sessionAvailable = _isSessionAvailable(date, "$hour:00");
                              return Container(
                                padding: EdgeInsets.all(8),
                                color: _isPastDate(date)
                                    ? Colors.grey[300]
                                    : (sessionAvailable ? Colors.green : Colors.red),
                                child: Center(
                                  child: Text(
                                    "$hour:00",
                                    style: TextStyle(color: Colors.white),
                                  ),
                                ),
                              );
                            }).toList(),
                          ),
                      ],
                    ),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }
}
