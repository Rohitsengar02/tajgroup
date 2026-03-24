import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../responsive.dart';
import '../../providers/user_provider.dart';
import '../onboarding/onboarding_screen.dart';

class SideMenu extends StatefulWidget {
  final Function(int)? onIndexChanged;
  const SideMenu({super.key, this.onIndexChanged});

  @override
  State<SideMenu> createState() => _SideMenuState();
}

class _SideMenuState extends State<SideMenu> {
  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    if (index == 24) { // Logout Index
      _handleLogout();
      return;
    }
    setState(() {
      _selectedIndex = index;
    });
    widget.onIndexChanged?.call(index);
  }

  Future<void> _handleLogout() async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    await userProvider.logout();
    if (mounted) {
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => const OnboardingScreen()),
        (route) => false,
      );
    }
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
          border: Border(right: BorderSide(color: Colors.grey.withOpacity(0.1))),
        ),
        child: Column(
          children: [
            const _DrawerHeader(),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                children: [
                  const _SectionHeader(title: "MENU", trailingIcon: Icons.keyboard_arrow_up_rounded),
                  _buildMenuItem("Dashboard", Icons.grid_view_rounded, 0, isActive: _selectedIndex == 0),
                  const SizedBox(height: 4),

                  const _SectionHeader(title: "SALES", trailingIcon: Icons.keyboard_arrow_down_rounded),
                  _buildMenuItem("Orders", Icons.shopping_cart_outlined, 1, badge: "12", isActive: _selectedIndex == 1),
                  const SizedBox(height: 4),
                  _buildMenuItem("Estimates / Quotation", Icons.request_page_outlined, 2, isActive: _selectedIndex == 2),
                  const SizedBox(height: 4),
                  _buildMenuItem("Proforma Invoice", Icons.receipt_long_outlined, 3, isActive: _selectedIndex == 3),
                  const SizedBox(height: 4),
                  _buildMenuItem("Payments", Icons.payments_outlined, 4, isActive: _selectedIndex == 4),
                  const SizedBox(height: 4),
                  _buildMenuItem("Delivery Challan", Icons.local_shipping_outlined, 5, isActive: _selectedIndex == 5),
                  const SizedBox(height: 4),
                  _buildMenuItem("Sales Return", Icons.assignment_return_outlined, 6, isActive: _selectedIndex == 6),
                  const SizedBox(height: 4),
                  _buildMenuItem("Secondary Sales", Icons.storefront_outlined, 7, isActive: _selectedIndex == 7),
                  const SizedBox(height: 4),
                  _buildMenuItem("Primary Sales", Icons.business_outlined, 8, isActive: _selectedIndex == 8),

                  const SizedBox(height: 16),
                  const _SectionHeader(title: "OPERATIONS", trailingIcon: Icons.keyboard_arrow_down_rounded),
                  _buildMenuItem("Customers", Icons.people_outline, 9, isActive: _selectedIndex == 9),
                  const SizedBox(height: 4),
                  _buildMenuItem("Distribution", Icons.local_shipping_outlined, 10, isActive: _selectedIndex == 10),
                  const SizedBox(height: 4),
                  _buildMenuItem("Team", Icons.groups_outlined, 11, badge: "3", isActive: _selectedIndex == 11),

                  const SizedBox(height: 16),
                  const _SectionHeader(title: "FIELD OPS", trailingIcon: Icons.keyboard_arrow_down_rounded),
                  _buildMenuItem("Beats", Icons.map_outlined, 12, isActive: _selectedIndex == 12),
                  const SizedBox(height: 4),
                  _buildMenuItem("Routes", Icons.route_outlined, 13, isActive: _selectedIndex == 13),
                  const SizedBox(height: 4),
                  _buildMenuItem("Network", Icons.hub_outlined, 14, isActive: _selectedIndex == 14),
                  const SizedBox(height: 4),
                  _buildMenuItem("Products & SKU", Icons.inventory_2_outlined, 15, isActive: _selectedIndex == 15),

                  const SizedBox(height: 16),
                  const _SectionHeader(title: "PERFORMANCE", trailingIcon: Icons.keyboard_arrow_down_rounded),
                  _buildMenuItem("Growth & Tracking", Icons.trending_up_rounded, 16, isActive: _selectedIndex == 16),
                  const SizedBox(height: 4),
                  _buildMenuItem("Loyalty", Icons.loyalty_outlined, 17, isActive: _selectedIndex == 17),
                  const SizedBox(height: 4),
                  _buildMenuItem("Schemes", Icons.card_giftcard_outlined, 18, isActive: _selectedIndex == 18),
                  const SizedBox(height: 4),
                  _buildMenuItem("Targets", Icons.track_changes_outlined, 19, isActive: _selectedIndex == 19),
                  const SizedBox(height: 4),
                  _buildMenuItem("Attendance", Icons.how_to_reg_outlined, 20, isActive: _selectedIndex == 20),

                  const SizedBox(height: 16),
                  const _SectionHeader(title: "PAYROLL", trailingIcon: Icons.keyboard_arrow_down_rounded),
                  _buildMenuItem("Payroll & Salary", Icons.account_balance_wallet_outlined, 21, isActive: _selectedIndex == 21),

                  const SizedBox(height: 32),
                  const _SectionHeader(title: "OTHERS", trailingIcon: Icons.keyboard_arrow_up_rounded),
                  _buildMenuItem("Reports", Icons.assessment_outlined, 22, isActive: _selectedIndex == 22),
                  const SizedBox(height: 4),
                  _buildMenuItem("Settings", Icons.settings_outlined, 23, isActive: _selectedIndex == 23),
                  const SizedBox(height: 4),
                  _buildMenuItem("Logout", Icons.logout_rounded, 24, isActive: _selectedIndex == 24),

                ],
              ),
            ),
            const _SidebarUserCard(),
          ],
        ),
      ),
    );
  }

  Widget _buildMenuItem(String title, IconData icon, int index, {String? badge, bool isActive = false}) {
    return DrawerListTile(
      title: title,
      icon: icon,
      press: () => _onItemTapped(index),
      isActive: isActive,
      badge: badge,
    );
  }
}

