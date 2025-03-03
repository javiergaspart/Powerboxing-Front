import 'package:flutter/material.dart';

class TrainerAvailabilityScreen extends StatefulWidget {
  final String trainerName;
  final String token;

  TrainerAvailabilityScreen({required this.trainerName, required this.token});

  @override
  _TrainerAvailabilityScreenState createState() => _TrainerAvailabilityScreenState();
}

class _TrainerAvailabilityScreenState extends State<TrainerAvailabilityScreen> {
  List<List<bool>> availability = List.generate(8, (week) => List.generate(13, (slot) => false));
  List<String> daysOfWeek = ['M', 'T', 'W', 'T', 'F', 'S', 'S'];
  List<String> timeSlots = [
    "08:00 AM", "09:00 AM", "10:00 AM", "11:00 AM", "12:00 PM",
    "01:00 PM", "02:00 PM", "03:00 PM", "04:00 PM", "05:00 PM",
    "06:00 PM", "07:00 PM", "08:00 PM"
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Trainer Availability")),
      body: SingleChildScrollView(
        child: Column(
          children: List.generate(8, (weekIndex) => Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text("Week ${weekIndex + 1}", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              ),
              Table(
                border: TableBorder.all(),
                children: [
                  TableRow(
                    children: daysOfWeek.map((day) => Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Center(child: Text(day)),
                    )).toList(),
                  ),
                  ...List.generate(timeSlots.length, (slotIndex) => TableRow(
                    children: List.generate(daysOfWeek.length, (dayIndex) => GestureDetector(
                      onTap: () {
                        setState(() {
                          availability[weekIndex][slotIndex] = !availability[weekIndex][slotIndex];
                        });
                      },
                      child: Container(
                        height: 40,
                        color: availability[weekIndex][slotIndex] ? Colors.green : Colors.red,
                        child: Center(child: Text(timeSlots[slotIndex], style: TextStyle(color: Colors.white))),
                      ),
                    )),
                  )),
                ],
              ),
            ],
          )),
        ),
      ),
    );
  }
}
