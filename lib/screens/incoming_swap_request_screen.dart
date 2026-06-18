import 'package:flutter/material.dart';
import '../theme.dart';
import '../data/mock_data.dart';
import '../data/swap_model.dart';
import '../services/app_session.dart';
import '../services/firebase_service.dart';

class IncomingSwapRequestScreen extends StatefulWidget {
  const IncomingSwapRequestScreen({super.key});

  @override
  State<IncomingSwapRequestScreen> createState() => _IncomingSwapRequestScreenState();
}

class _IncomingSwapRequestScreenState extends State<IncomingSwapRequestScreen> {
  SwapModel? _swap;
  bool _loading = false;
  bool _actionLoading = false;

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

  Future<void> _accept() async {
    setState(() => _actionLoading = true);
    try {
      if (AppSession.firebaseReady && AppSession.activeSwapId.isNotEmpty) {
        await FirebaseService.updateSwapStatus(AppSession.activeSwapId, 'accepted');
      }
      if (mounted) Navigator.pushNamed(context, '/confirm-mobile-money');
    } catch (_) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Something went wrong. Please try again.')),
        );
      }
    } finally {
      if (mounted) setState(() => _actionLoading = false);
    }
  }

  Future<void> _decline() async {
    setState(() => _actionLoading = true);
    try {
      if (AppSession.firebaseReady && AppSession.activeSwapId.isNotEmpty) {
        await FirebaseService.updateSwapStatus(AppSession.activeSwapId, 'declined');
        AppSession.activeSwapId = '';
      }
      if (mounted) Navigator.pop(context);
    } catch (_) {
      if (mounted) Navigator.pop(context);
    } finally {
      if (mounted) setState(() => _actionLoading = false);
    }
  }

  static String _initials(String name) {
    final parts = name.trim().split(' ');
    if (parts.length >= 2) return '${parts[0][0]}${parts[1][0]}'.toUpperCase();
    return name.isNotEmpty ? name[0].toUpperCase() : '?';
  }

  static String _fmt(int n) =>
      n.toString().replaceAllMapped(RegExp(r'\B(?=(\d{3})+(?!\d))'), (_) => ',');

  @override
  Widget build(BuildContext context) {
    final customerName = _swap?.customerName.isNotEmpty == true
        ? _swap!.customerName
        : MockData.customerName;
    final customerPhone = _swap?.customerPhone.isNotEmpty == true
        ? _swap!.customerPhone
        : MockData.customerPhone;
    final mkAmount = _swap?.mkAmount ?? MockData.swapMKAmount;
    final satsAmount = _swap?.satsAmount ?? MockData.swapSatsAmount;

    return Scaffold(
      backgroundColor: kBackground,
      appBar: AppBar(
        leading: IconButton(icon: const Icon(Icons.arrow_back_rounded), onPressed: () => Navigator.pop(context)),
        title: const Text('Swap Request'),
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator(color: kAccent))
          : Padding(
              padding: const EdgeInsets.fromLTRB(24, 16, 24, 32),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('New Request', style: TextStyle(color: kText, fontSize: 28, fontWeight: FontWeight.bold, letterSpacing: -0.5)),
                  const SizedBox(height: 6),
                  const Text('Review the details before accepting.', style: TextStyle(color: kMuted, fontSize: 14)),
                  const SizedBox(height: 32),

                  // Customer
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(color: kSurface, borderRadius: BorderRadius.circular(kRadius), boxShadow: kCardShadow),
                    child: Row(
                      children: [
                        Container(
                          width: 44,
                          height: 44,
                          decoration: BoxDecoration(shape: BoxShape.circle, color: kAccent.withValues(alpha: 0.25)),
                          alignment: Alignment.center,
                          child: Text(_initials(customerName), style: const TextStyle(color: kText, fontWeight: FontWeight.bold, fontSize: 14)),
                        ),
                        const SizedBox(width: 14),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(customerName, style: const TextStyle(color: kText, fontSize: 16, fontWeight: FontWeight.w600)),
                            const SizedBox(height: 2),
                            Text(customerPhone, style: const TextStyle(color: kMuted, fontSize: 13)),
                          ],
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 14),

                  // Swap amounts
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(color: kAccent, borderRadius: BorderRadius.circular(kRadius), boxShadow: kCardShadow),
                    child: Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text('THEY SEND', style: TextStyle(color: Color(0xFF3B7A00), fontSize: 11, letterSpacing: 1.2, fontWeight: FontWeight.w600)),
                              const SizedBox(height: 8),
                              Text('MK ${_fmt(mkAmount)}', style: const TextStyle(color: kText, fontSize: 22, fontWeight: FontWeight.bold)),
                              const SizedBox(height: 2),
                              const Text('via Airtel Money', style: TextStyle(color: Color(0xFF3B7A00), fontSize: 12)),
                            ],
                          ),
                        ),
                        const Icon(Icons.arrow_forward_rounded, color: Color(0xFF3B7A00)),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              const Text('THEY GET', style: TextStyle(color: Color(0xFF3B7A00), fontSize: 11, letterSpacing: 1.2, fontWeight: FontWeight.w600)),
                              const SizedBox(height: 8),
                              Text('${_fmt(satsAmount)} sats', style: const TextStyle(color: kText, fontSize: 22, fontWeight: FontWeight.bold)),
                              const SizedBox(height: 2),
                              const Text('via Lightning', style: TextStyle(color: Color(0xFF3B7A00), fontSize: 12)),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),

                  const Spacer(),

                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton(
                          onPressed: _actionLoading ? null : _decline,
                          child: const Text('Decline'),
                        ),
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: ElevatedButton(
                          onPressed: _actionLoading ? null : _accept,
                          child: _actionLoading
                              ? const SizedBox(height: 20, width: 20, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
                              : const Text('Accept'),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
    );
  }
}
