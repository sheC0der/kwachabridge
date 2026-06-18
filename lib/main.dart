import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'firebase_options.dart';
import 'services/app_session.dart';
import 'theme.dart';
import 'screens/splash_screen.dart';
import 'screens/role_selection_screen.dart';
import 'screens/identity_setup_screen.dart';
import 'screens/agent_profile_setup_screen.dart';
import 'screens/customer_profile_setup_screen.dart';
import 'screens/agent_dashboard_screen.dart';
import 'screens/customer_discovery_screen.dart';
import 'screens/set_rate_screen.dart';
import 'screens/incoming_swap_request_screen.dart';
import 'screens/confirm_mobile_money_screen.dart';
import 'screens/invoice_sent_screen.dart';
import 'screens/swap_complete_screen.dart';
import 'screens/agent_detail_screen.dart';
import 'screens/customer_swap_request_screen.dart';
import 'screens/customer_payment_instructions_screen.dart';
import 'screens/customer_waiting_screen.dart';
import 'screens/customer_invoice_screen.dart';
import 'screens/customer_bitcoin_received_screen.dart';
import 'screens/swap_request_screen.dart';
import 'screens/payment_instructions_screen.dart';
import 'screens/waiting_for_bitcoin_screen.dart';
import 'screens/lightning_invoice_received_screen.dart';
import 'screens/bitcoin_received_screen.dart';
import 'screens/wallet_screen.dart';
import 'screens/wallet_send_screen.dart';
import 'screens/wallet_receive_screen.dart';
import 'screens/virtual_card_screen.dart';
import 'screens/payment_confirmation_screen.dart';
import 'screens/settings_screen.dart';
import 'screens/savings_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  try {
    await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
    AppSession.firebaseReady = true;
  } catch (_) {
    // Firebase not configured — run in mock-data mode
    AppSession.firebaseReady = false;
  }
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    statusBarColor: Colors.transparent,
    statusBarIconBrightness: Brightness.light,
    systemNavigationBarColor: kBackground,
  ));
  runApp(const KwachaBridgeApp());
}

class KwachaBridgeApp extends StatelessWidget {
  const KwachaBridgeApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'KwachaBridge',
      debugShowCheckedModeBanner: false,
      theme: buildAppTheme(),
      initialRoute: '/',
      routes: {
        // Core
        '/': (context) => const SplashScreen(),
        '/role-selection': (context) => const RoleSelectionScreen(),
        '/identity-setup': (context) => const IdentitySetupScreen(),
        '/agent-profile-setup': (context) => const AgentProfileSetupScreen(),
        '/customer-profile-setup': (context) => const CustomerProfileSetupScreen(),

        // Agent flow
        '/agent-dashboard': (context) => const AgentDashboardScreen(),
        '/set-rate': (context) => const SetRateScreen(),
        '/incoming-swap-request': (context) => const IncomingSwapRequestScreen(),
        '/confirm-mobile-money': (context) => const ConfirmMobileMoneyScreen(),
        '/invoice-sent': (context) => const InvoiceSentScreen(),
        '/swap-complete': (context) => const SwapCompleteScreen(),

        // Customer flow
        '/customer-discovery': (context) => const CustomerDiscoveryScreen(),
        '/agent-detail': (context) => const AgentDetailScreen(),
        '/customer-swap-request': (context) => const CustomerSwapRequestScreen(),
        '/customer-payment-instructions': (context) => const CustomerPaymentInstructionsScreen(),
        '/customer-waiting': (context) => const CustomerWaitingScreen(),
        '/customer-invoice': (context) => const CustomerInvoiceScreen(),
        '/customer-bitcoin-received': (context) => const CustomerBitcoinReceivedScreen(),

        // Legacy agent customer routes (kept for backward compat)
        '/swap-request': (context) => const SwapRequestScreen(),
        '/payment-instructions': (context) => const PaymentInstructionsScreen(),
        '/waiting-for-bitcoin': (context) => const WaitingForBitcoinScreen(),
        '/lightning-invoice-received': (context) => const LightningInvoiceReceivedScreen(),
        '/bitcoin-received': (context) => const BitcoinReceivedScreen(),

        // Shared
        '/wallet': (context) => const WalletScreen(),
        '/savings': (context) => const SavingsScreen(),
        '/wallet-send': (context) => const WalletSendScreen(),
        '/wallet-receive': (context) => const WalletReceiveScreen(),
        '/virtual-card': (context) => const VirtualCardScreen(),
        '/payment-confirmation': (context) => const PaymentConfirmationScreen(),
        '/settings': (context) => const SettingsScreen(),
      },
    );
  }
}
