import 'package:flutter/material.dart';

class StockistSideMenu extends StatefulWidget {
  final Function(int)? onIndexChanged;
  const StockistSideMenu({super.key, this.onIndexChanged});

  @override
  State<StockistSideMenu> createState() => _StockistSideMenuState();
}

class _StockistSideMenuState extends State<StockistSideMenu> {
  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() => _selectedIndex = index);
    widget.onIndexChanged?.call(index);
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: Colors.white,
      elevation: 0,
      child: Container(
        decoration: BoxDecoration(border: Border(right: BorderSide(color: Colors.grey.withOpacity(0.05)))),
        child: Column(
          children: [
            _buildHeader(),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                children: [
                  const _SectionHeader(title: "CORE"),
                  _buildMenuItem("Dashboard", Icons.grid_view_rounded, 0),
                  _buildMenuItem("Orders", Icons.shopping_bag_outlined, 1, badge: "8"),
                  _buildMenuItem("Inventory", Icons.inventory_2_outlined, 2, badge: "Low"),
                  
                  const _SectionHeader(title: "PARTNERS"),
                  _buildMenuItem("Distributors", Icons.hub_outlined, 3),
                  _buildMenuItem("Sales Reports", Icons.assessment_outlined, 4),
                  
                  const _SectionHeader(title: "LIFECYCLE"),
                  _buildMenuItem("Payments", Icons.payments_outlined, 5),
                  _buildMenuItem("Shipments", Icons.local_shipping_outlined, 6),
                ],
              ),
            ),
            _buildUserCard(),
          ],
        ),
      ),
    );
  }

  Widget _buildMenuItem(String title, IconData icon, int index, {String? badge}) {
    bool isActive = _selectedIndex == index;
    return InkWell(
      onTap: () => _onItemTapped(index),
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        margin: const EdgeInsets.only(bottom: 4),
        decoration: BoxDecoration(color: isActive ? Colors.black : Colors.transparent, borderRadius: BorderRadius.circular(16)),
        child: Row(
          children: [
            Icon(icon, size: 20, color: isActive ? Colors.white : Colors.grey[800]),
            const SizedBox(width: 16),
            Expanded(child: Text(title, style: TextStyle(fontSize: 14, color: isActive ? Colors.white : Colors.grey[800], fontWeight: isActive ? FontWeight.bold : FontWeight.w600))),
            if (badge != null)
              Container(padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4), decoration: BoxDecoration(color: badge == "Low" ? Colors.red : const Color(0xFFF97316), borderRadius: BorderRadius.circular(10)), child: Text(badge, style: const TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold))),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.only(top: 40, bottom: 32, left: 24, right: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(width: 40, height: 40, decoration: const BoxDecoration(color: Colors.indigo, shape: BoxShape.circle), child: const Icon(Icons.warehouse_rounded, color: Colors.white, size: 24)),
          const SizedBox(height: 16),
          const Text("Tajnova", style: TextStyle(fontSize: 18, fontWeight: FontWeight.w900, color: Colors.black, letterSpacing: 1.2)),
          Text("SUPER STOCKIST", style: TextStyle(fontSize: 10, fontWeight: FontWeight.w800, color: Colors.grey[500], letterSpacing: 1.5)),
        ],
      ),
    );
  }

  Widget _buildUserCard() {
    return Container(
      padding: const EdgeInsets.all(24),
      child: Row(
        children: [
          const CircleAvatar(radius: 16, backgroundImage: NetworkImage("https://images.unsplash.com/photo-1472099645785-5658abf4ff4e?q=80&w=200&auto=format&fit=crop")),
          const SizedBox(width: 12),
          const Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, mainAxisSize: MainAxisSize.min, children: [Text("S. Stockist", style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold)), Text("Region: North", style: TextStyle(fontSize: 11, color: Colors.grey))])),
          const Icon(Icons.logout_rounded, size: 18, color: Colors.redAccent),
        ],
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  final String title;
  const _SectionHeader({required this.title});
  @override
  Widget build(BuildContext context) {
    return Padding(padding: const EdgeInsets.only(left: 4, bottom: 12, top: 20), child: Text(title, style: TextStyle(color: Colors.grey[400], fontSize: 10, fontWeight: FontWeight.w900, letterSpacing: 2)));
  }
}
