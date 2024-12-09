import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/result_model.dart';
import '../constants/urls.dart';

class ResultService {
  // Fetch punch results for a specific session
  Future<PunchResult> getPunchResult(String sessionId, String userId) async {
    final url = Uri.parse('${AppUrls.baseUrl}/results/$sessionId/$userId');
    
    final response = await http.get(url, headers: {
      'Content-Type': 'application/json',
      // Add your auth token or any other required headers
    });

    if (response.statusCode == 200) {
      // Parse the response body into a PunchResult object
      return PunchResult.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to load punch results');
    }
  }
}
