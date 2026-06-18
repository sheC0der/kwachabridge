import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:qr_flutter/qr_flutter.dart';
import '../theme.dart';
import '../data/mock_data.dart';

class CustomerInvoiceScreen extends StatelessWidget {
  const CustomerInvoiceScreen({super.key});

  static String _fmt(int n) =>
      n.toString().replaceAllMapped(RegExp(r'\B(?=(\d{3})+(?!\d))'), (_) => ',');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBackground,
      appBar: AppBar(
        leading: IconButton(icon: const Icon(Icons.arrow_back_rounded), onPressed: () => Navigator.pop(context)),
        title: const Text('Pay Your Invoice'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(24, 16, 24, 40),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Text('AMOUNT', style: TextStyle(color: kMuted, fontSize: 11, letterSpacing: 1.2, fontWeight: FontWeight.w600)),
            const SizedBox(height: 8),
            Text(
              '${_fmt(MockData.swapSatsAmount)} sats',
              style: const TextStyle(color: kText, fontSize: 40, fontWeight: FontWeight.bold, letterSpacing: -1),
            ),
            const SizedBox(height: 4),
            const Text('≈ \$0.29', style: TextStyle(color: kMuted, fontSize: 16)),

            const SizedBox(height: 32),

            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(color: kSurface, borderRadius: BorderRadius.circular(kRadius), boxShadow: kCardShadow),
              child: QrImageView(
                data: MockData.lightningInvoice,
                version: QrVersions.auto,
                size: 220,
                backgroundColor: Colors.white,
              ),
            ),

            const SizedBox(height: 24),

            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(color: kSurface, borderRadius: BorderRadius.circular(kRadius), boxShadow: kCardShadow),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('INVOICE', style: TextStyle(color: kMuted, fontSize: 11, letterSpacing: 1.2, fontWeight: FontWeight.w600)),
                  const SizedBox(height: 8),
                  const Text(
                    MockData.lightningInvoice,
                    style: TextStyle(color: kMuted, fontFamily: 'monospace', fontSize: 11, height: 1.6),
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 12),
                  GestureDetector(
                    onTap: () {
                      Clipboard.setData(const ClipboardData(text: MockData.lightningInvoice));
                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Invoice copied')));
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      decoration: BoxDecoration(color: kBackground, borderRadius: BorderRadius.circular(kRadiusPill)),
                      child: const Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.copy_rounded, color: kText, size: 14),
                          SizedBox(width: 6),
                          Text('Copy Invoice', style: TextStyle(color: kText, fontSize: 13, fontWeight: FontWeight.w500)),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 28),

            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () => Navigator.pushReplacementNamed(context, '/customer-bitcoin-received'),
                child: const Text("I Have Paid the Invoice"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
