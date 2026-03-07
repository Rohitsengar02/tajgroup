import 'package:flutter/material.dart';
import '../../../../constants.dart';

class NotificationsPanel extends StatelessWidget {
  const NotificationsPanel({super.key});

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
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                "System Alerts",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: textPrimaryColor,
                ),
              ),
              Text(
                "Mark all read",
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: primaryColor.withValues(alpha: 0.8),
                ),
              ),
            ],
          ),
          const SizedBox(height: defaultPadding),
          _buildNotification("Low stock alert", "SKU-992 is below 10 units at WB warehouse.", Icons.warning_amber_rounded, Color(0xFFF97316)),
          _buildNotification("Payment overdue", "Invoice #4902 is 15 days past due date.", Icons.error_outline, errorColor),
          _buildNotification("Route delay", "Agent Rajesh is 45 mins behind schedule.", Icons.schedule, Color(0xFF6C5CE7)),
          _buildNotification("New order created", "Order #5821 placed for ₹42,000 by Big Bazaar.", Icons.check_circle_outline, successColor),
        ],
      ),
    );
  }

  Widget _buildNotification(String title, String subtitle, IconData icon, Color iconColor) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
           Container(
             padding: const EdgeInsets.all(8),
             decoration: BoxDecoration(
               color: iconColor.withValues(alpha: 0.1),
               shape: BoxShape.circle,
             ),
             child: Icon(icon, color: iconColor, size: 20),
           ),
           const SizedBox(width: 12),
           Expanded(
             child: Column(
               crossAxisAlignment: CrossAxisAlignment.start,
               children: [
                 Text(
                   title,
                   style: const TextStyle(fontWeight: FontWeight.bold, color: textPrimaryColor, fontSize: 13),
                 ),
                 const SizedBox(height: 2),
                 Text(
                   subtitle,
                   style: const TextStyle(color: textSecondaryColor, fontSize: 11),
                 ),
               ],
             ),
           ),
        ],
      ),
    );
  }
}
