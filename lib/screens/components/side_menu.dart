import 'package:flutter/material.dart';
import '../../responsive.dart';

class SideMenu extends StatefulWidget {
  final Function(int)? onIndexChanged;
  const SideMenu({super.key, this.onIndexChanged});

  @override
  State<SideMenu> createState() => _SideMenuState();
}

class _SideMenuState extends State<SideMenu> {
  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
    widget.onIndexChanged?.call(index);
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: Colors.white,
      surfaceTintColor: Colors.white,
      elevation: 0,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border(right: BorderSide(color: Colors.grey.withValues(alpha: 0.1))),
        ),
        child: Column(
          children: [
            const _DrawerHeader(),
            const _SearchBar(),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                children: [
                  _buildMenuItem("Dashboard", Icons.grid_view_rounded, 0),
                  
                  const _SectionHeader(title: "Sales"),
                  _buildMenuItem("Orders", Icons.shopping_cart_outlined, 1, badge: "12"),
                  _buildMenuItem("Estimates / Quotation", Icons.request_page_outlined, 2),
                  _buildMenuItem("Proforma Invoice", Icons.receipt_long_outlined, 3),
                  _buildMenuItem("Payments", Icons.payments_outlined, 4),
                  _buildMenuItem("Delivery Challan", Icons.local_shipping_outlined, 5),
                  _buildMenuItem("Sales Return", Icons.assignment_return_outlined, 6),
                  _buildMenuItem("Secondary Sales", Icons.storefront_outlined, 7),
                  _buildMenuItem("Primary Sales", Icons.business_outlined, 8),

                  const _SectionHeader(title: "Operations"),
                  _buildMenuItem("Customers", Icons.people_outline, 9),
                  _buildMenuItem("Distribution", Icons.local_shipping_outlined, 10),
                  _buildMenuItem("Team", Icons.groups_outlined, 11),

                  const _SectionHeader(title: "Field Ops"),
                  _buildMenuItem("Beats", Icons.map_outlined, 12),
                  _buildMenuItem("Routes", Icons.route_outlined, 13),
                  _buildMenuItem("Network", Icons.hub_outlined, 14),
                  _buildMenuItem("Products & SKU", Icons.inventory_2_outlined, 15),

                  const _SectionHeader(title: "Performance"),
                  _buildMenuItem("Growth & Tracking", Icons.trending_up_rounded, 16),
                  _buildMenuItem("Loyalty", Icons.loyalty_outlined, 17),
                  _buildMenuItem("Schemes", Icons.card_giftcard_outlined, 18),
                  _buildMenuItem("Targets", Icons.track_changes_outlined, 19),
                  _buildMenuItem("Attendance", Icons.how_to_reg_outlined, 20),

                  const _SectionHeader(title: "Payroll"),
                  _buildMenuItem("Payroll & Salary", Icons.account_balance_wallet_outlined, 21),

                  const Divider(height: 32, thickness: 0.5),
                  _buildMenuItem("Reports", Icons.assessment_outlined, 22),
                  _buildMenuItem("Settings", Icons.settings_outlined, 23),

                  const SizedBox(height: 24),
                  const _ModeToggle(),
                  const SizedBox(height: 24),
                ],
              ),
            ),
            const _SidebarUserCard(),
          ],
        ),
      ),
    );
  }

  Widget _buildMenuItem(String title, IconData icon, int index, {String? badge}) {
    return DrawerListTile(
      title: title,
      icon: icon,
      press: () => _onItemTapped(index),
      isActive: _selectedIndex == index,
      badge: badge,
    );
  }
}

