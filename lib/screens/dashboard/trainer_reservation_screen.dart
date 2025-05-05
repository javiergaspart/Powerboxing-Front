import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../../services/reservation_service.dart';
import '../../models/session_model.dart';
import '../../providers/trainer_provider.dart';
import 'package:google_fonts/google_fonts.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../constants/urls.dart';

class TrainerAvailabilityScreen extends StatefulWidget {
  @override
  _TrainerAvailabilityScreenState createState() =>
      _TrainerAvailabilityScreenState();
}

class _TrainerAvailabilityScreenState extends State<TrainerAvailabilityScreen> {
  final _reservationService = ReservationService();
  Set<DateTime> _existingSlots = {}; // Already saved slots from backend
  DateTime _selectedDate = DateTime.now();
  bool _isLoading = false;
  List<DateTime> _availableSlots = [];
  Set<DateTime> _selectedSlots = {}; // Stores selected slots for saving

  DateTime _normalizeTime(DateTime dt) {
    return DateTime(dt.year, dt.month, dt.day, dt.hour, dt.minute);
  }

  void _generateAvailableSlots() async {
    setState(() {
      _availableSlots.clear();
      _existingSlots.clear();
    });

    DateTime now = DateTime.now();
    DateTime startTime = DateTime(_selectedDate.year, _selectedDate.month, _selectedDate.day, 9, 0);

    if (_selectedDate.isAtSameMomentAs(DateTime(now.year, now.month, now.day))) {
      int roundedMinutes = now.minute % 30 == 0 ? now.minute : (now.minute ~/ 30 + 1) * 30;
      startTime = DateTime(now.year, now.month, now.day, now.hour, roundedMinutes);
      if (startTime.hour >= 18) return;
    }

    DateTime endTime = DateTime(_selectedDate.year, _selectedDate.month, _selectedDate.day, 18, 0);
    while (startTime.isBefore(endTime)) {
      if (_selectedDate.isAfter(now) || startTime.isAfter(now)) {
        _availableSlots.add(startTime);
      }
      startTime = startTime.add(Duration(minutes: 30));
    }

    final trainer = Provider.of<TrainerProvider>(context, listen: false).trainer;
    if (trainer != null) {
      final dateStr = DateFormat('yyyy-MM-dd').format(_selectedDate);
      try {
        final response = await http.get(
          Uri.parse('${AppUrls.baseUrl}/sessions/trainer/${trainer.id}/slots?date=$dateStr'),
        );

        if (response.statusCode == 200) {
          final Map<String, dynamic> result = jsonDecode(response.body);
          print("Selected slots response: $result");

          final List<dynamic> data = result['data'] ?? [];
          final Set<DateTime> fetchedSlots = {};

          for (var item in data) {
            print("Item: ${item}");
            String timeStr = item['slotTiming']; // e.g., "10:30 AM"
            final parts = timeStr.split(' ');
            final timeParts = parts[0].split(':');
            int hour = int.parse(timeParts[0]);
            int minute = int.parse(timeParts[1]);

// Adjust for AM/PM manually
            if (parts[1].toUpperCase() == 'PM' && hour != 12) hour += 12;
            if (parts[1].toUpperCase() == 'AM' && hour == 12) hour = 0;

            DateTime fullDateTime = DateTime(
              _selectedDate.year,
              _selectedDate.month,
              _selectedDate.day,
              hour,
              minute,
            );

            fetchedSlots.add(fullDateTime);
          }

          print("Fetched existing slots: $fetchedSlots");

          setState(() {
            _existingSlots = fetchedSlots;
            _selectedSlots = Set.from(fetchedSlots);
          });
        } else {
          print('Failed to fetch availability: ${response.statusCode}');
        }
      } catch (e) {
        print('Error fetching availability: $e');
      }
    }
  }


