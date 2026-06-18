class AppSession {
  static bool firebaseReady = false;

  // Current user identity
  static String publicKey = '';
  static String role = ''; // 'agent' | 'customer'
  static String displayName = '';
  static String phoneNumber = '';
  static String provider = ''; // 'Airtel Money' | 'TNM Mpamba'

  // Active swap being processed (shared across agent + customer flows)
  static String activeSwapId = '';

  static void clear() {
    publicKey = '';
    role = '';
    displayName = '';
    phoneNumber = '';
    provider = '';
    activeSwapId = '';
  }
}
