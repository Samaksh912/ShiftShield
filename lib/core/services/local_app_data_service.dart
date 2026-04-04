import 'dart:convert';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../config.dart';

class LocalServiceError implements Exception {
  final int statusCode;
  final String errorCode;
  final String message;
  final Map<String, dynamic> rawBody;

  LocalServiceError({
    required this.statusCode,
    required this.errorCode,
    required this.message,
    Map<String, dynamic>? rawBody,
  }) : rawBody = rawBody ?? const {};
}

class LocalAppDataService {
  static const FlutterSecureStorage _storage = FlutterSecureStorage();
  static const String _accountsKey = 'local_app_accounts_v1';
  static const String _signupVerificationKey = 'local_signup_verifications_v1';
  static const String _loginVerificationKey = 'local_login_verifications_v1';
  static const String _quotesKey = 'local_quotes_v1';

  static const List<Map<String, dynamic>> _cities = [
    {
      'id': 'bengaluru',
      'name': 'Bengaluru',
      'state': 'Karnataka',
      'city_tier': 'T1',
      'zones': [
        {
          'id': 'koramangala',
          'name': 'Koramangala',
          'city_id': 'bengaluru',
          'city_tier': 'T1',
          'risk_class': 'medium',
          'avg_lunch_earnings': 460,
          'avg_dinner_earnings': 690,
        },
        {
          'id': 'whitefield',
          'name': 'Whitefield',
          'city_id': 'bengaluru',
          'city_tier': 'T1',
          'risk_class': 'high',
          'avg_lunch_earnings': 440,
          'avg_dinner_earnings': 720,
        },
      ],
    },
    {
      'id': 'pune',
      'name': 'Pune',
      'state': 'Maharashtra',
      'city_tier': 'T1',
      'zones': [
        {
          'id': 'pune_hinjewadi',
          'name': 'Hinjewadi',
          'city_id': 'pune',
          'city_tier': 'T1',
          'risk_class': 'medium',
          'avg_lunch_earnings': 410,
          'avg_dinner_earnings': 650,
        },
      ],
    },
    {
      'id': 'bhubaneswar',
      'name': 'Bhubaneswar',
      'state': 'Odisha',
      'city_tier': 'T2',
      'zones': [
        {
          'id': 'bhubaneswar_patrapada',
          'name': 'Patrapada',
          'city_id': 'bhubaneswar',
          'city_tier': 'T2',
          'risk_class': 'low',
          'avg_lunch_earnings': 360,
          'avg_dinner_earnings': 540,
        },
      ],
    },
    {
      'id': 'lucknow',
      'name': 'Lucknow',
      'state': 'Uttar Pradesh',
      'city_tier': 'T2',
      'zones': [
        {
          'id': 'lucknow_gomti_nagar',
          'name': 'Gomti Nagar',
          'city_id': 'lucknow',
          'city_tier': 'T2',
          'risk_class': 'medium',
          'avg_lunch_earnings': 390,
          'avg_dinner_earnings': 610,
        },
      ],
    },
  ];

  static Map<String, dynamic> _seedAccount({
    required String riderId,
    required String name,
    required String phone,
    required String platform,
    required String cityId,
    required String zoneId,
    required String shiftsCovered,
    required String payoutPreference,
    required int activeDays,
    required int walletBalance,
    required int premiumPaid,
    required int totalPayoutThisWeek,
    required int lunchRemaining,
    required int dinnerRemaining,
    required List<Map<String, dynamic>> claims,
  }) {
    final city = _findCity(cityId);
    final zone = _findZone(zoneId);
    final currentPolicy = {
      'id': 'pol_${phone.substring(phone.length - 4)}_active',
      'week_start': '2026-04-06',
      'week_end': '2026-04-12',
      'status': 'active',
      'premium_paid': premiumPaid,
      'shifts_covered': shiftsCovered,
      'claims_this_week': claims.where((c) => c['status'] == 'paid').length,
      'total_payout_this_week': totalPayoutThisWeek,
      'shifts_remaining': {
        'lunch': lunchRemaining,
        'dinner': dinnerRemaining,
      },
    };

    return {
      'rider': {
        'id': riderId,
        'name': name,
        'phone': phone,
        'platform': platform,
        'city_id': cityId,
        'zone_id': zoneId,
        'zone_name': zone['name'],
        'shifts_covered': shiftsCovered,
        'payout_preference': payoutPreference,
        'active_days_last_30': activeDays,
        'upi_id': payoutPreference == 'upi' ? '${phone.substring(0, 6)}@oksbi' : '',
      },
      'city': city,
      'zone': zone,
      'wallet': {
        'balance': walletBalance,
      },
      'current_policy': currentPolicy,
      'policy_history': [
        currentPolicy,
        {
          'id': 'pol_${phone.substring(phone.length - 4)}_prev1',
          'week_start': '2026-03-30',
          'week_end': '2026-04-05',
          'status': 'expired',
          'premium_paid': premiumPaid - 6,
          'shifts_covered': shiftsCovered,
        },
      ],
      'claims': claims,
      'notifications': [
        {
          'id': 'notif_${phone.substring(phone.length - 4)}_1',
          'title': 'Coverage is active',
          'message': 'Your weekly payout protection is live for the current cycle.',
          'created_at': '2026-04-04T10:15:00Z',
          'read': false,
        },
      ],
    };
  }

