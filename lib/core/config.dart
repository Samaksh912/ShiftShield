class AppConfig {
  // ⚠️  Physical device: set this to your machine's LAN IP (e.g. 192.168.1.x:3000)
  //     or an ngrok HTTPS URL (e.g. https://abc123.ngrok-free.app)
  // ⚠️  Android Emulator only: use http://10.0.2.2:3000
  static const String baseUrl = 'http://10.0.2.2:3000'; // ← change me for physical device

  // ─── DEV BYPASS ────────────────────────────────────────────────────────────
  // Set to true to skip the entire auth flow and land directly on the Dashboard
  // using the pre-seeded Rider "Asha" (rider_id: 11111111-1111-4111-8111-111111111111)
  // ⚠️  REMEMBER to set this back to false before a real demo or store build!
  static const bool devBypassAuth = true;

  // JWT for Rider Asha — generated with secret 'shiftshield-dev-secret'
  static const String devJwt =
      'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9'
      '.eyJyaWRlcl9pZCI6IjExMTExMTExLTExMTEtNDExMS04MTExLTExMTExMTExMTExMSIsInBob25lIjoiOTg3NjU0MzIxMCIsImlhdCI6MTc3NTE3OTIzNn0'
      '.1m6Xq5VeW8nI5eixEiJlCPLOK5mTWfo_N6B3W-1anv8';
}
