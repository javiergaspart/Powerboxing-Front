import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:fitboxing_app/constants/urls.dart';
import 'package:fitboxing_app/models/session_model.dart';

class SessionService {
  // Base URL for your API
  final String baseUrl = AppUrls.baseUrl;

  // Get upcoming sessions for a specific location
  Future<List<Session>> getUpcomingSessions(String userId) async {
    try {
      // Update the endpoint to query by user ID
      final response = await http.get(
        Uri.parse('$baseUrl/sessions/upcoming?userId=$userId'), // Adjust endpoint as needed
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> result = json.decode(response.body);

        print('API Response: $result'); // Debugging: Log the response

        if (result['success']) {
          // Access data directly or handle nested structure
          final List<dynamic> data = result['data'] is List<dynamic>
              ? result['data']
              : result['data']['sessions']; // Adjust if 'sessions' is nested

          // Map the JSON to `Session` objects and sort by date
          return data
              .map((session) => Session.fromJson(session))
              .toList()
            ..sort((a, b) => a.date.compareTo(b.date)); // Sort by date (ascending)
        } else {
          throw Exception(result['error']);
        }
      } else {
        throw Exception('Failed to load user sessions');
      }
    } catch (e) {
      print('Error fetching user sessions: $e');
      throw e;
    }
  }



  // Get previous sessions for a user
  Future<List<Session>> getPreviousSessions(String userId) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/sessions/previous?userId=$userId'),
      );
      print(userId);
      print(response.statusCode);
      if (response.statusCode == 200) {
        final Map<String, dynamic> result = json.decode(response.body);
        if (result['success']) {
          final List<dynamic> data = result['data'];
          return data.map((session) => Session.fromJson(session)).toList();
        } else {
          throw Exception(result['error']);
        }
      } else {
        throw Exception('Failed to load previous sessions');
      }
    } catch (e) {
      print('Error fetching previous sessions: $e');
      throw e;
    }
  }

  // Book a session for a user
  Future<bool> bookSession({
    required String userId,
    required String location,
    required String date,
    required String sessionId,
  }) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/sessions/book'),
        body: json.encode({
          'userId': userId,
          'location': location,
          'date': date,
          'sessionId': sessionId,
        }),
        headers: {
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        return true; // Booking successful
      } else {
        throw Exception('Failed to book session');
      }
    } catch (e) {
      print('Error booking session: $e');
      throw e;
    }
  }

  // Get session details (for showing reports or other session-specific data)
  Future<Session> getSessionDetails(String sessionId) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/sessions/$sessionId'),
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        return Session.fromJson(data);
      } else {
        throw Exception('Failed to load session details');
      }
    } catch (e) {
      print('Error fetching session details: $e');
      throw e;
    }
  }
  // Reserve a session for a user
  // In your SessionService's reserveSlot method



  // Check session availability (if slots are available)
  Future<bool> checkSessionAvailability(String sessionId) async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/api/sessions/check-availability/$sessionId'));

      if (response.statusCode == 200) {
        return json.decode(response.body)['isAvailable'];
      } else {
        throw Exception('Failed to check session availability');
      }
    } catch (error) {
      throw Exception('Error checking session availability: $error');
    }
  }
}