  static final Map<String, Map<String, dynamic>> _seedAccounts = {
    '9876543210': _seedAccount(
      riderId: '11111111-1111-4111-8111-111111111111',
      name: 'Asha Rider',
      phone: '9876543210',
      platform: 'swiggy',
      cityId: 'bengaluru',
      zoneId: 'koramangala',
      shiftsCovered: 'both',
      payoutPreference: 'wallet',
      activeDays: 9,
      walletBalance: 2480,
      premiumPaid: 74,
      totalPayoutThisWeek: 350,
      lunchRemaining: 5,
      dinnerRemaining: 4,
      claims: [
        {
          'id': 'claim_asha_1',
          'claim_date': '2026-04-02T13:10:00Z',
          'shift_type': 'lunch',
          'trigger_type': 'rain',
          'trigger_detail': '62mm/hr',
          'severity_level': 'high',
          'payout_percentage': 100,
          'payout_amount': 350,
          'status': 'paid',
          'created_at': '2026-04-02T13:45:00Z',
          'condition_validation': 'Validated against local weather feed.',
        },
      ],
    ),
    '9123456780': _seedAccount(
      riderId: '22222222-2222-4222-8222-222222222222',
      name: 'Rohan Rider',
      phone: '9123456780',
      platform: 'zomato',
      cityId: 'bengaluru',
      zoneId: 'whitefield',
      shiftsCovered: 'dinner',
      payoutPreference: 'upi',
      activeDays: 11,
      walletBalance: 1860,
      premiumPaid: 82,
      totalPayoutThisWeek: 420,
      lunchRemaining: 0,
      dinnerRemaining: 5,
      claims: [
        {
          'id': 'claim_rohan_1',
          'claim_date': '2026-04-01T19:20:00Z',
          'shift_type': 'dinner',
          'trigger_type': 'aqi',
          'trigger_detail': 'AQI 342',
          'severity_level': 'moderate',
          'payout_percentage': 50,
          'payout_amount': 220,
          'status': 'paid',
          'created_at': '2026-04-01T19:50:00Z',
          'condition_validation': 'Validated against CPCB feed.',
        },
        {
          'id': 'claim_rohan_2',
          'claim_date': '2026-04-03T19:05:00Z',
          'shift_type': 'dinner',
          'trigger_type': 'heat',
          'trigger_detail': '41°C',
          'severity_level': 'high',
          'payout_percentage': 100,
          'payout_amount': 200,
          'status': 'paid',
          'created_at': '2026-04-03T19:30:00Z',
          'condition_validation': 'Validated against city forecast station.',
        },
      ],
    ),
    '9988776655': _seedAccount(
      riderId: '33333333-3333-4333-8333-333333333333',
      name: 'Meera Rider',
      phone: '9988776655',
      platform: 'swiggy',
      cityId: 'pune',
      zoneId: 'pune_hinjewadi',
      shiftsCovered: 'both',
      payoutPreference: 'wallet',
      activeDays: 8,
      walletBalance: 2145,
      premiumPaid: 68,
      totalPayoutThisWeek: 180,
      lunchRemaining: 4,
      dinnerRemaining: 3,
      claims: [
        {
          'id': 'claim_meera_1',
          'claim_date': '2026-03-31T12:30:00Z',
          'shift_type': 'lunch',
          'trigger_type': 'rain',
          'trigger_detail': '28mm/hr',
          'severity_level': 'low',
          'payout_percentage': 25,
          'payout_amount': 180,
          'status': 'paid',
          'created_at': '2026-03-31T13:05:00Z',
          'condition_validation': 'Validated against micro-zone rainfall data.',
        },
      ],
    ),
    '9345678123': _seedAccount(
      riderId: '44444444-4444-4444-8444-444444444444',
      name: 'Pooja Rider',
      phone: '9345678123',
      platform: 'zomato',
      cityId: 'bhubaneswar',
      zoneId: 'bhubaneswar_patrapada',
      shiftsCovered: 'lunch',
      payoutPreference: 'wallet',
      activeDays: 6,
      walletBalance: 1325,
      premiumPaid: 49,
      totalPayoutThisWeek: 0,
      lunchRemaining: 5,
      dinnerRemaining: 0,
      claims: [],
    ),
    '9451203344': _seedAccount(
      riderId: '55555555-5555-4555-8555-555555555555',
      name: 'Aditya Rider',
      phone: '9451203344',
      platform: 'swiggy',
      cityId: 'lucknow',
      zoneId: 'lucknow_gomti_nagar',
      shiftsCovered: 'both',
      payoutPreference: 'upi',
      activeDays: 10,
      walletBalance: 2010,
      premiumPaid: 58,
      totalPayoutThisWeek: 260,
      lunchRemaining: 4,
      dinnerRemaining: 4,
      claims: [
        {
          'id': 'claim_aditya_1',
          'claim_date': '2026-04-02T20:00:00Z',
          'shift_type': 'dinner',
          'trigger_type': 'rain',
          'trigger_detail': '48mm/hr',
          'severity_level': 'moderate',
          'payout_percentage': 50,
          'payout_amount': 260,
          'status': 'paid',
          'created_at': '2026-04-02T20:40:00Z',
          'condition_validation': 'Validated against local rainfall station.',
        },
      ],
    ),
  };

