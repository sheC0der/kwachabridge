import 'package:flutter/material.dart';
import '../theme.dart';
import '../data/mock_data.dart';

class AgentDetailScreen extends StatelessWidget {
  const AgentDetailScreen({super.key});

  String _initials(String name) {
    final parts = name.trim().split(' ');
    if (parts.length >= 2) return '${parts[0][0]}${parts[1][0]}'.toUpperCase();
    return name.isNotEmpty ? name[0].toUpperCase() : '?';
  }

  static String _fmt(int n) =>
      n.toString().replaceAllMapped(RegExp(r'\B(?=(\d{3})+(?!\d))'), (_) => ',');

  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)?.settings.arguments as Map?;
    final name = args?['name'] as String? ?? MockData.agentName;
    final provider = args?['provider'] as String? ?? MockData.agentProvider;
    final rate = (args?['rate'] as num?)?.toInt() ?? MockData.agentRate;
    final stars = (args?['stars'] as num?)?.toDouble() ?? MockData.agentReputation;
    final swaps = (args?['swaps'] as num?)?.toInt() ?? MockData.agentSwapCount;

    return Scaffold(
      backgroundColor: kBackground,
      appBar: AppBar(
        leading: IconButton(icon: const Icon(Icons.arrow_back_rounded), onPressed: () => Navigator.pop(context)),
        title: Text(name),
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(24, 16, 24, 32),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Profile header
                  Center(
                    child: Column(
                      children: [
                        Container(
                          width: 80,
                          height: 80,
                          decoration: BoxDecoration(shape: BoxShape.circle, color: kAccent),
                          alignment: Alignment.center,
                          child: Text(_initials(name), style: const TextStyle(color: kText, fontWeight: FontWeight.bold, fontSize: 28)),
                        ),
                        const SizedBox(height: 14),
                        Text(name, style: const TextStyle(color: kText, fontSize: 22, fontWeight: FontWeight.bold, letterSpacing: -0.5)),
                        const SizedBox(height: 8),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            ...List.generate(5, (i) => Icon(Icons.star_rounded, color: i < stars.floor() ? kAccent : kBorder, size: 18)),
                            const SizedBox(width: 8),
                            Text('$stars', style: const TextStyle(color: kMuted, fontSize: 14)),
                          ],
                        ),
                        const SizedBox(height: 4),
                        Text('$swaps swaps completed', style: const TextStyle(color: kMuted, fontSize: 13)),
                      ],
                    ),
                  ),

                  const SizedBox(height: 28),

                  // Rate card
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(22),
                    decoration: BoxDecoration(color: kAccent, borderRadius: BorderRadius.circular(kRadius), boxShadow: kCardShadow),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('RATE', style: TextStyle(color: Color(0xFF3B7A00), fontSize: 11, letterSpacing: 1.2, fontWeight: FontWeight.w600)),
                        const SizedBox(height: 10),
                        Text('1 USD = MK ${_fmt(rate)}', style: const TextStyle(color: kText, fontSize: 24, fontWeight: FontWeight.bold)),
                        const SizedBox(height: 4),
                        const Text('MK 5,000 → ≈ 45,000 sats', style: TextStyle(color: Color(0xFF3B7A00), fontSize: 13)),
                        const SizedBox(height: 14),
                        Row(
                          children: [
                            const Icon(Icons.phone_android_rounded, color: Color(0xFF3B7A00), size: 15),
                            const SizedBox(width: 6),
                            Text(provider, style: const TextStyle(color: Color(0xFF3B7A00), fontSize: 13)),
                          ],
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 24),

                  const Text('REVIEWS', style: TextStyle(color: kMuted, fontSize: 11, letterSpacing: 1.2, fontWeight: FontWeight.w600)),
                  const SizedBox(height: 12),

                  ...MockData.agentReviews.map((review) => Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: Container(
                      padding: const EdgeInsets.all(18),
                      decoration: BoxDecoration(color: kSurface, borderRadius: BorderRadius.circular(kRadius), boxShadow: kCardShadow),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(review['author']!, style: const TextStyle(color: kText, fontSize: 13, fontWeight: FontWeight.w600)),
                              Row(
                                children: [
                                  ...List.generate(int.parse(review['rating']!), (_) => const Icon(Icons.star_rounded, color: kAccent, size: 13)),
                                  const SizedBox(width: 6),
                                  Text(review['date']!, style: const TextStyle(color: kMuted, fontSize: 11)),
                                ],
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          Text(review['comment']!, style: const TextStyle(color: kMuted, fontSize: 13, height: 1.5)),
                        ],
                      ),
                    ),
                  )),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(24, 8, 24, 32),
            child: SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () => Navigator.pushNamed(context, '/customer-swap-request', arguments: {
                  'name': name, 'provider': provider, 'rate': rate,
                  'publicKey': args?['publicKey'] as String? ?? '',
                  'phoneNumber': args?['phoneNumber'] as String? ?? '',
                }),
                child: const Text('Start Swap'),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
