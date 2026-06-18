import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../theme.dart';
import '../data/mock_data.dart';
import '../data/swap_model.dart';
import '../services/app_session.dart';
import '../services/firebase_service.dart';

class AgentDashboardScreen extends StatelessWidget {
  const AgentDashboardScreen({super.key});

  String _initials(String name) {
    final parts = name.trim().split(' ');
    if (parts.length >= 2) return '${parts[0][0]}${parts[1][0]}'.toUpperCase();
    return name.isNotEmpty ? name[0].toUpperCase() : '?';
  }

  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;
    final displayName = AppSession.displayName.isNotEmpty
        ? AppSession.displayName
        : (args?['displayName'] as String? ?? MockData.agentName);
    final rawProvider = args?['provider'] as String?;
    final provider = AppSession.provider.isNotEmpty
        ? AppSession.provider
        : (rawProvider == 'airtel' ? 'Airtel Money' : 'TNM Mpamba');
    final publicKey = AppSession.publicKey;

    return Scaffold(
      backgroundColor: kBackground,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('Welcome back,', style: TextStyle(color: kMuted, fontSize: 13)),
                      Text(
                        displayName.split(' ').first,
                        style: const TextStyle(color: kText, fontSize: 22, fontWeight: FontWeight.bold, letterSpacing: -0.3),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      _IconBtn(icon: Icons.account_balance_wallet_outlined, onTap: () => Navigator.pushNamed(context, '/wallet')),
                      const SizedBox(width: 10),
                      _IconBtn(icon: Icons.settings_outlined, onTap: () => Navigator.pushNamed(context, '/settings')),
                    ],
                  ),
                ],
              ),

              const SizedBox(height: 24),

              // Profile card
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(color: kSurface, borderRadius: BorderRadius.circular(kRadius), boxShadow: kCardShadow),
                child: Row(
                  children: [
                    Container(
                      width: 50,
                      height: 50,
                      decoration: BoxDecoration(shape: BoxShape.circle, color: kAccent),
                      alignment: Alignment.center,
                      child: Text(_initials(displayName), style: const TextStyle(color: kText, fontWeight: FontWeight.bold, fontSize: 17)),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(displayName, style: const TextStyle(color: kText, fontSize: 16, fontWeight: FontWeight.w600)),
                          const SizedBox(height: 2),
                          Text(provider, style: const TextStyle(color: kMuted, fontSize: 13)),
                        ],
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
                      decoration: BoxDecoration(color: const Color(0xFFDCFCB8), borderRadius: BorderRadius.circular(kRadiusPill)),
                      child: const Text('Online', style: TextStyle(color: Color(0xFF3B7A00), fontSize: 12, fontWeight: FontWeight.w600)),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 14),

              // Rate card — live from Firestore if available
              _RateCard(publicKey: publicKey),

              const SizedBox(height: 28),

              const Text('INCOMING REQUESTS', style: TextStyle(color: kMuted, fontSize: 11, letterSpacing: 1.2, fontWeight: FontWeight.w600)),
              const SizedBox(height: 12),

              // Pending swaps — live from Firestore if available
              _PendingSwapsList(publicKey: publicKey),

              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }
}

// ── Rate Card ──────────────────────────────────────────────────────────────

class _RateCard extends StatelessWidget {
  final String publicKey;
  const _RateCard({required this.publicKey});

  static String _fmt(int n) =>
      n.toString().replaceAllMapped(RegExp(r'\B(?=(\d{3})+(?!\d))'), (_) => ',');

  @override
  Widget build(BuildContext context) {
    if (!AppSession.firebaseReady || publicKey.isEmpty) {
      return _card(context, MockData.agentRate);
    }
    return StreamBuilder<DocumentSnapshot>(
      stream: FirebaseService.agentDocStream(publicKey),
      builder: (ctx, snap) {
        final rate = snap.hasData && snap.data!.exists
            ? ((snap.data!.data() as Map<String, dynamic>?)?['rate'] as num?)?.toInt() ?? MockData.agentRate
            : MockData.agentRate;
        return _card(context, rate);
      },
    );
  }

  Widget _card(BuildContext context, int rate) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(color: kAccent, borderRadius: BorderRadius.circular(kRadius), boxShadow: kCardShadow),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('YOUR RATE', style: TextStyle(color: Color(0xFF3B7A00), fontSize: 11, letterSpacing: 1.2, fontWeight: FontWeight.w600)),
                const SizedBox(height: 8),
                Text('MK ${_fmt(rate)} / USD', style: const TextStyle(color: kText, fontSize: 22, fontWeight: FontWeight.bold)),
                const SizedBox(height: 2),
                Text(
                  '≈ ${rate > 0 ? (5000 / rate / 6535 * 100000000).round() : 0} sats per MK 5,000',
                  style: const TextStyle(color: Color(0xFF3B7A00), fontSize: 12),
                ),
              ],
            ),
          ),
          GestureDetector(
            onTap: () => Navigator.pushNamed(context, '/set-rate'),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
              decoration: BoxDecoration(color: kText, borderRadius: BorderRadius.circular(kRadiusPill)),
              child: const Text('Edit', style: TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.w600)),
            ),
          ),
        ],
      ),
    );
  }
}

