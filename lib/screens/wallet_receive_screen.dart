import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:qr_flutter/qr_flutter.dart';
import '../theme.dart';
import '../data/mock_data.dart';

class WalletReceiveScreen extends StatefulWidget {
  const WalletReceiveScreen({super.key});

  @override
  State<WalletReceiveScreen> createState() => _WalletReceiveScreenState();
}

class _WalletReceiveScreenState extends State<WalletReceiveScreen> {
  final _amountController = TextEditingController();

  @override
  void dispose() {
    _amountController.dispose();
    super.dispose();
  }

  void _copyInvoice() {
    Clipboard.setData(const ClipboardData(text: MockData.lightningInvoice));
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Invoice copied')));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBackground,
      appBar: AppBar(
        leading: IconButton(icon: const Icon(Icons.arrow_back_rounded), onPressed: () => Navigator.pop(context)),
        title: const Text('Receive Bitcoin'),
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(24, 16, 24, 32),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const SizedBox(width: double.infinity),
                  const Text(
                    'Share your Lightning invoice',
                    textAlign: TextAlign.center,
                    style: TextStyle(color: kMuted, fontSize: 14),
                  ),
                  const SizedBox(height: 28),

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
                          style: TextStyle(color: kMuted, fontFamily: 'monospace', fontSize: 11, height: 1.7),
                          maxLines: 3,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 12),
                        GestureDetector(
                          onTap: _copyInvoice,
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                            decoration: BoxDecoration(color: kBackground, borderRadius: BorderRadius.circular(kRadiusPill)),
                            child: const Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(Icons.copy_rounded, color: kText, size: 14),
                                SizedBox(width: 6),
                                Text('Copy', style: TextStyle(color: kText, fontSize: 13, fontWeight: FontWeight.w500)),
                              ],
                            ),
                          ),
                        ),
                      ],
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
                        const Text('REQUEST SPECIFIC AMOUNT', style: TextStyle(color: kMuted, fontSize: 11, letterSpacing: 1.2, fontWeight: FontWeight.w500)),
                        const SizedBox(height: 10),
                        TextField(
                          controller: _amountController,
                          keyboardType: TextInputType.number,
                          style: const TextStyle(color: kText, fontSize: 15),
                          decoration: const InputDecoration(
                            hintText: 'Leave empty for any amount',
                            border: InputBorder.none,
                            enabledBorder: InputBorder.none,
                            focusedBorder: InputBorder.none,
                            filled: false,
                            suffixText: 'sats',
                            suffixStyle: TextStyle(color: kMuted),
                            contentPadding: EdgeInsets.zero,
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 10),
                  const Text('Anyone with a Lightning wallet can pay this invoice.', style: TextStyle(color: kMuted, fontSize: 12)),
                ],
              ),
            ),
          ),

          Padding(
            padding: const EdgeInsets.fromLTRB(24, 8, 24, 32),
            child: SizedBox(
              width: double.infinity,
              child: ElevatedButton(onPressed: _copyInvoice, child: const Text('Copy Invoice')),
            ),
          ),
        ],
      ),
    );
  }
}
