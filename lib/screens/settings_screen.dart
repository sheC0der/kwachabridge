import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../theme.dart';
import '../data/mock_data.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBackground,
      appBar: AppBar(
        leading: IconButton(icon: const Icon(Icons.arrow_back_rounded), onPressed: () => Navigator.pop(context)),
        title: const Text('Settings'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(24, 16, 24, 48),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('IDENTITY', style: TextStyle(color: kMuted, fontSize: 11, letterSpacing: 1.2, fontWeight: FontWeight.w600)),
            const SizedBox(height: 12),

            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(color: kSurface, borderRadius: BorderRadius.circular(kRadius), boxShadow: kCardShadow),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('YOUR NOSTR PUBLIC KEY', style: TextStyle(color: kMuted, fontSize: 11, letterSpacing: 1.2, fontWeight: FontWeight.w500)),
                  const SizedBox(height: 10),
                  Text(
                    '${MockData.agentPublicKey.substring(0, 20)}...${MockData.agentPublicKey.substring(MockData.agentPublicKey.length - 8)}',
                    style: const TextStyle(color: kText, fontFamily: 'monospace', fontSize: 13, letterSpacing: 0.5),
                  ),
                  const SizedBox(height: 14),
                  GestureDetector(
                    onTap: () {
                      Clipboard.setData(const ClipboardData(text: MockData.agentPublicKey));
                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Public key copied')));
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      decoration: BoxDecoration(color: kBackground, borderRadius: BorderRadius.circular(kRadiusPill)),
                      child: const Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.copy_rounded, color: kText, size: 14),
                          SizedBox(width: 6),
                          Text('Copy Key', style: TextStyle(color: kText, fontSize: 13, fontWeight: FontWeight.w500)),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 12),

            Container(
              decoration: BoxDecoration(color: kSurface, borderRadius: BorderRadius.circular(kRadius), boxShadow: kCardShadow),
              child: ListTile(
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(kRadius)),
                contentPadding: const EdgeInsets.symmetric(horizontal: 18, vertical: 4),
                title: const Text('Switch Role', style: TextStyle(color: kText, fontSize: 15, fontWeight: FontWeight.w500)),
                subtitle: const Text('Go back to role selection', style: TextStyle(color: kMuted, fontSize: 12)),
                trailing: const Icon(Icons.arrow_forward_ios_rounded, color: kMuted, size: 14),
                onTap: () => Navigator.pushNamedAndRemoveUntil(context, '/role-selection', (route) => false),
              ),
            ),

            const SizedBox(height: 28),

            const Text('ABOUT', style: TextStyle(color: kMuted, fontSize: 11, letterSpacing: 1.2, fontWeight: FontWeight.w600)),
            const SizedBox(height: 12),

            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(color: kSurface, borderRadius: BorderRadius.circular(kRadius), boxShadow: kCardShadow),
              child: const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _AboutRow('Version', '0.1.0'),
                  SizedBox(height: 14),
                  _AboutRow('Built at', 'bitcoin++ Nairobi 2026'),
                  SizedBox(height: 14),
                  _AboutRow('Powered by', 'Pontmore · Nostr · Lightning'),
                ],
              ),
            ),

            const SizedBox(height: 32),

            const Text('DANGER ZONE', style: TextStyle(color: Color(0xFFEF4444), fontSize: 11, letterSpacing: 1.2, fontWeight: FontWeight.w600)),
            const SizedBox(height: 12),

            Container(
              decoration: BoxDecoration(
                color: kSurface,
                borderRadius: BorderRadius.circular(kRadius),
                border: Border.all(color: const Color(0xFFFFE4E4)),
                boxShadow: kCardShadow,
              ),
              child: ListTile(
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(kRadius)),
                contentPadding: const EdgeInsets.symmetric(horizontal: 18, vertical: 4),
                title: const Text('Clear Local Data', style: TextStyle(color: Color(0xFFEF4444), fontSize: 15)),
                subtitle: const Text('Removes all keys and preferences', style: TextStyle(color: kMuted, fontSize: 12)),
                trailing: const Icon(Icons.delete_outline_rounded, color: Color(0xFFEF4444), size: 18),
                onTap: () => showDialog(
                  context: context,
                  builder: (_) => AlertDialog(
                    backgroundColor: kSurface,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(kRadius)),
                    title: const Text('Clear Data?', style: TextStyle(color: kText)),
                    content: const Text(
                      'This will remove your Nostr keys from this device. Make sure you have backed them up.',
                      style: TextStyle(color: kMuted, height: 1.6),
                    ),
                    actions: [
                      TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel', style: TextStyle(color: kMuted))),
                      TextButton(
                        onPressed: () {
                          Navigator.pop(context);
                          Navigator.pushNamedAndRemoveUntil(context, '/', (route) => false);
                        },
                        child: const Text('Clear', style: TextStyle(color: Color(0xFFEF4444))),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _AboutRow extends StatelessWidget {
  final String label;
  final String value;
  const _AboutRow(this.label, this.value);

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(width: 90, child: Text(label, style: const TextStyle(color: kMuted, fontSize: 13))),
        Expanded(child: Text(value, style: const TextStyle(color: kText, fontSize: 13, fontWeight: FontWeight.w500))),
      ],
    );
  }
}
