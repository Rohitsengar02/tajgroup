import 'package:flutter/material.dart';

class StockistReportsScreen extends StatelessWidget {
  const StockistReportsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(backgroundColor: Colors.white, elevation: 0, title: const Text("Stockist Performance", style: TextStyle(color: Color(0xFF1E293B), fontWeight: FontWeight.w900))),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            _buildMetricsGrid(),
            const SizedBox(height: 24),
            _buildReportTiles(),
          ],
        ),
      ),
    );
  }

  Widget _buildMetricsGrid() {
    return Row(
      children: [
        Expanded(child: _buildMetricTile("Monthly Revenue", "₹ 48,25,000", Icons.insights, Colors.indigo, "+15%")),
        const SizedBox(width: 16),
        Expanded(child: _buildMetricTile("Distributor Sales", "2,450 Units", Icons.hub_outlined, Colors.green, "On Track")),
        const SizedBox(width: 16),
        Expanded(child: _buildMetricTile("Best SKU", "Premium Tea", Icons.auto_awesome, Colors.orange, "Trending")),
      ],
    );
  }

  Widget _buildReportTiles() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(24)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text("Detailed Supply Reports", style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800, color: Color(0xFF1E293B))),
          const SizedBox(height: 24),
          _buildReportRow("Regional Sales Summary", "Feb 2026", "Download PDF", Icons.description_outlined),
          const Divider(height: 32),
          _buildReportRow("Distributor Performance Ledger", "YTD 2026", "Generate Report", Icons.summarize_outlined),
          const Divider(height: 32),
          _buildReportRow("Inventory Turnover Audit", "Q1 2026", "View Analytics", Icons.analytics_outlined),
        ],
      ),
    );
  }

  Widget _buildMetricTile(String label, String value, IconData icon, Color color, String subtitle) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(20)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(padding: const EdgeInsets.all(8), decoration: BoxDecoration(color: color.withOpacity(0.1), shape: BoxShape.circle), child: Icon(icon, color: color, size: 20)),
          const SizedBox(height: 16),
          Text(value, style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 18)),
          Text(label, style: TextStyle(color: Colors.grey[500], fontSize: 12, fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          Text(subtitle, style: TextStyle(color: color, fontSize: 10, fontWeight: FontWeight.w800, letterSpacing: 1)),
        ],
      ),
    );
  }

  Widget _buildReportRow(String title, String date, String action, IconData icon) {
    return Row(
      children: [
        Icon(icon, color: Colors.indigo, size: 24),
        const SizedBox(width: 16),
        Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)), Text(date, style: TextStyle(color: Colors.grey[500], fontSize: 12))])),
        TextButton(onPressed: () {}, child: Text(action, style: const TextStyle(color: Colors.indigo, fontWeight: FontWeight.w900, fontSize: 12))),
      ],
    );
  }
}