  Future<void> _deleteSlot(DateTime slot) async {
    final trainer = Provider.of<TrainerProvider>(context, listen: false).trainer;
    if (trainer == null) return;

    final url = Uri.parse('${AppUrls.baseUrl}/sessions/${trainer.id}/slot');
    final body = jsonEncode({
      "date": DateFormat('yyyy-MM-dd').format(_selectedDate),
      "time": DateFormat('h:mm a').format(slot), // Ensures consistent plain-text AM/PM
    });
    print("Selected slot to delete: ${body}");

    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: body,
    );
    print("Response: ${response}");
    print("Response: ${response.statusCode}");
    if (response.statusCode == 200) {
      print("Response: ${response}");
      print("Response: ${response.statusCode}");
      setState(() {
        _existingSlots.remove(slot);
        _selectedSlots.remove(slot);
      });
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Slot deleted')));
      _generateAvailableSlots();
    }
    else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Failed to delete slot')));
    }
  }

  Future<void> _saveAvailability() async {
    if (_selectedSlots.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Please select at least one slot.')));
      return;
    }
    setState(() => _isLoading = true);

    try {
      final trainer = Provider.of<TrainerProvider>(context, listen: false).trainer;
      if (trainer == null) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('No Trainer logged in!')));
        return;
      }
      String formattedDate = DateFormat('yyyy-MM-dd').format(_selectedDate);
      List<String> slotTimings = _selectedSlots.map((slot) => DateFormat.jm().format(slot)).toList();
      String location = 'FitBoxing Studio'; // Optional: Make this dynamic later

      bool success = await _reservationService.saveTrainerSlots(
        context: context,
        trainerId: trainer.id.toString(),
        slotTimings: slotTimings,
        location: location,
        date: formattedDate,
      );
      if (success) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Slots saved successfully!')));
        _generateAvailableSlots();
      } else {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Failed to save slots')));
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error: $e')));
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  void initState() {
    super.initState();
    _generateAvailableSlots();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF151718),
      appBar: AppBar(
        title: Text('Trainer Availability', style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.black,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Text(
              'Select Available Slots for ${DateFormat('yyyy-MM-dd').format(_selectedDate)}',
              style: GoogleFonts.robotoCondensed(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            SizedBox(height: 16),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: List.generate(6, (index) {
                  DateTime date = DateTime.now().add(Duration(days: index));
                  bool isSelected = _selectedDate.year == date.year &&
                      _selectedDate.month == date.month &&
                      _selectedDate.day == date.day;

                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        _selectedDate = date;
                        _generateAvailableSlots();
                      });
                    },
                    child: Container(
                      margin: EdgeInsets.symmetric(horizontal: 8),
                      padding: EdgeInsets.symmetric(vertical: 10, horizontal: 16),
                      decoration: BoxDecoration(
                        color: isSelected ? Color(0xFF99C448) : Colors.grey[700],
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Text(
                        DateFormat('EEE\ndd').format(date),
                        textAlign: TextAlign.center,
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  );
                }),
              ),
            ),
            SizedBox(height: 20),
            Expanded(
              child: ListView.builder(
                itemCount: _availableSlots.length,
                itemBuilder: (context, index) {
                  final slot = _availableSlots[index];
                  final isSelected = _selectedSlots.contains(_normalizeTime(slot));
                  final isDisabled = _existingSlots.contains(slot);
                  print("Slot: ${DateFormat.jm().format(slot)}, Selected: ${_selectedSlots.contains(slot)}");
                  return GestureDetector(
                    onTap: () {
                      if (_existingSlots.contains(slot)) return; // Block toggle for existing
                      setState(() {
                        if (_selectedSlots.contains(slot)) {
                          _selectedSlots.remove(slot);
                        } else {
                          _selectedSlots.add(slot);
                        }
                      });
                    },
                    onLongPress: () async {
                      if (isDisabled) {
                        final confirm = await showDialog<bool>(
                          context: context,
                          builder: (context) => AlertDialog(
                            title: Text('Delete Slot?'),
                            content: Text('Delete ${DateFormat.jm().format(slot)}?'),
                            actions: [
                              TextButton(
                                child: Text('Cancel'),
                                onPressed: () => Navigator.pop(context, false),
                              ),
                              TextButton(
                                child: Text('Delete'),
                                onPressed: () => Navigator.pop(context, true),
                              ),
                            ],
                          ),
                        );

                        if (confirm == true) {
                          await _deleteSlot(slot);
                        }
                      }
                    },
                      child: Container(
                      margin: EdgeInsets.symmetric(vertical: 6),
                      padding: EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: _existingSlots.contains(slot)
                            ? Color(0xFF99C448) // Always green for existing
                            : (_selectedSlots.contains(slot)
                            ? Color(0xFF99C448) // Green if newly selected
                            : Colors.grey[800]), // Default background
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Text(
                        DateFormat.jm().format(slot),
                        style: TextStyle(color: Colors.white, fontSize: 18),
                      ),
                    ),
                  );
                },
              ),
            ),
            _isLoading
                ? CircularProgressIndicator()
                : ElevatedButton(
              onPressed: _saveAvailability,
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all(Color(0xFF99C448)),
                padding: MaterialStateProperty.all(EdgeInsets.symmetric(vertical: 14, horizontal: 40)),
                shape: MaterialStateProperty.all(
                  RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                ),
              ),
              child: Text(
                'Save Availability',
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.white),
              ),
            ),
            SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}
