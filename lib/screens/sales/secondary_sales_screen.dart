import 'package:flutter/material.dart';
import '../../constants.dart';
import '../../responsive.dart';

class SecondarySalesScreen extends StatelessWidget {
  const SecondarySalesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(defaultPadding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const _Header(),
            const SizedBox(height: defaultPadding),
            const _SalesAnalytics(),
            const SizedBox(height: defaultPadding * 1.5),
            const _RetailOutletPerformance(),
            const SizedBox(height: defaultPadding * 1.5),
            const _ActionRow(),
            const SizedBox(height: defaultPadding),
            const _SecondarySalesTable(),
            const SizedBox(height: defaultPadding * 2),
          ],
        ),
      ),
    );
  }
}

class _Header extends StatelessWidget {
  const _Header();

  @override
  Widget build(BuildContext context) {
    bool isMobile = Responsive.isMobile(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Secondary Sales",
          style: TextStyle(fontSize: isMobile ? 24 : 28, fontWeight: FontWeight.bold, color: textPrimaryColor),
        ),
        const SizedBox(height: 4),
        Text(
          "Track outlet-level sales and retail distribution performance",
          style: TextStyle(fontSize: isMobile ? 12 : 14, color: textSecondaryColor, fontWeight: FontWeight.w500),
        ),
      ],
    );
  }
}

class _SalesAnalytics extends StatelessWidget {
  const _SalesAnalytics();

  @override
  Widget build(BuildContext context) {
    bool isMobile = Responsive.isMobile(context);
    List<Widget> stats = [
      _buildStatCard("Outlet Sales", "₹12.4L", Icons.storefront_rounded, [const Color(0xFF6366F1), const Color(0xFF818CF8)]),
      _buildStatCard("Active Outlets", "842", Icons.business_rounded, [const Color(0xFF22C55E), const Color(0xFF4ADE80)]),
      _buildStatCard("Avg Bill Value", "₹1,450", Icons.receipt_rounded, [const Color(0xFFF59E0B), const Color(0xFFFBBF24)]),
      _buildStatCard("Growth", "+12.4%", Icons.trending_up_rounded, [const Color(0xFFA855F7), const Color(0xFFC084FC)]),
    ];

    if (isMobile) {
      return SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: stats.map((stat) => Container(
            width: MediaQuery.of(context).size.width * 0.65,
            margin: const EdgeInsets.only(right: 16),
            child: stat,
          )).toList(),
        ),
      );
    }

    return GridView.count(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: 4,
      crossAxisSpacing: defaultPadding,
      mainAxisSpacing: defaultPadding,
      childAspectRatio: 2.2,
      children: stats,
    );
  }

  Widget _buildStatCard(String title, String value, IconData icon, List<Color> colors) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(colors: colors, begin: Alignment.topLeft, end: Alignment.bottomRight),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(color: colors[0].withValues(alpha: 0.3), blurRadius: 10, offset: const Offset(0, 5))
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(color: Colors.white.withValues(alpha: 0.2), borderRadius: BorderRadius.circular(12)),
            child: Icon(icon, color: Colors.white, size: 24),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(value, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w900, color: Colors.white)),
                Text(title, style: const TextStyle(fontSize: 11, color: Colors.white70, fontWeight: FontWeight.w600), overflow: TextOverflow.ellipsis),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _RetailOutletPerformance extends StatelessWidget {
  const _RetailOutletPerformance();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: surfaceColor,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(color: Colors.black.withValues(alpha: 0.02), blurRadius: 10, offset: const Offset(0, 5))
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text("Top Retail Channels", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          const SizedBox(height: 24),
          _buildChannelBar("General Trade", 0.65, const Color(0xFF6366F1)),
          const SizedBox(height: 16),
          _buildChannelBar("Modern Trade", 0.20, const Color(0xFF22C55E)),
          const SizedBox(height: 16),
          _buildChannelBar("E-Commerce", 0.15, const Color(0xFFA855F7)),
        ],
      ),
    );
  }

  Widget _buildChannelBar(String label, double percent, Color color) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(label, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600)),
            Text("${(percent * 100).toInt()}%", style: TextStyle(color: color, fontWeight: FontWeight.bold, fontSize: 12)),
          ],
        ),
        const SizedBox(height: 8),
        Stack(
          children: [
            Container(height: 6, decoration: BoxDecoration(color: color.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(10))),
            FractionallySizedBox(widthFactor: percent, child: Container(height: 6, decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(10)))),
          ],
        ),
      ],
    );
  }
}

class _ActionRow extends StatelessWidget {
  const _ActionRow();

  @override
  Widget build(BuildContext context) {
    bool isMobile = Responsive.isMobile(context);
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: Container(
                height: 48,
                decoration: BoxDecoration(
                  color: surfaceColor,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.grey.withValues(alpha: 0.1)),
                ),
                child: const TextField(
                  decoration: InputDecoration(
                    hintText: "Search Outlet, Salesman...",
                    prefixIcon: Icon(Icons.search, size: 20),
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.symmetric(vertical: 14),
                  ),
                ),
              ),
            ),
            if (!isMobile) ...[
              const SizedBox(width: 12),
              _buildFilterChip("Region"),
              const SizedBox(width: 8),
              _buildFilterChip("Beat"),
            ],
          ],
        ),
        if (isMobile) ...[
          const SizedBox(height: 12),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                _buildFilterChip("Region"),
                const SizedBox(width: 8),
                _buildFilterChip("Beat"),
                const SizedBox(width: 8),
                _buildFilterChip("Category"),
                const SizedBox(width: 8),
                _buildFilterChip("Status"),
              ],
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildFilterChip(String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(color: surfaceColor, borderRadius: BorderRadius.circular(12), border: Border.all(color: Colors.grey.withValues(alpha: 0.1))),
      child: Text(label, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600)),
    );
  }
}

