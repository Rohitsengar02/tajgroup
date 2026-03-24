import 'package:flutter/material.dart';
import '../../constants.dart';
import '../../responsive.dart';

class DistributionScreen extends StatelessWidget {
  const DistributionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(defaultPadding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const _DistributionHeader(),
            const SizedBox(height: defaultPadding),
            const _DistributionStats(),
            const SizedBox(height: defaultPadding * 1.5),
            const _SearchAndMapBar(),
            const SizedBox(height: defaultPadding * 1.5),
            const _DistributionGrid(),
            const SizedBox(height: defaultPadding * 2),
          ],
        ),
      ),
    );
  }
}

class _DistributionHeader extends StatelessWidget {
  const _DistributionHeader();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Distribution",
          style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: textPrimaryColor),
        ),
        const SizedBox(height: 4),
        Text(
          "Live logistics & delivery tracking",
          style: TextStyle(fontSize: 14, color: textSecondaryColor, fontWeight: FontWeight.w500),
        ),
      ],
    );
  }
}

class _DistributionStats extends StatelessWidget {
  const _DistributionStats();

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      int crossAxisCount = Responsive.isMobile(context) ? 2 : 4;
      return GridView.count(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        crossAxisCount: crossAxisCount,
        crossAxisSpacing: defaultPadding,
        mainAxisSpacing: defaultPadding,
        childAspectRatio: 2.2,
        children: [
          _buildStatCard("Active Vehicles", "8", Icons.local_shipping_outlined, const Color(0xFF6366F1)),
          _buildStatCard("In Transit", "24", Icons.access_time_rounded, const Color(0xFFF59E0B)),
          _buildStatCard("Delivered", "156", Icons.check_circle_outline_rounded, const Color(0xFF22C55E)),
          _buildStatCard("Routes Covered", "12", Icons.map_outlined, const Color(0xFFA855F7)),
        ],
      );
    });
  }

  Widget _buildStatCard(String title, String value, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: surfaceColor,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(color: Colors.black.withValues(alpha: 0.02), blurRadius: 10, offset: const Offset(0, 5))
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(color: color.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(12)),
            child: Icon(icon, color: color, size: 24),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(value, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w900, color: textPrimaryColor)),
                Text(title, style: const TextStyle(fontSize: 11, color: textSecondaryColor, fontWeight: FontWeight.w600), overflow: TextOverflow.ellipsis),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _SearchAndMapBar extends StatelessWidget {
  const _SearchAndMapBar();

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Container(
            height: 48,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            decoration: BoxDecoration(
              color: surfaceColor,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: textSecondaryColor.withValues(alpha: 0.1)),
            ),
            child: const TextField(
              decoration: InputDecoration(
                hintText: "Search drivers or vehicles...",
                hintStyle: TextStyle(fontSize: 14, color: textSecondaryColor),
                icon: Icon(Icons.search, size: 20, color: textSecondaryColor),
                border: InputBorder.none,
              ),
            ),
          ),
        ),
        const SizedBox(width: 16),
        _buildFilterButton(),
        const SizedBox(width: 16),
        _buildLiveMapButton(),
      ],
    );
  }

  Widget _buildFilterButton() {
    return Container(
      height: 48,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: surfaceColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: textSecondaryColor.withValues(alpha: 0.1)),
      ),
      child: Row(
        children: const [
          Icon(Icons.filter_list_rounded, size: 20, color: textSecondaryColor),
          SizedBox(width: 8),
          Text("Filters", style: TextStyle(fontSize: 14, color: textSecondaryColor, fontWeight: FontWeight.w600)),
        ],
      ),
    );
  }

  Widget _buildLiveMapButton() {
    return Container(
      height: 48,
      padding: const EdgeInsets.symmetric(horizontal: 20),
      decoration: BoxDecoration(
        color: const Color(0xFF6366F1),
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(color: const Color(0xFF6366F1).withValues(alpha: 0.3), blurRadius: 10, offset: const Offset(0, 4))
        ],
      ),
      child: Center(
        child: Row(
          children: const [
            Icon(Icons.location_on_rounded, size: 18, color: Colors.white),
            SizedBox(width: 8),
            Text("Live Map", style: TextStyle(fontSize: 14, color: Colors.white, fontWeight: FontWeight.bold)),
          ],
        ),
      ),
    );
  }
}

