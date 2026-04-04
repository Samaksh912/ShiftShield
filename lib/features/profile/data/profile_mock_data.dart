const Map<String, dynamic> mockProfileData = {
  'rider': {
    'id': 'rid_12345',
    'name': 'Rahul Sharma',
    'phone': '+91 98765 43210',
    'platform': 'Zomato',
    'zone_id': 'zone_blr_01',
    'zone_name': 'Koramangala',
    'baselines': {
      'lunch': 450,
      'dinner': 550,
    },
    'preferences': {
      'shift_preference': 'both',
      'payout_preference': 'wallet',
      'upi_id': '',
    }
  }
};

const Map<String, dynamic> mockZonesList = {
  'zones': [
    {'id': 'zone_blr_01', 'name': 'Koramangala'},
    {'id': 'zone_blr_02', 'name': 'Indiranagar'},
    {'id': 'zone_blr_03', 'name': 'HSR Layout'},
    {'id': 'zone_blr_04', 'name': 'Whitefield'},
  ]
};
