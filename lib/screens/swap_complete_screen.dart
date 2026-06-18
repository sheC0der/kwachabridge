import 'package:flutter/material.dart';
import '../theme.dart';
import '../data/mock_data.dart';
import '../data/swap_model.dart';
import '../services/app_session.dart';
import '../services/firebase_service.dart';

class SwapCompleteScreen extends StatefulWidget {
  const SwapCompleteScreen({super.key});

  @override
  State<SwapCompleteScreen> createState() => _SwapCompleteScreenState();
}

class _SwapCompleteScreenState extends State<SwapCompleteScreen> {
  SwapModel? _swap;

  @override
  void initState() {
    super.initState();
    _complete();
  }

  Future<void> _complete() async {
    if (!AppSession.firebaseReady || AppSession.activeSwapId.isEmpty) return;
    try {
      await FirebaseService.completeSwap(AppSession.activeSwapId, AppSession.publicKey);
      final swap = await FirebaseService.getSwap(AppSession.activeSwapId);
      if (mounted) setState(() => _swap = swap);
      AppSession.activeSwapId = '';
    } catch (_) {
      // Proceed with mock
    }
  }

  static String _fmt(int n) =>
      n.toString().replaceAllMapped(RegExp(r'\B(?=(\d{3})+(?!\d))'), (_) => ',');

  @override
  Widget build(BuildContext context) {
    final customerName = _swap?.customerName.isNotEmpty == true ? _swap!.customerName : MockData.customerName;
    final mkAmount = _swap?.mkAmount ?? MockData.swapMKAmount;
    final satsAmount = _swap?.satsAmount ?? MockData.swapSatsAmount;

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
                child: const Icon(Icons.check_rounded, color: kText, size: 44),
              ),

              const SizedBox(height: 24),
              const Text('Swap Complete', style: TextStyle(color: kText, fontSize: 32, fontWeight: FontWeight.bold, letterSpacing: -0.5)),
              const SizedBox(height: 8),
              const Text('Successfully settled on Lightning.', style: TextStyle(color: kMuted, fontSize: 16)),

              const SizedBox(height: 40),

              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(22),
                decoration: BoxDecoration(color: kSurface, borderRadius: BorderRadius.circular(kRadius), boxShadow: kCardShadow),
                child: Column(
                  children: [
                    _Row('MK received', 'MK ${_fmt(mkAmount)}'),
                    const SizedBox(height: 14),
                    _Row('Sats sent', '${_fmt(satsAmount)} sats'),
                    const SizedBox(height: 14),
                    _Row('Sent to', customerName),
                  ],
                ),
              ),

              const Spacer(),

              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () => Navigator.pushNamedAndRemoveUntil(context, '/agent-dashboard', (route) => false),
                  child: const Text('Back to Dashboard'),
                ),
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
