import 'package:flutter/material.dart';
import 'package:tajpro/constants.dart';

class StockistWelcomeBanner extends StatelessWidget {
  const StockistWelcomeBanner({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(32),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF2B3674), Color(0xFF1B254B)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(30),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF2B3674).withOpacity(0.3),
            blurRadius: 25,
            offset: const Offset(0, 15),
          ),
        ],
      ),
      child: Stack(
        children: [
          Positioned(
            right: -20,
            top: -20,
            child: Icon(
              Icons.warehouse_rounded,
              size: 180,
              color: Colors.white.withOpacity(0.05),
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Text(
                  "REGIONAL HUB: NORTH INDIA",
                  style: TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.w900, letterSpacing: 1.5),
                ),
              ),
              const SizedBox(height: 20),
              const Text(
                "Good Morning,\nNorth Hub Logistics",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 32,
                  fontWeight: FontWeight.w900,
                  height: 1.2,
                  letterSpacing: -1,
                ),
              ),
              const SizedBox(height: 12),
              SizedBox(
                width: 400,
                child: Text(
                  "Your regional inventory is at 84% capacity. 12 distributor orders are awaiting your approval for today's primary dispatch.",
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.7),
                    fontSize: 15,
                    fontWeight: FontWeight.w500,
                    height: 1.5,
                  ),
                ),
              ),
              const SizedBox(height: 32),
              Row(
                children: [
                  _buildStatPill("₹ 1.2 Cr", "Active Inventory"),
                  const SizedBox(width: 16),
                  _buildStatPill("142", "Distributors"),
                  const SizedBox(width: 16),
                  _buildStatPill("98.4%", "Fulfillment"),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatPill(String value, String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.1),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: Colors.white.withOpacity(0.1)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(value, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w900, fontSize: 16)),
          Text(label, style: TextStyle(color: Colors.white.withOpacity(0.5), fontWeight: FontWeight.bold, fontSize: 10, letterSpacing: 0.5)),
        ],
      ),
    );
  }
}
