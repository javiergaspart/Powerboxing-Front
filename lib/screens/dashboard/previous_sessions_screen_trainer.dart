import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../../providers/trainer_provider.dart';
import './session_details_screen.dart';
import 'package:provider/provider.dart';
import '../../constants/urls.dart';

class PreviousSessionsScreen extends StatefulWidget {
  @override
  _PreviousSessionsScreenState createState() => _PreviousSessionsScreenState();
}

class _PreviousSessionsScreenState extends State<PreviousSessionsScreen> {
  DateTime selectedDate = DateTime.now();
  List<dynamic> pastSessions = [];

  Future<void> fetchPastSessions(String trainerId) async {
    String formattedDate = DateFormat('yyyy-MM-dd').format(selectedDate);

    var response = await http.get(
      Uri.parse('${AppUrls.baseUrl}/trainer/$trainerId/past-sessions?date=$formattedDate'),
    );

    if (response.statusCode == 200) {
      var data = json.decode(response.body);
      if (data['data'] != null) {
        setState(() {
          pastSessions = data['data'];
        });
      } else {
        print('No past sessions available for this date.');
        setState(() {
          pastSessions = []; // Reset the list if no data is found
        });
      }
    } else {
      print('Failed to load sessions');
    }
  }


  @override
  void initState() {
    super.initState();
    final trainerId = Provider.of<TrainerProvider>(context, listen: false).trainer?.id ?? '';
    fetchPastSessions(trainerId);
  }

  @override
  Widget build(BuildContext context) {
    final trainerId = Provider.of<TrainerProvider>(context).trainer?.id ?? '';

    return Scaffold(
      backgroundColor: const Color(0xFF151718),
      appBar: AppBar(
        title: const Text(
          'Previous Sessions',
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
            GestureDetector(
              onTap: () async {
                DateTime? pickedDate = await showDatePicker(
                  context: context,
                  initialDate: selectedDate,
                  firstDate: DateTime(2020),
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
                    fetchPastSessions(trainerId); // Fetch sessions for the new date
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
            const SizedBox(height: 30),
            // Sessions List
            Expanded(
              child: pastSessions.isEmpty
                  ? const Center(
                child: Text(
                  'No previous sessions available',
                  style: TextStyle(color: Colors.white70, fontSize: 18),
                ),
              )
                  : ListView.separated(
                itemCount: pastSessions.length,
                separatorBuilder: (_, __) => const SizedBox(height: 15),
                itemBuilder: (context, index) {
                  var session = pastSessions[index];
                  return InkWell(
                    onTap: () {
                      var sessionId = session['_id'];
                      print("Session id: ${sessionId}");
                      if (sessionId != null && sessionId.isNotEmpty) {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => SessionDetailsScreen(
                              sessionId: sessionId,
                            ),
                          ),
                        );
                      } else {
                        print("Session ID is null or empty");
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text("Invalid session ID!")),
                        );
                      }
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
                            DateFormat('yyyy-MM-dd').format(
                              DateTime.parse(session['date']),
                            ),
                            style: const TextStyle(
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
