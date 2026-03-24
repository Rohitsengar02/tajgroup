import 'package:flutter/material.dart';

class InventoryHealth extends StatelessWidget {
  const InventoryHealth({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(28),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(30),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.012),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text("Batch Lifecycle Health",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w900, color: Color(0xFF1E293B))),
          const SizedBox(height: 4),
          const Text("Expiry & Threshold Monitoring",
              style: TextStyle(fontSize: 13, color: Colors.grey, fontWeight: FontWeight.w600)),
          const SizedBox(height: 40),
          _buildHealthItem("Fast Moving Consumer Goods", 0.92, Colors.green),
          const SizedBox(height: 24),
          _buildHealthItem("Perishables & Dairy (Taj Dairy)", 0.38, Colors.redAccent),
          const SizedBox(height: 24),
          _buildHealthItem("Dry Staples (Flour & Grains)", 0.65, Colors.orange),
          const SizedBox(height: 24),
          _buildHealthItem("Premium Packaged Foods", 0.78, Colors.blue),
          const SizedBox(height: 48),
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: const Color(0xFFF1F5F9),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Row(
              children: [
                 Container(padding: const EdgeInsets.all(10), decoration: const BoxDecoration(color: Colors.white, shape: BoxShape.circle), child: const Icon(Icons.auto_awesome, color: Colors.indigo, size: 20)),
                 const SizedBox(width: 16),
                 const Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text("AI Suggestion", style: TextStyle(fontWeight: FontWeight.w900, fontSize: 13, color: Colors.indigo)), Text("Regional hub is at 88% capacity. Consider moving Batch #412 earlier to avoid bottleneck.", style: TextStyle(color: Colors.grey, fontSize: 11, fontWeight: FontWeight.w700))])),
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget _buildHealthItem(String label, double value, Color color) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(label, style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 13, color: Color(0xFF1E293B))),
            Text("${(value * 100).toInt()}%",
                style: TextStyle(fontWeight: FontWeight.w900, fontSize: 13, color: color)),
          ],
        ),
        const SizedBox(height: 12),
        ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: LinearProgressIndicator(
            value: value,
            minHeight: 8,
            backgroundColor: color.withOpacity(0.08),
            valueColor: AlwaysStoppedAnimation<Color>(color),
          ),
        ),
      ],
    );
  }
}
