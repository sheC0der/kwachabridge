import 'dart:math' show sin;
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../theme.dart';

class SavingsScreen extends StatelessWidget {
  const SavingsScreen({super.key});

  static List<FlSpot> _satSpots() => List.generate(
        30,
        (i) => FlSpot(
          i.toDouble(),
          28000 + (i / 29) * 6000 + sin(i * 0.8) * 320,
        ),
      );

  static List<FlSpot> _mkSpots() => List.generate(
        30,
        (i) => FlSpot(
          i.toDouble(),
          28000 - (i / 29) * 1400 + sin(i * 0.6 + 2) * 160,
        ),
      );

  void _showLockSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: kSurface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(kRadius)),
      ),
      builder: (ctx) => _LockSatsSheet(
        onConfirm: () {
          Navigator.pop(ctx);
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Sats locked into savings')),
          );
        },
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
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(24, 8, 24, 32),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Bitcoin Savings',
                      style: TextStyle(color: kText, fontSize: 28, fontWeight: FontWeight.bold, letterSpacing: -0.5),
                    ),
                    const SizedBox(height: 4),
                    const Text(
                      'Your savings grow as kwacha loses value',
                      style: TextStyle(color: kMuted, fontSize: 14),
                    ),

                    const SizedBox(height: 24),

                    // Stat cards
                    Row(
                      children: [
                        Expanded(
                          child: _StatCard(
                            label: 'Saved',
                            value: '20,000 sats',
                            sub: '≈ \$0.13',
                          ),
                        ),
                        const SizedBox(width: 14),
                        Expanded(
                          child: _StatCard(
                            label: 'Current Value',
                            value: 'MK 34,000',
                            sub: '+21.4%',
                            positiveAccent: true,
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 14),

                    // Performance banner
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                      decoration: BoxDecoration(color: kAccent, borderRadius: BorderRadius.circular(kRadius), boxShadow: kCardShadow),
                      child: Row(
                        children: [
                          const Icon(Icons.trending_up_rounded, color: Color(0xFF3B7A00), size: 22),
                          const SizedBox(width: 12),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: const [
                              Text('+MK 6,000 since you started saving', style: TextStyle(color: kText, fontSize: 14, fontWeight: FontWeight.bold)),
                              SizedBox(height: 2),
                              Text('vs. MK −1,400 in a kwacha savings account', style: TextStyle(color: Color(0xFF3B7A00), fontSize: 12)),
                            ],
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 20),

                    // Chart card
                    Container(
                      padding: const EdgeInsets.fromLTRB(12, 20, 16, 8),
                      decoration: BoxDecoration(color: kSurface, borderRadius: BorderRadius.circular(kRadius), boxShadow: kCardShadow),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Padding(
                            padding: EdgeInsets.only(left: 8),
                            child: Text('30-DAY PERFORMANCE', style: TextStyle(color: kMuted, fontSize: 11, letterSpacing: 1.2, fontWeight: FontWeight.w600)),
                          ),
                          const SizedBox(height: 16),
                          SizedBox(
                            height: 180,
                            child: LineChart(
                              LineChartData(
                                minX: 0,
                                maxX: 29,
                                minY: 24000,
                                maxY: 36500,
                                lineBarsData: [
                                  // Sats-in-kwacha line
                                  LineChartBarData(
                                    spots: _satSpots(),
                                    isCurved: true,
                                    curveSmoothness: 0.35,
                                    color: kAccent,
                                    barWidth: 2.5,
                                    dotData: const FlDotData(show: false),
                                    belowBarData: BarAreaData(
                                      show: true,
                                      color: kAccent.withValues(alpha: 0.12),
                                    ),
                                  ),
                                  // Kwacha savings account line
                                  LineChartBarData(
                                    spots: _mkSpots(),
                                    isCurved: true,
                                    curveSmoothness: 0.35,
                                    color: kMuted,
                                    barWidth: 2,
                                    dotData: const FlDotData(show: false),
                                    belowBarData: BarAreaData(show: false),
                                    dashArray: [6, 4],
                                  ),
                                ],
                                gridData: const FlGridData(show: false),
                                borderData: FlBorderData(show: false),
                                lineTouchData: const LineTouchData(enabled: false),
                                titlesData: FlTitlesData(
                                  topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                                  rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                                  leftTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                                  bottomTitles: AxisTitles(
                                    sideTitles: SideTitles(
                                      showTitles: true,
                                      reservedSize: 28,
                                      interval: 7,
                                      getTitlesWidget: (value, meta) {
                                        String label;
                                        switch (value.toInt()) {
                                          case 0: label = 'W1'; break;
                                          case 7: label = 'W2'; break;
                                          case 14: label = 'W3'; break;
                                          case 21: label = 'W4'; break;
                                          default: return const SizedBox.shrink();
                                        }
                                        return Padding(
                                          padding: const EdgeInsets.only(top: 8),
                                          child: Text(label, style: const TextStyle(color: kMuted, fontSize: 10)),
                                        );
                                      },
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 14),

                    // Legend
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
                      decoration: BoxDecoration(color: kSurface, borderRadius: BorderRadius.circular(kRadiusSm), boxShadow: kCardShadow),
                      child: const Row(
                        children: [
                          _LegendDot(color: kAccent, solid: true),
                          SizedBox(width: 8),
                          Expanded(child: Text('Your sats in kwacha', style: TextStyle(color: kText, fontSize: 13))),
                          _LegendDot(color: kMuted, solid: false),
                          SizedBox(width: 8),
                          Expanded(child: Text('Kwacha savings account', style: TextStyle(color: kMuted, fontSize: 13))),
                        ],
                      ),
                    ),

                    const SizedBox(height: 28),

                    const Text('YOUR SAVINGS HISTORY', style: TextStyle(color: kMuted, fontSize: 11, letterSpacing: 1.2, fontWeight: FontWeight.w600)),
                    const SizedBox(height: 12),

                    const _HistoryEntry(sats: '5,000 sats', value: 'MK 8,500', date: '30 days ago'),
                    const SizedBox(height: 10),
                    const _HistoryEntry(sats: '10,000 sats', value: 'MK 16,800', date: '15 days ago'),
                    const SizedBox(height: 10),
                    const _HistoryEntry(sats: '5,000 sats', value: 'MK 8,700', date: '5 days ago'),
                  ],
                ),
              ),
            ),

            // Pinned bottom action
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 8, 24, 28),
              child: Column(
                children: [
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () => _showLockSheet(context),
                      child: const Text('Lock More Sats'),
                    ),
                  ),
                  const SizedBox(height: 12),
                  const Text(
                    'Your savings are held in Bitcoin. Value shown in kwacha is approximate and updates with market rate.',
                    textAlign: TextAlign.center,
                    style: TextStyle(color: kMuted, fontSize: 11, height: 1.6),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ── Stat Card ──────────────────────────────────────────────────────────────

class _StatCard extends StatelessWidget {
  final String label;
  final String value;
  final String sub;
  final bool positiveAccent;

  const _StatCard({required this.label, required this.value, required this.sub, this.positiveAccent = false});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(color: kSurface, borderRadius: BorderRadius.circular(kRadius), boxShadow: kCardShadow),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label.toUpperCase(), style: const TextStyle(color: kMuted, fontSize: 10, letterSpacing: 1.2, fontWeight: FontWeight.w600)),
          const SizedBox(height: 8),
          Text(value, style: const TextStyle(color: kText, fontSize: 17, fontWeight: FontWeight.bold, letterSpacing: -0.3)),
          const SizedBox(height: 3),
          Text(sub, style: TextStyle(color: positiveAccent ? const Color(0xFF3B7A00) : kMuted, fontSize: 12, fontWeight: positiveAccent ? FontWeight.w600 : FontWeight.normal)),
        ],
      ),
    );
  }
}

