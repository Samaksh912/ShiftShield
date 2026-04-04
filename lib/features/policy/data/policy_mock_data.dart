const Map<String, dynamic> mockCurrentPolicy = {
  'current_policy': {
    'week_start': '2024-03-30',
    'week_end': '2024-04-05',
    'status': 'active',
    'premium_paid': 52,
    'shifts_covered': 'Both (Lunch & Dinner)',
  }
};

const Map<String, dynamic> mockPolicyHistory = {
  'policies': [
    {
      'week_start': '2024-03-23',
      'week_end': '2024-03-29',
      'status': 'expired',
      'premium_paid': 33,
      'shifts_covered': 'Lunch Shift',
    },
    {
      'week_start': '2024-03-16',
      'week_end': '2024-03-22',
      'status': 'expired',
      'premium_paid': 52,
      'shifts_covered': 'Both Shifts',
    },
    {
      'week_start': '2024-03-09',
      'week_end': '2024-03-15',
      'status': 'expired',
      'premium_paid': 33,
      'shifts_covered': 'Dinner Shift',
    }
  ]
};
