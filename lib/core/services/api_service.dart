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
    final token = await AuthService.getToken();
    return {
      'Content-Type': 'application/json',
      if (token != null) 'Authorization': 'Bearer $token',
    };
  }

  static Map<String, dynamic> _handleResponse(http.Response response) {
    final contentType = response.headers['content-type'] ?? '';
    if (!contentType.contains('application/json')) {
      throw ApiException(
        statusCode: response.statusCode,
        errorCode: 'unexpected_response',
        message: response.statusCode == 404
            ? 'Endpoint not found. Check backend URL and route path.'
            : 'Server returned a non-JSON response.',
        rawBody: {
          'body': response.body,
          'content_type': contentType,
        },
      );
    }

    final decoded = jsonDecode(response.body);
    if (decoded is! Map<String, dynamic>) {
      throw ApiException(
        statusCode: response.statusCode,
        errorCode: 'unexpected_response',
        message: 'Server returned an unexpected response shape.',
        rawBody: {'body': response.body},
      );
    }

    final body = decoded;
    if (response.statusCode >= 200 && response.statusCode < 300) {
      return body;
    }
    throw ApiException(
      statusCode: response.statusCode,
      errorCode: body['error'] as String? ?? body['code'] as String? ?? 'unknown_error',
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
  // AUTH — SIGNUP FLOW
  // ─────────────────────────────────────────────

  /// POST /api/auth/request-otp  (signup OTP)
  static Future<Map<String, dynamic>> sendSignupOtp(String phone) {
    return _post('/api/auth/request-otp', {'phone': phone});
  }

  /// POST /api/auth/verify-otp  (signup OTP verification)
  /// Returns { verified, verification_token, ... }
  static Future<Map<String, dynamic>> verifySignupOtp(String phone, String otp) {
    return _post('/api/auth/verify-otp', {'phone': phone, 'otp': otp});
  }

  /// POST /api/auth/signup  (complete signup with profile)
  static Future<Map<String, dynamic>> signup(Map<String, dynamic> body) {
    return _post('/api/auth/signup', body);
  }

  // ─────────────────────────────────────────────
  // AUTH — LOGIN FLOW
  // ─────────────────────────────────────────────

  /// POST /api/auth/request-login-otp
  static Future<Map<String, dynamic>> sendLoginOtp(String phone) {
    return _post('/api/auth/request-login-otp', {'phone': phone});
  }

  /// POST /api/auth/verify-login-otp
  /// Returns { verified, verification_token, ... }
  static Future<Map<String, dynamic>> verifyLoginOtp(String phone, String otp) {
    return _post('/api/auth/verify-login-otp', {'phone': phone, 'otp': otp});
  }

  /// POST /api/auth/login
  static Future<Map<String, dynamic>> login(
    String phone,
    String verificationToken,
  ) {
    return _post('/api/auth/login', {
      'phone': phone,
      'verification_token': verificationToken,
    });
  }

  // ─────────────────────────────────────────────
  // AUTH — SESSION
  // ─────────────────────────────────────────────

  /// GET /api/auth/me
  static Future<Map<String, dynamic>> getMe() {
    return _get('/api/auth/me');
  }

  // Note: PUT /api/auth/me is not supported by the backend.
  // Profile edits are session-local only.

  // ─────────────────────────────────────────────
  // CITIES & ZONES
  // ─────────────────────────────────────────────

  /// GET /api/cities
  /// Returns { cities: [ { id, name, zones: [...] }, ... ] }
  static Future<Map<String, dynamic>> getCities() {
    return _get('/api/cities');
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

  /// GET /api/policies/:id
  static Future<Map<String, dynamic>> getPolicyById(String policyId) {
    return _get('/api/policies/$policyId');
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

  // ─────────────────────────────────────────────
  // NOTIFICATIONS
  // ─────────────────────────────────────────────

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