class _DistributionGrid extends StatelessWidget {
  const _DistributionGrid();

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      int crossAxisCount = Responsive.isMobile(context) ? 1 : (Responsive.isTablet(context) ? 2 : 3);
      return GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: crossAxisCount,
          crossAxisSpacing: defaultPadding,
          mainAxisSpacing: defaultPadding,
          childAspectRatio: 1.6,
        ),
        itemCount: 5,
        itemBuilder: (context, index) {
          final drivers = [
            {"initial": "RK", "name": "Rajesh Kumar", "vehicle": "MH-12-AB-1234", "status": "In Transit", "statusColor": const Color(0xFF3B82F6), "route": "Downtown", "orders": "8/12", "eta": "4:30 PM", "progress": 0.6},
            {"initial": "SP", "name": "Suresh Patel", "vehicle": "MH-12-CD-5678", "status": "Completed", "statusColor": const Color(0xFF22C55E), "route": "Market Area", "orders": "15/15", "eta": "-", "progress": 1.0},
            {"initial": "AS", "name": "Amit Singh", "vehicle": "MH-12-EF-9012", "status": "In Transit", "statusColor": const Color(0xFF3B82F6), "route": "Industrial", "orders": "3/10", "eta": "5:00 PM", "progress": 0.3},
            {"initial": "VS", "name": "Vijay Sharma", "vehicle": "MH-12-GH-3456", "status": "Pending", "statusColor": const Color(0xFFF59E0B), "route": "Residential", "orders": "0/8", "eta": "-", "progress": 0.0},
            {"initial": "MG", "name": "Manoj Gupta", "vehicle": "MH-12-IJ-7890", "status": "Completed", "statusColor": const Color(0xFF22C55E), "route": "Highway", "orders": "6/6", "eta": "-", "progress": 1.0},
          ];
          final driver = drivers[index];
          return _DriverCard(
            initial: driver["initial"] as String,
            name: driver["name"] as String,
            vehicle: driver["vehicle"] as String,
            status: driver["status"] as String,
            statusColor: driver["statusColor"] as Color,
            route: driver["route"] as String,
            orders: driver["orders"] as String,
            eta: driver["eta"] as String,
            progress: driver["progress"] as double,
          );
        },
      );
    });
  }
}

class _DriverCard extends StatefulWidget {
  final String initial, name, vehicle, status, route, orders, eta;
  final Color statusColor;
  final double progress;

  const _DriverCard({
    required this.initial,
    required this.name,
    required this.vehicle,
    required this.status,
    required this.statusColor,
    required this.route,
    required this.orders,
    required this.eta,
    required this.progress,
  });

  @override
  State<_DriverCard> createState() => _DriverCardState();
}

class _DriverCardState extends State<_DriverCard> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: surfaceColor,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: _isHovered ? primaryColor.withValues(alpha: 0.1) : Colors.black.withValues(alpha: 0.03),
              blurRadius: _isHovered ? 20 : 10,
              offset: _isHovered ? const Offset(0, 10) : const Offset(0, 5),
            )
          ],
        ),
        child: Column(
          children: [
            Row(
              children: [
                CircleAvatar(
                  radius: 20,
                  backgroundColor: widget.statusColor.withValues(alpha: 0.1),
                  child: Text(
                    widget.initial,
                    style: TextStyle(color: widget.statusColor, fontWeight: FontWeight.bold, fontSize: 13),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(widget.name, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: textPrimaryColor)),
                      Text(widget.vehicle, style: const TextStyle(fontSize: 12, color: textSecondaryColor)),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: widget.statusColor.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    widget.status,
                    style: TextStyle(color: widget.statusColor, fontSize: 10, fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
            const Spacer(),
            _buildInfoRow("Route:", widget.route),
            const SizedBox(height: 8),
            _buildInfoRow("Orders:", widget.orders),
            const SizedBox(height: 8),
            _buildInfoRow("ETA:", widget.eta),
            const Spacer(),
            Stack(
              children: [
                Container(
                  height: 4,
                  width: double.infinity,
                  decoration: BoxDecoration(color: bgColor, borderRadius: BorderRadius.circular(10)),
                ),
                FractionallySizedBox(
                  widthFactor: widget.progress,
                  child: Container(
                    height: 4,
                    decoration: BoxDecoration(color: primaryColor, borderRadius: BorderRadius.circular(10)),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: const TextStyle(fontSize: 13, color: textSecondaryColor, fontWeight: FontWeight.w500)),
        Text(value, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: textPrimaryColor)),
      ],
    );
  }
}
