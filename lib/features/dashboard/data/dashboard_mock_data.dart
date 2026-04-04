const Map<String, dynamic> dummyDashboard = {
  'rider': {'name': 'Samaksh Goel', 'zone_name': 'Bengaluru South', 'platform': 'swiggy'},
  'wallet': {'balance': 9999},
  'current_policy': {
    'week_start': '2024-01-01',
    'week_end': '2024-01-07',
    'status': 'active',
    'premium_paid': 99,
    'claims_this_week': 2,
    'total_payout_this_week': 350,
    'shifts_remaining': {
      'lunch': 5,
      'dinner': 4,
    }
  },
  'zone_weather': {
    'current_temp': 32,
    'current_aqi': 85,
    'current_rain_mm': 12.5,
    'status': 'normal',
    'last_updated': '',
  },
  'recent_claims': <dynamic>[
    {
      'shift_type': 'lunch',
      'trigger_type': 'rain',
      'payout_amount': 150,
      'status': 'paid',
      'created_at': '2024-01-02'
    },
    {
      'shift_type': 'dinner',
      'trigger_type': 'aqi',
      'payout_amount': 200,
      'status': 'paid',
      'created_at': '2024-01-03'
    }
  ],
  'next_week_quote_available': true,
};
