import 'package:flutter/material.dart';
import '../theme.dart';
import '../data/mock_data.dart';

class VirtualCardScreen extends StatelessWidget {
  const VirtualCardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBackground,
      appBar: AppBar(
        leading: IconButton(icon: const Icon(Icons.arrow_back_rounded), onPressed: () => Navigator.pop(context)),
        title: const Text('KwachaBridge Card'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(24, 16, 24, 40),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Card visual
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: kText,
                borderRadius: BorderRadius.circular(kRadius),
                boxShadow: kCardShadow,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('KwachaBridge', style: TextStyle(color: kAccent, fontSize: 16, fontWeight: FontWeight.bold, letterSpacing: -0.5)),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                        decoration: BoxDecoration(
                          color: kAccent.withValues(alpha: 0.15),
                          borderRadius: BorderRadius.circular(kRadiusSm),
                        ),
                        child: const Text('VIRTUAL', style: TextStyle(color: kAccent, fontSize: 9, letterSpacing: 1.5, fontWeight: FontWeight.w700)),
                      ),
                    ],
                  ),
                  const SizedBox(height: 28),
                  const Text(
                    '**** **** **** 4291',
                    style: TextStyle(color: Colors.white, fontSize: 22, letterSpacing: 4, fontFamily: 'monospace', fontWeight: FontWeight.w300),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    MockData.customerName.toUpperCase(),
                    style: TextStyle(color: Colors.white.withValues(alpha: 0.6), fontSize: 12, letterSpacing: 1.5),
                  ),
                  const SizedBox(height: 10),
                  const Text('45,000 sats  /  ≈ \$0.29', style: TextStyle(color: kAccent, fontSize: 14, fontWeight: FontWeight.bold)),
                ],
              ),
            ),

            const SizedBox(height: 28),

            const Text('PAY FOR SERVICES', style: TextStyle(color: kMuted, fontSize: 11, letterSpacing: 1.2, fontWeight: FontWeight.w600)),
            const SizedBox(height: 12),

            _ServiceCard(name: 'Google One', detail: '100GB storage', usd: '\$0.99', sats: '~1,523 sats', onPay: () => Navigator.pushNamed(context, '/payment-confirmation', arguments: {'service': 'Google One', 'usd': '\$0.99', 'sats': '~1,523 sats'})),
            const SizedBox(height: 12),
            _ServiceCard(name: 'Spotify', detail: 'Premium music', usd: '\$2.99', sats: '~4,600 sats', onPay: () => Navigator.pushNamed(context, '/payment-confirmation', arguments: {'service': 'Spotify', 'usd': '\$2.99', 'sats': '~4,600 sats'})),
            const SizedBox(height: 12),
            _ServiceCard(name: 'iCloud 50GB', detail: 'Apple storage', usd: '\$0.99', sats: '~1,523 sats', onPay: () => Navigator.pushNamed(context, '/payment-confirmation', arguments: {'service': 'iCloud 50GB', 'usd': '\$0.99', 'sats': '~1,523 sats'})),
            const SizedBox(height: 12),
            _ServiceCard(name: 'Namecheap', detail: 'Domain registration', usd: '\$5.00', sats: '~7,692 sats', onPay: () => Navigator.pushNamed(context, '/payment-confirmation', arguments: {'service': 'Namecheap', 'usd': '\$5.00', 'sats': '~7,692 sats'})),
            const SizedBox(height: 12),
            _ServiceCard(name: 'Netflix Basic', detail: 'Streaming', usd: '\$6.99', sats: '~10,754 sats', onPay: () => Navigator.pushNamed(context, '/payment-confirmation', arguments: {'service': 'Netflix Basic', 'usd': '\$6.99', 'sats': '~10,754 sats'})),
          ],
        ),
      ),
    );
  }
}

class _ServiceCard extends StatelessWidget {
  final String name;
  final String detail;
  final String usd;
  final String sats;
  final VoidCallback onPay;

  const _ServiceCard({required this.name, required this.detail, required this.usd, required this.sats, required this.onPay});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(color: kSurface, borderRadius: BorderRadius.circular(kRadius), boxShadow: kCardShadow),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(color: kAccent.withValues(alpha: 0.2), borderRadius: BorderRadius.circular(kRadiusSm)),
            alignment: Alignment.center,
            child: Text(name[0], style: const TextStyle(color: kText, fontWeight: FontWeight.bold, fontSize: 15)),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(name, style: const TextStyle(color: kText, fontSize: 14, fontWeight: FontWeight.w600)),
                const SizedBox(height: 2),
                Text(detail, style: const TextStyle(color: kMuted, fontSize: 12)),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(usd, style: const TextStyle(color: kText, fontSize: 13, fontWeight: FontWeight.w600)),
              Text(sats, style: const TextStyle(color: kMuted, fontSize: 11)),
            ],
          ),
          const SizedBox(width: 12),
          GestureDetector(
            onTap: onPay,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(color: kAccent, borderRadius: BorderRadius.circular(kRadiusPill)),
              child: const Text('Pay', style: TextStyle(color: kText, fontSize: 12, fontWeight: FontWeight.w700)),
            ),
          ),
        ],
      ),
    );
  }
}