  static Future<void> _ensureInitialized() async {
    final existing = await _storage.read(key: _accountsKey);
    if (existing != null && existing.isNotEmpty) {
      return;
    }

    final seeded = <String, dynamic>{};
    for (final entry in _seedAccounts.entries) {
      seeded[entry.key] = _deepCopy(entry.value);
    }

    await _storage.write(key: _accountsKey, value: jsonEncode(seeded));
    await _storage.write(key: _signupVerificationKey, value: jsonEncode(<String, dynamic>{}));
    await _storage.write(key: _loginVerificationKey, value: jsonEncode(<String, dynamic>{}));
    await _storage.write(key: _quotesKey, value: jsonEncode(<String, dynamic>{}));
  }

  static Future<Map<String, dynamic>> _readJsonMap(String key) async {
    final raw = await _storage.read(key: key);
    if (raw == null || raw.isEmpty) {
      return <String, dynamic>{};
    }
    final decoded = jsonDecode(raw);
    if (decoded is Map<String, dynamic>) {
      return decoded;
    }
    return Map<String, dynamic>.from(decoded as Map);
  }

  static Future<void> _writeJsonMap(String key, Map<String, dynamic> value) async {
    await _storage.write(key: key, value: jsonEncode(value));
  }

  static Map<String, dynamic> _deepCopy(Map<String, dynamic> value) {
    return Map<String, dynamic>.from(jsonDecode(jsonEncode(value)) as Map);
  }

  static Map<String, dynamic> _findCity(String cityId) {
    return _deepCopy(
      _cities.firstWhere(
        (city) => city['id'] == cityId,
        orElse: () => _cities.first,
      ),
    );
  }

  static Map<String, dynamic> _findZone(String zoneId) {
    for (final city in _cities) {
      final zones = (city['zones'] as List<dynamic>);
      for (final zone in zones) {
        final zoneMap = Map<String, dynamic>.from(zone as Map);
        if (zoneMap['id'] == zoneId) {
          return zoneMap;
        }
      }
    }
    return Map<String, dynamic>.from((_cities.first['zones'] as List).first as Map);
  }

  static Future<Map<String, dynamic>> _loadAccounts() async {
    await _ensureInitialized();
    return _readJsonMap(_accountsKey);
  }

