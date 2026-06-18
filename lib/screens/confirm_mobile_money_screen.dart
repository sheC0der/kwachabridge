import 'package:flutter/material.dart';
import '../theme.dart';
import '../data/mock_data.dart';
import '../data/swap_model.dart';
import '../services/app_session.dart';
import '../services/firebase_service.dart';

class ConfirmMobileMoneyScreen extends StatefulWidget {
  const ConfirmMobileMoneyScreen({super.key});

  @override
  State<ConfirmMobileMoneyScreen> createState() => _ConfirmMobileMoneyScreenState();
}

class _ConfirmMobileMoneyScreenState extends State<ConfirmMobileMoneyScreen> {
  SwapModel? _swap;
  bool _loading = false;
  bool _confirming = false;

  @override
  void initState() {
    super.initState();
    _loadSwap();
  }

  Future<void> _loadSwap() async {
    if (!AppSession.firebaseReady || AppSession.activeSwapId.isEmpty) return;
    setState(() => _loading = true);
    try {
      final swap = await FirebaseService.getSwap(AppSession.activeSwapId);
      if (mounted) setState(() => _swap = swap);
    } catch (_) {
      // Fall back to mock
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  Future<void> _confirm() async {
    setState(() => _confirming = true);
    try {
      if (AppSession.firebaseReady && AppSession.activeSwapId.isNotEmpty) {
        await FirebaseService.updateSwapStatus(AppSession.activeSwapId, 'confirmed');
      }
      if (mounted) Navigator.pushNamed(context, '/invoice-sent');
    } catch (_) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Something went wrong. Please try again.')),
        );
      }
    } finally {
      if (mounted) setState(() => _confirming = false);
    }
  }

  static String _fmt(int n) =>
      n.toString().replaceAllMapped(RegExp(r'\B(?=(\d{3})+(?!\d))'), (_) => ',');

  @override
  Widget build(BuildContext context) {
    final customerName = _swap?.customerName.isNotEmpty == true ? _swap!.customerName : MockData.customerName;
    final customerPhone = _swap?.customerPhone.isNotEmpty == true ? _swap!.customerPhone : MockData.customerPhone;
    final mkAmount = _swap?.mkAmount ?? MockData.swapMKAmount;

    return Scaffold(
      backgroundColor: kBackground,
      appBar: AppBar(
        leading: IconButton(icon: const Icon(Icons.arrow_back_rounded), onPressed: () => Navigator.pop(context)),
        title: const Text('Confirm Payment'),
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator(color: kAccent))
          : Padding(
              padding: const EdgeInsets.fromLTRB(24, 16, 24, 32),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Waiting for\nPayment', style: TextStyle(color: kText, fontSize: 28, fontWeight: FontWeight.bold, letterSpacing: -0.5, height: 1.2)),
                  const SizedBox(height: 10),
                  const Text(
                    'Once you receive the mobile money transfer, confirm below.',
                    style: TextStyle(color: kMuted, fontSize: 14, height: 1.6),
                  ),
                  const SizedBox(height: 32),

                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(22),
                    decoration: BoxDecoration(color: kSurface, borderRadius: BorderRadius.circular(kRadius), boxShadow: kCardShadow),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('PAYMENT DETAILS', style: TextStyle(color: kMuted, fontSize: 11, letterSpacing: 1.2, fontWeight: FontWeight.w600)),
                        const SizedBox(height: 18),
                        _Row('From', customerName),
                        const SizedBox(height: 12),
                        _Row('Number', customerPhone),
                        const SizedBox(height: 12),
                        const _Row('Provider', 'Airtel Money'),
                        const SizedBox(height: 12),
                        _Row('Amount', 'MK ${_fmt(mkAmount)}'),
                      ],
                    ),
                  ),

                  const SizedBox(height: 16),

                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(color: kAccent.withValues(alpha: 0.15), borderRadius: BorderRadius.circular(kRadius)),
                    child: const Row(
                      children: [
                        Icon(Icons.access_time_rounded, color: Color(0xFF3B7A00), size: 16),
                        SizedBox(width: 10),
                        Expanded(
                          child: Text('Check your Airtel Money inbox for the transfer.', style: TextStyle(color: Color(0xFF3B7A00), fontSize: 13)),
                        ),
                      ],
                    ),
                  ),

                  const Spacer(),

                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: _confirming ? null : _confirm,
                      child: _confirming
                          ? const SizedBox(height: 22, width: 22, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
                          : Text("I've Received MK ${_fmt(mkAmount)}"),
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
