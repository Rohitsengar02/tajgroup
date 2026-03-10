import 'package:flutter/material.dart';

class StockistInventoryScreen extends StatelessWidget {
  const StockistInventoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(backgroundColor: Colors.white, elevation: 0, title: const Text("Warehouse Inventory", style: TextStyle(color: Color(0xFF1E293B), fontWeight: FontWeight.w900))),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            _buildAlertBox(),
            const SizedBox(height: 24),
            _buildStockList(),
          ],
        ),
      ),
    );
  }

  Widget _buildAlertBox() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(color: Colors.redAccent.withOpacity(0.05), borderRadius: BorderRadius.circular(24), border: Border.all(color: Colors.redAccent.withOpacity(0.1))),
      child: Row(
        children: [
          Container(padding: const EdgeInsets.all(12), decoration: const BoxDecoration(color: Colors.redAccent, shape: BoxShape.circle), child: const Icon(Icons.warning_rounded, color: Colors.white, size: 24)),
          const SizedBox(width: 20),
          const Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text("Critical Stock Alert", style: TextStyle(fontWeight: FontWeight.w900, fontSize: 16, color: Colors.redAccent)), Text("4 Items are below minimum batch threshhold. Restock advised to prevent regional distributor outages.", style: TextStyle(color: Colors.black54, fontSize: 13, height: 1.4))])),
          _buildTextButton("Restock Now", Colors.redAccent),
        ],
      ),
    );
  }

  Widget _buildStockList() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(24)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text("Live Warehouse Batch Tracking", style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800, color: Color(0xFF1E293B))),
          const SizedBox(height: 24),
          _buildInventoryRow("Taj Premium Tea 250g", "Batch #412", "Expired in 12 Days", "4,200 Units", "Steady", Colors.green),
          const Divider(height: 32),
          _buildInventoryRow("Classic Coffee Roast", "Batch #410", "Expired in 45 Days", "1,200 Units", "Low", Colors.orange),
          const Divider(height: 32),
          _buildInventoryRow("Taj Refined Flour 5kg", "Batch #398", "Expired in 5 Days", "84 Units", "Critical", Colors.redAccent),
        ],
      ),
    );
  }

  Widget _buildInventoryRow(String name, String batch, String expiry, String units, String status, Color color) {
    return Row(
      children: [
        Container(width: 48, height: 48, decoration: BoxDecoration(color: Colors.grey[500]?.withOpacity(0.1), borderRadius: BorderRadius.circular(12)), child: Icon(Icons.inventory_2_outlined, color: Colors.grey[600], size: 24)),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(name, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
              Text("$batch | $expiry", style: TextStyle(color: Colors.grey[500], fontSize: 12)),
            ],
          ),
        ),
        Text(units, style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 15)),
        const SizedBox(width: 24),
        Container(padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6), decoration: BoxDecoration(color: color.withOpacity(0.1), borderRadius: BorderRadius.circular(10)), child: Text(status, style: TextStyle(color: color, fontSize: 11, fontWeight: FontWeight.bold))),
      ],
    );
  }

  Widget _buildTextButton(String label, Color color) {
    return TextButton(onPressed: () {}, child: Text(label, style: TextStyle(color: color, fontWeight: FontWeight.w900, fontSize: 13)));
  }
}
