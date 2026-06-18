class MockData {
  // Agent
  static const String agentName = 'James Banda';
  static const String agentPhone = '+265 991 234 567';
  static const String agentProvider = 'Airtel Money';
  static const int agentRate = 1700;
  static const double agentReputation = 4.8;
  static const int agentSwapCount = 247;
  static const bool agentAvailable = true;
  static const String agentPublicKey =
      'a3f8b2c1d4e5f6a7b8c9d0e1f2a3b4c5d6e7f8a9b0c1d2e3f4a5b6c7d8e9f0a1';

  // Customer
  static const String customerName = 'Grace Phiri';
  static const String customerPhone = '+265 881 234 567';
  static const String customerPublicKey =
      '1234567890abcdef1234567890abcdef1234567890abcdef1234567890abcdef12';

  // Swap
  static const int swapMKAmount = 5000;
  static const int swapSatsAmount = 45000;
  static const String swapStatus = 'pending';

  // Lightning invoice (mock)
  static const String lightningInvoice =
      'lnbc450n1pj4xyzpp5qqqsyqcyq5rqwzqfqqqsyqcyq5rqwzqfqqqsyqcyq5rqwzqfqpqqqqqqqqqqqqqqqqqqqcqpjsp5zyg3zyg3zyg3';

  // Discovery agents — names match spec exactly
  static const List<Map<String, dynamic>> agents = [
    {
      'name': 'James Banda',
      'provider': 'Airtel Money',
      'rate': 1700,
      'available': true,
      'stars': 4.8,
      'swaps': 247,
    },
    {
      'name': 'Sarah Mwale',
      'provider': 'TNM Mpamba',
      'rate': 1750,
      'available': true,
      'stars': 4.5,
      'swaps': 89,
    },
    {
      'name': 'Peter Chirwa',
      'provider': 'Airtel Money',
      'rate': 1800,
      'available': false,
      'stars': 4.2,
      'swaps': 56,
    },
  ];

  // Mock reviews
  static const List<Map<String, String>> agentReviews = [
    {
      'author': 'Grace Phiri',
      'rating': '5',
      'comment': 'Fast and reliable. Swap completed in under 2 minutes!',
      'date': '2 days ago',
    },
    {
      'author': 'Kondwani M.',
      'rating': '4',
      'comment': 'Good rate, smooth process. Highly recommend.',
      'date': '1 week ago',
    },
  ];

  // Sats calculation — BTC mock at ~$6,535 so MK 5,000 ≈ 45,000 sats
  static int calcSats(int mkAmount) {
    return ((mkAmount / agentRate) / 6535 * 100000000).round();
  }
}
