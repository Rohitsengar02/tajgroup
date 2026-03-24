import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../../constants.dart';
import '../../responsive.dart';
import 'add_route_screen.dart';

class RoutesScreen extends StatefulWidget {
  const RoutesScreen({super.key});

  @override
  State<RoutesScreen> createState() => _RoutesScreenState();
}

class _RoutesScreenState extends State<RoutesScreen> {
  List<dynamic> routesList = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchRoutes();
  }

  Future<void> _fetchRoutes() async {
    setState(() => isLoading = true);
    try {
      final response = await http.get(Uri.parse('$backendUrl/api/routes'));
      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        if (mounted) {
          setState(() {
            routesList = data;
            isLoading = false;
          });
        }
      } else {
        throw Exception('Failed to load routes');
      }
    } catch (error) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error fetching routes: $error'), backgroundColor: errorColor),
        );
        setState(() => isLoading = false);
      }
    }
  }

  Future<void> _deleteRoute(String id) async {
    try {
      final response = await http.delete(Uri.parse('$backendUrl/api/routes/$id'));
      if (response.statusCode == 200) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Route deleted successfully')));
          _fetchRoutes();
        }
      } else {
        throw Exception('Failed to delete route');
      }
    } catch (error) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error deleting route: $error'), backgroundColor: errorColor),
        );
      }
    }
  }

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
            _RoutesStats(routes: routesList),
            const SizedBox(height: defaultPadding * 1.5),
            _SearchAndActionBar(onRefresh: _fetchRoutes),
            const SizedBox(height: defaultPadding * 1.5),
            isLoading
                ? const Center(child: Padding(padding: EdgeInsets.all(50), child: CircularProgressIndicator()))
                : routesList.isEmpty
                    ? const Center(child: Padding(padding: EdgeInsets.all(50), child: Text("No routes found", style: TextStyle(color: textSecondaryColor))))
                    : _RoutesGrid(routes: routesList, onDelete: _deleteRoute, onRefresh: _fetchRoutes),
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
  final List<dynamic> routes;
  const _RoutesStats({required this.routes});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      int crossAxisCount = Responsive.isMobile(context) ? 2 : 4;
      
      int totalRoutes = routes.length;
      int activeRoutes = routes.where((r) => r['status'] == 'Active').length;
      int totalStops = routes.fold(0, (sum, r) => sum + ((r['stops'] as num?)?.toInt() ?? 0));
      
      return GridView.count(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        crossAxisCount: crossAxisCount,
        crossAxisSpacing: defaultPadding,
        mainAxisSpacing: defaultPadding,
        childAspectRatio: 2.2,
        children: [
          _buildGradientStatCard("Total Routes", "$totalRoutes", Icons.route_rounded, [const Color(0xFF6366F1), const Color(0xFF818CF8)]),
          _buildGradientStatCard("Total Stops", "$totalStops", Icons.location_on_rounded, [const Color(0xFF22C55E), const Color(0xFF4ADE80)]),
          _buildGradientStatCard("Avg. Duration", "N/A", Icons.access_time_filled_rounded, [const Color(0xFFF59E0B), const Color(0xFFFBBF24)]),
          _buildGradientStatCard("Active Today", "$activeRoutes", Icons.local_shipping_rounded, [const Color(0xFFA855F7), const Color(0xFFC084FC)]),
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
  final VoidCallback onRefresh;
  const _SearchAndActionBar({required this.onRefresh});

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
        InkWell(
          onTap: onRefresh,
          child: Container(
            height: 48,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            decoration: BoxDecoration(
              color: surfaceColor,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: textSecondaryColor.withValues(alpha: 0.1)),
            ),
            child: const Row(
              children: [
                Icon(Icons.refresh_rounded, size: 20, color: textSecondaryColor),
              ],
            ),
          ),
        ),
        const SizedBox(width: 16),
        _buildCreateRouteButton(context),
      ],
    );
  }

  Widget _buildCreateRouteButton(BuildContext context) {
    return InkWell(
      onTap: () async {
        final result = await Navigator.of(context).push(
          PageRouteBuilder(
            pageBuilder: (context, animation, secondaryAnimation) => const AddRouteScreen(),
            transitionsBuilder: (context, animation, secondaryAnimation, child) {
              return FadeTransition(opacity: animation, child: child);
            },
            opaque: false,
            barrierColor: Colors.black.withValues(alpha: 0.5),
          ),
        );
        if (result == true) {
          onRefresh();
        }
      },
      child: Container(
        height: 48,
        padding: const EdgeInsets.symmetric(horizontal: 20),
        decoration: BoxDecoration(
          color: const Color(0xFF6366F1),
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(color: const Color(0xFF6366F1).withValues(alpha: 0.3), blurRadius: 10, offset: const Offset(0, 4))
          ],
        ),
        child: const Center(
          child: Row(
            children: [
              Icon(Icons.add_rounded, size: 20, color: Colors.white),
              SizedBox(width: 8),
              Text("Create Route", style: TextStyle(fontSize: 14, color: Colors.white, fontWeight: FontWeight.bold)),
            ],
          ),
        ),
      ),
    );
  }
}

