class AppUrls {
  static const String baseUrl = "http://10.0.2.2:5173/fitboxing";

  // Authentication endpoints
  static const String login = "$baseUrl/auth/login";
  static const String register = "$baseUrl/auth/register";
  
  // Session endpoints
  static const String getSessions = "$baseUrl/sessions";
  static const String bookSession = "$baseUrl/sessions/book";
  
  // Results endpoints
  static const String getResults = "$baseUrl/results/session/";

  // User endpoints
  static const String getUserProfile = "$baseUrl/users/profile";
  static const String updateProfile = "$baseUrl/users/updateProfile";
  static const String updateProfileImage = "$baseUrl/users/upload-profile-image"; // New API for image upload

}
