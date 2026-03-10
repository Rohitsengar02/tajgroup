import 'package:flutter/material.dart';
import 'package:tajpro/responsive.dart';
import 'components/stockist_welcome_banner.dart';
import 'components/stock_kpi_cards.dart';
import 'components/distribution_chart.dart';
import 'components/recent_stock_moves.dart';
import 'components/inventory_health.dart';
import 'components/stockist_trend_chart.dart';

class StockistDashboardScreen extends StatelessWidget {
  final Function(int)? onIndexChanged;
  const StockistDashboardScreen({super.key, this.onIndexChanged});

  @override
  Widget build(BuildContext context) {
    bool isDesktop = Responsive.isDesktop(context);
    
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(isDesktop ? 32 : 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Top Header: Welcome & Quick Access
            const StockistWelcomeBanner(),
            const SizedBox(height: 32),
            
            // KPI Section: Row on Desktop, Carousel on Mobile
            const StockKpiCards(),
            const SizedBox(height: 32),
            
            // NEW: Beautiful Growth Trend Line Chart
            const StockistTrendChart(),
            const SizedBox(height: 32),
            
            // Main Content Area: Responsive charts and lists
            if (isDesktop)
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Left Column: Supply Chain Bar Charts
                  Expanded(
                    flex: 7,
                    child: Column(
                      children: [
                        const StockistDistributionChart(),
                        const SizedBox(height: 32),
                        const RecentStockMoves(),
                      ],
                    ),
                  ),
                  const SizedBox(width: 32),
                  
                  // Right Column: Inventory Health & Insights
                  Expanded(
                    flex: 4,
                    child: Column(
                      children: [
                         const InventoryHealth(),
                         const SizedBox(height: 32),
                         _buildQuickActionsCard(),
                         const SizedBox(height: 32),
                         _buildTopDistributorsMiniList(),
                      ],
                    ),
                  ),
                ],
              )
            else
              Column(
                children: [
                  const StockistDistributionChart(),
                  const SizedBox(height: 24),
                  const InventoryHealth(),
                  const SizedBox(height: 24),
                  const RecentStockMoves(),
                ],
              ),
            
            const SizedBox(height: 60),
          ],
        ),
      ),
    );
  }

  Widget _buildQuickActionsCard() {
    return Container(
      padding: const EdgeInsets.all(28),
      decoration: BoxDecoration(
        gradient: const LinearGradient(colors: [Color(0xFF6C5CE7), Color(0xFF3B82F6)]),
        borderRadius: BorderRadius.circular(30),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text("QUICK HUB ACTIONS", style: TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.w900, letterSpacing: 1.2)),
          const SizedBox(height: 24),
          _buildActionButton(Icons.add_box_rounded, "New Dispatch Challan"),
          const SizedBox(height: 12),
          _buildActionButton(Icons.inventory_rounded, "Update Batch SKU"),
          const SizedBox(height: 12),
          _buildActionButton(Icons.assignment_ind_rounded, "Assign Distributor"),
          const SizedBox(height: 12),
          _buildActionButton(Icons.download_for_offline_rounded, "Export Regional Sheet"),
        ],
      ),
    );
  }

  Widget _buildActionButton(IconData icon, String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(color: Colors.white.withOpacity(0.1), borderRadius: BorderRadius.circular(16)),
      child: Row(
        children: [
           Icon(icon, color: Colors.white, size: 20),
           const SizedBox(width: 16),
           Text(label, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w800, fontSize: 13)),
        ],
      ),
    );
  }

  Widget _buildTopDistributorsMiniList() {
    return Container(
      padding: const EdgeInsets.all(28),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(30), border: Border.all(color: Colors.grey.withOpacity(0.05))),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text("Top Supply Partners", style: TextStyle(fontSize: 18, fontWeight: FontWeight.w900, color: Color(0xFF1E293B))),
          const SizedBox(height: 24),
          _buildPartnerRow("Global North", "₹ 24.5L", Colors.indigo),
          const SizedBox(height: 16),
          _buildPartnerRow("City Logistics", "₹ 18.2L", Colors.green),
          const SizedBox(height: 16),
          _buildPartnerRow("Rural Supply", "₹ 12.8L", Colors.orange),
        ],
      ),
    );
  }

  Widget _buildPartnerRow(String name, String revenue, Color color) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(children: [Container(width: 8, height: 8, decoration: BoxDecoration(color: color, shape: BoxShape.circle)), const SizedBox(width: 12), Text(name, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14))]),
        Text(revenue, style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 14)),
      ],
    );
  }
}
