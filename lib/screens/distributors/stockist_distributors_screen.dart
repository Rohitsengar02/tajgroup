import 'package:flutter/material.dart';

class StockistDistributorsScreen extends StatelessWidget {
  const StockistDistributorsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(backgroundColor: Colors.white, elevation: 0, title: const Text("Distributor Network", style: TextStyle(color: Color(0xFF1E293B), fontWeight: FontWeight.w900))),
      body: ListView(
        padding: const EdgeInsets.all(24),
        children: [
          _buildPerformanceCard("City Hub Distribution", "South Zone", "₹ 24.5 Lakhs", "Excellent Performance", Colors.green),
          const SizedBox(height: 16),
          _buildPerformanceCard("Rural Supply Co.", "East Zone", "₹ 12.8 Lakhs", "Consistent Supply", Colors.blue),
          const SizedBox(height: 16),
          _buildPerformanceCard("North Star Logistics", "North Zone", "₹ 8.2 Lakhs", "Growth Opportunity", Colors.orange),
        ],
      ),
    );
  }

  Widget _buildPerformanceCard(String name, String zone, String revenue, String label, Color color) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(24), border: Border.all(color: Colors.grey.withOpacity(0.05))),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
               Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text(name, style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 18)), Text(zone, style: TextStyle(color: Colors.grey[500], fontSize: 14, fontWeight: FontWeight.w600))]),
               Container(padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6), decoration: BoxDecoration(color: color.withOpacity(0.1), borderRadius: BorderRadius.circular(10)), child: Text(label, style: TextStyle(color: color, fontSize: 11, fontWeight: FontWeight.bold))),
            ],
          ),
          const Divider(height: 48),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
               _buildInfoCol("Region Revenue", revenue),
               _buildInfoCol("Network Status", "Active"),
               _buildActionButton(Icons.manage_accounts_outlined, "Manage", Colors.indigo),
            ],
          )
        ],
      ),
    );
  }

  Widget _buildInfoCol(String label, String value) {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text(label, style: TextStyle(color: Colors.grey[400], fontSize: 11, fontWeight: FontWeight.w800, letterSpacing: 1)), const SizedBox(height: 4), Text(value, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15))]);
  }

  Widget _buildActionButton(IconData icon, String label, Color color) {
    return Container(
       padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
       decoration: BoxDecoration(color: color.withOpacity(0.1), borderRadius: BorderRadius.circular(12)),
       child: Row(children: [Icon(icon, color: color, size: 16), const SizedBox(width: 8), Text(label, style: TextStyle(color: color, fontWeight: FontWeight.bold, fontSize: 12))]),
    );
  }
}
