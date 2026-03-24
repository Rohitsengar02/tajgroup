import 'package:flutter/material.dart';

class StockistPaymentsScreen extends StatelessWidget {
  const StockistPaymentsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(backgroundColor: Colors.white, elevation: 0, title: const Text("Stockist Collections", style: TextStyle(color: Color(0xFF1E293B), fontWeight: FontWeight.w900))),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
             _buildCollectionsSummary(),
             const SizedBox(height: 24),
             _buildTransactionHistory(),
          ],
        ),
      ),
    );
  }

  Widget _buildCollectionsSummary() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(color: Colors.indigo, borderRadius: BorderRadius.circular(24), boxShadow: [BoxShadow(color: Colors.indigo.withOpacity(0.2), blurRadius: 20, offset: const Offset(0, 10))]),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
               const Text("Aggregate Oustanding Balance", style: TextStyle(color: Colors.white70, fontSize: 13, fontWeight: FontWeight.w600, letterSpacing: 0.5)),
               Container(padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6), decoration: BoxDecoration(color: Colors.white.withOpacity(0.2), borderRadius: BorderRadius.circular(10)), child: const Text("Net 30", style: TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold))),
            ],
          ),
          const SizedBox(height: 12),
          const Text("₹ 1,42,84,000", style: TextStyle(color: Colors.white, fontSize: 36, fontWeight: FontWeight.w900, letterSpacing: -1)),
          const SizedBox(height: 24),
          Row(
            children: [
              _buildSummaryPill(Icons.account_balance_wallet_outlined, "Received: ₹ 84L", Colors.white24),
              const SizedBox(width: 12),
              _buildSummaryPill(Icons.access_time_rounded, "Overdue: ₹ 12L", Colors.redAccent.withOpacity(0.3)),
            ],
          )
        ],
      ),
    );
  }

  Widget _buildSummaryPill(IconData icon, String label, Color bgColor) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      decoration: BoxDecoration(color: bgColor, borderRadius: BorderRadius.circular(16)),
      child: Row(children: [Icon(icon, color: Colors.white, size: 16), const SizedBox(width: 8), Text(label, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 12))]),
    );
  }

  Widget _buildTransactionHistory() {
     return Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(24)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
             const Text("Recent Distributor Remittances", style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800, color: Color(0xFF1E293B))),
             const SizedBox(height: 24),
             _buildTransactionRow("City Hub Logistics", "NEFT-9284", "₹ 4,25,000", "Verified", Colors.green),
             const Divider(height: 32),
             _buildTransactionRow("Global North", "CHQ-1049", "₹ 8,12,000", "Clearing", Colors.blue),
             const Divider(height: 32),
             _buildTransactionRow("East Zone Supply", "CASH-491", "₹ 45,000", "Pending", Colors.orange),
          ],
        ),
     );
  }

  Widget _buildTransactionRow(String party, String method, String amount, String status, Color color) {
    return Row(
      children: [
        Container(width: 48, height: 48, decoration: BoxDecoration(color: color.withOpacity(0.05), shape: BoxShape.circle), child: Icon(Icons.currency_rupee_rounded, color: color, size: 24)),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(party, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
              Text("Payment: $method", style: TextStyle(color: Colors.grey[500], fontSize: 12)),
            ],
          ),
        ),
        Text(amount, style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 15)),
        const SizedBox(width: 24),
        Container(padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6), decoration: BoxDecoration(color: color.withOpacity(0.1), borderRadius: BorderRadius.circular(10)), child: Text(status, style: TextStyle(color: color, fontSize: 11, fontWeight: FontWeight.bold))),
      ],
    );
  }
}
