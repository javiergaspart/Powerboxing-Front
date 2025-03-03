import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:jwt_decoder/jwt_decoder.dart';

class TrainerDashboard extends StatefulWidget {
  final String trainerName;
  final String token;

  TrainerDashboard({required this.trainerName, required this.token});

  @override
  _TrainerDashboardState createState() => _TrainerDashboardState();
}

class _TrainerDashboardState extends State<TrainerDashboard> {
  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> _screens = [
      TrainerAvailabilityScreen(trainerName: widget.trainerName, token: widget.token),
      SessionManagementScreen(trainerName: widget.trainerName, token: widget.token),  
    ];

    return Scaffold(
      appBar: AppBar(
        title: Text("Trainer Dashboard - ${widget.trainerName}"),
      ),
      body: _screens[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.calendar_today), label: 'Availability'),
          BottomNavigationBarItem(icon: Icon(Icons.people), label: 'Sessions'),
        ],
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
      ),
    );
  }
}

class TrainerAvailabilityScreen extends StatefulWidget {
  final String trainerName;
  final String token;

  TrainerAvailabilityScreen({required this.trainerName, required this.token});

  @override
  _TrainerAvailabilityScreenState createState() => _TrainerAvailabilityScreenState();
}
List<dynamic> fetchedSessions = [];
class _TrainerAvailabilityScreenState extends State<TrainerAvailabilityScreen> {
bool _isSessionAvailableForSlot(int weekIndex, int dayIndex, int slotIndex) {
  DateTime selectedDate = this.now.add(Duration(days: (weekIndex * 7) + dayIndex));
  String dateString = "${selectedDate.year}-${selectedDate.month.toString().padLeft(2, '0')}-${selectedDate.day.toString().padLeft(2, '0')}";
  String timeString = "${(slotIndex + 8).toString().padLeft(2, '0')}:00";

  return fetchedSessions.any((session) => session['date'] == dateString && session['time'] == timeString);
}

  late List<List<List<bool>>> availability;
  late DateTime now;

  @override
  void initState() {
    super.initState();
    now = DateTime.now();
    now = now.subtract(Duration(days: now.weekday - 1));
    _initializeAvailability();
    _fetchAvailability();
  }

  void _initializeAvailability() {
    availability = List.generate(8, (_) => List.generate(7, (_) => List.generate(13, (_) => false)));
  }

  Future<void> _fetchAvailability() async {
  final url = Uri.parse('http://localhost:10000/api/sessions/get');
  final trainerId = JwtDecoder.decode(widget.token)['userId'];

  final response = await http.get(
    url,
    headers: {'Authorization': 'Bearer ${widget.token}'},
  );

  print("🔍 Raw API Response: ${response.body}"); // ✅ Debug full response

  if (response.statusCode == 200) {
    final data = jsonDecode(response.body);
    
    print("✅ Decoded API Data: $data"); // ✅ Debug decoded data

    setState(() {
      fetchedSessions = data.containsKey('availability') && data['availability'] != null
          ? data['availability']
          : [];
    });

    print("✅ Updated fetchedSessions: $fetchedSessions"); // ✅ Debug stored sessions
  } else {
    print("❌ Error fetching availability: ${response.body}");
  }
}


  void _toggleSlot(int week, int dayIndex, int slotIndex) {
    DateTime selectedDate = now.add(Duration(days: (week * 7) + dayIndex));
    if (selectedDate.isBefore(DateTime.now())) return; 
    
    setState(() {
      availability[week][dayIndex][slotIndex] = !availability[week][dayIndex][slotIndex];
    });
  }

  Future<void> _saveAvailability() async {
    final url = Uri.parse('http://localhost:10000/api/sessions/save');
    final trainerId = JwtDecoder.decode(widget.token)['userId'];

    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json', 'Authorization': 'Bearer ${widget.token}'},
      body: jsonEncode({'trainer_id': trainerId, 'availability': availability}),
    );

    print("🔍 Sent Data: ${jsonEncode({'trainer_id': trainerId, 'availability': availability})}");
    print("🔍 Response Status: ${response.statusCode}");
    print("🔍 Response Body: ${response.body}");

    if (response.statusCode == 200) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Availability saved successfully')));
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error: ${response.body}')));
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
                        DateTime date = now.add(Duration(days: (weekIndex * 7) + dayIndex));
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
                              color: _isSessionAvailableForSlot(weekIndex, dayIndex, slotIndex) ? Colors.blue : Colors.red,
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

class SessionManagementScreen extends StatelessWidget {
  final String trainerName;
  final String token;

  SessionManagementScreen({required this.trainerName, required this.token});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text("Session Management Coming Soon..."),
    );
  }
}
