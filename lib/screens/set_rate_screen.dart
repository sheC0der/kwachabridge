import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../theme.dart';
import '../data/mock_data.dart';
import '../services/app_session.dart';
import '../services/firebase_service.dart';

class SetRateScreen extends StatefulWidget {
  const SetRateScreen({super.key});

  @override
  State<SetRateScreen> createState() => _SetRateScreenState();
}

class _SetRateScreenState extends State<SetRateScreen> {
  final _controller = TextEditingController();
  bool _loading = false;

  @override
  void initState() {
    super.initState();
    _controller.text = MockData.agentRate.toString();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  int get _rate => int.tryParse(_controller.text) ?? MockData.agentRate;

  Future<void> _save() async {
    final rate = _rate;
    if (rate <= 0) return;

    setState(() => _loading = true);
    try {
      if (AppSession.firebaseReady && AppSession.publicKey.isNotEmpty) {
        await FirebaseService.updateRate(
          publicKey: AppSession.publicKey,
          rate: rate,
          isAvailable: true,
        );
      }
      if (mounted) Navigator.pop(context);
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
    return Scaffold(
      backgroundColor: kBackground,
      appBar: AppBar(
        leading: IconButton(icon: const Icon(Icons.arrow_back_rounded), onPressed: () => Navigator.pop(context)),
        title: const Text('Set Your Rate'),
      ),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(24, 16, 24, 32),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Your Exchange Rate', style: TextStyle(color: kText, fontSize: 28, fontWeight: FontWeight.bold, letterSpacing: -0.5)),
            const SizedBox(height: 6),
            const Text('Set how many MK you accept per 1 USD.', style: TextStyle(color: kMuted, fontSize: 14)),
            const SizedBox(height: 32),

            const Text('MK PER 1 USD', style: TextStyle(color: kMuted, fontSize: 11, letterSpacing: 1.2, fontWeight: FontWeight.w500)),
            const SizedBox(height: 10),
            TextField(
              controller: _controller,
              keyboardType: TextInputType.number,
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              style: const TextStyle(color: kText, fontSize: 28, fontWeight: FontWeight.bold),
              decoration: const InputDecoration(
                hintText: '1700',
                prefix: Text('MK ', style: TextStyle(color: kMuted, fontSize: 18, fontWeight: FontWeight.w400)),
              ),
              onChanged: (_) => setState(() {}),
            ),

            const SizedBox(height: 28),

            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(color: kSurface, borderRadius: BorderRadius.circular(kRadius), boxShadow: kCardShadow),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('PREVIEW', style: TextStyle(color: kMuted, fontSize: 11, letterSpacing: 1.2, fontWeight: FontWeight.w600)),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('1 USD =', style: TextStyle(color: kMuted, fontSize: 15)),
                      Text(
                        'MK ${_rate.toString().replaceAllMapped(RegExp(r'\B(?=(\d{3})+(?!\d))'), (_) => ',')}',
                        style: const TextStyle(color: kText, fontSize: 15, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('MK 5,000 →', style: TextStyle(color: kMuted, fontSize: 15)),
                      Text(
                        '≈ ${_rate > 0 ? (5000 / _rate / 6535 * 100000000).round() : 0} sats',
                        style: const TextStyle(color: kText, fontSize: 15, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            const Spacer(),

            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _loading ? null : _save,
                child: _loading
                    ? const SizedBox(height: 22, width: 22, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
                    : const Text('Save Rate'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
