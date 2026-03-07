import 'package:flutter/material.dart';
import '../../constants.dart';
import '../../responsive.dart';

class RoutesScreen extends StatelessWidget {
  const RoutesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(defaultPadding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const _RoutesHeader(),
            const SizedBox(height: defaultPadding),
            const _RoutesStats(),
            const SizedBox(height: defaultPadding * 1.5),
            const _SearchAndActionBar(),
            const SizedBox(height: defaultPadding * 1.5),
            const _RoutesGrid(),
            const SizedBox(height: defaultPadding * 2),
          ],
        ),
      ),
    );
  }
}

class _RoutesHeader extends StatelessWidget {
  const _RoutesHeader();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Route Management",
          style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: textPrimaryColor),
        ),
        const SizedBox(height: 4),
        Text(
          "Plan and optimize your delivery logistics",
          style: TextStyle(fontSize: 14, color: textSecondaryColor, fontWeight: FontWeight.w500),
        ),
      ],
    );
  }
}

class _RoutesStats extends StatelessWidget {
  const _RoutesStats();

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
          _buildGradientStatCard("Total Routes", "18", Icons.route_rounded, [const Color(0xFF6366F1), const Color(0xFF818CF8)]),
          _buildGradientStatCard("Total Stops", "245", Icons.location_on_rounded, [const Color(0xFF22C55E), const Color(0xFF4ADE80)]),
          _buildGradientStatCard("Avg. Duration", "4.5 hrs", Icons.access_time_filled_rounded, [const Color(0xFFF59E0B), const Color(0xFFFBBF24)]),
          _buildGradientStatCard("Active Today", "12", Icons.local_shipping_rounded, [const Color(0xFFA855F7), const Color(0xFFC084FC)]),
        ],
      );
    });
  }

  Widget _buildGradientStatCard(String title, String value, IconData icon, List<Color> colors) {
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

class _SearchAndActionBar extends StatelessWidget {
  const _SearchAndActionBar();

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
                hintText: "Search routes...",
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
        _buildCreateRouteButton(),
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

  Widget _buildCreateRouteButton() {
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
            Icon(Icons.add_rounded, size: 20, color: Colors.white),
            SizedBox(width: 8),
            Text("Create Route", style: TextStyle(fontSize: 14, color: Colors.white, fontWeight: FontWeight.bold)),
          ],
        ),
      ),
    );
  }
}

class _RoutesGrid extends StatelessWidget {
  const _RoutesGrid();

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
          childAspectRatio: 1.4,
        ),
        itemCount: 6,
        itemBuilder: (context, index) {
          final routes = [
            {"name": "Route A - Downtown", "status": "Active", "statusColor": const Color(0xFF22C55E), "stops": "12", "distance": "45 km", "duration": "4.5 hrs", "vehicle": "MH-12-AB-1234", "driver": "Rajesh K."},
            {"name": "Route B - Market", "status": "Active", "statusColor": const Color(0xFF22C55E), "stops": "15", "distance": "38 km", "duration": "5 hrs", "vehicle": "MH-12-CD-5678", "driver": "Suresh P."},
            {"name": "Route C - Industrial", "status": "Active", "statusColor": const Color(0xFF22C55E), "stops": "8", "distance": "62 km", "duration": "3.5 hrs", "vehicle": "MH-12-EF-9012", "driver": "Amit S."},
            {"name": "Route D - Residential", "status": "Pending", "statusColor": const Color(0xFFF59E0B), "stops": "20", "distance": "28 km", "duration": "6 hrs", "vehicle": "MH-12-GH-3456", "driver": "Vijay S."},
            {"name": "Route E - Highway", "status": "Active", "statusColor": const Color(0xFF22C55E), "stops": "6", "distance": "85 km", "duration": "3 hrs", "vehicle": "MH-12-IJ-7890", "driver": "Manoj G."},
            {"name": "Route F - Commercial", "status": "Inactive", "statusColor": const Color(0xFF94A3B8), "stops": "18", "distance": "32 km", "duration": "5.5 hrs", "vehicle": "MH-12-KL-4321", "driver": "Arun V."},
          ];
          final route = routes[index % 6];
          return _RouteCard(
            name: route["name"] as String,
            status: route["status"] as String,
            statusColor: route["statusColor"] as Color,
            stops: route["stops"] as String,
            distance: route["distance"] as String,
            duration: route["duration"] as String,
            vehicle: route["vehicle"] as String,
            driver: route["driver"] as String,
          );
        },
      );
    });
  }
}

class _RouteCard extends StatefulWidget {
  final String name, status, stops, distance, duration, vehicle, driver;
  final Color statusColor;

  const _RouteCard({
    required this.name,
    required this.status,
    required this.statusColor,
    required this.stops,
    required this.distance,
    required this.duration,
    required this.vehicle,
    required this.driver,
  });

  @override
  State<_RouteCard> createState() => _RouteCardState();
}

class _RouteCardState extends State<_RouteCard> {
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
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(widget.name, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: textPrimaryColor), overflow: TextOverflow.ellipsis),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: widget.statusColor.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    widget.status,
                    style: TextStyle(color: widget.statusColor, fontSize: 11, fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                _buildSubStat(widget.stops, "Stops"),
                const SizedBox(width: 12),
                _buildSubStat(widget.distance, "Distance"),
                const SizedBox(width: 12),
                _buildSubStat(widget.duration, "Duration"),
              ],
            ),
            const Spacer(),
            const Divider(height: 32, thickness: 0.5),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text("Vehicle:", style: TextStyle(fontSize: 12, color: textSecondaryColor, fontWeight: FontWeight.w500)),
                Text(widget.vehicle, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: textPrimaryColor)),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text("Driver:", style: TextStyle(fontSize: 12, color: textSecondaryColor, fontWeight: FontWeight.w500)),
                Text(widget.driver, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: textPrimaryColor)),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSubStat(String value, String label) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 10),
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          children: [
            Text(value, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w900, color: textPrimaryColor)),
            const SizedBox(height: 2),
            Text(label, style: const TextStyle(fontSize: 10, color: textSecondaryColor, fontWeight: FontWeight.w600)),
          ],
        ),
      ),
    );
  }
}