  static Future<void> _saveAccounts(Map<String, dynamic> accounts) async {
    await _writeJsonMap(_accountsKey, accounts);
  }

  static Future<Map<String, dynamic>> _getAccountByPhone(String phone) async {
    final accounts = await _loadAccounts();
    final account = accounts[phone];
    if (account is! Map) {
      throw LocalServiceError(
        statusCode: 404,
        errorCode: 'rider_not_found',
        message: 'No rider profile found for this mobile number.',
      );
    }
    return Map<String, dynamic>.from(jsonDecode(jsonEncode(account)) as Map);
  }

  static Future<Map<String, dynamic>> sendSignupOtp(String phone) async {
    if (!AppConfig.isDemoSignupPhone(phone)) {
      throw LocalServiceError(
        statusCode: 400,
        errorCode: 'verification_unavailable',
        message: 'We could not start verification for this mobile number right now.',
      );
    }
    return {
      'otp_sent': true,
      'auth_type': 'phone_verification',
      'message': 'OTP sent successfully',
      'phone': '+91$phone',
    };
  }

  static Future<Map<String, dynamic>> verifySignupOtp(String phone, String otp) async {
    final expectedOtp = AppConfig.demoSignupOtpFor(phone);
    if (expectedOtp == null || otp != expectedOtp) {
      throw LocalServiceError(
        statusCode: 401,
        errorCode: 'invalid_otp',
        message: 'The verification code you entered is invalid.',
      );
    }

    final token = 'signup_${phone}_${DateTime.now().millisecondsSinceEpoch}';
    final verifications = await _readJsonMap(_signupVerificationKey);
    verifications[phone] = token;
    await _writeJsonMap(_signupVerificationKey, verifications);

    return {
      'verified': true,
      'phone': '+91$phone',
      'verification_token': token,
      'expires_in': 600,
    };
  }

  static Future<Map<String, dynamic>> signup(Map<String, dynamic> body) async {
    final phone = body['phone'] as String? ?? '';
    final verificationToken = body['verification_token'] as String? ?? '';
    final verifications = await _readJsonMap(_signupVerificationKey);
    if (verifications[phone] != verificationToken) {
      throw LocalServiceError(
        statusCode: 401,
        errorCode: 'invalid_verification',
        message: 'The verification session has expired. Please request a new OTP.',
      );
    }

    final accounts = await _loadAccounts();
    if (accounts.containsKey(phone)) {
      throw LocalServiceError(
        statusCode: 409,
        errorCode: 'rider_exists',
        message: 'An account already exists for this mobile number.',
      );
    }

    final cityId = body['city_id'] as String? ?? '';
    final zoneId = body['zone_id'] as String? ?? '';
    final city = _findCity(cityId);
    final zone = _findZone(zoneId);
    final riderId = 'rid_${phone}_${DateTime.now().millisecondsSinceEpoch}';
    final rider = {
      'id': riderId,
      'name': body['name'] as String? ?? 'Rider',
      'phone': phone,
      'platform': body['platform'] as String? ?? 'swiggy',
      'city_id': cityId,
      'zone_id': zoneId,
      'zone_name': zone['name'],
      'shifts_covered': body['shifts_covered'] as String? ?? 'both',
      'payout_preference': body['payout_preference'] as String? ?? 'wallet',
      'active_days_last_30': 8,
      'upi_id': body['upi_id'] as String? ?? '',
    };

    final account = {
      'rider': rider,
      'city': city,
      'zone': zone,
      'wallet': {
        'balance': 1650,
      },
      'current_policy': null,
      'policy_history': <dynamic>[],
      'claims': <dynamic>[],
      'notifications': [
        {
          'id': 'notif_signup_${phone.substring(phone.length - 4)}',
          'title': 'Account setup complete',
          'message': 'Your rider profile is ready. Generate a quote to activate weekly coverage.',
          'created_at': DateTime.now().toIso8601String(),
          'read': false,
        },
      ],
    };

    accounts[phone] = account;
    verifications.remove(phone);
    await _saveAccounts(accounts);
    await _writeJsonMap(_signupVerificationKey, verifications);

    return {
      'token': 'session_${phone}_${DateTime.now().millisecondsSinceEpoch}',
      'rider': rider,
      'session': {
        'auth_type': 'session',
        'expires_in': 604800,
      },
    };
  }

