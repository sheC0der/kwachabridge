import 'package:flutter/material.dart';
import '../theme.dart';

class WalletScreen extends StatelessWidget {
  const WalletScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBackground,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 20, 16, 0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('My Wallet', style: TextStyle(color: kText, fontSize: 28, fontWeight: FontWeight.bold, letterSpacing: -0.5)),
                  GestureDetector(
                    onTap: () => Navigator.pushNamed(context, '/settings'),
                    child: Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(color: kSurface, shape: BoxShape.circle, boxShadow: kCardShadow),
                      alignment: Alignment.center,
                      child: const Icon(Icons.settings_outlined, color: kText, size: 20),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // Balance card
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: kAccent,
                  borderRadius: BorderRadius.circular(kRadius),
                  boxShadow: kCardShadow,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('YOUR BALANCE', style: TextStyle(color: Color(0xFF3B7A00), fontSize: 11, letterSpacing: 1.2, fontWeight: FontWeight.w600)),
                    const SizedBox(height: 10),
                    const Text(
                      '45,000 sats',
                      style: TextStyle(color: kText, fontSize: 36, fontWeight: FontWeight.bold, letterSpacing: -1),
                    ),
                    const SizedBox(height: 4),
                    const Text('≈ \$0.29', style: TextStyle(color: Color(0xFF3B7A00), fontSize: 15)),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 20),

            // Action buttons
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Row(
                children: [
                  Expanded(
                    child: _ActionButton(
                      icon: Icons.arrow_upward_rounded,
                      label: 'Send',
                      onTap: () => Navigator.pushNamed(context, '/wallet-send'),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _ActionButton(
                      icon: Icons.arrow_downward_rounded,
                      label: 'Receive',
                      onTap: () => Navigator.pushNamed(context, '/wallet-receive'),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _ActionButton(
                      icon: Icons.credit_card_outlined,
                      label: 'Card',
                      accent: true,
                      onTap: () => Navigator.pushNamed(context, '/virtual-card'),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _ActionButton(
                      icon: Icons.savings_rounded,
                      label: 'Save',
                      onTap: () => Navigator.pushNamed(context, '/savings'),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 28),

            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 24),
              child: Text('RECENT TRANSACTIONS', style: TextStyle(color: kMuted, fontSize: 11, letterSpacing: 1.2, fontWeight: FontWeight.w600)),
            ),
            const SizedBox(height: 12),

            Expanded(
              child: ListView(
                padding: const EdgeInsets.fromLTRB(24, 0, 24, 40),
                children: const [
                  _TxRow(label: 'Swap from James Banda', sub: 'Today', amount: '+45,000 sats', positive: true),
                  SizedBox(height: 10),
                  _TxRow(label: 'Swap from Sarah Mwale', sub: 'Yesterday', amount: '+30,000 sats', positive: true),
                  SizedBox(height: 10),
                  _TxRow(label: 'Sent to Spotify', sub: '2 days ago', amount: '-3,200 sats', positive: false),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ActionButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;
  final bool accent;

  const _ActionButton({required this.icon, required this.label, required this.onTap, this.accent = false});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(
          color: accent ? kText : kSurface,
          borderRadius: BorderRadius.circular(kRadius),
          boxShadow: kCardShadow,
        ),
        child: Column(
          children: [
            Icon(icon, color: accent ? kAccent : kText, size: 22),
            const SizedBox(height: 6),
            Text(label, style: TextStyle(color: accent ? kAccent : kText, fontSize: 12, fontWeight: FontWeight.w600)),
          ],
        ),
      ),
    );
  }
}

class _TxRow extends StatelessWidget {
  final String label;
  final String sub;
  final String amount;
  final bool positive;

  const _TxRow({required this.label, required this.sub, required this.amount, required this.positive});

  @override
  Widget build(BuildContext context) {
    final color = positive ? const Color(0xFF2E7D32) : kMuted;
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: kSurface,
        borderRadius: BorderRadius.circular(kRadius),
        boxShadow: kCardShadow,
      ),
      child: Row(
        children: [
          Container(
            width: 42,
            height: 42,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: positive ? const Color(0xFFDCFCB8) : kBorder,
            ),
            alignment: Alignment.center,
            child: Icon(
              positive ? Icons.arrow_downward_rounded : Icons.arrow_upward_rounded,
              color: positive ? const Color(0xFF3B7A00) : kMuted,
              size: 18,
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label, style: const TextStyle(color: kText, fontSize: 14, fontWeight: FontWeight.w500)),
                const SizedBox(height: 2),
                Text(sub, style: const TextStyle(color: kMuted, fontSize: 12)),
              ],
            ),
          ),
          Text(amount, style: TextStyle(color: color, fontSize: 14, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }
}
