import 'package:flutter/material.dart';
import '../theme.dart';
import '../data/mock_data.dart';
import '../data/agent_model.dart';
import '../services/app_session.dart';
import '../services/firebase_service.dart';

class CustomerDiscoveryScreen extends StatelessWidget {
  const CustomerDiscoveryScreen({super.key});

  String _initials(String name) {
    final parts = name.trim().split(' ');
    if (parts.length >= 2) return '${parts[0][0]}${parts[1][0]}'.toUpperCase();
    return name.isNotEmpty ? name[0].toUpperCase() : '?';
  }

  List<AgentModel> get _mockAgents =>
      MockData.agents.map(AgentModel.fromMock).toList();

  Map<String, dynamic> _agentArgs(AgentModel a) => {
        'name': a.displayName,
        'provider': a.mobileMoneyProvider,
        'rate': a.rate,
        'available': a.isAvailable,
        'stars': a.reputationScore,
        'swaps': a.completedSwaps,
        'publicKey': a.publicKey,
        'phoneNumber': a.phoneNumber,
      };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBackground,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 20, 16, 0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Find an Agent',
                    style: TextStyle(color: kText, fontSize: 28, fontWeight: FontWeight.bold, letterSpacing: -0.5),
                  ),
                  TextButton.icon(
                    onPressed: () {},
                    icon: const Icon(Icons.sort_rounded, color: kMuted, size: 18),
                    label: const Text('Best Rate', style: TextStyle(color: kMuted, fontSize: 13)),
                  ),
                ],
              ),
            ),
            const Padding(
              padding: EdgeInsets.fromLTRB(24, 4, 24, 0),
              child: Text(
                'Compare rates and swap kwacha for Bitcoin',
                style: TextStyle(color: kMuted, fontSize: 13),
              ),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: AppSession.firebaseReady
                  ? StreamBuilder<List<AgentModel>>(
                      stream: FirebaseService.availableAgentsStream(),
                      builder: (ctx, snap) {
                        if (snap.connectionState == ConnectionState.waiting) {
                          return _list(context, _mockAgents);
                        }
                        final agents = snap.hasData && snap.data!.isNotEmpty
                            ? snap.data!
                            : _mockAgents;
                        return _list(context, agents);
                      },
                    )
                  : _list(context, _mockAgents),
            ),
          ],
        ),
      ),
    );
  }

  Widget _list(BuildContext context, List<AgentModel> agents) {
    return ListView.separated(
      padding: const EdgeInsets.fromLTRB(24, 4, 24, 40),
      itemCount: agents.length,
      separatorBuilder: (ctx, i) => const SizedBox(height: 14),
      itemBuilder: (ctx, i) {
        final a = agents[i];
        return _AgentCard(
          name: a.displayName,
          provider: a.mobileMoneyProvider,
          rate: a.rate,
          available: a.isAvailable,
          stars: a.reputationScore,
          initials: _initials(a.displayName),
          onSwap: a.isAvailable
              ? () => Navigator.pushNamed(context, '/agent-detail', arguments: _agentArgs(a))
              : null,
        );
      },
    );
  }
}

class _AgentCard extends StatelessWidget {
  final String name;
  final String provider;
  final int rate;
  final bool available;
  final double stars;
  final String initials;
  final VoidCallback? onSwap;

  const _AgentCard({
    required this.name, required this.provider, required this.rate,
    required this.available, required this.stars, required this.initials,
    required this.onSwap,
  });

  static String _fmt(int n) =>
      n.toString().replaceAllMapped(RegExp(r'\B(?=(\d{3})+(?!\d))'), (m) => ',');

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: kSurface,
        borderRadius: BorderRadius.circular(kRadius),
        boxShadow: kCardShadow,
      ),
      child: Row(
        children: [
          Stack(
            children: [
              Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: kAccent.withValues(alpha: 0.2),
                ),
                alignment: Alignment.center,
                child: Text(initials, style: const TextStyle(color: kText, fontWeight: FontWeight.bold, fontSize: 16)),
              ),
              if (available)
                Positioned(
                  right: 0,
                  bottom: 0,
                  child: Container(
                    width: 13,
                    height: 13,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: const Color(0xFF4CAF50),
                      border: Border.all(color: kSurface, width: 2),
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(name, style: const TextStyle(color: kText, fontSize: 15, fontWeight: FontWeight.w600)),
                const SizedBox(height: 2),
                Text(provider, style: const TextStyle(color: kMuted, fontSize: 12)),
                const SizedBox(height: 4),
                Row(
                  children: [
                    const Icon(Icons.star_rounded, color: kAccent, size: 14),
                    const SizedBox(width: 3),
                    Text('$stars', style: const TextStyle(color: kMuted, fontSize: 12)),
                    if (!available) ...[
                      const SizedBox(width: 8),
                      const Text('Offline', style: TextStyle(color: kMuted, fontSize: 11)),
                    ],
                  ],
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text('MK ${_fmt(rate)}', style: const TextStyle(color: kText, fontSize: 15, fontWeight: FontWeight.bold)),
              const Text('per \$1', style: TextStyle(color: kMuted, fontSize: 11)),
              const SizedBox(height: 10),
              GestureDetector(
                onTap: onSwap,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 8),
                  decoration: BoxDecoration(
                    color: available ? kAccent : kBorder,
                    borderRadius: BorderRadius.circular(kRadiusPill),
                  ),
                  child: Text(
                    'Swap',
                    style: TextStyle(
                      color: available ? kText : kMuted,
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
