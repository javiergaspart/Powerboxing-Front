import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class TrainerAvailabilityScreen extends StatefulWidget {
  final String trainerName;
  final String token;

  TrainerAvailabilityScreen({required this.trainerName, required this.token});

  @override
  _TrainerAvailabilityScreenState createState() => _TrainerAvailabilityScreenState();
}

class _TrainerAvailabilityScreenState extends State<TrainerAvailabilityScreen> {
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

  void _toggleSlot(int weekIndex, int dayIndex, int slotIndex) {
    setState(() {
      availability[weekIndex][dayIndex][slotIndex] = !availability[weekIndex][dayIndex][slotIndex];
    });
  }

  Future<void> _fetchAvailability() async {
    final url = Uri.parse('http://localhost:10000/api/trainer/sessions/${widget.trainerName}');
    final response = await http.get(
      url,
      headers: {'Authorization': 'Bearer ${widget.token}'},
    );

    if (response.statusCode == 200) {
      final body = jsonDecode(response.body);
      if (body == null || body.isEmpty) {
        print("⚠️ No sessions found.");
        return;
      }

      setState(() {
        for (var session in body) {
          DateTime sessionTime = DateTime.parse(session["timeSlot"]);
          int weekIndex = ((sessionTime.difference(today).inDays) ~/ 7);
          int dayIndex = sessionTime.weekday - 1;
          int slotIndex = sessionTime.hour - 8;

          if (weekIndex >= 0 && weekIndex < 8 && dayIndex >= 0 && dayIndex < 7 && slotIndex >= 0 && slotIndex < 13) {
            availability[weekIndex][dayIndex][slotIndex] = true; // Mark as booked (Blue)
          }
        }
      });
    } else {
      print("❌ Error fetching availability: \${response.body}");
    }
  }

  Future<void> _saveAvailability() async {
    final url = Uri.parse('http://localhost:10000/api/sessions/save');
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json', 'Authorization': 'Bearer ${widget.token}'},
      body: jsonEncode({'trainer_id': widget.trainerName, 'availability': availability}),
    );

    print("🔍 Sent Data: \${jsonEncode({'trainer_id': widget.trainerName, 'availability': availability})}");
    print("🔍 Response Status: \${response.statusCode}");
    print("🔍 Response Body: \${response.body}");

    if (response.statusCode == 200) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Availability saved successfully')));
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error: \${response.body}')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: _saveAvailability,
        child: Icon(Icons.save),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: List.generate(8, (weekIndex) {
            return Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text("Week ${weekIndex + 1}",
                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                ),
                Table(
                  border: TableBorder.all(),
                  columnWidths: {for (int i = 0; i < 7; i++) i: FlexColumnWidth()},
                  children: [
                    TableRow(
                      children: List.generate(7, (dayIndex) {
                        DateTime date = today.add(Duration(days: (weekIndex * 7) + dayIndex));
                        bool isPast = date.isBefore(DateTime.now());
                        return Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Center(
                            child: Text(
                              DateFormat('EEE dd/MM').format(date),
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: isPast ? Colors.grey : Colors.black,
                              ),
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
    );
  }
}