class _RoutesGrid extends StatelessWidget {
  final List<dynamic> routes;
  final Function(String) onDelete;
  final VoidCallback onRefresh;

  const _RoutesGrid({required this.routes, required this.onDelete, required this.onRefresh});

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
          mainAxisExtent: 340, // Expanded fixed height to prevent overflow
        ),
        itemCount: routes.length,
        itemBuilder: (context, index) {
          final route = routes[index];
          String status = route['status'] ?? 'Pending';
          Color sColor = const Color(0xFFF59E0B);
          if (status == 'Active') sColor = const Color(0xFF22C55E);
          if (status == 'Inactive') sColor = const Color(0xFF94A3B8);

          return _RouteCard(
            routeData: route,
            statusColor: sColor,
            onDelete: () => _confirmDelete(context, route['_id']),
            onEdit: () => _editRoute(context, route),
          );
        },
      );
    });
  }

  void _confirmDelete(BuildContext context, String id) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Delete Route'),
        content: const Text('Are you sure you want to permanently delete this route?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Cancel')),
          TextButton(
            onPressed: () {
              Navigator.pop(ctx);
              onDelete(id);
            },
            child: const Text('Delete', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  void _editRoute(BuildContext context, Map<String, dynamic> route) async {
    final result = await Navigator.of(context).push(
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) => AddRouteScreen(routeData: route),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          return FadeTransition(opacity: animation, child: child);
        },
        opaque: false,
        barrierColor: Colors.black.withValues(alpha: 0.5),
      ),
    );
    if (result == true) {
      onRefresh();
    }
  }
}

class _RouteCard extends StatefulWidget {
  final Map<String, dynamic> routeData;
  final Color statusColor;
  final VoidCallback onDelete;
  final VoidCallback onEdit;

  const _RouteCard({
    required this.routeData,
    required this.statusColor,
    required this.onDelete,
    required this.onEdit,
  });

  @override
  State<_RouteCard> createState() => _RouteCardState();
}

