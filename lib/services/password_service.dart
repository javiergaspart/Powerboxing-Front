import 'dart:convert';
import 'package:http/http.dart' as http;
import '../constants/urls.dart';

class PasswordService {
  static Future<Map<String, dynamic>> changePassword(
      String userId, String currentPassword, String newPassword) async {
    try {
      final url = Uri.parse('${AppUrls.baseUrl}/password/change-password');
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'userId': userId,
          'currentPassword': currentPassword,
          'newPassword': newPassword,
        }),
      );

      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        return {
          'success': false,
          'message': 'Server error: ${response.body}',
        };
      }
    } catch (error) {
      print('Error changing password: $error');
      return {
        'success': false,
        'message': error.toString(),
      };
    }
  }

  static Future<Map<String, dynamic>> sendResetOTP(String email) async {
    try {
      final url = Uri.parse('${AppUrls.baseUrl}/password/send-reset-otp');
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: json.encode({'email': email}),
      );

      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        return {
          'success': false,
          'message': 'Server error: ${response.body}',
        };
      }
    } catch (error) {
      print('Error sending OTP: $error');
      return {
        'success': false,
        'message': error.toString(),
      };
    }
  }

  static Future<Map<String, dynamic>> resetPassword(
      String email, String otp, String newPassword) async {
    try {
      final url = Uri.parse('${AppUrls.baseUrl}/password/reset-password');
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'email': email,
          'otp': otp,
          'newPassword': newPassword,
        }),
      );

      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        return {
          'success': false,
          'message': 'Server error: ${response.body}',
        };
      }
    } catch (error) {
      print('Error resetting password: $error');
      return {
        'success': false,
        'message': error.toString(),
      };
    }
  }
}
