class ApiConfig {
  // Base URL for your backend API
  static const String baseUrl = 'http://10.0.2.2:8080/fitboxing';

  // Authentication Endpoints
  static const String loginEndpoint = '$baseUrl/auth/login';
  static const String signupEndpoint = '$baseUrl/auth/register';
  static const String resetPasswordEndpoint = '$baseUrl/auth/forgot-password';

  // User-related Endpoints
  static const String getUserEndpoint = '$baseUrl/users/me';

  // Session Endpoints
  static const String createSessionEndpoint = '$baseUrl/sessions/create';
  static const String getSessionsEndpoint = '$baseUrl/sessions';
  static const String getSessionByIdEndpoint = '$baseUrl/sessions/';

  // Reservation Endpoints
  static const String createReservationEndpoint = '$baseUrl/reservations/create';
  static const String getReservationsEndpoint = '$baseUrl/reservations';
  
  // Results Endpoints
  static const String getResultsEndpoint = '$baseUrl/results';

  // Punching Bag Endpoints
  static const String getPunchingBagsEndpoint = '$baseUrl/punching-bags';
}
