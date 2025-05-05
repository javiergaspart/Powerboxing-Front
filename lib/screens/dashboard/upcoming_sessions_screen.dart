import 'package:flutter/material.dart';
import './session_details_screen.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../../providers/trainer_provider.dart';
import './session_details_screen.dart';
import 'package:provider/provider.dart';
import '../../constants/urls.dart';

class UpcomingSessionsScreen extends StatefulWidget {
  @override
  _UpcomingSessionsScreenState createState() => _UpcomingSessionsScreenState();
}

class _UpcomingSessionsScreenState extends State<UpcomingSessionsScreen> {
  DateTime selectedDate = DateTime.now();
  List<dynamic> upcomingSessions = [];

  Future<void> fetchUpcomingSessions(String trainerId) async {
    String formattedDate = DateFormat('yyyy-MM-dd').format(selectedDate);

    // Log the request URL and formatted date
    print('Fetching upcoming sessions for trainer $trainerId on date: $formattedDate');

    try {
      var response = await http.get(
        Uri.parse('${AppUrls.baseUrl}/sessions/trainer/$trainerId/slots?date=$formattedDate'),
      );

      // Log response status
      print('Response Status Code: ${response.statusCode}');

      if (response.statusCode == 200) {
        // Log the response body (data returned from API)
        print('Response Body: ${response.body}');

        setState(() {
          upcomingSessions = json.decode(response.body)['data'];
        });
      } else {
        print('Failed to load sessions. Status code: ${response.statusCode}');
      }
    } catch (e) {
      // Catch and log any errors during the request
      print('Error fetching upcoming sessions: $e');
    }
  }

  @override
  void initState() {
    super.initState();
    final trainerId = Provider.of<TrainerProvider>(context, listen: false).trainer?.id ?? '';
    fetchUpcomingSessions(trainerId);
  }

  @override
  Widget build(BuildContext context) {
    final trainerId = Provider.of<TrainerProvider>(context).trainer?.id ?? '';

    return Scaffold(
      backgroundColor: const Color(0xFF151718),
      appBar: AppBar(
        title: const Text(
          'Upcoming Sessions',
          style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: Colors.white,
          ),
        ),
        iconTheme: const IconThemeData(color: Colors.white),
        backgroundColor: const Color(0xFF151718),
        centerTitle: true,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            const Text(
              'Select Date',
              style: TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 15),

            // Date Picker Button
            Center(
              child: GestureDetector(
                onTap: () async {
                  DateTime? pickedDate = await showDatePicker(
                    context: context,
                    initialDate: selectedDate,
                    firstDate: DateTime.now(),
                    lastDate: DateTime(2101),
                    builder: (context, child) {
                      return Theme(
                        data: ThemeData.dark().copyWith(
                          colorScheme: const ColorScheme.dark(
                            primary: Color(0xFF400966),
                            onPrimary: Colors.white,
                            surface: Color(0xFF1E1E1E),
                            onSurface: Colors.white,
                          ),
                          dialogBackgroundColor: const Color(0xFF151718),
                        ),
                        child: child!,
                      );
                    },
                  );
                  if (pickedDate != null && pickedDate != selectedDate) {
                    setState(() {
                      selectedDate = pickedDate;
                      fetchUpcomingSessions(trainerId);
                    });
                  }
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 25),
                  decoration: BoxDecoration(
                    color: const Color(0xFF400966),
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.3),
                        blurRadius: 6,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.calendar_today, color: Colors.white),
                      const SizedBox(width: 12),
                      Text(
                        DateFormat('yyyy-MM-dd').format(selectedDate),
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),

            const SizedBox(height: 30),

            // Sessions List
            Expanded(
              child: upcomingSessions.isEmpty
                  ? const Center(
                child: Text(
                  'No sessions available',
                  style: TextStyle(color: Colors.white70, fontSize: 18),
                ),
              )
                  : ListView.separated(
                itemCount: upcomingSessions.length,
                separatorBuilder: (_, __) => const SizedBox(height: 15),
                itemBuilder: (context, index) {
                  var session = upcomingSessions[index];
                  return InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => SessionDetailsScreen(
                            sessionId: session['_id'],
                          ),
                        ),
                      );
                    },
                    child: Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: const Color(0xFF1F1F1F),
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.2),
                            blurRadius: 4,
                            offset: const Offset(0, 2),
                          )
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                              DateFormat('yyyy-MM-dd').format(DateTime.parse(session['date'])),                           style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.white, // white bold for date
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            session['slotTiming'] ?? 'Time not available',
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.grey, // grey bold for time
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
