import 'package:flutter/material.dart';
import '../../constants.dart';
import '../../responsive.dart';

class DeliveryChallanScreen extends StatelessWidget {
  const DeliveryChallanScreen({super.key});

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
            const _ChallanAnalytics(),
            const SizedBox(height: defaultPadding * 1.5),
            const _ActionRow(),
            const SizedBox(height: defaultPadding),
            const _ChallanTable(),
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
          "Delivery Challans",
          style: TextStyle(fontSize: isMobile ? 24 : 28, fontWeight: FontWeight.bold, color: textPrimaryColor),
        ),
        const SizedBox(height: 4),
        Text(
          "Manage goods dispatch and delivery confirmations",
          style: TextStyle(fontSize: isMobile ? 13 : 14, color: textSecondaryColor, fontWeight: FontWeight.w500),
        ),
      ],
    );
  }
}

class _ChallanAnalytics extends StatelessWidget {
  const _ChallanAnalytics();

  @override
  Widget build(BuildContext context) {
    bool isMobile = Responsive.isMobile(context);
    List<Widget> stats = [
      _buildStatCard("Active Challans", "24", Icons.local_shipping_rounded, [const Color(0xFF3B82F6), const Color(0xFF60A5FA)]),
      _buildStatCard("In Transit", "18", Icons.moving_rounded, [const Color(0xFFF59E0B), const Color(0xFFFBBF24)]),
      _buildStatCard("Delivered", "145", Icons.verified_rounded, [const Color(0xFF22C55E), const Color(0xFF4ADE80)]),
      _buildStatCard("Pending Sign", "12", Icons.pending_actions_rounded, [const Color(0xFFEF4444), const Color(0xFFF87171)]),
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
                  hintText: "Search Challan ID, Customer...",
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
                  backgroundColor: primaryColor,
                  elevation: 0,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                icon: const Icon(Icons.add_rounded, color: Colors.white),
                label: const Text("New Challan", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
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
                    hintText: "Search Challan ID, Customer...",
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
                backgroundColor: primaryColor,
                elevation: 0,
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
              icon: const Icon(Icons.add_rounded, color: Colors.white),
              label: const Text("New Challan", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
            ),
          ],
        );
  }
}

class _ChallanTable extends StatelessWidget {
  const _ChallanTable();

  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> challans = [
      {"id": "DC-5521", "customer": "Metro retail", "date": "05 Mar, 10:30 AM", "driver": "Sunil Kumar", "items": "12 Items", "status": "In Transit"},
      {"id": "DC-5522", "customer": "Global Mart", "date": "05 Mar, 09:15 AM", "driver": "Rajesh V", "items": "45 Items", "status": "Delivered"},
      {"id": "DC-5523", "customer": "Royal Traders", "date": "04 Mar, 04:45 PM", "driver": "Amit S", "items": "8 Items", "status": "Pending Sign"},
    ];

    bool isMobile = Responsive.isMobile(context);

    if (isMobile) {
      return ListView.separated(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: challans.length,
        separatorBuilder: (context, index) => const SizedBox(height: 12),
        itemBuilder: (context, index) => _ChallanMobileCard(data: challans[index]),
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
            itemCount: challans.length,
            separatorBuilder: (context, index) => Divider(height: 1, color: Colors.grey.withValues(alpha: 0.05)),
            itemBuilder: (context, index) => _ChallanRow(data: challans[index]),
          ),
        ],
      ),
    );
  }
}

class _ChallanMobileCard extends StatelessWidget {
  final Map<String, dynamic> data;
  const _ChallanMobileCard({required this.data});

  @override
  Widget build(BuildContext context) {
    Color statusColor;
    switch (data["status"]) {
      case "Delivered": statusColor = const Color(0xFF22C55E); break;
      case "In Transit": statusColor = const Color(0xFF3B82F6); break;
      default: statusColor = const Color(0xFFEF4444);
    }

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
              Text(data["id"], style: const TextStyle(fontWeight: FontWeight.bold, color: primaryColor)),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(color: statusColor.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(6)),
                child: Text(data["status"], style: TextStyle(color: statusColor, fontSize: 10, fontWeight: FontWeight.bold)),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(data["customer"], style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
                    const SizedBox(height: 4),
                    const Text("Warehouse A -> Main Store", style: TextStyle(fontSize: 11, color: textSecondaryColor)),
                  ],
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  const Text("ITEMS", style: TextStyle(fontSize: 8, fontWeight: FontWeight.bold, color: textSecondaryColor)),
                  Text(data["items"], style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 14)),
                ],
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(data["date"], style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold)),
                  Text("Driver: ${data["driver"]}", style: const TextStyle(fontSize: 10, color: textSecondaryColor)),
                ],
              ),
              Row(
                children: [
                  _buildIconButton(Icons.map_outlined),
                  const SizedBox(width: 8),
                  _buildIconButton(Icons.visibility_outlined),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildIconButton(IconData icon) {
    return Container(
      padding: const EdgeInsets.all(6),
      decoration: BoxDecoration(color: bgColor, borderRadius: BorderRadius.circular(8)),
      child: Icon(icon, size: 16, color: textPrimaryColor),
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
          Expanded(flex: 2, child: Text("CHALLAN ID", style: tableHeaderStyle)),
          Expanded(flex: 3, child: Text("CUSTOMER / DESTINATION", style: tableHeaderStyle)),
          Expanded(flex: 2, child: Text("DISPATCH INFO", style: tableHeaderStyle)),
          Expanded(flex: 2, child: Text("MANIFEST", style: tableHeaderStyle)),
          Expanded(flex: 2, child: Text("STATUS", style: tableHeaderStyle)),
        ],
      ),
    );
  }
}

class _ChallanRow extends StatelessWidget {
  final Map<String, dynamic> data;
  const _ChallanRow({required this.data});

  @override
  Widget build(BuildContext context) {
    Color statusColor;
    switch (data["status"]) {
      case "Delivered": statusColor = const Color(0xFF22C55E); break;
      case "In Transit": statusColor = const Color(0xFF3B82F6); break;
      default: statusColor = const Color(0xFFEF4444);
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      child: Row(
        children: [
          Expanded(flex: 2, child: Text(data["id"], style: const TextStyle(fontWeight: FontWeight.bold, color: primaryColor))),
          Expanded(flex: 3, child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(data["customer"], style: const TextStyle(fontWeight: FontWeight.bold)),
              const Text("Warehouse A -> Main Store", style: TextStyle(fontSize: 10, color: textSecondaryColor)),
            ],
          )),
          Expanded(flex: 2, child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(data["date"], style: const TextStyle(fontSize: 12)),
              Text("Driver: ${data["driver"]}", style: const TextStyle(fontSize: 10, color: textSecondaryColor)),
            ],
          )),
          Expanded(flex: 2, child: Text(data["items"], style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13))),
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
