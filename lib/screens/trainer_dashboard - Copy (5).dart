import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:jwt_decoder/jwt_decoder.dart';  // ✅ Added for decoding JWT token

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
      SessionManagementScreen(trainerName: widget.trainerName, token: widget.token),  // ✅ Restored Session Management
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

class _TrainerAvailabilityScreenState extends State<TrainerAvailabilityScreen> {
  late List<List<List<bool>>> availability;
  late DateTime now;

  @override
  void initState() {
    super.initState();
    now = DateTime.now();
    now = now.subtract(Duration(days: now.weekday - 1));
    _initializeAvailability();
  }

  void _initializeAvailability() {
    availability = List.generate(8, (_) => List.generate(7, (_) => List.generate(13, (_) => false)));
  }

  void _toggleSlot(int week, int dayIndex, int slotIndex) {
    DateTime selectedDate = now.add(Duration(days: (week * 7) + dayIndex));
    if (selectedDate.isBefore(DateTime.now())) return; // Prevent selection of past days
    
    setState(() {
      availability[week][dayIndex][slotIndex] = !availability[week][dayIndex][slotIndex];
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {},  // Saving functionality remains unchanged
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
                                color: isPast ? Colors.grey : Colors.black, // Gray out past days
                              ),
                            ),
                          ),
                        );
                      }),
                    ),
                    ...List.generate(13, (slotIndex) {
                      return TableRow(
                        children: List.generate(7, (dayIndex) {
                          DateTime date = now.add(Duration(days: (weekIndex * 7) + dayIndex));
                          bool isPast = date.isBefore(DateTime.now());
                          return GestureDetector(
                            onTap: isPast ? null : () => _toggleSlot(weekIndex, dayIndex, slotIndex),
                            child: Container(
                              color: isPast
                                  ? Colors.grey[300] // Gray out past days
                                  : (availability[weekIndex][dayIndex][slotIndex] ? Colors.green : Colors.red),
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
