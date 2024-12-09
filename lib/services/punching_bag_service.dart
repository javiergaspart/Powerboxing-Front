import 'package:dio/dio.dart';
import '../config/api_config.dart';

class PunchingBagService {
  final Dio dio = Dio();

  // Fetch punching bag data
  Future<List<dynamic>> getPunchingBags() async {
    try {
      final response = await dio.get(ApiConfig.getPunchingBagsEndpoint);
      if (response.statusCode == 200) {
        return response.data['punchingBags'];
      } else {
        return [];
      }
    } catch (e) {
      print("Error fetching punching bags: $e");
      return [];
    }
  }

  // Submit punch data (force, accuracy, etc.)
  Future<bool> submitPunchData(String sessionId, Map<String, dynamic> punchData) async {
    try {
      final response = await dio.post('${ApiConfig.getPunchingBagsEndpoint}/submit', data: {
        'sessionId': sessionId,
        'punchData': punchData,
      });

      if (response.statusCode == 200) {
        return true;
      } else {
        return false;
      }
    } catch (e) {
      print("Error submitting punch data: $e");
      return false;
    }
  }
}
