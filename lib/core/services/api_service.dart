import 'dart:convert';
import 'package:http/http.dart' as http;
import '../config.dart';
import 'auth_service.dart';

/// A centralized API client that:
/// - Attaches JWT to every authenticated request
/// - Parses standard error shapes { "error": "code", "message": "..." }
/// - Throws [ApiException] on non-2xx responses
class ApiService {
  static final String _base = AppConfig.baseUrl;

  // ─────────────────────────────────────────────
  // INTERNAL HELPERS
  // ─────────────────────────────────────────────

  static Future<Map<String, String>> _authHeaders() async {
    final token = AppConfig.devBypassAuth
        ? AppConfig.devJwt
        : await AuthService.getToken();

    print('>>> devBypassAuth: ${AppConfig.devBypassAuth}');
    print('>>> token: $token');

    return {
      'Content-Type': 'application/json',
      if (token != null) 'Authorization': 'Bearer $token',
    };
  }

  static Map<String, dynamic> _handleResponse(http.Response response) {
    final body = jsonDecode(response.body) as Map<String, dynamic>;
    if (response.statusCode >= 200 && response.statusCode < 300) {
      return body;
    }
    throw ApiException(
      statusCode: response.statusCode,
      errorCode: body['error'] as String? ?? 'unknown_error',
      message: body['message'] as String? ?? 'Something went wrong.',
      rawBody: body,
    );
  }

  static Future<Map<String, dynamic>> _get(String path) async {
    final headers = await _authHeaders();
    final response = await http.get(Uri.parse('$_base$path'), headers: headers);
    return _handleResponse(response);
  }

  static Future<Map<String, dynamic>> _post(
    String path,
    Map<String, dynamic> body,
  ) async {
    final headers = await _authHeaders();
    final response = await http.post(
      Uri.parse('$_base$path'),
      headers: headers,
      body: jsonEncode(body),
    );
    return _handleResponse(response);
  }

  static Future<Map<String, dynamic>> _put(
    String path,
    Map<String, dynamic> body,
  ) async {
    final headers = await _authHeaders();
    final response = await http.put(
      Uri.parse('$_base$path'),
      headers: headers,
      body: jsonEncode(body),
    );
    return _handleResponse(response);
  }

  // ─────────────────────────────────────────────
  // AUTH
  // ─────────────────────────────────────────────

  /// POST /api/auth/send-otp
  static Future<Map<String, dynamic>> sendOtp(String phone) {
    return _post('/api/auth/send-otp', {'phone': phone});
  }

  /// POST /api/auth/verify-otp
  /// Returns { token, is_new_user, rider }
  static Future<Map<String, dynamic>> verifyOtp(String phone, String otp) {
    return _post('/api/auth/verify-otp', {'phone': phone, 'otp': otp});
  }

  // ─────────────────────────────────────────────
  // ZONES
  // ─────────────────────────────────────────────

  /// GET /api/zones
  static Future<List<dynamic>> getZones() async {
    final data = await _get('/api/zones');
    return data['zones'] as List<dynamic>;
  }

  // ─────────────────────────────────────────────
  // MOCK PLATFORM
  // ─────────────────────────────────────────────

  /// GET /api/mock-platform/rider/:phone
  static Future<Map<String, dynamic>> getMockPlatformRider(String phone) {
    return _get('/api/mock-platform/rider/$phone');
  }

  // ─────────────────────────────────────────────
  // RIDER PROFILE
  // ─────────────────────────────────────────────

  /// POST /api/riders/profile
  static Future<Map<String, dynamic>> createProfile(Map<String, dynamic> body) {
    return _post('/api/riders/profile', body);
  }

  /// GET /api/riders/me
  static Future<Map<String, dynamic>> getMe() {
    return _get('/api/riders/me');
  }

  /// PUT /api/riders/me
  static Future<Map<String, dynamic>> updateMe(Map<String, dynamic> body) {
    return _put('/api/riders/me', body);
  }

  // ─────────────────────────────────────────────
  // QUOTES
  // ─────────────────────────────────────────────

  /// POST /api/quotes/generate
  static Future<Map<String, dynamic>> generateQuote(String weekStart) {
    return _post('/api/quotes/generate', {'week_start': weekStart});
  }

  // ─────────────────────────────────────────────
  // POLICIES
  // ─────────────────────────────────────────────
  /// POST /api/policies/create
  static Future<Map<String, dynamic>> createPolicy(
    String quoteId,
    String paymentMethod, {
    String? paymentReferenceId,
    String? paymentStatus,
  }) {
    return _post('/api/policies/create', {
      'quote_id': quoteId,
      'payment_method': paymentMethod,
      if (paymentReferenceId != null)
        'payment_reference_id': paymentReferenceId,
      if (paymentStatus != null) 'payment_status': paymentStatus,
    });
  }

  /// GET /api/policies/current
  static Future<Map<String, dynamic>> getCurrentPolicy() {
    return _get('/api/policies/current');
  }

  /// GET /api/policies/history
  static Future<Map<String, dynamic>> getPolicyHistory({
    int limit = 20,
    int offset = 0,
  }) {
    return _get('/api/policies/history?limit=$limit&offset=$offset');
  }

  // ─────────────────────────────────────────────
  // DASHBOARD
  // ─────────────────────────────────────────────

  /// GET /api/dashboard
  static Future<Map<String, dynamic>> getDashboard() {
    return _get('/api/dashboard');
  }

  // ─────────────────────────────────────────────
  // WALLET
  // ─────────────────────────────────────────────

  /// GET /api/wallet
  static Future<Map<String, dynamic>> getWallet() {
    return _get('/api/wallet');
  }

  /// POST /api/wallet/topup
  static Future<Map<String, dynamic>> topUp(int amount) {
    return _post('/api/wallet/topup', {'amount': amount});
  }

  /// POST /api/wallet/withdraw
  static Future<Map<String, dynamic>> withdraw(int amount) {
    return _post('/api/wallet/withdraw', {'amount': amount});
  }

  // ─────────────────────────────────────────────
  // CLAIMS
  // ─────────────────────────────────────────────

  /// GET /api/claims
  static Future<Map<String, dynamic>> getClaims() {
    return _get('/api/claims');
  }

  /// GET /api/notifications
  static Future<Map<String, dynamic>> getNotifications() {
    return _get('/api/notifications');
  }
}

// ─────────────────────────────────────────────
// EXCEPTION TYPE
// ─────────────────────────────────────────────

class ApiException implements Exception {
  final int statusCode;
  final String errorCode;
  final String message;
  final Map<String, dynamic> rawBody;

  ApiException({
    required this.statusCode,
    required this.errorCode,
    required this.message,
    required this.rawBody,
  });

  @override
  String toString() => 'ApiException($statusCode, $errorCode): $message';
}