// ── Pending Swaps ──────────────────────────────────────────────────────────

class _PendingSwapsList extends StatelessWidget {
  final String publicKey;
  const _PendingSwapsList({required this.publicKey});

  static String _initials(String name) {
    final parts = name.trim().split(' ');
    if (parts.length >= 2) return '${parts[0][0]}${parts[1][0]}'.toUpperCase();
    return name.isNotEmpty ? name[0].toUpperCase() : '?';
  }

  static String _fmt(int n) =>
      n.toString().replaceAllMapped(RegExp(r'\B(?=(\d{3})+(?!\d))'), (_) => ',');

  @override
  Widget build(BuildContext context) {
    if (!AppSession.firebaseReady || publicKey.isEmpty) {
      return _mockCard(context);
    }
    return StreamBuilder<List<SwapModel>>(
      stream: FirebaseService.pendingSwapsForAgentStream(publicKey),
      builder: (ctx, snap) {
        if (snap.connectionState == ConnectionState.waiting) {
          return const Center(child: Padding(
            padding: EdgeInsets.all(24),
            child: CircularProgressIndicator(color: kAccent, strokeWidth: 2),
          ));
        }
        final swaps = snap.data ?? [];
        if (swaps.isEmpty) return _emptyState();
        return Column(
          children: swaps.map((swap) => Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: _swapCard(context, swap),
          )).toList(),
        );
      },
    );
  }

  Widget _swapCard(BuildContext context, SwapModel swap) {
    final name = swap.customerName.isNotEmpty ? swap.customerName : MockData.customerName;
    return GestureDetector(
      onTap: () {
        AppSession.activeSwapId = swap.swapId;
        Navigator.pushNamed(context, '/incoming-swap-request');
      },
      child: Container(
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(color: kSurface, borderRadius: BorderRadius.circular(kRadius), boxShadow: kCardShadow),
        child: Row(
          children: [
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(shape: BoxShape.circle, color: kAccent.withValues(alpha: 0.25)),
              alignment: Alignment.center,
              child: Text(_initials(name), style: const TextStyle(color: kText, fontWeight: FontWeight.bold, fontSize: 14)),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('$name wants to swap', style: const TextStyle(color: kText, fontSize: 14, fontWeight: FontWeight.w600)),
                  const SizedBox(height: 3),
                  Text('MK ${_fmt(swap.mkAmount)} → ${_fmt(swap.satsAmount)} sats', style: const TextStyle(color: kMuted, fontSize: 13)),
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
              decoration: BoxDecoration(color: kAccent, borderRadius: BorderRadius.circular(kRadiusPill)),
              child: const Text('View', style: TextStyle(color: kText, fontSize: 12, fontWeight: FontWeight.w600)),
            ),
          ],
        ),
      ),
    );
  }

  Widget _mockCard(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.pushNamed(context, '/incoming-swap-request'),
      child: Container(
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(color: kSurface, borderRadius: BorderRadius.circular(kRadius), boxShadow: kCardShadow),
        child: Row(
          children: [
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(shape: BoxShape.circle, color: kAccent.withValues(alpha: 0.25)),
              alignment: Alignment.center,
              child: const Text('GP', style: TextStyle(color: kText, fontWeight: FontWeight.bold, fontSize: 14)),
            ),
            const SizedBox(width: 14),
            const Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Grace Phiri wants to swap', style: TextStyle(color: kText, fontSize: 14, fontWeight: FontWeight.w600)),
                  SizedBox(height: 3),
                  Text('MK 5,000 → 45,000 sats', style: TextStyle(color: kMuted, fontSize: 13)),
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
              decoration: BoxDecoration(color: kAccent, borderRadius: BorderRadius.circular(kRadiusPill)),
              child: const Text('View', style: TextStyle(color: kText, fontSize: 12, fontWeight: FontWeight.w600)),
            ),
          ],
        ),
      ),
    );
  }

  Widget _emptyState() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(28),
      decoration: BoxDecoration(color: kSurface, borderRadius: BorderRadius.circular(kRadius), boxShadow: kCardShadow),
      child: const Column(
        children: [
          Icon(Icons.inbox_rounded, color: kBorder, size: 40),
          SizedBox(height: 12),
          Text('No pending requests', style: TextStyle(color: kMuted, fontSize: 14)),
        ],
      ),
    );
  }
}

// ── Icon Button ────────────────────────────────────────────────────────────

class _IconBtn extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;
  const _IconBtn({required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 42,
        height: 42,
        decoration: BoxDecoration(color: kSurface, shape: BoxShape.circle, boxShadow: kCardShadow),
        alignment: Alignment.center,
        child: Icon(icon, color: kText, size: 20),
      ),
    );
  }
}
