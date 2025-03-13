import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class TrainerDashboard extends StatefulWidget {
  final String trainerId;
  final String token;

  TrainerDashboard({required this.trainerId, required this.token});

  @override
  _TrainerDashboardState createState() => _TrainerDashboardState();
}

class _TrainerDashboardState extends State<TrainerDashboard> {
  late List<List<List<bool>>> availability;
  late List<String> weekHeaders;
  late DateTime today;

  @override
  void initState() {
    super.initState();
    today = DateTime.now();
    _initializeAvailability();
    _fetchAvailability();
  }

  void _initializeAvailability() {
    availability = List.generate(8, (_) => List.generate(7, (_) => List.generate(13, (_) => false)));

    weekHeaders = List.generate(8, (index) {
      DateTime startDate = today.add(Duration(days: index * 7));
      String startFormatted = DateFormat('dd/MM').format(startDate);
      String endFormatted = DateFormat('dd/MM').format(startDate.add(Duration(days: 6)));
      return "Week ${index + 1} ($startFormatted - $endFormatted)";
    });
  }

  Future<void> _fetchAvailability() async {
  final url = Uri.parse('http://localhost:10000/api/trainer/availability/${widget.trainerId}');
  final response = await http.get(
    url,
    headers: {'Authorization': 'Bearer ${widget.token}'},
  );

  if (response.statusCode == 200) {
    final List<dynamic> body = jsonDecode(response.body);
    if (body.isEmpty) return;

    setState(() {
      for (var session in body) {
        DateTime sessionTime = DateFormat('yyyy-MM-dd HH:mm').parse("${session["date"]} ${session["time"]}");
        int weekIndex = ((sessionTime.difference(today).inDays) ~/ 7);
        int dayIndex = sessionTime.weekday - 1;
        int slotIndex = sessionTime.hour - 8;

        if (weekIndex >= 0 && weekIndex < 8 && dayIndex >= 0 && dayIndex < 7 && slotIndex >= 0 && slotIndex < 13) {
          availability[weekIndex][dayIndex][slotIndex] = true;
        }
      }
    });
  } else {
    print("❌ Error fetching availability: ${response.body}");
  }
}


  void _toggleSlot(int weekIndex, int dayIndex, int slotIndex) {
    setState(() {
      availability[weekIndex][dayIndex][slotIndex] = !availability[weekIndex][dayIndex][slotIndex];
    });
  }

  Future<void> _saveAvailability() async {
  final url = Uri.parse('http://localhost:10000/api/sessions/save');

  List<Map<String, dynamic>> sessions = [];

  for (int weekIndex = 0; weekIndex < 8; weekIndex++) {
    for (int dayIndex = 0; dayIndex < 7; dayIndex++) {
      for (int slotIndex = 0; slotIndex < 13; slotIndex++) {
        if (availability[weekIndex][dayIndex][slotIndex]) {
          DateTime sessionDate = today.add(Duration(days: (weekIndex * 7) + dayIndex));
          String formattedDate = DateFormat('yyyy-MM-dd').format(sessionDate);
          String sessionTime = "${8 + slotIndex}:00";

          sessions.add({
            "trainer_id": widget.trainerId,
            "date": formattedDate,
            "time": sessionTime,
            "available_slots": 20
          });
        }
      }
    }
  }

  final response = await http.post(
    url,
    headers: {
      'Authorization': 'Bearer ${widget.token}',
      'Content-Type': 'application/json',
    },
    body: jsonEncode({
      "trainer_id": widget.trainerId,
      "sessions": sessions,
    }),
  );

  if (response.statusCode == 200) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Availability saved successfully!")));
  } else {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Failed to save availability.")));
  }
}


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: List.generate(8, (weekIndex) {
            return Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(weekHeaders[weekIndex],
                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                ),
                Table(
                  border: TableBorder.all(),
                  children: [
                    TableRow(
                      children: List.generate(7, (dayIndex) {
                        DateTime date = today.add(Duration(days: (weekIndex * 7) + dayIndex));
                        return Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Center(
                            child: Text(
                              DateFormat('EEE dd/MM').format(date),
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ),
                        );
                      }),
                    ),
                    ...List.generate(13, (slotIndex) {
                      return TableRow(
                        children: List.generate(7, (dayIndex) {
                          return GestureDetector(
                            onTap: () => _toggleSlot(weekIndex, dayIndex, slotIndex),
                            child: Container(
                              color: availability[weekIndex][dayIndex][slotIndex] ? Colors.green : Colors.red,
                              padding: EdgeInsets.all(8.0),
                              child: Center(child: Text("${8 + slotIndex}:00")),
                            ),
                          );
                        }),
                      );
                    }),
                  ],
                ),
              ],
            );
          }),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _saveAvailability,
        child: Icon(Icons.save),
      ),
    );
  }
}
