import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:intl/intl.dart';
import './manage_session_screen.dart';
import './session_start_screen.dart';
import '../../constants/urls.dart';

class SessionDetailsScreen extends StatefulWidget {
  final String sessionId;

  const SessionDetailsScreen({Key? key, required this.sessionId}) : super(key: key);

  @override
  _SessionDetailsScreenState createState() => _SessionDetailsScreenState();
}

class _SessionDetailsScreenState extends State<SessionDetailsScreen> {
  dynamic sessionDetails;

  // Fetch session details from API
  Future<void> fetchSessionDetails() async {
    var response = await http.get(
      Uri.parse('${AppUrls.baseUrl}/sessions/${widget.sessionId}'),
    );

    if (response.statusCode == 200) {
      setState(() {
        sessionDetails = json.decode(response.body)['data'];
      });
    } else {
      print('Failed to load session details');
    }
  }

  @override
  void initState() {
    super.initState();
    fetchSessionDetails();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF151718),
      appBar: AppBar(
        backgroundColor: const Color(0xFF151718),
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
        title: const Text(
          'Session Details',
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: sessionDetails == null
          ? const Center(child: CircularProgressIndicator(color: Color(0xFF400966)))
          : Padding(
        padding: const EdgeInsets.all(20.0),
        child: ListView(
          children: [
            _buildDetailRow("Date", _formatDate(sessionDetails['date'])),
            _buildDetailRow("Time", sessionDetails['slotTiming']),
            _buildDetailRow("Location", sessionDetails['location']),
            _buildDetailRow("Instructor", sessionDetails['instructor']),
            _buildDetailRow("Available Slots", sessionDetails['availableSlots'].toString()),
            _buildDetailRow("Total Slots", sessionDetails['totalSlots'].toString()),
            const SizedBox(height: 20),
            Column(
              children: [
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF400966),
                    padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ManageSessionScreen(sessionId: widget.sessionId),
                      ),
                    );
                  },
                  child: const Text(
                    "Manage Participants",
                    style: TextStyle(color: Colors.white, fontSize: 16),
                  ),
                ),
                const SizedBox(height: 15),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green.shade700,
                    padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => SessionScreen(),
                      ),
                    );
                  },
                  child: const Text(
                    "Start Session",
                    style: TextStyle(color: Colors.white, fontSize: 16),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "$label: ",
            style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w600),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(color: Colors.white70, fontSize: 18),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          )
        ],
      ),
    );
  }

  String _formatDate(String rawDate) {
    try {
      final date = DateTime.parse(rawDate);
      return DateFormat('dd MMMM yyyy').format(date);
    } catch (_) {
      return rawDate;
    }
  }
}
