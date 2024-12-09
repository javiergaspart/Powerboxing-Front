import 'package:dio/dio.dart';
import 'package:fitboxing_app/models/user_model.dart';
import 'package:fitboxing_app/utils/validators.dart';
import '../constants/urls.dart';

class UserService {
  Dio _dio = Dio();  // Dio instance

  // Base URL for your API
  final String baseUrl = AppUrls.baseUrl;

  // Get user profile data
  Future<User?> getUserProfile(String token) async {
    try {
      Response response = await _dio.get(
        '$baseUrl/user/profile',
        options: Options(
          headers: {'Authorization': 'Bearer $token'},
        ),
      );

      // If successful, parse the response and return a UserModel
      if (response.statusCode == 200) {
        return User.fromJson(response.data);
      } else {
        throw Exception('Failed to load user profile');
      }
    } catch (e) {
      print('Error fetching user profile: $e');
      rethrow;
    }
  }

  // Update user profile
  Future<User?> updateUserProfile({
    required String token,
    required String name,
    required String email,
    String? phone,
    String? avatarUrl,
  }) async {
    try {
      Response response = await _dio.put(
        '$baseUrl/user/profile',
        data: {
          'name': name,
          'email': email,
          'phone': phone,
          'avatar_url': avatarUrl,
        },
        options: Options(
          headers: {'Authorization': 'Bearer $token'},
        ),
      );

      // If the update is successful, return the updated UserModel
      if (response.statusCode == 200) {
        return User.fromJson(response.data);
      } else {
        throw Exception('Failed to update user profile');
      }
    } catch (e) {
      print('Error updating user profile: $e');
      rethrow;
    }
  }

  // Change user password
  Future<bool> changePassword({
    required String token,
    required String oldPassword,
    required String newPassword,
  }) async {
    try {
      Response response = await _dio.put(
        '$baseUrl/user/change-password',
        data: {
          'old_password': oldPassword,
          'new_password': newPassword,
        },
        options: Options(
          headers: {'Authorization': 'Bearer $token'},
        ),
      );

      // If successful, return true
      if (response.statusCode == 200) {
        return true;
      } else {
        throw Exception('Failed to change password');
      }
    } catch (e) {
      print('Error changing password: $e');
      rethrow;
    }
  }

  // Delete user account
  Future<bool> deleteUserAccount(String token) async {
    try {
      Response response = await _dio.delete(
        '$baseUrl/user',
        options: Options(
          headers: {'Authorization': 'Bearer $token'},
        ),
      );

      // If successful, return true
      if (response.statusCode == 200) {
        return true;
      } else {
        throw Exception('Failed to delete user account');
      }
    } catch (e) {
      print('Error deleting user account: $e');
      rethrow;
    }
  }

  // Validate email using regular expression (for client-side validation before API call)
  bool validateEmail(String email) {
    return Validators.isValidEmail(email);
  }

  // Validate phone number using a regular expression (for client-side validation before API call)
  bool validatePhone(String phone) {
    return Validators.isValidPhone(phone);
  }
}
