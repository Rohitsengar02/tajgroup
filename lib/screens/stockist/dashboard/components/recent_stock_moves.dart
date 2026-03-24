import 'package:flutter/material.dart';

class RecentStockMoves extends StatelessWidget {
  const RecentStockMoves({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(28),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(30),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.01),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Regional Dispatches", style: TextStyle(fontSize: 18, fontWeight: FontWeight.w900, color: Color(0xFF1E293B))),
                  SizedBox(height: 4),
                  Text("Latest Distributor Procurements", style: TextStyle(fontSize: 13, color: Colors.grey, fontWeight: FontWeight.w600)),
                ],
              ),
              _buildHeaderAction(),
            ],
          ),
          const SizedBox(height: 32),
          _buildDispatchRow("Global North Hub", "ORD-9842", "₹ 4,25,000", "56 Items", "Pending Approval", Colors.orange),
          const Divider(height: 48, thickness: 0.5),
          _buildDispatchRow("City Logistics Co.", "ORD-9841", "₹ 2,10,000", "12 Items", "In Transit", Colors.blue),
          const Divider(height: 48, thickness: 0.5),
          _buildDispatchRow("East Region Supply", "ORD-9840", "₹ 8,15,000", "84 Items", "Receipt Verified", Colors.green),
          const Divider(height: 48, thickness: 0.5),
          _buildDispatchRow("Rural Distributors", "ORD-9839", "₹ 1,12,000", "08 Items", "Processing", Colors.indigo),
        ],
      ),
    );
  }

  Widget _buildDispatchRow(String party, String id, String amount, String qty, String status, Color color) {
    return Row(
      children: [
        Container(
          width: 52,
          height: 52,
          decoration: BoxDecoration(color: const Color(0xFFF8FAFC), borderRadius: BorderRadius.circular(16)),
          child: const Center(child: Icon(Icons.inventory_2_outlined, color: Colors.black87, size: 24)),
        ),
        const SizedBox(width: 20),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(party, style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 16, color: Color(0xFF1E293B))),
              const SizedBox(height: 4),
              Row(
                children: [
                  Text("Order #$id", style: TextStyle(color: Colors.grey[500], fontSize: 12, fontWeight: FontWeight.w600)),
                  const SizedBox(width: 8),
                  Container(width: 4, height: 4, decoration: const BoxDecoration(color: Colors.grey, shape: BoxShape.circle)),
                  const SizedBox(width: 8),
                  Text(qty, style: TextStyle(color: Colors.grey[500], fontSize: 12, fontWeight: FontWeight.w600)),
                ],
              ),
            ],
          ),
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(amount, style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 16, color: Color(0xFF1E293B))),
            const SizedBox(height: 6),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(color: color.withOpacity(0.08), borderRadius: BorderRadius.circular(8)),
              child: Text(status, style: TextStyle(color: color, fontSize: 10, fontWeight: FontWeight.w900, letterSpacing: 0.3)),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildHeaderAction() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      decoration: BoxDecoration(color: const Color(0xFFF8FAFC), borderRadius: BorderRadius.circular(14)),
      child: const Row(children: [Text("Batch View", style: TextStyle(fontWeight: FontWeight.w900, fontSize: 13, color: Colors.indigo)), SizedBox(width: 8), Icon(Icons.keyboard_arrow_down_rounded, size: 18, color: Colors.indigo)]),
    );
  }
}
