import 'package:flutter/material.dart';
import '../../../../constants.dart';

class NetworkOverview extends StatelessWidget {
  const NetworkOverview({super.key});

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
            "Distributor Network",
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
              _buildNetworkCard("Super Stockists", "14", Icons.store_mall_directory_outlined, primaryColor),
              const SizedBox(width: 8),
              _buildNetworkCard("Distributors", "240", Icons.add_business_outlined, successColor),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildNetworkCard("Retailers", "4,120", Icons.storefront_outlined, Color(0xFFF97316)),
              const SizedBox(width: 8),
              _buildNetworkCard("Active Outlets", "3,890", Icons.verified_outlined, Color(0xFF9333EA)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildNetworkCard(String title, String value, IconData icon, Color color) {
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