  static Future<Map<String, dynamic>> sendLoginOtp(String phone) async {
    await _getAccountByPhone(phone);
    return {
      'otp_sent': true,
      'auth_type': 'phone_login',
      'message': 'OTP sent successfully',
      'phone': '+91$phone',
    };
  }

  static Future<Map<String, dynamic>> verifyLoginOtp(String phone, String otp) async {
    await _getAccountByPhone(phone);
    final expectedOtp = AppConfig.demoLoginOtpFor(phone) ?? AppConfig.demoSignupOtpFor(phone);
    if (expectedOtp == null || otp != expectedOtp) {
      throw LocalServiceError(
        statusCode: 401,
        errorCode: 'invalid_otp',
        message: 'The verification code you entered is invalid.',
      );
    }

    final token = 'login_${phone}_${DateTime.now().millisecondsSinceEpoch}';
    final verifications = await _readJsonMap(_loginVerificationKey);
    verifications[phone] = token;
    await _writeJsonMap(_loginVerificationKey, verifications);

    return {
      'verified': true,
      'phone': '+91$phone',
      'verification_token': token,
      'expires_in': 600,
    };
  }

  static Future<Map<String, dynamic>> login(String phone, String verificationToken) async {
    final verifications = await _readJsonMap(_loginVerificationKey);
    if (verifications[phone] != verificationToken) {
      throw LocalServiceError(
        statusCode: 401,
        errorCode: 'invalid_verification',
        message: 'Your verification session expired. Please request a new OTP.',
      );
    }

    final account = await _getAccountByPhone(phone);
    verifications.remove(phone);
    await _writeJsonMap(_loginVerificationKey, verifications);

    return {
      'token': 'session_${phone}_${DateTime.now().millisecondsSinceEpoch}',
      'rider': account['rider'],
      'session': {
        'auth_type': 'session',
        'expires_in': 604800,
      },
    };
  }

  static Future<Map<String, dynamic>> getMe(String? phone) async {
    if (phone == null || phone.isEmpty) {
      throw LocalServiceError(
        statusCode: 401,
        errorCode: 'unauthorized',
        message: 'No active session found.',
      );
    }

    final account = await _getAccountByPhone(phone);
    return {
      'rider': account['rider'],
      'city': account['city'],
      'zone': account['zone'],
    };
  }

  static Future<Map<String, dynamic>> getCities() async {
    return {'cities': jsonDecode(jsonEncode(_cities))};
  }

  static Future<Map<String, dynamic>> generateQuote(String? phone, String weekStart) async {
    if (phone == null || phone.isEmpty) {
      throw LocalServiceError(
        statusCode: 401,
        errorCode: 'unauthorized',
        message: 'No active session found.',
      );
    }

    final account = await _getAccountByPhone(phone);
    final rider = Map<String, dynamic>.from(account['rider'] as Map);
    final zone = Map<String, dynamic>.from(account['zone'] as Map);
    final riskClass = zone['risk_class'] as String? ?? 'medium';
    final payoutPreference = rider['payout_preference'] as String? ?? 'wallet';

    final premium = riskClass == 'high'
        ? 92
        : riskClass == 'low'
            ? 54
            : 68;
    final lunchMax = riskClass == 'high' ? 520 : 420;
    final dinnerMax = riskClass == 'high' ? 760 : 620;
    final quoteId = 'quote_${phone}_${DateTime.now().millisecondsSinceEpoch}';
    final purchaseDeadline = DateTime.now().add(const Duration(hours: 20)).toIso8601String();

    final quote = {
      'id': quoteId,
      'week_start': weekStart,
      'week_end': _weekEnd(weekStart),
      'premium': premium,
      'risk_band': riskClass,
      'can_purchase': true,
      'purchase_deadline': purchaseDeadline,
      'coverage_breakdown': {
        'lunch': rider['shifts_covered'] == 'dinner' ? false : true,
        'dinner': rider['shifts_covered'] == 'lunch' ? false : true,
      },
      'lunch_shift_max_payout': lunchMax,
      'dinner_shift_max_payout': dinnerMax,
      'explanation': {
        'summary': 'Your weekly premium is calibrated to recent operating conditions in ${zone['name']}.',
        'top_factors': [
          {
            'factor': 'Zone risk profile',
            'contribution_pct': 45,
            'detail': 'Risk class is ${riskClass.toUpperCase()} for ${zone['name']}.',
          },
          {
            'factor': 'Shift coverage',
            'contribution_pct': 30,
            'detail': 'Coverage is set to ${rider['shifts_covered']}.',
          },
          {
            'factor': 'Payout mode',
            'contribution_pct': 25,
            'detail': 'Preferred payout mode is ${payoutPreference.toUpperCase()}.',
          },
        ],
      },
    };

    final quotes = await _readJsonMap(_quotesKey);
    quotes[quoteId] = {
      'phone': phone,
      'quote': quote,
    };
    await _writeJsonMap(_quotesKey, quotes);

    return {'quote': quote};
  }

