import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../theme.dart';
import '../services/app_session.dart';

class IdentitySetupScreen extends StatefulWidget {
  const IdentitySetupScreen({super.key});

  @override
  State<IdentitySetupScreen> createState() => _IdentitySetupScreenState();
}

class _IdentitySetupScreenState extends State<IdentitySetupScreen> {
  late final String _publicKey;
  late final String _privateKey;

  @override
  void initState() {
    super.initState();
    _publicKey = _generateHex(64);
    _privateKey = _generateHex(64);
  }

  String _generateHex(int length) {
    const chars = '0123456789abcdef';
    final random = Random.secure();
    return List.generate(length, (_) => chars[random.nextInt(chars.length)]).join();
  }

  void _copyPrivateKey() {
    Clipboard.setData(ClipboardData(text: _privateKey));
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Private key copied — keep it safe, never share it.')),
    );
  }

  void _showWhatIsThis() {
    showModalBottomSheet(
      context: context,
      backgroundColor: kSurface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(kRadius)),
      ),
      builder: (_) => Padding(
        padding: const EdgeInsets.fromLTRB(28, 28, 28, 48),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const [
            Text(
              'Your Nostr Identity',
              style: TextStyle(color: kText, fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 16),
            Text(
              'KwachaBridge uses Nostr, an open protocol, for identity. Your keypair is generated on your device and never sent to any server.',
              style: TextStyle(color: kMuted, fontSize: 14, height: 1.7),
            ),
            SizedBox(height: 12),
            Text(
              'Your private key controls your identity. Back it up somewhere safe. Losing it means losing access to your account permanently.',
              style: TextStyle(color: kMuted, fontSize: 14, height: 1.7),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBackground,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 28),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 16),
              const Text(
                'Your Identity on\nKwachaBridge',
                style: TextStyle(
                  color: kText,
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  height: 1.2,
                  letterSpacing: -0.5,
                ),
              ),
              const SizedBox(height: 12),
              const Text(
                'No email. No password. Just one tap.',
                style: TextStyle(color: kMuted, fontSize: 16),
              ),
              const SizedBox(height: 40),

              const Text(
                'PUBLIC KEY',
                style: TextStyle(color: kMuted, fontSize: 11, letterSpacing: 1.2, fontWeight: FontWeight.w500),
              ),
              const SizedBox(height: 10),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(18),
                decoration: BoxDecoration(
                  color: kSurface,
                  borderRadius: BorderRadius.circular(kRadius),
                  boxShadow: kCardShadow,
                ),
                child: Text(
                  _publicKey,
                  style: const TextStyle(
                    color: kMuted,
                    fontFamily: 'monospace',
                    fontSize: 12,
                    height: 1.6,
                    letterSpacing: 0.5,
                  ),
                ),
              ),

              const SizedBox(height: 20),
              Row(
                children: [
                  GestureDetector(
                    onTap: _copyPrivateKey,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                      decoration: BoxDecoration(
                        color: kSurface,
                        borderRadius: BorderRadius.circular(kRadiusPill),
                        boxShadow: kCardShadow,
                      ),
                      child: const Text(
                        'Copy Private Key',
                        style: TextStyle(color: kText, fontSize: 13, fontWeight: FontWeight.w500),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  GestureDetector(
                    onTap: _showWhatIsThis,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                      decoration: BoxDecoration(
                        color: kSurface,
                        borderRadius: BorderRadius.circular(kRadiusPill),
                        boxShadow: kCardShadow,
                      ),
                      child: const Text(
                        'What is this?',
                        style: TextStyle(color: kMuted, fontSize: 13, fontWeight: FontWeight.w500),
                      ),
                    ),
                  ),
                ],
              ),

              const Spacer(),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    final role = ModalRoute.of(context)?.settings.arguments as String? ?? 'customer';
                    AppSession.publicKey = _publicKey;
                    AppSession.role = role;
                    Navigator.pushNamed(
                      context,
                      role == 'agent' ? '/agent-profile-setup' : '/customer-profile-setup',
                      arguments: {'publicKey': _publicKey, 'role': role},
                    );
                  },
                  child: const Text('Continue'),
                ),
              ),
              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }
}
