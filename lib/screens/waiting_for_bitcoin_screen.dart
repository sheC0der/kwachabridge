import 'package:flutter/material.dart';
import '../theme.dart';

class WaitingForBitcoinScreen extends StatelessWidget {
  const WaitingForBitcoinScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBackground,
      appBar: AppBar(
        leading: IconButton(icon: const Icon(Icons.arrow_back_rounded), onPressed: () => Navigator.pop(context)),
        title: const Text('Waiting'),
      ),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(24, 16, 24, 32),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Waiting for\nBitcoin', style: TextStyle(color: kText, fontSize: 28, fontWeight: FontWeight.bold, letterSpacing: -0.5, height: 1.2)),
            const SizedBox(height: 6),
            const Text('The agent will send sats once they confirm your payment.', style: TextStyle(color: kMuted, fontSize: 14, height: 1.5)),
            const SizedBox(height: 32),

            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(22),
              decoration: BoxDecoration(color: kSurface, borderRadius: BorderRadius.circular(kRadius), boxShadow: kCardShadow),
              child: Column(
                children: [
                  _Step(label: 'Payment sent to agent', done: true),
                  const SizedBox(height: 20),
                  _Step(label: 'Agent confirms receipt', done: false, loading: true),
                  const SizedBox(height: 20),
                  _Step(label: 'Lightning invoice paid', done: false),
                ],
              ),
            ),

            const Spacer(),

            TextButton(
              onPressed: () => Navigator.pushNamed(context, '/lightning-invoice-received'),
              child: const Text('Continue →', style: TextStyle(color: kMuted)),
            ),
          ],
        ),
      ),
    );
  }
}

class _Step extends StatelessWidget {
  final String label;
  final bool done;
  final bool loading;

  const _Step({required this.label, required this.done, this.loading = false});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 32,
          height: 32,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: done ? kAccent : (loading ? kAccent.withValues(alpha: 0.2) : kBorder),
          ),
          alignment: Alignment.center,
          child: loading
              ? const SizedBox(width: 14, height: 14, child: CircularProgressIndicator(color: Color(0xFF3B7A00), strokeWidth: 2))
              : Icon(done ? Icons.check_rounded : Icons.circle_outlined, color: done ? kText : kMuted, size: 16),
        ),
        const SizedBox(width: 14),
        Text(
          label,
          style: TextStyle(
            color: done || loading ? kText : kMuted,
            fontSize: 15,
            fontWeight: done ? FontWeight.w600 : FontWeight.normal,
          ),
        ),
      ],
    );
  }
}
