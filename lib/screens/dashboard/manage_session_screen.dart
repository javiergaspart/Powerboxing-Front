import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../../constants/punching_bag_ids.dart';
import '../../constants/urls.dart';

class ManageSessionScreen extends StatefulWidget {
  final String sessionId;

  const ManageSessionScreen({Key? key, required this.sessionId}) : super(key: key);

  @override
  State<ManageSessionScreen> createState() => _ManageSessionScreenState();
}

class _ManageSessionScreenState extends State<ManageSessionScreen> {
  List<dynamic> bookedUsers = [];
  Map<String, String> userNumberMap = {};

  @override
  void initState() {
    super.initState();
    fetchSessionDetails();
  }

  Future<void> fetchSessionDetails() async {
    final response = await http.get(Uri.parse('${AppUrls.baseUrl}/sessions/${widget.sessionId}'));

    if (response.statusCode == 200) {
      final data = json.decode(response.body)['data'];
      setState(() {
        bookedUsers = data['bookedUsers'];
      });
    } else {
      print('Failed to load session details');
    }
  }

  Future<void> mapUsersToBags() async {
    List<Map<String, String>> mappings = [];

    userNumberMap.forEach((userId, numberStr) {
      final number = int.tryParse(numberStr);
      if (number != null && number > 0 && punchingBagIdMap.containsKey(number)) {
        mappings.add({
          'userId': userId,
          'punchingBagId': punchingBagIdMap[number]!,
        });
      }
    });

    final response = await http.post(
      Uri.parse('${AppUrls.baseUrl}/sessions/${widget.sessionId}/map-users-to-bags'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({'mappings': mappings}),
    );

    if (response.statusCode == 200) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Mapping successful')));
    } else {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Mapping failed')));
    }
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
          'Manage Session',
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: bookedUsers.isEmpty
          ? const Center(child: CircularProgressIndicator(color: Color(0xFF400966)))
          : Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Expanded(
              child: ListView.builder(
                itemCount: bookedUsers.length,
                itemBuilder: (context, index) {
                  final user = bookedUsers[index];
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10.0),
                    child: Row(
                      children: [
                        Expanded(
                          child: Text(
                            user['username'] ?? 'User ${index + 1}',
                            style: const TextStyle(color: Colors.white, fontSize: 16),
                          ),
                        ),
                        SizedBox(
                          width: 60,
                          child: TextField(
                            style: const TextStyle(color: Colors.white),
                            keyboardType: TextInputType.number,
                            decoration: InputDecoration(
                              filled: true,
                              fillColor: Colors.white12,
                              hintText: '0-10',
                              hintStyle: const TextStyle(color: Colors.white54),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                            onChanged: (value) {
                              userNumberMap[user['_id']] = value;
                            },
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF400966),
                padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              onPressed: mapUsersToBags,
              child: const Text("Manage Session", style: TextStyle(color: Colors.white, fontSize: 16)),
            )
          ],
        ),
      ),
    );
  }
}
