import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

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

class _TrainerAvailabilityScreenState extends State<TrainerAvailabilityScreen> {
  late List<List<List<bool>>> availability; // Stores per week, day, slot
  late List<String> headers;
  late DateTime now;

  @override
  void initState() {
    super.initState();
    now = DateTime.now();
    now = now.subtract(Duration(days: now.weekday - 1)); // Ensure Monday start
    _initializeAvailability();
  }

  void _initializeAvailability() {
    availability = List.generate(8, (_) => List.generate(7, (_) => List.generate(13, (_) => false)));

    headers = List.generate(7, (index) {
      DateTime date = now.add(Duration(days: index));
      return DateFormat('EEE dd/MM').format(date);
    });
  }

  void _toggleSlot(int week, int dayIndex, int slotIndex) {
    setState(() {
      availability[week][dayIndex][slotIndex] = !availability[week][dayIndex][slotIndex];
    });
  }

  void _saveAvailability() {
    print("Saving availability...");
    for (int week = 0; week < availability.length; week++) {
      for (int day = 0; day < availability[week].length; day++) {
        for (int slot = 0; slot < availability[week][day].length; slot++) {
          if (availability[week][day][slot]) {
            print("Week ${week + 1}, Day ${day + 1}, Slot ${slot + 1} is available");
          }
        }
      }
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
                      children: headers.map((header) => Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Center(child: Text(header, style: TextStyle(fontWeight: FontWeight.bold))),
                      )).toList(),
                    ),
                    ...List.generate(13, (slotIndex) {
                      return TableRow(
                        children: List.generate(7, (dayIndex) {
                          DateTime currentDate = now.add(Duration(days: dayIndex));
                          bool isPast = currentDate.isBefore(DateTime.now()) && weekIndex == 0;
                          return GestureDetector(
                            onTap: isPast ? null : () => _toggleSlot(weekIndex, dayIndex, slotIndex),
                            child: Container(
                              color: isPast
                                  ? Colors.grey
                                  : (availability[weekIndex][dayIndex][slotIndex] ? Colors.green : Colors.red),
                              padding: EdgeInsets.all(8.0),
                              child: Center(child: Text("${8 + slotIndex}:00 ${slotIndex < 4 ? 'AM' : 'PM'}")),
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
