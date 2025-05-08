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
import '../../constants/urls.dart';

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
  Future<List<PunchResult>>? punchResult;
  List<PunchResult> results = [];

  @override
  void initState() {
    super.initState();
    if (widget.isCompleted) {
      print("Fetching punch result for session: ${widget.sessionId}");
      punchResult = fetchPunchResult(widget.sessionId);
    } else {
      print("Session is not completed, skipping punch result fetch.");
    }
  }

  Future<List<PunchResult>> fetchPunchResult(String sessionId) async {
    try {
      final response = await http.get(
        Uri.parse('${AppUrls.baseUrl}/results/session/$sessionId'),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        print("API Response: $data");

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
      backgroundColor: const Color(0xFF151718),
      appBar: AppBar(
        title: const Text("Session Details",
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.white)),
        backgroundColor: Colors.black,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            const SizedBox(height: 20),
            _buildSessionDetails(),
            const SizedBox(height: 30),
            if (widget.isCompleted) _buildPunchResult(),
          ],
        ),
      ),
    );
  }

  Widget _buildSessionDetails() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.deepPurple.shade900, Colors.black],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(color: Colors.purpleAccent.withOpacity(0.4), blurRadius: 12, offset: const Offset(0, 6)),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _styledText("LOCATION", widget.location.toUpperCase()),
          _styledText("DATE", widget.date),
          _styledText("TIME", widget.time),
          _styledText("INSTRUCTOR", widget.instructor.toUpperCase()),
          _styledText("USER", widget.username.toUpperCase()),
        ],
      ),
    );
  }

  Widget _styledText(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10.0),
      child: RichText(
        text: TextSpan(
          text: "$label: ",
          style: const TextStyle(
            color: Colors.purpleAccent,
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
          children: [
            TextSpan(
              text: value,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPunchResult() {
    return FutureBuilder<List<PunchResult>>(
      future: punchResult,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator(color: Colors.purpleAccent));
        } else if (snapshot.hasError || snapshot.data == null || snapshot.data!.isEmpty) {
          return const Text(
            "No punch results available",
            style: TextStyle(color: Colors.redAccent, fontSize: 18),
          );
        } else {
          final result = snapshot.data!.first;
          return Container(
            padding: const EdgeInsets.all(20),
            margin: const EdgeInsets.only(top: 10),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              gradient: LinearGradient(
                colors: [Colors.black, Colors.deepPurple.shade900],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              boxShadow: [
                BoxShadow(color: Colors.greenAccent.withOpacity(0.4), blurRadius: 12, offset: const Offset(0, 6)),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildStatCard("ENERGY", result.accuracy.toStringAsFixed(2), "assets/images/energy.jpeg"),
                const SizedBox(height: 20),
                _buildStatCard("POWER", result.power.toInt().toString(), "assets/images/power.jpeg"),
                const SizedBox(height: 20),
                _buildStatCard("ACCURACY", result.accuracy.toStringAsFixed(2), "assets/images/accuracy.jpeg"),
              ],
            ),
          );
        }
      },
    );
  }

  Widget _buildStatCard(String title, String value, String iconPath) {
    return Row(
      children: [
        Image.asset(iconPath, width: 46, height: 46),
        const SizedBox(width: 14),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title,
                style: const TextStyle(
                    color: Colors.purpleAccent, fontSize: 14, fontWeight: FontWeight.w600, letterSpacing: 1)),
            Text(value,
                style: const TextStyle(
                    color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold, letterSpacing: 1)),
          ],
        ),
      ],
    );
  }
}
