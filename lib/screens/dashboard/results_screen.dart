import 'package:flutter/material.dart';
import '../../services/session_service.dart';
import '../../models/session_model.dart';
import '../../models/user_model.dart';
import 'package:provider/provider.dart';
import 'package:fitboxing_app/providers/user_provider.dart';
import 'package:intl/intl.dart';
import '../../styles/styles.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../models/result_model.dart';

class ResultScreen extends StatefulWidget {
  final String sessionId;
  final String location;
  final String date;
  final String time;
  final String username;
  final String instructor;
  final bool isCompleted;

  const ResultScreen({
    Key? key,
    required this.sessionId,
    required this.location,
    required this.date,
    required this.time,
    required this.username,
    required this.instructor,
    required this.isCompleted,
  }) : super(key: key);

  @override
  _ResultScreenState createState() => _ResultScreenState();
}

class _ResultScreenState extends State<ResultScreen> {
  Future<List<PunchResult>>? punchResult; // Updated type
  List<PunchResult> results = [];


  @override
  void initState() {
    super.initState();
    if (widget.isCompleted) {
      print("Fetching punch result for session: ${widget.sessionId}");
      punchResult = fetchPunchResult(widget.sessionId); // Now it matches the type
    } else {
      print("Session is not completed, skipping punch result fetch.");
    }
  }



  Future<List<PunchResult>> fetchPunchResult(String sessionId) async {
    try {
      final response = await http.get(
        Uri.parse('http://10.0.2.2:5173/fitboxing/results/session/$sessionId'),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        print("API Response: $data"); // Debugging log

        if (data["success"] == true) {
          return (data["data"] as List)
              .map((item) => PunchResult.fromJson(item))
              .toList();
        }
      }
      print("Failed to fetch punch result. Status Code: ${response.statusCode}");
      print("Response Body: ${response.body}");
      return [];
    } catch (e) {
      print("Error fetching punch result for session $sessionId: $e");
      return [];
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF151718),
      appBar: AppBar(
        title: Text("Session Details", style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.white)),
        backgroundColor: Colors.black,
        iconTheme: IconThemeData(color: Colors.white), // Set back arrow color to white
      ),
      body: Padding(
        padding: EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 30),
            _buildSessionDetails(),
            SizedBox(height: 30),
            if (widget.isCompleted) _buildPunchResult(),
          ],
        ),
      ),
    );
  }

  Widget _buildSessionDetails() {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.5),
        borderRadius: BorderRadius.circular(15),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _styledText("LOCATION", widget.location.toUpperCase(), Colors.green, 18),
          _styledText("DATE", widget.date, Colors.green, 18),
          _styledText("TIME", widget.time, Colors.green, 18),
          _styledText("INSTRUCTOR", widget.instructor.toUpperCase(), Colors.green, 18),
          _styledText("USER", widget.username.toUpperCase(), Colors.green, 18),
        ],
      ),
    );
  }

  Widget _styledText(String label, String value, Color color, double fontSize) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: RichText(
        text: TextSpan(
          text: "$label : ",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: fontSize),
          children: [TextSpan(text: value, style: TextStyle(color: color, fontSize: fontSize))],
        ),
      ),
    );
  }

  Widget _buildPunchResult() {
    return FutureBuilder<List<PunchResult>>(
      future: punchResult,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError || snapshot.data == null || snapshot.data!.isEmpty) {
          return Text("No punch results available", style: TextStyle(color: Colors.red, fontSize: 18));
        } else {
          final result = snapshot.data!.first; // Take the first result
          return Container(
            padding: EdgeInsets.all(20),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15),
              color: Colors.black.withOpacity(0.5),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 10),
                _buildStatCard("ENERGY", result.accuracy.toStringAsFixed(2), "assets/images/energy.jpeg", iconSize: 42),
                SizedBox(height: 20),
                _buildStatCard("POWER", result.power.toInt().toString(), "assets/images/power.jpeg", iconSize: 42),
                SizedBox(height: 20),
                _buildStatCard("ACCURACY", result.accuracy.toStringAsFixed(2), "assets/images/accuracy.jpeg"),
              ],
            ),
          );
        }
      },
    );
  }

  Widget _buildStatCard(String title, String value, String iconPath, {double iconSize = 40}) {
    return Row(
      children: [
        Image.asset(iconPath, width: iconSize, height: iconSize), // Adjusted icon size
        SizedBox(width: 12), // Added slight spacing for better alignment
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
            Text(value, style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
          ],
        ),
      ],
    );
  }
}
