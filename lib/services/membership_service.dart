import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/membership.dart';
import '../constants/urls.dart';

class MembershipService {
  // Fetch the list of memberships from the backend
  Future<List<Membership>> getMemberships() async {
    final url = Uri.parse('${AppUrls.baseUrl}/memberships');

    final response = await http.get(url, headers: {
      'Content-Type': 'application/json',
      // Add your auth token or any other required headers
    });

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      return data.map((json) => Membership.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load memberships');
    }
  }
}