class _SecondarySalesTable extends StatelessWidget {
  const _SecondarySalesTable();

  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> sales = [
      {"outlet": "Sharma Kirana Store", "salesman": "Rajesh Kumar", "beat": "Downtown A", "amount": "₹12,450", "status": "Settled"},
      {"outlet": "Global Mega Mart", "salesman": "Priya Sharma", "beat": "Market Area", "amount": "₹45,200", "status": "Pending"},
      {"outlet": "Metro General", "salesman": "Amit Patel", "beat": "Railway St", "amount": "₹3,400", "status": "Settled"},
    ];

    bool isMobile = Responsive.isMobile(context);

    if (isMobile) {
      return ListView.separated(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: sales.length,
        separatorBuilder: (context, index) => const SizedBox(height: 12),
        itemBuilder: (context, index) => _SecondarySalesMobileCard(data: sales[index]),
      );
    }

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: surfaceColor,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(color: Colors.black.withValues(alpha: 0.02), blurRadius: 10, offset: const Offset(0, 5))
        ],
      ),
      child: Column(
        children: [
          const _TableHeader(),
          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: sales.length,
            separatorBuilder: (context, index) => Divider(height: 1, color: Colors.grey.withValues(alpha: 0.05)),
            itemBuilder: (context, index) => _SalesRow(data: sales[index]),
          ),
        ],
      ),
    );
  }
}

class _SecondarySalesMobileCard extends StatelessWidget {
  final Map<String, dynamic> data;
  const _SecondarySalesMobileCard({required this.data});

  @override
  Widget build(BuildContext context) {
    Color statusColor = data["status"] == "Settled" ? const Color(0xFF22C55E) : const Color(0xFFF59E0B);

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: surfaceColor,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 10, offset: const Offset(0, 4))
        ],
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  data["outlet"],
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(color: statusColor.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(6)),
                child: Text(data["status"], style: TextStyle(color: statusColor, fontSize: 10, fontWeight: FontWeight.bold)),
              ),
            ],
          ),
          const SizedBox(height: 8),
          const Row(
            children: [
              Icon(Icons.category_outlined, size: 12, color: textSecondaryColor),
              SizedBox(width: 4),
              Text("Category: General Trade", style: TextStyle(fontSize: 10, color: textSecondaryColor)),
            ],
          ),
          const Divider(height: 24),
          Row(
            children: [
              _buildInfoItem(Icons.person_outline_rounded, "Salesman", data["salesman"]),
              const SizedBox(width: 24),
              _buildInfoItem(Icons.map_outlined, "Beat", data["beat"]),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text("Sale Value", style: TextStyle(fontSize: 10, color: textSecondaryColor, fontWeight: FontWeight.bold)),
                  Text(data["amount"], style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w900, color: primaryColor)),
                ],
              ),
              ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  backgroundColor: primaryColor.withValues(alpha: 0.1),
                  foregroundColor: primaryColor,
                  elevation: 0,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                ),
                child: const Text("Details", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildInfoItem(IconData icon, String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(icon, size: 14, color: textSecondaryColor),
            const SizedBox(width: 4),
            Text(label, style: const TextStyle(fontSize: 10, color: textSecondaryColor, fontWeight: FontWeight.bold)),
          ],
        ),
        const SizedBox(height: 4),
        Text(value, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600)),
      ],
    );
  }
}

class _TableHeader extends StatelessWidget {
  const _TableHeader();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
      decoration: BoxDecoration(
        color: const Color(0xFFF8FAFC),
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Row(
        children: const [
          Expanded(flex: 3, child: Text("OUTLET NAME", style: tableHeaderStyle)),
          Expanded(flex: 2, child: Text("ASSIGNED SALESMAN", style: tableHeaderStyle)),
          Expanded(flex: 2, child: Text("BEAT / ROUTE", style: tableHeaderStyle)),
          Expanded(flex: 2, child: Text("SALE VALUE", style: tableHeaderStyle)),
          Expanded(flex: 2, child: Text("STATUS", style: tableHeaderStyle)),
        ],
      ),
    );
  }
}

class _SalesRow extends StatelessWidget {
  final Map<String, dynamic> data;
  const _SalesRow({required this.data});

  @override
  Widget build(BuildContext context) {
    Color statusColor = data["status"] == "Settled" ? const Color(0xFF22C55E) : const Color(0xFFF59E0B);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      child: Row(
        children: [
          Expanded(flex: 3, child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(data["outlet"], style: const TextStyle(fontWeight: FontWeight.bold)),
              const Text("Category: General Trade", style: TextStyle(fontSize: 10, color: textSecondaryColor)),
            ],
          )),
          Expanded(flex: 2, child: Text(data["salesman"], style: const TextStyle(fontSize: 13))),
          Expanded(flex: 2, child: Text(data["beat"], style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600))),
          Expanded(flex: 2, child: Text(data["amount"], style: const TextStyle(fontWeight: FontWeight.w900, color: primaryColor))),
          Expanded(flex: 2, child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(color: statusColor.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(8)),
            child: Text(data["status"], style: TextStyle(color: statusColor, fontSize: 11, fontWeight: FontWeight.bold), textAlign: TextAlign.center),
          )),
        ],
      ),
    );
  }
}

const tableHeaderStyle = TextStyle(fontSize: 10, fontWeight: FontWeight.w900, color: Color(0xFF64748B), letterSpacing: 0.5);
