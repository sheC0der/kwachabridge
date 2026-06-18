import 'package:flutter/material.dart';
import '../theme.dart';

class PaymentConfirmationScreen extends StatefulWidget {
  const PaymentConfirmationScreen({super.key});

  @override
  State<PaymentConfirmationScreen> createState() => _PaymentConfirmationScreenState();
}

class _PaymentConfirmationScreenState extends State<PaymentConfirmationScreen> {
  bool _paid = false;

  static String _parseSats(String sats) => sats.replaceAll('~', '').trim();

  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)?.settings.arguments as Map?;
    final service = args?['service'] as String? ?? 'Service';
    final usd = args?['usd'] as String? ?? '\$0.00';
    final sats = args?['sats'] as String? ?? '0 sats';

    if (_paid) {
      return Scaffold(
        backgroundColor: kBackground,
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 28),
            child: Column(
              children: [
                const Spacer(),
                Container(
                  width: 72,
                  height: 72,
                  decoration: BoxDecoration(color: kAccent, borderRadius: BorderRadius.circular(kRadius)),
                  alignment: Alignment.center,
                  child: const Icon(Icons.check_rounded, color: kText, size: 38),
                ),
                const SizedBox(height: 24),
                const Text('Payment Successful', style: TextStyle(color: kText, fontSize: 28, fontWeight: FontWeight.bold, letterSpacing: -0.5)),
                const SizedBox(height: 16),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(22),
                  decoration: BoxDecoration(color: kSurface, borderRadius: BorderRadius.circular(kRadius), boxShadow: kCardShadow),
                  child: Column(
                    children: [
                      _Row('Service paid', service),
                      const SizedBox(height: 14),
                      _Row('Sats deducted', _parseSats(sats)),
                    ],
                  ),
                ),
                const Spacer(),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () => Navigator.pushNamedAndRemoveUntil(context, '/wallet', (route) => false),
                    child: const Text('Back to Wallet'),
                  ),
                ),
                const SizedBox(height: 32),
              ],
            ),
          ),
        ),
      );
    }

    return Scaffold(
      backgroundColor: kBackground,
      appBar: AppBar(
        leading: IconButton(icon: const Icon(Icons.arrow_back_rounded), onPressed: () => Navigator.pop(context)),
        title: const Text('Confirm Payment'),
      ),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(24, 16, 24, 32),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(color: kAccent.withValues(alpha: 0.2), borderRadius: BorderRadius.circular(kRadiusSm)),
                  alignment: Alignment.center,
                  child: Text(service[0], style: const TextStyle(color: kText, fontWeight: FontWeight.bold, fontSize: 20)),
                ),
                const SizedBox(width: 14),
                Text(service, style: const TextStyle(color: kText, fontSize: 20, fontWeight: FontWeight.w600)),
              ],
            ),

            const SizedBox(height: 40),

            Center(
              child: Column(
                children: [
                  Text(usd, style: const TextStyle(color: kText, fontSize: 48, fontWeight: FontWeight.bold, letterSpacing: -1)),
                  const SizedBox(height: 4),
                  Text(_parseSats(sats), style: const TextStyle(color: kMuted, fontSize: 20)),
                ],
              ),
            ),

            const SizedBox(height: 32),

            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(color: kSurface, borderRadius: BorderRadius.circular(kRadius), boxShadow: kCardShadow),
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('After payment', style: TextStyle(color: kMuted, fontSize: 14)),
                  Text('≈ 43,477 sats remaining', style: TextStyle(color: kText, fontSize: 14, fontWeight: FontWeight.w500)),
                ],
              ),
            ),

            const Spacer(),

            Row(
              children: [
                Expanded(child: OutlinedButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel'))),
                const SizedBox(width: 14),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () => setState(() => _paid = true),
                    child: const Text('Confirm Payment'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _Row extends StatelessWidget {
  final String label;
  final String value;
  const _Row(this.label, this.value);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: const TextStyle(color: kMuted, fontSize: 14)),
        Text(value, style: const TextStyle(color: kText, fontSize: 14, fontWeight: FontWeight.w500)),
      ],
    );
  }
}
