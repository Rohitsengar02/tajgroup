import 'package:flutter/material.dart';
import '../../../../constants.dart';

class TeamPerformance extends StatelessWidget {
  const TeamPerformance({super.key});

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
            "Team Performance",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: textPrimaryColor,
            ),
          ),
          const SizedBox(height: defaultPadding),
          _buildAgentCard("Rajesh Kumar", "Target ₹2L", "Achieved ₹1.6L", 0.8, "https://i.pravatar.cc/150?img=11"),
          _buildAgentCard("Anita Desai", "Target ₹1.5L", "Achieved ₹1.2L", 0.8, "https://i.pravatar.cc/150?img=9"),
          _buildAgentCard("Suresh Patel", "Target ₹3L", "Achieved ₹1.8L", 0.6, "https://i.pravatar.cc/150?img=12"),
          _buildAgentCard("Vikram Singh", "Target ₹2L", "Achieved ₹2.1L", 1.05, "https://i.pravatar.cc/150?img=13"),
        ],
      ),
    );
  }

  Widget _buildAgentCard(String name, String target, String achieved, double progress, String image) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: surfaceColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: textSecondaryColor.withValues(alpha: 0.1)),
      ),
      child: Row(
        children: [
          CircleAvatar(backgroundImage: NetworkImage(image), radius: 20),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(name, style: const TextStyle(fontWeight: FontWeight.bold, color: textPrimaryColor)),
                    Text("${(progress * 100).toInt()}%", style: TextStyle(fontWeight: FontWeight.bold, color: progress >= 1 ? successColor : primaryColor)),
                  ],
                ),
                const SizedBox(height: 4),
                Text("$target | $achieved", style: const TextStyle(fontSize: 12, color: textSecondaryColor)),
                const SizedBox(height: 8),
                ClipRRect(
                  borderRadius: BorderRadius.circular(4),
                  child: LinearProgressIndicator(
                    value: progress > 1 ? 1 : progress,
                    backgroundColor: textSecondaryColor.withValues(alpha: 0.1),
                    valueColor: AlwaysStoppedAnimation<Color>(progress >= 1 ? successColor : primaryColor),
                    minHeight: 6,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