class _RouteCardState extends State<_RouteCard> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    final r = widget.routeData;
    final name = r['name'] ?? "Unknown Route";
    final status = r['status'] ?? "Pending";
    final start = r['startLocation'] ?? "N/A";
    final end = r['endLocation'] ?? "N/A";
    final stops = r['stops']?.toString() ?? "0";
    final orders = r['totalOrders']?.toString() ?? "0";
    final distance = r['distance'] ?? "0 km";
    final duration = r['duration'] ?? "0 hrs";
    final vehicle = r['vehicle'] ?? "Unassigned";
    final driver = r['driver'] ?? "Unassigned";
    final helper = r['assignedHelper'] ?? "N/A";
    final revenue = r['expectedRevenue']?.toString() ?? "0";

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
                  child: Text(name, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: textPrimaryColor), overflow: TextOverflow.ellipsis),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: widget.statusColor.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    status,
                    style: TextStyle(color: widget.statusColor, fontSize: 11, fontWeight: FontWeight.bold),
                  ),
                ),
                const SizedBox(width: 8),
                PopupMenuButton<String>(
                  padding: EdgeInsets.zero,
                  iconSize: 20,
                  icon: const Icon(Icons.more_vert_rounded, color: textSecondaryColor),
                  onSelected: (value) {
                    if (value == 'edit') widget.onEdit();
                    if (value == 'delete') widget.onDelete();
                  },
                  itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
                    const PopupMenuItem<String>(
                      value: 'edit',
                      child: Row(
                        children: [
                          Icon(Icons.edit_outlined, size: 18, color: textPrimaryColor),
                          SizedBox(width: 8),
                          Text('Edit Route'),
                        ],
                      ),
                    ),
                    const PopupMenuItem<String>(
                      value: 'delete',
                      child: Row(
                        children: [
                          Icon(Icons.delete_outline, size: 18, color: Colors.red),
                          SizedBox(width: 8),
                          Text('Delete', style: TextStyle(color: Colors.red)),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
            
            const SizedBox(height: 8),
            
            Row(
              children: [
                const Icon(Icons.circle_outlined, size: 12, color: textSecondaryColor),
                const SizedBox(width: 8),
                Expanded(child: Text(start, style: const TextStyle(fontSize: 12, color: textPrimaryColor, fontWeight: FontWeight.w500), overflow: TextOverflow.ellipsis)),
              ],
            ),
            Container(
              margin: const EdgeInsets.only(left: 5, top: 4, bottom: 4),
              height: 12,
              width: 1,
              color: textSecondaryColor.withValues(alpha: 0.3),
            ),
            Row(
              children: [
                const Icon(Icons.location_on, size: 12, color: secondaryColor),
                const SizedBox(width: 8),
                Expanded(child: Text(end, style: const TextStyle(fontSize: 12, color: secondaryColor, fontWeight: FontWeight.w600), overflow: TextOverflow.ellipsis)),
              ],
            ),
            
            const SizedBox(height: 16),
            
            Row(
              children: [
                _buildSubStat(stops, "Stops"),
                const SizedBox(width: 8),
                _buildSubStat(orders, "Orders"),
                const SizedBox(width: 8),
                _buildSubStat(distance, "Dist."),
                const SizedBox(width: 8),
                _buildSubStat(duration, "Time"),
              ],
            ),
            
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(color: Colors.grey.withValues(alpha: 0.05), borderRadius: BorderRadius.circular(8)),
              child: Column(
                children: [
                  _buildMiniRow("Vehicle:", vehicle, Icons.local_shipping_outlined),
                  const SizedBox(height: 4),
                  _buildMiniRow("Driver:", driver, Icons.person_outline),
                  const SizedBox(height: 4),
                  _buildMiniRow("Helper:", helper.isEmpty ? "N/A" : helper, Icons.people_outline),
                ],
              ),
            ),
            
            const Divider(height: 24, thickness: 0.5),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                 const Text("Expected Revenue", style: TextStyle(fontSize: 11, color: textSecondaryColor, fontWeight: FontWeight.w600)),
                Text("₹$revenue", style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w900, color: successColor)),
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
        padding: const EdgeInsets.symmetric(vertical: 8),
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Column(
          children: [
            Text(value, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w900, color: textPrimaryColor)),
            Text(label, style: const TextStyle(fontSize: 9, color: textSecondaryColor, fontWeight: FontWeight.w600)),
          ],
        ),
      ),
    );
  }

  Widget _buildMiniRow(String label, String val, IconData icon) {
    return Row(
      children: [
        Icon(icon, size: 14, color: textSecondaryColor.withValues(alpha: 0.8)),
        const SizedBox(width: 6),
        Text(label, style: const TextStyle(fontSize: 11, color: textSecondaryColor, fontWeight: FontWeight.w500)),
        const SizedBox(width: 4),
        Expanded(
          child: Text(
            val, 
            textAlign: TextAlign.right,
            style: const TextStyle(fontSize: 11, color: textPrimaryColor, fontWeight: FontWeight.w600),
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }
}
