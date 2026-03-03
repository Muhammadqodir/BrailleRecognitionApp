class ApiConstants {
  // Base URL - Update this with your actual API URL
  static const String baseUrl = 'https://braillerecognition.alfocus.uz/api';

  // Auth endpoints
  static const String register = '/auth/register';
  static const String login = '/auth/login';
  static const String googleSignIn = '/auth/google';
  static const String appleSignIn = '/auth/apple';
  static const String me = '/auth/me';
  static const String logout = '/auth/logout';

  // Language endpoints
  static const String languages = '/languages';

  // Headers
  static const String authorizationHeader = 'Authorization';
  static const String contentTypeHeader = 'Content-Type';
  static const String acceptHeader = 'Accept';

  // Values
  static const String applicationJson = 'application/json';
  static const String bearerPrefix = 'Bearer ';

  // Timeout
  static const Duration connectionTimeout = Duration(seconds: 30);
  static const Duration receiveTimeout = Duration(seconds: 30);
}
