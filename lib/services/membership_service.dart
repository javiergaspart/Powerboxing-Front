import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/membership.dart';
import '../constants/urls.dart';

class MembershipService {
  // Fetch the list of memberships from the backend
  Future<List<Membership>> getMemberships() async {
    final url = Uri.parse('${AppUrls.baseUrl}/membership/purchase');

    final response = await http.get(url, headers: {
      'Content-Type': 'application/json',
      // Add your auth token if needed
    });

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      return data.map((json) => Membership.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load memberships');
    }
  }

  // Purchase membership (increase sessionBalance)
  Future<Map<String, dynamic>> purchaseSessions(String userId, int sessionsBought) async {
    final url = Uri.parse('${AppUrls.baseUrl}/membership/purchase');

    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
        // Add your auth token if needed
      },
      body: jsonEncode({
        'userId': userId,
        'sessionsBought': sessionsBought,
      }),
    );

    if (response.statusCode == 200) {
      return json.decode(response.body); // Returns success message & updated balance
    } else {
      return {'success': false, 'message': 'Failed to purchase sessions'};
    }
  }
}
