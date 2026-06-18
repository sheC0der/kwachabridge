import 'package:flutter/material.dart';
import '../theme.dart';

class WalletSendScreen extends StatefulWidget {
  const WalletSendScreen({super.key});

  @override
  State<WalletSendScreen> createState() => _WalletSendScreenState();
}

class _WalletSendScreenState extends State<WalletSendScreen> {
  final _invoiceController = TextEditingController();
  bool _invoicePasted = false;
  bool _sent = false;

  static const String _mockInvoice =
      'lnbc450n1pj4xyzpp5qqqsyqcyq5rqwzqfqqqsyqcyq5rqwzqfqqqsyqcyq5rqwzqfqpqqqqqqqqqqqqqqqqqqqcqpjsp5zyg3zyg3';

  void _paste() {
    setState(() {
      _invoiceController.text = _mockInvoice;
      _invoicePasted = true;
    });
  }

  @override
  void dispose() {
    _invoiceController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_sent) return _SuccessView(onBack: () => Navigator.pop(context));

    return Scaffold(
      backgroundColor: kBackground,
      appBar: AppBar(
        leading: IconButton(icon: const Icon(Icons.arrow_back_rounded), onPressed: () => Navigator.pop(context)),
        title: const Text('Send Bitcoin'),
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(24, 16, 24, 32),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Available: 45,000 sats', style: TextStyle(color: kMuted, fontSize: 14)),
                  const SizedBox(height: 28),

                  const Text('LIGHTNING INVOICE', style: TextStyle(color: kMuted, fontSize: 11, letterSpacing: 1.2, fontWeight: FontWeight.w500)),
                  const SizedBox(height: 10),
                  Container(
                    decoration: BoxDecoration(
                      color: kSurface,
                      borderRadius: BorderRadius.circular(kRadius),
                      boxShadow: kCardShadow,
                    ),
                    child: TextField(
                      controller: _invoiceController,
                      style: const TextStyle(color: kText, fontFamily: 'monospace', fontSize: 12),
                      maxLines: 3,
                      decoration: InputDecoration(
                        hintText: 'lnbc...',
                        border: InputBorder.none,
                        enabledBorder: InputBorder.none,
                        focusedBorder: InputBorder.none,
                        filled: false,
                        contentPadding: const EdgeInsets.fromLTRB(16, 14, 48, 14),
                        suffixIcon: IconButton(
                          icon: const Icon(Icons.content_paste_outlined, color: kAccent, size: 20),
                          onPressed: _paste,
                        ),
                      ),
                    ),
                  ),

                  if (_invoicePasted) ...[
                    const SizedBox(height: 28),

                    const Text('AMOUNT', style: TextStyle(color: kMuted, fontSize: 11, letterSpacing: 1.2, fontWeight: FontWeight.w500)),
                    const SizedBox(height: 10),
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(color: kAccent, borderRadius: BorderRadius.circular(kRadius), boxShadow: kCardShadow),
                      child: const Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('10,000 sats', style: TextStyle(color: kText, fontSize: 32, fontWeight: FontWeight.bold, letterSpacing: -0.5)),
                          SizedBox(height: 4),
                          Text('≈ \$0.06', style: TextStyle(color: Color(0xFF3B7A00), fontSize: 16)),
                        ],
                      ),
                    ),

                    const SizedBox(height: 14),

                    Container(
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(color: kSurface, borderRadius: BorderRadius.circular(kRadius), boxShadow: kCardShadow),
                      child: const Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Icon(Icons.info_outline_rounded, color: kMuted, size: 15),
                          SizedBox(width: 10),
                          Expanded(
                            child: Text(
                              'Double check the invoice before sending. Payments are irreversible.',
                              style: TextStyle(color: kMuted, fontSize: 12, height: 1.5),
                            ),
                          ),
                        ],
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
                onPressed: _invoicePasted ? () => setState(() => _sent = true) : null,
                child: Text(_invoicePasted ? 'Send 10,000 sats' : 'Paste an Invoice First'),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _SuccessView extends StatelessWidget {
  final VoidCallback onBack;
  const _SuccessView({required this.onBack});

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
                width: 72,
                height: 72,
                decoration: BoxDecoration(color: kAccent, borderRadius: BorderRadius.circular(kRadius)),
                alignment: Alignment.center,
                child: const Icon(Icons.check_rounded, color: kText, size: 38),
              ),
              const SizedBox(height: 24),
              const Text('Payment Sent', style: TextStyle(color: kText, fontSize: 32, fontWeight: FontWeight.bold, letterSpacing: -0.5)),
              const SizedBox(height: 8),
              const Text('Your Lightning payment was sent.', style: TextStyle(color: kMuted, fontSize: 15)),
              const SizedBox(height: 40),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(22),
                decoration: BoxDecoration(color: kSurface, borderRadius: BorderRadius.circular(kRadius), boxShadow: kCardShadow),
                child: const Column(
                  children: [
                    _Row('Amount sent', '10,000 sats'),
                    SizedBox(height: 14),
                    _Row('Remaining', '35,000 sats'),
                    SizedBox(height: 14),
                    _Row('Network', 'Lightning'),
                  ],
                ),
              ),
              const Spacer(),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(onPressed: onBack, child: const Text('Back to Wallet')),
              ),
              const SizedBox(height: 32),
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
