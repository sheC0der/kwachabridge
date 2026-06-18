import 'package:flutter/material.dart';
import '../theme.dart';
import '../data/mock_data.dart';

class CustomerPaymentInstructionsScreen extends StatelessWidget {
  const CustomerPaymentInstructionsScreen({super.key});

  static String _fmt(int n) =>
      n.toString().replaceAllMapped(RegExp(r'\B(?=(\d{3})+(?!\d))'), (_) => ',');

  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)?.settings.arguments as Map?;
    final agentName = args?['agentName'] as String? ?? MockData.agentName;
    final provider = args?['provider'] as String? ?? MockData.agentProvider;
    final mkAmount = (args?['mkAmount'] as num?)?.toInt() ?? MockData.swapMKAmount;

    return Scaffold(
      backgroundColor: kBackground,
      appBar: AppBar(
        leading: IconButton(icon: const Icon(Icons.arrow_back_rounded), onPressed: () => Navigator.pop(context)),
        title: const Text('Send Your Payment'),
      ),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(24, 16, 24, 32),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Send the Payment', style: TextStyle(color: kText, fontSize: 28, fontWeight: FontWeight.bold, letterSpacing: -0.5)),
            const SizedBox(height: 6),
            const Text('Send exactly the amount below to complete your swap.', style: TextStyle(color: kMuted, fontSize: 14, height: 1.6)),
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
                  Text(MockData.agentPhone, style: const TextStyle(color: kAccent, fontSize: 28, fontWeight: FontWeight.bold, letterSpacing: 1)),
                  const SizedBox(height: 4),
                  Text(provider, style: const TextStyle(color: kMuted, fontSize: 13)),
                  const SizedBox(height: 20),
                  const Divider(color: kBorder),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Agent', style: TextStyle(color: kMuted, fontSize: 14)),
                      Text(agentName, style: const TextStyle(color: kText, fontSize: 14, fontWeight: FontWeight.w500)),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Amount', style: TextStyle(color: kMuted, fontSize: 14)),
                      Text('MK ${_fmt(mkAmount)}', style: const TextStyle(color: kText, fontSize: 22, fontWeight: FontWeight.bold)),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),

            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(color: kAccent.withValues(alpha: 0.15), borderRadius: BorderRadius.circular(kRadius)),
              child: const Row(
                children: [
                  Icon(Icons.info_outline_rounded, color: Color(0xFF3B7A00), size: 16),
                  SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      'Send exactly this amount. Wrong amounts may delay your swap.',
                      style: TextStyle(color: Color(0xFF3B7A00), fontSize: 12, height: 1.5),
                    ),
                  ),
                ],
              ),
            ),

            const Spacer(),

            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () => Navigator.pushNamed(context, '/customer-waiting'),
                child: const Text("I Have Sent the Payment"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
