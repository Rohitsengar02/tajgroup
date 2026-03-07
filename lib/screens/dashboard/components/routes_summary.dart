import 'package:flutter/material.dart';
import '../../../../constants.dart';

class RoutesSummary extends StatelessWidget {
  const RoutesSummary({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(defaultPadding),
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Routes & Field Operations",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: textPrimaryColor,
            ),
          ),
          const SizedBox(height: defaultPadding),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildMetricCard("Active Routes", "12", Icons.route_outlined, primaryColor),
              const SizedBox(width: 8),
              _buildMetricCard("Visits Today", "156", Icons.directions_walk_outlined, Color(0xFFF97316)),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildMetricCard("Completed", "132", Icons.check_circle_outline, successColor),
              const SizedBox(width: 8),
              _buildMetricCard("Missed", "24", Icons.cancel_outlined, errorColor),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildMetricCard(String title, String value, IconData icon, Color color) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: surfaceColor,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: textSecondaryColor.withValues(alpha: 0.1)),
        ),
        child: Column(
          children: [
             Icon(icon, color: color, size: 24),
             const SizedBox(height: 8),
             Text(title, style: const TextStyle(fontSize: 12, color: textSecondaryColor, fontWeight: FontWeight.w600)),
             const SizedBox(height: 4),
             Text(value, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: textPrimaryColor)),
          ],
        ),
      ),
    );
  }
}
