import 'package:flutter/material.dart';
import '../theme.dart';
import '../data/mock_data.dart';

class CustomerBitcoinReceivedScreen extends StatelessWidget {
  const CustomerBitcoinReceivedScreen({super.key});

  static String _fmt(int n) =>
      n.toString().replaceAllMapped(RegExp(r'\B(?=(\d{3})+(?!\d))'), (_) => ',');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBackground,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 28),
          child: Column(
            children: [
              const Spacer(),

              Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(color: kAccent, borderRadius: BorderRadius.circular(kRadius)),
                alignment: Alignment.center,
                child: const Icon(Icons.bolt_rounded, color: kText, size: 44),
              ),

              const SizedBox(height: 24),
              const Text('Bitcoin Received', style: TextStyle(color: kText, fontSize: 32, fontWeight: FontWeight.bold, letterSpacing: -0.5)),
              const SizedBox(height: 8),
              Text(
                '${_fmt(MockData.swapSatsAmount)} sats',
                style: const TextStyle(color: kAccent, fontSize: 28, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 4),
              const Text('≈ \$0.29', style: TextStyle(color: kMuted, fontSize: 16)),

              const SizedBox(height: 40),

              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(22),
                decoration: BoxDecoration(color: kSurface, borderRadius: BorderRadius.circular(kRadius), boxShadow: kCardShadow),
                child: const Column(
                  children: [
                    _Row('Kwacha sent', 'MK 5,000'),
                    SizedBox(height: 14),
                    _Row('Sats received', '45,000 sats'),
                    SizedBox(height: 14),
                    _Row('Agent', MockData.agentName),
                    SizedBox(height: 14),
                    _Row('Time', 'just now'),
                  ],
                ),
              ),

              const Spacer(),

              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () => Navigator.pushNamedAndRemoveUntil(context, '/wallet', (route) => false),
                  child: const Text('Go to Wallet'),
                ),
              ),
              const SizedBox(height: 12),
              TextButton(
                onPressed: () => Navigator.pushNamedAndRemoveUntil(context, '/customer-discovery', (route) => false),
                child: const Text('New Swap', style: TextStyle(color: kMuted)),
              ),
              const SizedBox(height: 28),
            ],
          ),
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
