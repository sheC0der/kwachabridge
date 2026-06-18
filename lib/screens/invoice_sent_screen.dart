import 'package:flutter/material.dart';
import '../theme.dart';
import '../data/mock_data.dart';
import '../data/swap_model.dart';
import '../services/app_session.dart';
import '../services/firebase_service.dart';

class InvoiceSentScreen extends StatefulWidget {
  const InvoiceSentScreen({super.key});

  @override
  State<InvoiceSentScreen> createState() => _InvoiceSentScreenState();
}

class _InvoiceSentScreenState extends State<InvoiceSentScreen> {
  SwapModel? _swap;

  @override
  void initState() {
    super.initState();
    _updateStatus();
  }

  Future<void> _updateStatus() async {
    if (!AppSession.firebaseReady || AppSession.activeSwapId.isEmpty) return;
    try {
      await FirebaseService.updateSwapStatus(AppSession.activeSwapId, 'invoice_sent');
      final swap = await FirebaseService.getSwap(AppSession.activeSwapId);
      if (mounted) setState(() => _swap = swap);
    } catch (_) {
      // Proceed with mock data
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
      appBar: AppBar(
        leading: IconButton(icon: const Icon(Icons.arrow_back_rounded), onPressed: () => Navigator.pop(context)),
        title: const Text('Invoice Sent'),
      ),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(24, 16, 24, 32),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 52,
              height: 52,
              decoration: BoxDecoration(color: kAccent, borderRadius: BorderRadius.circular(kRadiusSm)),
              alignment: Alignment.center,
              child: const Icon(Icons.check_rounded, color: kText, size: 28),
            ),
            const SizedBox(height: 18),
            const Text('Payment Confirmed', style: TextStyle(color: kText, fontSize: 26, fontWeight: FontWeight.bold, letterSpacing: -0.5)),
            const SizedBox(height: 6),
            Text('Lightning invoice sent to $customerName.', style: const TextStyle(color: kMuted, fontSize: 14)),
            const SizedBox(height: 32),

            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(22),
              decoration: BoxDecoration(color: kSurface, borderRadius: BorderRadius.circular(kRadius), boxShadow: kCardShadow),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('TRANSACTION SUMMARY', style: TextStyle(color: kMuted, fontSize: 11, letterSpacing: 1.2, fontWeight: FontWeight.w600)),
                  const SizedBox(height: 18),
                  _Row('You received', 'MK ${_fmt(mkAmount)}'),
                  const SizedBox(height: 12),
                  _Row('Sats sent', '${_fmt(satsAmount)} sats'),
                  const SizedBox(height: 12),
                  _Row('To', customerName),
                ],
              ),
            ),

            const SizedBox(height: 16),

            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(color: kAccent.withValues(alpha: 0.15), borderRadius: BorderRadius.circular(kRadius)),
              child: const Row(
                children: [
                  SizedBox(width: 16, height: 16, child: CircularProgressIndicator(color: Color(0xFF3B7A00), strokeWidth: 2)),
                  SizedBox(width: 12),
                  Text('Waiting for Lightning confirmation...', style: TextStyle(color: Color(0xFF3B7A00), fontSize: 13)),
                ],
              ),
            ),

            const Spacer(),

            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () => Navigator.pushNamed(context, '/swap-complete'),
                child: const Text('Transaction Complete'),
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
