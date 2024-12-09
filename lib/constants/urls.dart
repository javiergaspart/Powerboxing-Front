class AppUrls {
  static const String baseUrl = "http://10.0.2.2:5000/fitboxing";
  
  // Authentication endpoints
  static const String login = "$baseUrl/auth/login";
  static const String register = "$baseUrl/auth/register";
  
  // Session endpoints
  static const String getSessions = "$baseUrl/sessions";
  static const String bookSession = "$baseUrl/sessions/book";
  
  // Results endpoints
  static const String getResults = "$baseUrl/results";
  
  // User endpoints
  static const String getUserProfile = "$baseUrl/user/profile";
  static const String updateUserProfile = "$baseUrl/user/update";
}
