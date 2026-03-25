import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../../constants.dart';
import '../../responsive.dart';
import 'add_distribution_screen.dart';

class DistributionScreen extends StatefulWidget {
  const DistributionScreen({super.key});

  @override
  State<DistributionScreen> createState() => _DistributionScreenState();
}

class _DistributionScreenState extends State<DistributionScreen> {
  List<dynamic> _distributions = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchDistributions();
  }

  Future<void> _fetchDistributions() async {
    setState(() => _isLoading = true);
    try {
      final response = await http.get(Uri.parse('$backendUrl/api/distribution'));
      if (response.statusCode == 200) {
        setState(() => _distributions = jsonDecode(response.body));
      }
    } catch (e) {
      debugPrint("Error fetching distributions: $e");
    } finally {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _deleteDistribution(String id) async {
    try {
      final response = await http.delete(Uri.parse('$backendUrl/api/distribution/$id'));
      if (response.statusCode == 200) {
        _fetchDistributions();
      }
    } catch (e) {
      debugPrint("Error deleting distribution: $e");
    }
  }

  void _navigateToAdd() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const AddDistributionScreen()),
    );
    if (result == true) _fetchDistributions();
  }

  void _navigateToUpdate(Map<String, dynamic> data) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => AddDistributionScreen(distribution: data)),
    );
    if (result == true) _fetchDistributions();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: RefreshIndicator(
        onRefresh: _fetchDistributions,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(defaultPadding),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _DistributionHeader(onAdd: _navigateToAdd),
              const SizedBox(height: defaultPadding),
              _DistributionStats(distributions: _distributions),
              const SizedBox(height: defaultPadding * 1.5),
              const _SearchAndMapBar(),
              const SizedBox(height: defaultPadding * 1.5),
              _isLoading 
                  ? const Center(child: CircularProgressIndicator())
                  : _DistributionGrid(
                      distributions: _distributions, 
                      onEdit: _navigateToUpdate,
                      onDelete: _deleteDistribution,
                    ),
              const SizedBox(height: defaultPadding * 2),
            ],
          ),
        ),
      ),
    );
  }
}

class _DistributionHeader extends StatelessWidget {
  final VoidCallback onAdd;
  const _DistributionHeader({required this.onAdd});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
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
        ),
        ElevatedButton.icon(
          onPressed: onAdd,
          icon: const Icon(Icons.add, color: Colors.white),
          label: const Text("Add New", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
          style: ElevatedButton.styleFrom(
            backgroundColor: primaryColor,
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          ),
        ),
      ],
    );
  }
}

class _DistributionStats extends StatelessWidget {
  final List<dynamic> distributions;
  const _DistributionStats({required this.distributions});

  @override
  Widget build(BuildContext context) {
    int transit = distributions.where((d) => d['status'] == "In Transit").length;
    int completed = distributions.where((d) => d['status'] == "Completed").length;
    int pending = distributions.where((d) => d['status'] == "Pending").length;
    
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
          _buildStatCard("Active Vehicles", distributions.length.toString(), Icons.local_shipping_outlined, const Color(0xFF6366F1)),
          _buildStatCard("In Transit", transit.toString(), Icons.access_time_rounded, const Color(0xFFF59E0B)),
          _buildStatCard("Delivered", completed.toString(), Icons.check_circle_outline_rounded, const Color(0xFF22C55E)),
          _buildStatCard("Pending", pending.toString(), Icons.map_outlined, const Color(0xFFA855F7)),
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
  final List<dynamic> distributions;
  final Function(Map<String, dynamic>) onEdit;
  final Function(String) onDelete;
  
  const _DistributionGrid({
    required this.distributions, 
    required this.onEdit,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    if (distributions.isEmpty) {
      return Center(
        child: Column(
          children: [
            const SizedBox(height: 40),
            Icon(Icons.local_shipping_outlined, size: 64, color: textSecondaryColor.withValues(alpha: 0.2)),
            const SizedBox(height: 16),
            const Text("No active distributions found.", style: TextStyle(color: textSecondaryColor, fontWeight: FontWeight.w600)),
          ],
        ),
      );
    }

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
        itemCount: distributions.length,
        itemBuilder: (context, index) {
          final driver = distributions[index];
          
          Color statusColor = const Color(0xFF3B82F6);
          if (driver['status'] == 'Completed') statusColor = const Color(0xFF22C55E);
          if (driver['status'] == 'Pending') statusColor = const Color(0xFFF59E0B);

          return _DriverCard(
            id: driver['_id'],
            initial: driver["initials"] ?? "D",
            name: driver["driverName"] ?? "Unknown",
            vehicle: driver["vehicleNumber"] ?? "-",
            status: driver["status"] ?? "Pending",
            statusColor: statusColor,
            route: driver["route"] ?? "No Route",
            orders: "${driver['completedOrders']}/${driver['totalOrders']}",
            eta: driver["eta"] ?? "-",
            progress: (driver["progress"] ?? 0.0).toDouble(),
            onEdit: () => onEdit(driver),
            onDelete: () => onDelete(driver['_id']),
          );
        },
      );
    });
  }
}

class _DriverCard extends StatefulWidget {
  final String id, initial, name, vehicle, status, route, orders, eta;
  final Color statusColor;
  final double progress;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const _DriverCard({
    required this.id,
    required this.initial,
    required this.name,
    required this.vehicle,
    required this.status,
    required this.statusColor,
    required this.route,
    required this.orders,
    required this.eta,
    required this.progress,
    required this.onEdit,
    required this.onDelete,
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
                PopupMenuButton<String>(
                  icon: const Icon(Icons.more_vert, size: 20, color: textSecondaryColor),
                  onSelected: (v) {
                    if (v == 'edit') widget.onEdit();
                    if (v == 'delete') widget.onDelete();
                  },
                  itemBuilder: (context) => [
                    const PopupMenuItem(value: 'edit', child: Row(children: [Icon(Icons.edit_outlined, size: 18), SizedBox(width: 8), Text("Edit")])),
                    const PopupMenuItem(value: 'delete', child: Row(children: [Icon(Icons.delete_outline, size: 18, color: Colors.red), SizedBox(width: 8), Text("Delete", style: TextStyle(color: Colors.red))])),
                  ],
                ),
              ],
            ),
            const Spacer(),
            _buildInfoRow("Status:", widget.status, color: widget.statusColor),
            const SizedBox(height: 8),
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
                  widthFactor: widget.progress.clamp(0.0, 1.0),
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

  Widget _buildInfoRow(String label, String value, {Color? color}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: const TextStyle(fontSize: 13, color: textSecondaryColor, fontWeight: FontWeight.w500)),
        Text(value, style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: color ?? textPrimaryColor)),
      ],
    );
  }
}
