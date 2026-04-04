class AppConfig {
  static const String baseUrl = 'http://192.168.1.47:3000';
  static const bool devBypassAuth = true;
  static const String devJwt =
      'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9'
      '.eyJyaWRlcl9pZCI6IjExMTExMTExLTExMTEtNDExMS04MTExLTExMTExMTExMTExMSIsImlhdCI6MTc3NTIzODgwNywiZXhwIjoxNzc3ODMwODA3fQ'
      '.jZLQHWevIZRIl-cRgOhBkfeDgjNAkuVPu2da9smJvlU';

  // Demo credentials: phone → OTP
  static const Map<String, String> demoOtps = {
    '9876543210': '9324',
    '9123456780': '2841',
    '9988776655': '6157',
    '9345678123': '4408',
    '9451203344': '7712',
  };

  static bool isDemoPhone(String phone) => demoOtps.containsKey(phone);
  static String? demoOtpFor(String phone) => demoOtps[phone];
}
