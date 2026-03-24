import 'package:flutter/material.dart';
import '../../../../constants.dart';

class AiInsightsPanel extends StatelessWidget {
  const AiInsightsPanel({super.key});

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
          Row(
            children: [
              const Text(
                "AI Insights",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: textPrimaryColor,
                ),
              ),
              const SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  gradient: secondaryGradient,
                  borderRadius: BorderRadius.circular(6),
                ),
                child: const Text("PRO", style: TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold)),
              ),
            ],
          ),
          const SizedBox(height: defaultPadding),
          _buildInsightCard("Sales forecast", "Sales expected to increase 12% next week based on regional trends.", Icons.auto_graph, Color(0xFF6C5CE7)),
          _buildInsightCard("Inventory risk", "20 products in Western division are likely to run out of stock in 48 hrs.", Icons.inventory_2_outlined, Color(0xFFEE5D50)),
          _buildInsightCard("Demand prediction", "High demand predicted for 'Premium Widgets' in Delhi NCR.", Icons.lightbulb_outline, Color(0xFFFF7A18)),
        ],
      ),
    );
  }

  Widget _buildInsightCard(String title, String description, IconData icon, Color color) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withValues(alpha: 0.2)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: color, size: 24),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: TextStyle(fontWeight: FontWeight.bold, color: color)),
                const SizedBox(height: 4),
                Text(description, style: const TextStyle(fontSize: 12, color: textPrimaryColor)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
