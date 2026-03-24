import 'package:flutter/material.dart';
import '../../constants.dart';
import '../../responsive.dart';

class PrimarySalesScreen extends StatelessWidget {
  const PrimarySalesScreen({super.key});

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
            const _PrimaryAnalytics(),
            const SizedBox(height: defaultPadding * 1.5),
            const _RegionalDistribution(),
            const SizedBox(height: defaultPadding * 1.5),
            const _ActionRow(),
            const SizedBox(height: defaultPadding),
            const _PrimarySalesTable(),
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
          "Primary Sales",
          style: TextStyle(fontSize: isMobile ? 24 : 28, fontWeight: FontWeight.bold, color: textPrimaryColor),
        ),
        const SizedBox(height: 4),
        Text(
          "Manage distributor-level shipments and bulk inventory movement",
          style: TextStyle(fontSize: isMobile ? 12 : 14, color: textSecondaryColor, fontWeight: FontWeight.w500),
        ),
      ],
    );
  }
}

class _PrimaryAnalytics extends StatelessWidget {
  const _PrimaryAnalytics();

  @override
  Widget build(BuildContext context) {
    bool isMobile = Responsive.isMobile(context);
    List<Widget> stats = [
      _buildStatCard("Total Primary", "₹84.2L", Icons.warehouse_rounded, [const Color(0xFF1E293B), const Color(0xFF334155)]),
      _buildStatCard("Distributors", "42", Icons.hub_rounded, [const Color(0xFF6366F1), const Color(0xFF818CF8)]),
      _buildStatCard("In Dispatch", "12 Bills", Icons.local_shipping_rounded, [const Color(0xFFF59E0B), const Color(0xFFFBBF24)]),
      _buildStatCard("Growth (MoM)", "+18%", Icons.trending_up_rounded, [const Color(0xFF22C55E), const Color(0xFF4ADE80)]),
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

class _RegionalDistribution extends StatelessWidget {
  const _RegionalDistribution();

  @override
  Widget build(BuildContext context) {
    bool isMobile = Responsive.isMobile(context);
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
          const Text("Zonal Supply Chain Distribution", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          const SizedBox(height: 24),
          isMobile 
            ? Column(
                children: [
                  _buildZoneCard("North Zone", "₹32L", 0.38, const Color(0xFF6366F1)),
                  const SizedBox(height: 16),
                  _buildZoneCard("West Zone", "₹28L", 0.33, const Color(0xFF10B981)),
                  const SizedBox(height: 16),
                  _buildZoneCard("South Zone", "₹24L", 0.29, const Color(0xFFF59E0B)),
                ],
              )
            : Row(
                children: [
                  _buildZoneCard("North Zone", "₹32L", 0.38, const Color(0xFF6366F1)),
                  const SizedBox(width: 20),
                  _buildZoneCard("West Zone", "₹28L", 0.33, const Color(0xFF10B981)),
                  const SizedBox(width: 20),
                  _buildZoneCard("South Zone", "₹24L", 0.29, const Color(0xFFF59E0B)),
                ],
              ),
        ],
      ),
    );
  }

  Widget _buildZoneCard(String zone, String value, double share, Color color) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(color: color.withValues(alpha: 0.05), borderRadius: BorderRadius.circular(16), border: Border.all(color: color.withValues(alpha: 0.1))),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(zone, style: TextStyle(color: color, fontWeight: FontWeight.bold, fontSize: 13)),
          const SizedBox(height: 12),
          Text(value, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w900, color: textPrimaryColor)),
          const SizedBox(height: 8),
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: LinearProgressIndicator(value: share, backgroundColor: color.withValues(alpha: 0.1), color: color, minHeight: 4),
          ),
        ],
      ),
    );
  }
}

class _ActionRow extends StatelessWidget {
  const _ActionRow();

  @override
  Widget build(BuildContext context) {
    bool isMobile = Responsive.isMobile(context);
    return isMobile 
      ? Column(
          children: [
            Container(
              height: 48,
              decoration: BoxDecoration(
                color: surfaceColor,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.grey.withValues(alpha: 0.1)),
              ),
              child: const TextField(
                decoration: InputDecoration(
                  hintText: "Search Bill ID, Distributor...",
                  prefixIcon: Icon(Icons.search, size: 20),
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.symmetric(vertical: 14),
                ),
              ),
            ),
            const SizedBox(height: 12),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF1E293B),
                  elevation: 0,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                icon: const Icon(Icons.add_rounded, color: Colors.white),
                label: const Text("Bulk Invoice", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
              ),
            ),
          ],
        )
      : Row(
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
                    hintText: "Search Bill ID, Distributor...",
                    prefixIcon: Icon(Icons.search, size: 20),
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.symmetric(vertical: 14),
                  ),
                ),
              ),
            ),
            const SizedBox(width: 12),
            ElevatedButton.icon(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF1E293B),
                elevation: 0,
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
              icon: const Icon(Icons.add_rounded, color: Colors.white),
              label: const Text("Bulk Invoice", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
            ),
          ],
        );
  }
}

