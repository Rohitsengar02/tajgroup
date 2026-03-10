import 'package:flutter/material.dart';

class StockistOrdersScreen extends StatelessWidget {
  const StockistOrdersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(backgroundColor: Colors.white, elevation: 0, title: const Text("Distributor Orders", style: TextStyle(color: Color(0xFF1E293B), fontWeight: FontWeight.w900))),
      body: ListView(
        padding: const EdgeInsets.all(24),
        children: [
          _buildOrderCard("ORD-4201", "Global North Distribution", "₹ 12,40,000", "56 Items", "Pending Approval", Colors.orange),
          const SizedBox(height: 16),
          _buildOrderCard("ORD-4198", "City Hub Logistics", "₹ 4,15,000", "12 Items", "In Review", Colors.blue),
          const SizedBox(height: 16),
          _buildOrderCard("ORD-4195", "Rural Supply Co.", "₹ 8,90,000", "28 Items", "Shipment Ready", Colors.green),
        ],
      ),
    );
  }

  Widget _buildOrderCard(String id, String distributor, String amount, String items, String status, Color color) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(24), border: Border.all(color: Colors.grey.withOpacity(0.05))),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
               Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text(id, style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 18)), Text(distributor, style: TextStyle(color: Colors.grey[500], fontSize: 14, fontWeight: FontWeight.w600))]),
               Container(padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6), decoration: BoxDecoration(color: color.withOpacity(0.1), borderRadius: BorderRadius.circular(8)), child: Text(status, style: TextStyle(color: color, fontSize: 11, fontWeight: FontWeight.bold))),
            ],
          ),
          const Divider(height: 48),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
               _buildInfoCol("Order Value", amount),
               _buildInfoCol("Stock Count", items),
               Row(
                  children: [
                    _buildActionButton(Icons.close_rounded, "Reject", Colors.redAccent),
                    const SizedBox(width: 8),
                    _buildActionButton(Icons.check_rounded, "Approve", Colors.green),
                  ],
               )
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