  static Future<Map<String, dynamic>> createPolicy(
    String? phone,
    String quoteId,
    String paymentMethod,
  ) async {
    if (phone == null || phone.isEmpty) {
      throw LocalServiceError(
        statusCode: 401,
        errorCode: 'unauthorized',
        message: 'No active session found.',
      );
    }

    final accounts = await _loadAccounts();
    final account = Map<String, dynamic>.from(accounts[phone] as Map);
    final quotes = await _readJsonMap(_quotesKey);
    final quoteRecord = quotes[quoteId];
    if (quoteRecord is! Map) {
      throw LocalServiceError(
        statusCode: 404,
        errorCode: 'quote_not_found',
        message: 'The selected quote is no longer available.',
      );
    }

    final quote = Map<String, dynamic>.from((quoteRecord['quote'] as Map));
    final policy = {
      'id': 'pol_${phone}_${DateTime.now().millisecondsSinceEpoch}',
      'week_start': quote['week_start'],
      'week_end': quote['week_end'],
      'status': 'active',
      'premium_paid': quote['premium'],
      'shifts_covered': account['rider']['shifts_covered'],
      'claims_this_week': 0,
      'total_payout_this_week': 0,
      'shifts_remaining': {
        'lunch': account['rider']['shifts_covered'] == 'dinner' ? 0 : 6,
        'dinner': account['rider']['shifts_covered'] == 'lunch' ? 0 : 6,
      },
    };

    if (paymentMethod == 'wallet') {
      final wallet = Map<String, dynamic>.from(account['wallet'] as Map);
      final currentBalance = wallet['balance'] as int? ?? 0;
      final requiredPremium = quote['premium'] as int? ?? 0;
      if (currentBalance < requiredPremium) {
        throw LocalServiceError(
          statusCode: 400,
          errorCode: 'insufficient_balance',
          message: 'Wallet balance is too low to purchase this policy.',
        );
      }
      wallet['balance'] = currentBalance - requiredPremium;
      account['wallet'] = wallet;
    }

    final history = List<dynamic>.from(account['policy_history'] as List? ?? const []);
    final currentPolicy = account['current_policy'];
    if (currentPolicy != null) {
      history.insert(0, currentPolicy);
    }
    account['current_policy'] = policy;
    account['policy_history'] = history;

    final notifications = List<dynamic>.from(account['notifications'] as List? ?? const []);
    notifications.insert(0, {
      'id': 'notif_policy_${DateTime.now().millisecondsSinceEpoch}',
      'title': 'Coverage activated',
      'message': 'Your weekly protection is now active from ${quote['week_start']} to ${quote['week_end']}.',
      'created_at': DateTime.now().toIso8601String(),
      'read': false,
    });
    account['notifications'] = notifications;

    accounts[phone] = account;
    quotes.remove(quoteId);
    await _saveAccounts(accounts);
    await _writeJsonMap(_quotesKey, quotes);

    return {
      'policy': policy,
      'message': 'Policy created successfully',
    };
  }

  static Future<Map<String, dynamic>> getCurrentPolicy(String? phone) async {
    final account = await _getAccountByPhone(phone ?? '');
    return {
      'current_policy': account['current_policy'],
    };
  }

  static Future<Map<String, dynamic>> getPolicyHistory(String? phone) async {
    final account = await _getAccountByPhone(phone ?? '');
    return {
      'policies': account['policy_history'] ?? <dynamic>[],
    };
  }

