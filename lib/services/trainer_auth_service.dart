import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/trainer.dart';
import '../constants/urls.dart';

class TrainerAuthService {
  final String baseUrl = AppUrls.baseUrl;

  Future<Trainer> loginTrainer(String email, String password) async {
    final url = '$baseUrl/trainer/login';
    print('[TrainerAuthService] Attempting login for: $email');
    print('[TrainerAuthService] POST $url');
    print('[TrainerAuthService] Payload: ${jsonEncode({'email': email, 'password': password})}');

    try {
      final response = await http.post(
        Uri.parse(url),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'email': email, 'password': password}),
      );

      print('[TrainerAuthService] Response status: ${response.statusCode}');
      print('[TrainerAuthService] Response body: ${response.body}');

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return Trainer.fromJson(data['trainer']);
      } else {
        throw Exception('Trainer login failed (Status: ${response.statusCode})');
      }
    } catch (e) {
      print('[TrainerAuthService] Exception occurred: $e');
      rethrow;
    }
  }
}