class _DrawerHeader extends StatelessWidget {
  const _DrawerHeader();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(top: 40, bottom: 32, left: 16, right: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Container(
                width: 36,
                height: 36,
                decoration: const BoxDecoration(
                  color: Colors.black,
                  shape: BoxShape.circle,
                ),
                child: const Center(
                  child: Icon(Icons.bubble_chart_rounded, color: Colors.white, size: 20),
                ),
              ),
              const SizedBox(width: 12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    children: [
                      const Text(
                        "Tajnova Store",
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w900,
                          color: Colors.black87,
                        ),
                      ),
                      const SizedBox(width: 4),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
                        decoration: BoxDecoration(
                          color: const Color(0xFF10B981).withOpacity(0.2),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: const Text("PRO", style: TextStyle(color: Color(0xFF10B981), fontSize: 8, fontWeight: FontWeight.bold)),
                      )
                    ],
                  ),
                  const SizedBox(height: 2),
                  Row(
                    children: [
                      Icon(Icons.lock_outline_rounded, size: 12, color: Colors.grey[500]),
                      const SizedBox(width: 4),
                      Text("Private", style: TextStyle(fontSize: 12, fontWeight: FontWeight.w500, color: Colors.grey[500])),
                    ],
                  ),
                ],
              ),
            ],
          ),
          Icon(Icons.unfold_more_rounded, size: 20, color: Colors.grey[500]),
        ],
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  final String title;
  final IconData trailingIcon;
  const _SectionHeader({required this.title, required this.trailingIcon});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 4, bottom: 12, top: 16, right: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: TextStyle(
              color: Colors.grey[500],
              fontSize: 11,
              fontWeight: FontWeight.w800,
              letterSpacing: 1.2,
            ),
          ),
          Icon(trailingIcon, size: 16, color: Colors.grey[500]),
        ],
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
    return InkWell(
      onTap: press,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: isActive ? Colors.black : Colors.transparent,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Row(
          children: [
            Icon(
              icon,
              size: 20,
              color: isActive ? Colors.white : Colors.grey[800],
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Text(
                title,
                style: TextStyle(
                  fontSize: 14,
                  color: isActive ? Colors.white : Colors.grey[800],
                  fontWeight: isActive ? FontWeight.bold : FontWeight.w600,
                ),
              ),
            ),
            if (badge != null)
              Container(
                padding: const EdgeInsets.all(6),
                decoration: const BoxDecoration(
                  color: Color(0xFFF97316),
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: Text(
                    badge!,
                    style: const TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class _SidebarUserCard extends StatelessWidget {
  const _SidebarUserCard();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      child: Row(
        children: [
          const CircleAvatar(
            radius: 18,
            backgroundImage: NetworkImage("https://images.unsplash.com/photo-1472099645785-5658abf4ff4e?q=80&w=200&auto=format&fit=crop"),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  "Rohit Sharma",
                  style: TextStyle(
                    color: Colors.black87,
                    fontSize: 13,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Row(
                   children: [
                      const Icon(Icons.verified, color: Color(0xFF10B981), size: 10),
                      const SizedBox(width: 4),
                      Text(
                        "rohit@tajpro.com",
                        style: TextStyle(
                          color: Colors.grey[500],
                          fontSize: 11,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                   ],
                )
              ],
            ),
          ),
          Icon(Icons.more_horiz, color: Colors.grey[500], size: 20),
        ],
      ),
    );
  }
}

