import 'dart:convert';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:fitboxing_app/models/reservation_model.dart';
import 'package:fitboxing_app/providers/user_provider.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;
import '../constants/urls.dart';

class ReservationService {
  // Create a reservation
  Future<bool> reserveOrCreateSession({
    required BuildContext context, // Pass context from UI
    required String userId,
    required String slotTimings,
    required String location,
    required String date,
    required String instructor,
    required int totalSlots,
    required String time,
  }) async {
    print("UserID: $userId");
    print("Slot Timings: $slotTimings");
    print("Date: $date");
    print("Location: $location");
    print("Instructor: $instructor");

    // Get UserProvider
    final userProvider = Provider.of<UserProvider>(context, listen: false);

    // Check session balance
    if (userProvider.user == null || userProvider.user!.sessionBalance < 1) {
      _showSnackBar(context, "Session Balance not Available!");
      return false;
    }

    final url = Uri.parse('${AppUrls.baseUrl}/sessions/book');
    final response = await http.post(
      url,
      body: json.encode({
        'userId': userId,
        'slotTimings': slotTimings,
        'location': location,
        'date': date,
        'instructor': instructor,
        'totalSlots': totalSlots,
        'time': time,
      }),
      headers: {'Content-Type': 'application/json'},
    );
    print("Response: ${response.statusCode}");
    print("Response: ${response.body}");

    if (response.statusCode == 200 || response.statusCode == 201) {
      final responseData = json.decode(response.body);
      if (responseData.containsKey('newBalance')) {
        int newBalance = responseData['newBalance'];
        userProvider.updateSessionBalance(newBalance);
      }

      return true; // Reservation successful
    } else {
      final responseData = json.decode(response.body);
      _showSnackBar(context, responseData['message'] ?? 'Failed to reserve or create session');
      return false;
    }
  }

  // Get reservations for a user
  Future<List<Reservation>> getUserReservations(String userId) async {
    final url = Uri.parse('${AppUrls.baseUrl}/reservations/user/$userId');
    final response = await http.get(
      url,
      headers: {
        'Content-Type': 'application/json',
        // Add your authorization token if required
      },
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      List<dynamic> data = json.decode(response.body);
      return data.map((reservation) => Reservation.fromJson(reservation)).toList();
    } else {
      throw Exception('Failed to load reservations');
    }
  }

  Future<bool> saveTrainerSlots({
    required BuildContext context,
    required String trainerId,
    required List<String> slotTimings,
    required String location,
    required String date,
  }) async {
    try {
      final url = Uri.parse('${AppUrls.baseUrl}/sessions/saveTrainerSlots');

      // 🌟 Log raw data before sending
      debugPrint('🚀 Sending saveTrainerSlots request...');
      debugPrint('📅 Date: $date');
      debugPrint('📍 Location: $location');
      debugPrint('👤 Trainer ID: $trainerId');
      for (var slot in slotTimings) {
        debugPrint('⏰ Slot: "$slot" | Code units: ${slot.codeUnits}');
      }

      final body = {
        'trainerId': trainerId,
        'slotTimings': slotTimings,
        'location': location,
        'date': date,
        'availableSlots': 10,
      };

      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
        },
        body: json.encode(body),
      );

      debugPrint('📨 Response status: ${response.statusCode}');
      debugPrint('📨 Response body: ${response.body}');

      if (response.statusCode == 200 || response.statusCode == 201) {
        debugPrint('Saved!');
        return true;
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to save trainer slots: ${response.body}')),
        );
        return false;
      }
    } catch (e, stackTrace) {
      debugPrint('🔥 Error in saveTrainerSlots: $e');
      debugPrint('🧵 StackTrace: $stackTrace');

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
      return false;
    }
  }// Function to get trainer's slots for a specific date
  Future<List<DateTime>> getTrainerSlots(String trainerId, DateTime date) async {
    try {
      // Format the date to match the backend format
      String formattedDate = DateFormat('yyyy-MM-dd').format(date);

      final response = await http.get(
        Uri.parse('${AppUrls.baseUrl}/sessions/trainer/$trainerId/slots?date=$formattedDate'),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        // Parse the response and return the list of available slots
        List<dynamic> slotsJson = jsonDecode(response.body);
        List<DateTime> slots = slotsJson.map((slot) {
          return DateFormat("yyyy-MM-dd HH:mm").parse(slot['dateTime']);
        }).toList();
        return slots;
      } else {
        // Handle errors
        print('Failed to fetch trainer slots: ${response.body}');
        return [];
      }
    } catch (e) {
      print('Error fetching trainer slots: $e');
      return [];
    }
  }



  // Function to delete a trainer's slot

  // Helper function to show Snackbar
  void _showSnackBar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }
}
