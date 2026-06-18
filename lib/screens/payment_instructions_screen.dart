import 'package:flutter/material.dart';
import '../theme.dart';
import '../data/mock_data.dart';

class PaymentInstructionsScreen extends StatelessWidget {
  const PaymentInstructionsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBackground,
      appBar: AppBar(
        leading: IconButton(icon: const Icon(Icons.arrow_back_rounded), onPressed: () => Navigator.pop(context)),
        title: const Text('Payment Instructions'),
      ),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(24, 16, 24, 32),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Send Payment', style: TextStyle(color: kText, fontSize: 28, fontWeight: FontWeight.bold, letterSpacing: -0.5)),
            const SizedBox(height: 6),
            const Text('Send the exact amount via Airtel Money.', style: TextStyle(color: kMuted, fontSize: 14)),
            const SizedBox(height: 32),

            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(22),
              decoration: BoxDecoration(color: kSurface, borderRadius: BorderRadius.circular(kRadius), boxShadow: kCardShadow),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('SEND TO', style: TextStyle(color: kMuted, fontSize: 11, letterSpacing: 1.2, fontWeight: FontWeight.w600)),
                  const SizedBox(height: 16),
                  Text(MockData.agentPhone, style: const TextStyle(color: kAccent, fontSize: 28, fontWeight: FontWeight.bold, letterSpacing: -0.5)),
                  const SizedBox(height: 4),
                  const Text(MockData.agentName, style: TextStyle(color: kMuted, fontSize: 14)),
                  const SizedBox(height: 20),
                  const Divider(color: kBorder),
                  const SizedBox(height: 16),
                  const _Row('Amount', 'MK 5,000'),
                  const SizedBox(height: 12),
                  const _Row('Provider', MockData.agentProvider),
                  const SizedBox(height: 12),
                  const _Row('You receive', '≈ 45,000 sats'),
                ],
              ),
            ),

            const SizedBox(height: 16),

            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(color: kAccent.withValues(alpha: 0.15), borderRadius: BorderRadius.circular(kRadius)),
              child: const Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(Icons.info_outline_rounded, color: Color(0xFF3B7A00), size: 16),
                  SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      'Send exactly MK 5,000. Incorrect amounts may result in a failed swap.',
                      style: TextStyle(color: Color(0xFF3B7A00), fontSize: 13, height: 1.5),
                    ),
                  ),
                ],
              ),
            ),

            const Spacer(),

            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () => Navigator.pushNamed(context, '/waiting-for-bitcoin'),
                child: const Text("I've Sent the Payment"),
              ),
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
