import 'package:flutter/material.dart';
import '../theme.dart';

class RoleSelectionScreen extends StatelessWidget {
  const RoleSelectionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBackground,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 28),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 64),
              const Text(
                'Welcome to\nKwachaBridge',
                style: TextStyle(
                  color: kText,
                  fontSize: 36,
                  fontWeight: FontWeight.bold,
                  letterSpacing: -0.5,
                  height: 1.15,
                ),
              ),
              const SizedBox(height: 10),
              const Text(
                'How would you like to get started?',
                style: TextStyle(color: kMuted, fontSize: 16),
              ),
              const SizedBox(height: 48),
              _RoleCard(
                icon: Icons.swap_horiz_rounded,
                label: 'Agent',
                description: 'I exchange mobile money for Bitcoin',
                onTap: () => Navigator.pushNamed(context, '/identity-setup', arguments: 'agent'),
              ),
              const SizedBox(height: 16),
              _RoleCard(
                icon: Icons.bolt_rounded,
                label: 'Customer',
                description: 'I want to buy Bitcoin with mobile money',
                onTap: () => Navigator.pushNamed(context, '/identity-setup', arguments: 'customer'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _RoleCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final String description;
  final VoidCallback onTap;

  const _RoleCard({
    required this.icon,
    required this.label,
    required this.description,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: kSurface,
          borderRadius: BorderRadius.circular(kRadius),
          boxShadow: kCardShadow,
        ),
        child: Row(
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: kAccent,
                borderRadius: BorderRadius.circular(kRadiusSm),
              ),
              alignment: Alignment.center,
              child: Icon(icon, color: kText, size: 24),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    label,
                    style: const TextStyle(
                      color: kText,
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    description,
                    style: const TextStyle(color: kMuted, fontSize: 13),
                  ),
                ],
              ),
            ),
            const Icon(Icons.arrow_forward_ios_rounded, color: kMuted, size: 16),
          ],
        ),
      ),
    );
  }
}
