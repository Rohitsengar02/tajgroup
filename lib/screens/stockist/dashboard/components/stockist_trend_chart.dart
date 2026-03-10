import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:tajpro/constants.dart';

class StockistTrendChart extends StatelessWidget {
  const StockistTrendChart({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(28),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(30),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.015),
            blurRadius: 25,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Regional Growth Trend",
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.w900, color: Color(0xFF1E293B))),
                  SizedBox(height: 4),
                  Text("Net Procurement vs Dispatch",
                      style: TextStyle(fontSize: 13, color: Colors.grey, fontWeight: FontWeight.w600)),
                ],
              ),
              _buildTrendBadge(),
            ],
          ),
          const SizedBox(height: 40),
          SizedBox(
            height: 300,
            child: LineChart(
              LineChartData(
                gridData: const FlGridData(show: false),
                titlesData: FlTitlesData(
                  show: true,
                  rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: 30,
                      interval: 1,
                      getTitlesWidget: (value, meta) {
                        const style = TextStyle(color: Colors.grey, fontWeight: FontWeight.w700, fontSize: 11);
                        switch (value.toInt()) {
                          case 0: return const Text('JAN', style: style);
                          case 2: return const Text('MAR', style: style);
                          case 4: return const Text('MAY', style: style);
                          case 6: return const Text('JUL', style: style);
                          case 8: return const Text('SEP', style: style);
                          case 10: return const Text('NOV', style: style);
                        }
                        return const Text('');
                      },
                    ),
                  ),
                  leftTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                ),
                borderData: FlBorderData(show: false),
                lineBarsData: [
                  LineChartBarData(
                    spots: const [
                      FlSpot(0, 3),
                      FlSpot(2, 2.5),
                      FlSpot(4, 4),
                      FlSpot(6, 3.5),
                      FlSpot(8, 5),
                      FlSpot(10, 4.2),
                    ],
                    isCurved: true,
                    gradient: const LinearGradient(colors: [Color(0xFF6C5CE7), Color(0xFF3B82F6)]),
                    barWidth: 4,
                    isStrokeCapRound: true,
                    dotData: const FlDotData(show: false),
                    belowBarData: BarAreaData(
                      show: true,
                      gradient: LinearGradient(
                        colors: [const Color(0xFF6C5CE7).withOpacity(0.2), const Color(0xFF3B82F6).withOpacity(0)],
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                      ),
                    ),
                  ),
                  LineChartBarData(
                    spots: const [
                      FlSpot(0, 1.5),
                      FlSpot(2, 3),
                      FlSpot(4, 2),
                      FlSpot(6, 4.5),
                      FlSpot(8, 3.2),
                      FlSpot(10, 5),
                    ],
                    isCurved: true,
                    color: const Color(0xFF10B981),
                    barWidth: 3,
                    dashArray: [5, 5],
                    dotData: const FlDotData(show: false),
                  ),
                ],
                lineTouchData: LineTouchData(
                   touchTooltipData: LineTouchTooltipData(
                      getTooltipColor: (_) => const Color(0xFF1E293B),
                      getTooltipItems: (touchedSpots) {
                         return touchedSpots.map((spot) {
                            return LineTooltipItem(
                               "₹ ${spot.y.toStringAsFixed(1)}L",
                               const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                            );
                         }).toList();
                      }
                   )
                )
              ),
            ),
          ),
          const SizedBox(height: 20),
          _buildLegend(),
        ],
      ),
    );
  }

  Widget _buildTrendBadge() {
    return Container(
       padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
       decoration: BoxDecoration(color: const Color(0xFFE8FDF5), borderRadius: BorderRadius.circular(12)),
       child: const Row(children: [Icon(Icons.trending_up, color: Color(0xFF10B981), size: 16), SizedBox(width: 8), Text("+24% Growth", style: TextStyle(color: Color(0xFF10B981), fontWeight: FontWeight.w900, fontSize: 12))]),
    );
  }

  Widget _buildLegend() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Row(children: [Container(width: 12, height: 4, decoration: BoxDecoration(color: const Color(0xFF6C5CE7), borderRadius: BorderRadius.circular(2))), const SizedBox(width: 8), const Text("Actual Sales", style: TextStyle(color: Colors.grey, fontSize: 13, fontWeight: FontWeight.bold))]),
        const SizedBox(width: 24),
        Row(children: [Container(width: 12, height: 4, decoration: BoxDecoration(color: const Color(0xFF10B981), borderRadius: BorderRadius.circular(2))), const SizedBox(width: 8), const Text("Projected Hub Growth", style: TextStyle(color: Colors.grey, fontSize: 13, fontWeight: FontWeight.bold))]),
      ],
    );
  }
}