// ── Chart Legend Dot ───────────────────────────────────────────────────────

class _LegendDot extends StatelessWidget {
  final Color color;
  final bool solid;

  const _LegendDot({required this.color, required this.solid});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 10,
      height: 10,
      decoration: solid
          ? BoxDecoration(color: color, shape: BoxShape.circle)
          : BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: color, width: 2),
            ),
    );
  }
}

// ── History Entry ──────────────────────────────────────────────────────────

class _HistoryEntry extends StatelessWidget {
  final String sats;
  final String value;
  final String date;

  const _HistoryEntry({required this.sats, required this.value, required this.date});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(color: kSurface, borderRadius: BorderRadius.circular(kRadius), boxShadow: kCardShadow),
      child: Row(
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(color: kAccent, borderRadius: BorderRadius.circular(kRadiusSm)),
            alignment: Alignment.center,
            child: const Icon(Icons.lock_rounded, color: kText, size: 20),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(sats, style: const TextStyle(color: kText, fontSize: 14, fontWeight: FontWeight.w600)),
                const SizedBox(height: 2),
                Text(value, style: const TextStyle(color: kMuted, fontSize: 13)),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            decoration: BoxDecoration(color: kBackground, borderRadius: BorderRadius.circular(kRadiusPill)),
            child: Text(date, style: const TextStyle(color: kMuted, fontSize: 11)),
          ),
        ],
      ),
    );
  }
}

// ── Lock Sats Bottom Sheet ─────────────────────────────────────────────────

class _LockSatsSheet extends StatefulWidget {
  final VoidCallback onConfirm;
  const _LockSatsSheet({required this.onConfirm});

  @override
  State<_LockSatsSheet> createState() => _LockSatsSheetState();
}

class _LockSatsSheetState extends State<_LockSatsSheet> {
  final _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(24, 28, 24, 36),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Lock Sats', style: TextStyle(color: kText, fontSize: 20, fontWeight: FontWeight.bold)),
                GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: const Icon(Icons.close_rounded, color: kMuted),
                ),
              ],
            ),
            const SizedBox(height: 6),
            const Text('Enter how many sats to add to savings.', style: TextStyle(color: kMuted, fontSize: 13)),
            const SizedBox(height: 24),

            const Text('AMOUNT IN SATS', style: TextStyle(color: kMuted, fontSize: 11, letterSpacing: 1.2, fontWeight: FontWeight.w500)),
            const SizedBox(height: 10),
            TextField(
              controller: _controller,
              keyboardType: TextInputType.number,
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              autofocus: true,
              style: const TextStyle(color: kText, fontSize: 24, fontWeight: FontWeight.bold),
              decoration: const InputDecoration(
                hintText: '5000',
                suffix: Text('sats', style: TextStyle(color: kMuted, fontSize: 16, fontWeight: FontWeight.w400)),
              ),
            ),

            const SizedBox(height: 28),

            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: widget.onConfirm,
                child: const Text('Confirm'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
