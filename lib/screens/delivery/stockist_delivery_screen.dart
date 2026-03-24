import 'package:flutter/material.dart';

class StockistDeliveryScreen extends StatelessWidget {
  const StockistDeliveryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(backgroundColor: Colors.white, elevation: 0, title: const Text("Stock Shipments", style: TextStyle(color: Color(0xFF1E293B), fontWeight: FontWeight.w900))),
      body: ListView(
        padding: const EdgeInsets.all(24),
        children: [
           _buildShipmentCard("SHP-9801", "City Hub Logistics", "In Transit", "ETA: 4 Hours", Colors.blue, Icons.local_shipping_outlined),
           const SizedBox(height: 16),
           _buildShipmentCard("SHP-9798", "Global North Dist.", "Processing", "Warehouse Loading", Colors.orange, Icons.inventory_2_outlined),
           const SizedBox(height: 16),
           _buildShipmentCard("SHP-9795", "Rural Supply Co.", "Delivered", "Receipt Verified", Colors.green, Icons.check_circle_outlined),
        ],
      ),
    );
  }

  Widget _buildShipmentCard(String id, String destination, String status, String subtitle, Color color, IconData icon) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(24)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(padding: const EdgeInsets.all(12), decoration: BoxDecoration(color: color.withOpacity(0.1), shape: BoxShape.circle), child: Icon(icon, color: color, size: 24)),
              const SizedBox(width: 16),
              Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text(id, style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 16)), Text(destination, style: TextStyle(color: Colors.grey[500], fontSize: 13, fontWeight: FontWeight.bold))])),
              Container(padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6), decoration: BoxDecoration(color: color.withOpacity(0.1), borderRadius: BorderRadius.circular(10)), child: Text(status, style: TextStyle(color: color, fontSize: 11, fontWeight: FontWeight.bold))),
            ],
          ),
          const Divider(height: 48),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
               Column(crossAxisAlignment: CrossAxisAlignment.start, children: [const Text("Delivery Progress", style: TextStyle(color: Colors.grey, fontSize: 11, fontWeight: FontWeight.w800, letterSpacing: 1)), const SizedBox(height: 4), Text(subtitle, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14))]),
               _buildActionButton(Icons.map_outlined, "Track Live", Colors.indigo),
            ],
          )
        ],
      ),
    );
  }

  Widget _buildActionButton(IconData icon, String label, Color color) {
    return Container(
       padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
       decoration: BoxDecoration(color: color.withOpacity(0.1), borderRadius: BorderRadius.circular(12)),
       child: Row(children: [Icon(icon, color: color, size: 16), const SizedBox(width: 8), Text(label, style: TextStyle(color: color, fontWeight: FontWeight.bold, fontSize: 12))]),
    );
  }
}
