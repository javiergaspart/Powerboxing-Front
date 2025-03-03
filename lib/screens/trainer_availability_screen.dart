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
    try {
      final response = await http.get(
        Uri.parse("http://localhost:10000/api/trainer/sessions?trainer=${widget.trainerName}"),
        headers: {"Authorization": "Bearer ${widget.token}"},
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        print("🔹 Retrieved Availability from DB:", data);

        setState(() {
          for (var session in data) {
            DateTime sessionTime = DateTime.parse(session["timeSlot"]);
            int weekIndex = ((sessionTime.difference(today).inDays) ~/ 7);
            int dayIndex = sessionTime.weekday - 1;
            int slotIndex = sessionTime.hour - 8;

            if (weekIndex >= 0 && weekIndex < 8 && dayIndex
