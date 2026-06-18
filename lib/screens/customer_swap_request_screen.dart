import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../theme.dart';
import '../data/mock_data.dart';
import '../services/app_session.dart';
import '../services/firebase_service.dart';

class CustomerSwapRequestScreen extends StatefulWidget {
  const CustomerSwapRequestScreen({super.key});

  @override
  State<CustomerSwapRequestScreen> createState() => _CustomerSwapRequestScreenState();
}

class _CustomerSwapRequestScreenState extends State<CustomerSwapRequestScreen> {
  final _amountController = TextEditingController(text: '5000');
  int _mkAmount = 5000;
  bool _loading = false;

  @override
  void initState() {
    super.initState();
    _amountController.addListener(() {
      final val = int.tryParse(_amountController.text) ?? 0;
      if (val != _mkAmount) setState(() => _mkAmount = val);
    });
  }

  @override
  void dispose() {
    _amountController.dispose();
    super.dispose();
  }

  int _calcSats(int mk, int rate) =>
      mk > 0 && rate > 0 ? (mk / rate / 6535 * 100000000).round() : 0;

  static String _fmt(int n) =>
      n.toString().replaceAllMapped(RegExp(r'\B(?=(\d{3})+(?!\d))'), (_) => ',');

  Future<void> _sendRequest(Map args) async {
    final agentId = args['publicKey'] as String? ?? '';
    final agentPhone = args['phoneNumber'] as String? ?? MockData.agentPhone;
    final rate = (args['rate'] as num?)?.toInt() ?? MockData.agentRate;
    final sats = _calcSats(_mkAmount, rate);
    final agentName = args['name'] as String? ?? MockData.agentName;
    final provider = args['provider'] as String? ?? MockData.agentProvider;

    setState(() => _loading = true);
    try {
      if (AppSession.firebaseReady && agentId.isNotEmpty) {
        final swapId = await FirebaseService.createSwap(
          agentId: agentId,
          customerId: AppSession.publicKey,
          mkAmount: _mkAmount,
          satsAmount: sats,
          agentPhone: agentPhone,
          customerName: AppSession.displayName.isNotEmpty ? AppSession.displayName : MockData.customerName,
          customerPhone: AppSession.phoneNumber.isNotEmpty ? AppSession.phoneNumber : MockData.customerPhone,
        );
        AppSession.activeSwapId = swapId;
      }
      if (mounted) {
        Navigator.pushNamed(context, '/customer-payment-instructions', arguments: {
          'agentName': agentName,
          'provider': provider,
          'agentPhone': agentPhone,
          'mkAmount': _mkAmount,
          'sats': sats,
        });
      }
    } catch (_) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Something went wrong. Please try again.')),
        );
      }
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)?.settings.arguments as Map? ?? {};
    final agentName = args['name'] as String? ?? MockData.agentName;
    final provider = args['provider'] as String? ?? MockData.agentProvider;
    final rate = (args['rate'] as num?)?.toInt() ?? MockData.agentRate;
    final sats = _calcSats(_mkAmount, rate);

    return Scaffold(
      backgroundColor: kBackground,
      appBar: AppBar(
        leading: IconButton(icon: const Icon(Icons.arrow_back_rounded), onPressed: () => Navigator.pop(context)),
        title: Text('Swap with $agentName'),
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(24, 16, 24, 32),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'How much are\nyou sending?',
                    style: TextStyle(color: kText, fontSize: 28, fontWeight: FontWeight.bold, letterSpacing: -0.5, height: 1.2),
                  ),
                  const SizedBox(height: 6),
                  Text('Rate: MK ${_fmt(rate)} per USD', style: const TextStyle(color: kMuted, fontSize: 14)),
                  const SizedBox(height: 32),

                  const Text('AMOUNT IN KWACHA', style: TextStyle(color: kMuted, fontSize: 11, letterSpacing: 1.2, fontWeight: FontWeight.w500)),
                  const SizedBox(height: 10),
                  TextField(
                    controller: _amountController,
                    keyboardType: TextInputType.number,
                    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                    autofocus: true,
                    style: const TextStyle(color: kText, fontSize: 36, fontWeight: FontWeight.bold),
                    decoration: const InputDecoration(
                      hintText: '5000',
                      prefix: Text('MK ', style: TextStyle(color: kMuted, fontSize: 24, fontWeight: FontWeight.w400)),
                    ),
                  ),

                  const SizedBox(height: 24),

                  if (_mkAmount > 0) ...[
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
                                const Text('YOU SEND', style: TextStyle(color: Color(0xFF3B7A00), fontSize: 11, letterSpacing: 1.2, fontWeight: FontWeight.w600)),
                                const SizedBox(height: 6),
                                Text('MK ${_fmt(_mkAmount)}', style: const TextStyle(color: kText, fontSize: 20, fontWeight: FontWeight.bold)),
                              ],
                            ),
                          ),
                          const Icon(Icons.arrow_forward_rounded, color: Color(0xFF3B7A00)),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                const Text('YOU GET', style: TextStyle(color: Color(0xFF3B7A00), fontSize: 11, letterSpacing: 1.2, fontWeight: FontWeight.w600)),
                                const SizedBox(height: 6),
                                Text('${_fmt(sats)} sats', style: const TextStyle(color: kText, fontSize: 20, fontWeight: FontWeight.bold)),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 14),
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(color: kSurface, borderRadius: BorderRadius.circular(kRadius), boxShadow: kCardShadow),
                      child: Text(
                        'Via $provider · $agentName',
                        style: const TextStyle(color: kMuted, fontSize: 14),
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(24, 8, 24, 32),
            child: SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: (_mkAmount > 0 && !_loading) ? () => _sendRequest(args) : null,
                child: _loading
                    ? const SizedBox(height: 22, width: 22, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
                    : const Text('Send Swap Request'),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
