import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:tajpro/constants.dart';

class StockistDistributionChart extends StatelessWidget {
  const StockistDistributionChart({super.key});

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
                  Text("Regional Supply Chain",
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.w900, color: Color(0xFF1E293B))),
                  SizedBox(height: 4),
                  Text("Monthly Procurement Tracking",
                      style: TextStyle(fontSize: 13, color: Colors.grey, fontWeight: FontWeight.w600)),
                ],
              ),
              _buildMonthFilter(),
            ],
          ),
          const SizedBox(height: 40),
          SizedBox(
            height: 300,
            child: BarChart(
              BarChartData(
                alignment: BarChartAlignment.spaceAround,
                maxY: 200,
                barTouchData: BarTouchData(
                  touchTooltipData: BarTouchTooltipData(
                    getTooltipColor: (_) => const Color(0xFF1E293B),
                    tooltipPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                    tooltipMargin: 12,
                    getTooltipItem: (group, groupIndex, rod, rodIndex) {
                      return BarTooltipItem(
                        "₹ ${rod.toY.toStringAsFixed(1)}L",
                        const TextStyle(color: Colors.white, fontWeight: FontWeight.w800, fontSize: 13),
                      );
                    },
                  ),
                ),
                titlesData: FlTitlesData(
                  show: true,
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      getTitlesWidget: (value, meta) {
                        const style = TextStyle(color: Colors.grey, fontWeight: FontWeight.w700, fontSize: 12);
                        String text;
                        switch (value.toInt()) {
                          case 0: text = 'Wk 1'; break;
                          case 1: text = 'Wk 2'; break;
                          case 2: text = 'Wk 3'; break;
                          case 3: text = 'Wk 4'; break;
                          default: text = ''; break;
                        }
                        return Padding(padding: const EdgeInsets.only(top: 16.0), child: Text(text, style: style));
                      },
                      reservedSize: 38,
                    ),
                  ),
                  leftTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                ),
                gridData: const FlGridData(show: false),
                borderData: FlBorderData(show: false),
                barGroups: [
                  _buildBarGroup(0, 150, [const Color(0xFF6C5CE7), const Color(0xFF3B82F6)]),
                  _buildBarGroup(1, 182, [const Color(0xFF3B82F6), const Color(0xFF10B981)]),
                  _buildBarGroup(2, 120, [const Color(0xFF10B981), const Color(0xFFF59E0B)]),
                  _buildBarGroup(3, 145, [const Color(0xFFF59E0B), const Color(0xFF6C5CE7)]),
                ],
              ),
              swapAnimationDuration: const Duration(milliseconds: 1000),
              swapAnimationCurve: Curves.easeOutQuart,
            ),
          ),
          const SizedBox(height: 24),
          _buildLegend(),
        ],
      ),
    );
  }

  BarChartGroupData _buildBarGroup(int x, double y, List<Color> colors) {
    return BarChartGroupData(
      x: x,
      barRods: [
        BarChartRodData(
          toY: y,
          width: 38,
          borderRadius: BorderRadius.circular(12),
          gradient: LinearGradient(colors: colors, begin: Alignment.bottomCenter, end: Alignment.topCenter),
          backDrawRodData: BackgroundBarChartRodData(
            show: true,
            toY: 200,
            color: const Color(0xFFF1F5F9),
          ),
        ),
      ],
    );
  }

  Widget _buildMonthFilter() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      decoration: BoxDecoration(color: const Color(0xFFF8FAFC), borderRadius: BorderRadius.circular(14)),
      child: const Row(children: [Text("This Quarter", style: TextStyle(fontWeight: FontWeight.w900, fontSize: 13, color: Colors.black87)), SizedBox(width: 8), Icon(Icons.keyboard_arrow_down_rounded, size: 18)]),
    );
  }

  Widget _buildLegend() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _buildLegendItem("Secondary Sales", const Color(0xFF1B254B)),
        const SizedBox(width: 24),
        _buildLegendItem("Primary Supply", const Color(0xFF3B82F6).withOpacity(0.2)),
      ],
    );
  }

  Widget _buildLegendItem(String label, Color color) {
    return Row(
      children: [
        Container(width: 12, height: 12, decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(4))),
        const SizedBox(width: 8),
        Text(label, style: const TextStyle(color: Colors.grey, fontSize: 13, fontWeight: FontWeight.bold)),
      ],
    );
  }
}
