import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import '../../../constants.dart';
import '../../../responsive.dart';

class ChartsSection extends StatelessWidget {
  const ChartsSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "Sales Performance",
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: textPrimaryColor,
                  ),
            ),
          ],
        ),
        const SizedBox(height: defaultPadding),
        Container(
          padding: const EdgeInsets.all(defaultPadding),
          height: 350,
          decoration: BoxDecoration(
            color: surfaceColor,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.02),
                blurRadius: 10,
                offset: const Offset(0, 5),
              )
            ],
          ),
          child: const SalesBarChart(),
        ),
        const SizedBox(height: defaultPadding),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "Customer Orders Overview",
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: textPrimaryColor,
                  ),
            ),
          ],
        ),
        const SizedBox(height: defaultPadding),
        Container(
          padding: const EdgeInsets.all(defaultPadding),
          height: 300,
          decoration: BoxDecoration(
            color: surfaceColor,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.02),
                blurRadius: 10,
                offset: const Offset(0, 5),
              )
            ],
          ),
          child: const OrdersLineChart(),
        ),
      ],
    );
  }
}

class SalesBarChart extends StatefulWidget {
  const SalesBarChart({super.key});

  @override
  State<SalesBarChart> createState() => _SalesBarChartState();
}

class _SalesBarChartState extends State<SalesBarChart> {
  int touchedIndex = -1;

  @override
  Widget build(BuildContext context) {
    return BarChart(
      BarChartData(
        alignment: BarChartAlignment.spaceAround,
        maxY: 20,
        barTouchData: BarTouchData(
          enabled: true,
          touchCallback: (FlTouchEvent event, barTouchResponse) {
            setState(() {
              if (!event.isInterestedForInteractions ||
                  barTouchResponse == null ||
                  barTouchResponse.spot == null) {
                touchedIndex = -1;
                return;
              }
              touchedIndex = barTouchResponse.spot!.touchedBarGroupIndex;
            });
          },
          touchTooltipData: BarTouchTooltipData(
            getTooltipColor: (_) => textPrimaryColor,
            getTooltipItem: (group, groupIndex, rod, rodIndex) {
              return BarTooltipItem(
                '${_getMonthName(group.x)}\n',
                const TextStyle(
                  color: Colors.white70,
                  fontWeight: FontWeight.bold,
                  fontSize: 12,
                ),
                children: <TextSpan>[
                  TextSpan(
                    text: '₹${rod.toY.toStringAsFixed(1)}L',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              );
            },
          ),
        ),
        titlesData: FlTitlesData(
          show: true,
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              reservedSize: 38,
              getTitlesWidget: (value, meta) {
                const style = TextStyle(
                  color: textSecondaryColor,
                  fontWeight: FontWeight.w600,
                  fontSize: 12,
                );
                return SideTitleWidget(
                  meta: meta,
                  space: 8,
                  child: Text(_getMonthName(value.toInt()), style: style),
                );
              },
            ),
          ),
          leftTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              reservedSize: 40,
              getTitlesWidget: (value, meta) {
                const style = TextStyle(
                  color: textSecondaryColor,
                  fontSize: 12,
                );
                if (value % 5 != 0) return const SizedBox();
                return SideTitleWidget(
                  meta: meta,
                  child: Text('${value.toInt()}L', style: style),
                );
              },
            ),
          ),
          rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
          topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
        ),
        gridData: FlGridData(
          show: true,
          drawVerticalLine: false,
          getDrawingHorizontalLine: (value) => FlLine(
            color: textSecondaryColor.withValues(alpha: 0.1),
            strokeWidth: 1,
          ),
        ),
        borderData: FlBorderData(show: false),
        barGroups: [
          _buildBarGroup(0, 8, isTouched: touchedIndex == 0),
          _buildBarGroup(1, 10, isTouched: touchedIndex == 1),
          _buildBarGroup(2, 14, isTouched: touchedIndex == 2),
          _buildBarGroup(3, 17, isTouched: touchedIndex == 3),
          _buildBarGroup(4, 13, isTouched: touchedIndex == 4),
          _buildBarGroup(5, 10, isTouched: touchedIndex == 5),
          _buildBarGroup(6, 16, isTouched: touchedIndex == 6),
        ],
      ),
      swapAnimationDuration: const Duration(milliseconds: 600),
      swapAnimationCurve: Curves.easeInOutBack,
    );
  }

  String _getMonthName(int index) {
    switch (index) {
      case 0: return 'Jan';
      case 1: return 'Feb';
      case 2: return 'Mar';
      case 3: return 'Apr';
      case 4: return 'May';
      case 5: return 'Jun';
      case 6: return 'Jul';
      default: return '';
    }
  }

  BarChartGroupData _buildBarGroup(int x, double y, {bool isTouched = false}) {
    return BarChartGroupData(
      x: x,
      barRods: [
        BarChartRodData(
          toY: isTouched ? y + 1 : y,
          gradient: LinearGradient(
            colors: isTouched 
                ? [secondaryGradient.colors.first, secondaryGradient.colors.last]
                : [primaryGradient.colors.first, primaryGradient.colors.last],
            begin: Alignment.bottomCenter,
            end: Alignment.topCenter,
          ),
          width: isTouched ? 24 : 20,
          borderRadius: BorderRadius.circular(6),
          backDrawRodData: BackgroundBarChartRodData(
            show: true,
            toY: 20,
            color: textSecondaryColor.withValues(alpha: 0.05),
          ),
        ),
      ],
    );
  }
}

class OrdersLineChart extends StatelessWidget {
  const OrdersLineChart({super.key});

  @override
  Widget build(BuildContext context) {
    return LineChart(
      LineChartData(
        lineTouchData: LineTouchData(
          handleBuiltInTouches: true,
          touchTooltipData: LineTouchTooltipData(
            getTooltipColor: (_) => textPrimaryColor,
          ),
        ),
        gridData: FlGridData(
          show: true,
          drawVerticalLine: false,
          getDrawingHorizontalLine: (value) => FlLine(
            color: textSecondaryColor.withValues(alpha: 0.1),
            strokeWidth: 1,
          ),
        ),
        titlesData: FlTitlesData(
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              getTitlesWidget: (value, meta) {
                const style = TextStyle(
                  color: textSecondaryColor,
                  fontWeight: FontWeight.bold,
                  fontSize: 12,
                );
                if (value.toInt() % 2 != 0) return const SizedBox();
                return SideTitleWidget(meta: meta, child: Text('Day ${value.toInt()}', style: style));
              },
            ),
          ),
          leftTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
          rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
          topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
        ),
        borderData: FlBorderData(show: false),
        minX: 0,
        maxX: 14,
        minY: 0,
        maxY: 6,
        lineBarsData: [
          LineChartBarData(
            isCurved: true,
            gradient: secondaryGradient,
            barWidth: 4,
            isStrokeCapRound: true,
            dotData: const FlDotData(show: false),
            belowBarData: BarAreaData(
              show: true,
              gradient: LinearGradient(
                colors: [
                  secondaryGradient.colors.first.withValues(alpha: 0.3),
                  secondaryGradient.colors.first.withValues(alpha: 0.0),
                ],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
            spots: const [
              FlSpot(0, 3), FlSpot(2, 2), FlSpot(4, 5), FlSpot(6, 3.1),
              FlSpot(8, 4), FlSpot(10, 3.5), FlSpot(12, 5), FlSpot(14, 4.5),
            ],
          ),
        ],
      ),
      duration: const Duration(milliseconds: 800),
      curve: Curves.elasticOut,
    );
  }
}
