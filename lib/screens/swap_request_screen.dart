import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../theme.dart';
import '../data/mock_data.dart';

class SwapRequestScreen extends StatefulWidget {
  const SwapRequestScreen({super.key});

  @override
  State<SwapRequestScreen> createState() => _SwapRequestScreenState();
}

class _SwapRequestScreenState extends State<SwapRequestScreen> {
  final _controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    _controller.text = MockData.swapMKAmount.toString();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  int get _mk => int.tryParse(_controller.text) ?? 0;
  int get _sats => MockData.calcSats(_mk);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBackground,
      appBar: AppBar(
        leading: IconButton(icon: const Icon(Icons.arrow_back_rounded), onPressed: () => Navigator.pop(context)),
        title: const Text('Swap Request'),
      ),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(24, 16, 24, 32),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('How much do you\nwant to swap?', style: TextStyle(color: kText, fontSize: 28, fontWeight: FontWeight.bold, letterSpacing: -0.5, height: 1.2)),
            const SizedBox(height: 10),
            const Text('Enter the MK amount to send to the agent.', style: TextStyle(color: kMuted, fontSize: 14)),
            const SizedBox(height: 32),

            const Text('KWACHA AMOUNT', style: TextStyle(color: kMuted, fontSize: 11, letterSpacing: 1.2, fontWeight: FontWeight.w500)),
            const SizedBox(height: 10),
            TextField(
              controller: _controller,
              keyboardType: TextInputType.number,
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              style: const TextStyle(color: kText, fontSize: 28, fontWeight: FontWeight.bold),
              decoration: const InputDecoration(
                hintText: '5000',
                prefix: Text('MK ', style: TextStyle(color: kMuted, fontSize: 18, fontWeight: FontWeight.w400)),
              ),
              onChanged: (_) => setState(() {}),
            ),

            const SizedBox(height: 24),

            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(color: kAccent, borderRadius: BorderRadius.circular(kRadius), boxShadow: kCardShadow),
              child: Row(
                children: [
                  const Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('YOU SEND', style: TextStyle(color: Color(0xFF3B7A00), fontSize: 11, letterSpacing: 1.2, fontWeight: FontWeight.w600)),
                        SizedBox(height: 6),
                        Text('MK 5,000', style: TextStyle(color: kText, fontSize: 20, fontWeight: FontWeight.bold)),
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
                        Text('$_sats sats', style: const TextStyle(color: kText, fontSize: 20, fontWeight: FontWeight.bold)),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),
            _DetailRow('Rate', 'MK ${MockData.agentRate.toString().replaceAllMapped(RegExp(r'\B(?=(\d{3})+(?!\d))'), (_) => ',')} / USD'),
            const SizedBox(height: 12),
            const _DetailRow('Agent', MockData.agentName),
            const SizedBox(height: 12),
            const _DetailRow('Provider', MockData.agentProvider),

            const Spacer(),

            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _mk > 0 ? () => Navigator.pushNamed(context, '/payment-instructions') : null,
                child: const Text('Continue'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _DetailRow extends StatelessWidget {
  final String label;
  final String value;
  const _DetailRow(this.label, this.value);

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
