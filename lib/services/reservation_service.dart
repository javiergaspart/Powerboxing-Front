import 'dart:convert';
import 'package:fitboxing_app/models/reservation_model.dart';
import 'package:http/http.dart' as http;
import '../constants/urls.dart';

class ReservationService {
  // Create a reservation
  Future<bool> reserveOrCreateSession({
    required String userId,
    required String slotTimings,
    required String location,
    required String date,
    required String instructor,
  }) async {
    print("userid" + userId);
    print(slotTimings);
    print(date);
    print(location);
    print(instructor);
    final url = Uri.parse('${AppUrls.baseUrl}/sessions/reserve-or-create');
    final response = await http.post(
      url,
      body: json.encode({
        'userId': userId,
        'slotTimings': slotTimings,
        'location': location,
        'date': date,
        'instructor': instructor,
      }),
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      return true; // Reservation successful
    } else {
      throw Exception('Failed to reserve or create session');
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

    if (response.statusCode == 200) {
      List<dynamic> data = json.decode(response.body);
      return data.map((reservation) => Reservation.fromJson(reservation)).toList();
    } else {
      throw Exception('Failed to load reservations');
    }
  }
}