class _DrawerHeader extends StatelessWidget {
  const _DrawerHeader();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(top: 40, bottom: 20, left: 16, right: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFF2D3142), Color(0xFF1A1D29)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(10),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.1),
                  blurRadius: 8,
                  offset: const Offset(0, 4),
                )
              ],
            ),
            child: const Center(
              child: Icon(Icons.diamond_outlined, color: Colors.amberAccent, size: 24),
            ),
          ),
          const SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                "TAJ GROUP",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w900,
                  color: Color(0xFF1E293B),
                  letterSpacing: 1.2,
                ),
              ),
              Text(
                "Enterprise ERP",
                style: TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.w500,
                  color: Colors.grey[500],
                  letterSpacing: 0.5,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _SearchBar extends StatelessWidget {
  const _SearchBar();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Container(
        height: 44,
        decoration: BoxDecoration(
          color: const Color(0xFFF8F9FB),
          borderRadius: BorderRadius.circular(12),
        ),
        child: const TextField(
          decoration: InputDecoration(
            hintText: "Search...",
            hintStyle: TextStyle(color: Colors.grey, fontSize: 14),
            prefixIcon: Icon(Icons.search, color: Colors.grey, size: 20),
            border: InputBorder.none,
            contentPadding: EdgeInsets.symmetric(vertical: 12),
          ),
        ),
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  final String title;
  const _SectionHeader({required this.title});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 4, bottom: 8, top: 16),
      child: Text(
        title,
        style: TextStyle(
          color: Colors.grey[500],
          fontSize: 12,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}

class DrawerListTile extends StatelessWidget {
  const DrawerListTile({
    super.key,
    required this.title,
    required this.icon,
    required this.press,
    this.isActive = false,
    this.badge,
  });

  final String title;
  final IconData icon;
  final VoidCallback press;
  final bool isActive;
  final String? badge;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 2),
      decoration: BoxDecoration(
        color: isActive ? const Color(0xFFF4F5F7) : Colors.transparent,
        borderRadius: BorderRadius.circular(10),
      ),
      child: ListTile(
        onTap: press,
        dense: true,
        visualDensity: const VisualDensity(vertical: -2),
        leading: Icon(
          icon,
          size: 20,
          color: isActive ? const Color(0xFF2D3142) : Colors.grey[600],
        ),
        title: Text(
          title,
          style: TextStyle(
            fontSize: 14,
            color: isActive ? const Color(0xFF2D3142) : Colors.grey[600],
            fontWeight: isActive ? FontWeight.w600 : FontWeight.w500,
          ),
        ),
        trailing: badge != null
            ? Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(
                  color: const Color(0xFFF05156),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  badge!,
                  style: const TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold),
                ),
              )
            : null,
      ),
    );
  }
}

class _ModeToggle extends StatelessWidget {
  const _ModeToggle();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: const Color(0xFFF4F5F7),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        children: [
          Expanded(
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 8),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
                boxShadow: [
                  BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 4, offset: const Offset(0, 2))
                ],
              ),
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.wb_sunny_outlined, size: 16, color: Color(0xFF2D3142)),
                  SizedBox(width: 8),
                  Text("Light", style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: Color(0xFF2D3142))),
                ],
              ),
            ),
          ),
          const Expanded(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.nightlight_outlined, size: 16, color: Colors.grey),
                SizedBox(width: 8),
                Text("Dark", style: TextStyle(fontSize: 13, fontWeight: FontWeight.w500, color: Colors.grey)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _SidebarUserCard extends StatelessWidget {
  const _SidebarUserCard();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        border: Border(top: BorderSide(color: Colors.grey.withValues(alpha: 0.1))),
      ),
      child: Row(
        children: [
          const CircleAvatar(
            radius: 18,
            backgroundImage: NetworkImage("https://i.pravatar.cc/150?img=11"),
          ),
          const SizedBox(width: 12),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  "Rohit Kumar",
                  style: TextStyle(
                    color: Color(0xFF2D3142),
                    fontSize: 13,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  "rohit@tajpro.com",
                  style: TextStyle(
                    color: Colors.grey,
                    fontSize: 11,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          IconButton(
            icon: const Icon(Icons.logout_outlined, color: Colors.grey, size: 18),
            onPressed: () {},
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(),
          ),
        ],
      ),
    );
  }
}