  static Future<Map<String, dynamic>> getPolicyById(String? phone, String policyId) async {
    final account = await _getAccountByPhone(phone ?? '');
    final currentPolicy = account['current_policy'];
    if (currentPolicy is Map && currentPolicy['id'] == policyId) {
      return {'policy': currentPolicy};
    }
    final history = List<dynamic>.from(account['policy_history'] as List? ?? const []);
    for (final item in history) {
      final policy = Map<String, dynamic>.from(item as Map);
      if (policy['id'] == policyId) {
        return {'policy': policy};
      }
    }
    throw LocalServiceError(
      statusCode: 404,
      errorCode: 'policy_not_found',
      message: 'Policy not found.',
    );
  }

  static Future<Map<String, dynamic>> getDashboard(String? phone) async {
    final account = await _getAccountByPhone(phone ?? '');
    final rider = Map<String, dynamic>.from(account['rider'] as Map);
    final zone = Map<String, dynamic>.from(account['zone'] as Map);
    final claims = List<dynamic>.from(account['claims'] as List? ?? const []);
    final currentPolicy = account['current_policy'];

    return {
      'rider': rider,
      'wallet': account['wallet'],
      'current_policy': currentPolicy,
      'zone_weather': {
        'current_temp': zone['city_tier'] == 'T1' ? 33 : 31,
        'current_aqi': zone['risk_class'] == 'high' ? 196 : 88,
        'current_rain_mm': zone['risk_class'] == 'low' ? 4.5 : 16.0,
        'status': currentPolicy == null ? 'quote_ready' : 'covered',
        'last_updated': DateTime.now().toIso8601String(),
      },
      'recent_claims': claims.take(2).toList(),
      'next_week_quote_available': true,
    };
  }

  static Future<Map<String, dynamic>> getWallet(String? phone) async {
    final account = await _getAccountByPhone(phone ?? '');
    return {
      'wallet': account['wallet'],
    };
  }

  static Future<Map<String, dynamic>> topUp(String? phone, int amount) async {
    final accounts = await _loadAccounts();
    final account = Map<String, dynamic>.from(accounts[phone] as Map);
    final wallet = Map<String, dynamic>.from(account['wallet'] as Map);
    wallet['balance'] = (wallet['balance'] as int? ?? 0) + amount;
    account['wallet'] = wallet;
    accounts[phone!] = account;
    await _saveAccounts(accounts);
    return {'wallet': wallet};
  }

  static Future<Map<String, dynamic>> withdraw(String? phone, int amount) async {
    final accounts = await _loadAccounts();
    final account = Map<String, dynamic>.from(accounts[phone] as Map);
    final wallet = Map<String, dynamic>.from(account['wallet'] as Map);
    final currentBalance = wallet['balance'] as int? ?? 0;
    if (currentBalance < amount) {
      throw LocalServiceError(
        statusCode: 400,
        errorCode: 'insufficient_balance',
        message: 'Wallet balance is too low for this withdrawal.',
      );
    }
    wallet['balance'] = currentBalance - amount;
    account['wallet'] = wallet;
    accounts[phone!] = account;
    await _saveAccounts(accounts);
    return {'wallet': wallet};
  }

  static Future<Map<String, dynamic>> getClaims(String? phone) async {
    final account = await _getAccountByPhone(phone ?? '');
    final claims = List<dynamic>.from(account['claims'] as List? ?? const []);
    final premiumsPaid = (account['policy_history'] as List? ?? const [])
            .fold<int>(0, (sum, item) => sum + ((item as Map)['premium_paid'] as int? ?? 0)) +
        ((account['current_policy'] as Map?)?['premium_paid'] as int? ?? 0);
    final totalPayout = claims.fold<int>(
      0,
      (sum, item) => sum + ((item as Map)['payout_amount'] as int? ?? 0),
    );

    return {
      'summary': {
        'total_claims': claims.length,
        'total_payout': totalPayout,
        'total_premiums_paid': premiumsPaid,
        'net_benefit': totalPayout - premiumsPaid,
      },
      'claims': claims,
    };
  }

  static Future<Map<String, dynamic>> getNotifications(String? phone) async {
    final account = await _getAccountByPhone(phone ?? '');
    return {
      'notifications': account['notifications'] ?? <dynamic>[],
    };
  }

  static String _weekEnd(String weekStart) {
    final start = DateTime.parse(weekStart);
    final end = start.add(const Duration(days: 6));
    return '${end.year.toString().padLeft(4, '0')}-${end.month.toString().padLeft(2, '0')}-${end.day.toString().padLeft(2, '0')}';
  }
}
