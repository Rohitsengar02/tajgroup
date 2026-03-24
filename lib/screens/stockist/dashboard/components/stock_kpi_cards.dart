import 'package:flutter/material.dart';
import 'package:carousel_slider_plus/carousel_slider_plus.dart';
import 'package:tajpro/responsive.dart';

class StockKpiCards extends StatelessWidget {
  const StockKpiCards({super.key});

  @override
  Widget build(BuildContext context) {
    bool isMobile = Responsive.isMobile(context);

    final List<Widget> cards = [
      _buildKpiCard("TOTAL DISPATCH", "₹ 84.5L", Icons.outbox_rounded, Colors.indigo, "+14.2%"),
      _buildKpiCard("STOCK CAPACITY", "72%", Icons.warehouse_rounded, Colors.orange, "Critical Inbound"),
      _buildKpiCard("RETAIL CONNECT", "2,480", Icons.hub_rounded, Colors.green, "Active Routes"),
      _buildKpiCard("PRIMARY INVOICE", "₹ 12.8L", Icons.receipt_long_rounded, Colors.blue, "18 Pending"),
    ];

    if (isMobile) {
      return CarouselSlider(
        options: CarouselOptions(
          height: 180,
          viewportFraction: 0.85,
          enlargeCenterPage: true,
          autoPlay: true,
          autoPlayInterval: const Duration(seconds: 4),
          enableInfiniteScroll: true,
        ),
        items: cards,
      );
    }

    // Row layout for desktop/tablet
    return Row(
      children: cards.map((card) => Expanded(child: Padding(padding: const EdgeInsets.only(right: 24), child: card))).toList(),
    );
  }

  Widget _buildKpiCard(String title, String value, IconData icon, Color color, String badge) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(30),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.015),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Stack(
        children: [
          Positioned(
            right: 0,
            top: 0,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              decoration: BoxDecoration(
                color: color.withOpacity(0.08),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Text(
                badge,
                style: TextStyle(color: color, fontSize: 10, fontWeight: FontWeight.w900, letterSpacing: 0.5),
              ),
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(color: color.withOpacity(0.1), shape: BoxShape.circle),
                child: Icon(icon, color: color, size: 24),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    value,
                    style: const TextStyle(fontSize: 28, fontWeight: FontWeight.w900, color: Color(0xFF1E293B), letterSpacing: -1),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    title,
                    style: TextStyle(fontSize: 11, fontWeight: FontWeight.w800, color: Colors.grey[500], letterSpacing: 1.2),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