class _PrimarySalesTable extends StatelessWidget {
  const _PrimarySalesTable();

  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> sales = [
      {"id": "PS-11021", "distributor": "Taj North Hub", "date": "05 Mar 2026", "value": "₹8,45,000", "transit": "Dispatched"},
      {"id": "PS-11022", "distributor": "Pune Superstockist", "date": "04 Mar 2026", "value": "₹12,20,000", "transit": "Delivered"},
      {"id": "PS-11023", "distributor": "Nashik Distro", "date": "04 Mar 2026", "value": "₹4,50,000", "transit": "Pending"},
    ];

    bool isMobile = Responsive.isMobile(context);

    if (isMobile) {
      return ListView.separated(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: sales.length,
        separatorBuilder: (context, index) => const SizedBox(height: 12),
        itemBuilder: (context, index) => _PrimaryMobileCard(data: sales[index]),
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

class _PrimaryMobileCard extends StatelessWidget {
  final Map<String, dynamic> data;
  const _PrimaryMobileCard({required this.data});

  @override
  Widget build(BuildContext context) {
    Color statusColor = data["transit"] == "Delivered" 
        ? const Color(0xFF22C55E) 
        : data["transit"] == "Dispatched" 
            ? const Color(0xFF3B82F6) 
            : const Color(0xFFF59E0B);

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
              Text(data["id"], style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: Color(0xFF1E293B))),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(color: statusColor.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(8)),
                child: Text(data["transit"], style: TextStyle(color: statusColor, fontSize: 11, fontWeight: FontWeight.bold)),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(color: primaryColor.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(10)),
                child: const Icon(Icons.hub_rounded, color: primaryColor, size: 20),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(data["distributor"], style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
                    Text(data["date"], style: const TextStyle(fontSize: 11, color: textSecondaryColor)),
                  ],
                ),
              ),
            ],
          ),
          const Divider(height: 32),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text("Invoice Value", style: TextStyle(fontSize: 10, color: textSecondaryColor, fontWeight: FontWeight.bold)),
                  Text(data["value"], style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w900, color: primaryColor)),
                ],
              ),
              ElevatedButton.icon(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  backgroundColor: surfaceColor,
                  foregroundColor: textPrimaryColor,
                  elevation: 0,
                  side: BorderSide(color: Colors.grey.withValues(alpha: 0.2)),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                ),
                icon: const Icon(Icons.visibility_outlined, size: 16),
                label: const Text("View Bill", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _TableHeader extends StatelessWidget {
  const _TableHeader();
  @override
  Widget build(BuildContext context) {
    return Container(padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20), decoration: BoxDecoration(color: const Color(0xFFF8FAFC), borderRadius: const BorderRadius.vertical(top: Radius.circular(20))), child: Row(children: const [Expanded(flex: 2, child: Text("BILL ID", style: tableHeaderStyle)), Expanded(flex: 3, child: Text("DISTRIBUTOR", style: tableHeaderStyle)), Expanded(flex: 2, child: Text("BILL DATE", style: tableHeaderStyle)), Expanded(flex: 2, child: Text("VALUE", style: tableHeaderStyle)), Expanded(flex: 2, child: Text("TRANSIT", style: tableHeaderStyle))]));
  }
}

class _SalesRow extends StatelessWidget {
  final Map<String, dynamic> data;
  const _SalesRow({required this.data});
  @override
  Widget build(BuildContext context) {
    Color statusColor = data["transit"] == "Delivered" ? const Color(0xFF22C55E) : data["transit"] == "Dispatched" ? const Color(0xFF3B82F6) : const Color(0xFFF59E0B);
    return Padding(padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16), child: Row(children: [Expanded(flex: 2, child: Text(data["id"], style: const TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF1E293B)))), Expanded(flex: 3, child: Text(data["distributor"], style: const TextStyle(fontWeight: FontWeight.bold))), Expanded(flex: 2, child: Text(data["date"], style: const TextStyle(fontSize: 13))), Expanded(flex: 2, child: Text(data["value"], style: const TextStyle(fontWeight: FontWeight.w900, color: primaryColor))), Expanded(flex: 2, child: Container(padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4), decoration: BoxDecoration(color: statusColor.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(8)), child: Text(data["transit"], style: TextStyle(color: statusColor, fontSize: 11, fontWeight: FontWeight.bold), textAlign: TextAlign.center)))]));
  }
}

const tableHeaderStyle = TextStyle(fontSize: 10, fontWeight: FontWeight.w900, color: Color(0xFF64748B), letterSpacing: 0.5);
