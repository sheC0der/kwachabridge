import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../theme.dart';
import '../data/mock_data.dart';
import '../services/app_session.dart';
import '../services/firebase_service.dart';

class CustomerWaitingScreen extends StatefulWidget {
  const CustomerWaitingScreen({super.key});

  @override
  State<CustomerWaitingScreen> createState() => _CustomerWaitingScreenState();
}

class _CustomerWaitingScreenState extends State<CustomerWaitingScreen> {
  Timer? _timer;
  StreamSubscription<DocumentSnapshot>? _sub;

  @override
  void initState() {
    super.initState();
    if (AppSession.firebaseReady && AppSession.activeSwapId.isNotEmpty) {
      _sub = FirebaseService.swapDocStream(AppSession.activeSwapId).listen((doc) {
        if (!mounted) return;
        final data = doc.data() as Map<String, dynamic>?;
        final status = data?['status'] as String? ?? '';
        if (status == 'accepted' || status == 'confirmed' || status == 'invoice_sent') {
          _sub?.cancel();
          Navigator.pushReplacementNamed(context, '/customer-invoice');
        }
      });
    } else {
      _timer = Timer(const Duration(seconds: 3), () {
        if (mounted) Navigator.pushReplacementNamed(context, '/customer-invoice');
      });
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    _sub?.cancel();
    super.dispose();
  }

  static String _fmt(int n) =>
      n.toString().replaceAllMapped(RegExp(r'\B(?=(\d{3})+(?!\d))'), (_) => ',');

  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)?.settings.arguments as Map?;
    final agentName = args?['agentName'] as String? ?? MockData.agentName;
    final mkAmount = (args?['mkAmount'] as num?)?.toInt() ?? MockData.swapMKAmount;
    final satsAmount = (args?['sats'] as num?)?.toInt() ?? MockData.swapSatsAmount;

    return Scaffold(
      backgroundColor: kBackground,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 28),
          child: Column(
            children: [
              const Spacer(),

              const SizedBox(
                width: 64,
                height: 64,
                child: CircularProgressIndicator(color: kAccent, strokeWidth: 2.5),
              ),

              const SizedBox(height: 32),

              const Text(
                'Waiting for Agent',
                textAlign: TextAlign.center,
                style: TextStyle(color: kText, fontSize: 28, fontWeight: FontWeight.bold, letterSpacing: -0.5),
              ),
              const SizedBox(height: 10),
              Text(
                '$agentName is confirming your payment',
                textAlign: TextAlign.center,
                style: const TextStyle(color: kText, fontSize: 16, fontWeight: FontWeight.w500),
              ),
              const SizedBox(height: 8),
              const Text(
                'You will receive a Lightning invoice shortly',
                textAlign: TextAlign.center,
                style: TextStyle(color: kMuted, fontSize: 14),
              ),

              const Spacer(),

              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(color: kSurface, borderRadius: BorderRadius.circular(kRadius), boxShadow: kCardShadow),
                child: Column(
                  children: [
                    _Row('MK sent', 'MK ${_fmt(mkAmount)}'),
                    const SizedBox(height: 12),
                    _Row('Expecting', '≈ ${_fmt(satsAmount)} sats'),
                    const SizedBox(height: 12),
                    _Row('Agent', agentName),
                  ],
                ),
              ),

              const SizedBox(height: 48),
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
