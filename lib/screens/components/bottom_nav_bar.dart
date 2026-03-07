// Updated Mobile Navigation Bar with scrollable categories
import 'package:flutter/material.dart';
import '../../constants.dart';
import '../../responsive.dart';

class CustomBottomNavBar extends StatelessWidget {
  final int selectedIndex;
  final Function(int) onIndexChanged;

  const CustomBottomNavBar({
    super.key,
    required this.selectedIndex,
    required this.onIndexChanged,
  });

  @override
  Widget build(BuildContext context) {
    if (!Responsive.isMobile(context)) return const SizedBox();

    final List<Map<String, dynamic>> allItems = [
      {"title": "Dashboard", "icon": Icons.grid_view_rounded, "index": 0},
      {"title": "Orders", "icon": Icons.shopping_cart_outlined, "index": 1},
      {"title": "Quotes", "icon": Icons.request_page_outlined, "index": 2},
      {"title": "Proforma", "icon": Icons.receipt_long_outlined, "index": 3},
      {"title": "Payments", "icon": Icons.payments_outlined, "index": 4},
      {"title": "Challan", "icon": Icons.local_shipping_outlined, "index": 5},
      {"title": "Returns", "icon": Icons.assignment_return_outlined, "index": 6},
      {"title": "Secondary", "icon": Icons.storefront_outlined, "index": 7},
      {"title": "Primary", "icon": Icons.business_outlined, "index": 8},
      {"title": "Customers", "icon": Icons.people_outline, "index": 9},
      {"title": "Distribution", "icon": Icons.local_shipping_outlined, "index": 10},
      {"title": "Team", "icon": Icons.groups_outlined, "index": 11},
      {"title": "Beats", "icon": Icons.map_outlined, "index": 12},
      {"title": "Routes", "icon": Icons.route_outlined, "index": 13},
      {"title": "Network", "icon": Icons.hub_outlined, "index": 14},
      {"title": "Products", "icon": Icons.inventory_2_outlined, "index": 15},
      {"title": "Growth", "icon": Icons.trending_up_rounded, "index": 16},
      {"title": "Loyalty", "icon": Icons.loyalty_outlined, "index": 17},
      {"title": "Schemes", "icon": Icons.card_giftcard_outlined, "index": 18},
      {"title": "Targets", "icon": Icons.track_changes_outlined, "index": 19},
      {"title": "Attendance", "icon": Icons.how_to_reg_outlined, "index": 20},
      {"title": "Payroll", "icon": Icons.account_balance_wallet_outlined, "index": 21},
      {"title": "Reports", "icon": Icons.assessment_outlined, "index": 22},
      {"title": "Settings", "icon": Icons.settings_outlined, "index": 23},
    ];

    // Priority items for the fixed bar
    final List<Map<String, dynamic>> fixedItems = [
      allItems[0], // Dashboard
      allItems[1], // Orders
      allItems[9], // Customers
      allItems[22], // Reports
    ];

    // Remaining items for the slider
    final List<Map<String, dynamic>> remainingItems = allItems.where((item) {
      return !fixedItems.any((fixed) => fixed["index"] == item["index"]);
    }).toList();

    return Container(
      margin: const EdgeInsets.fromLTRB(16, 0, 16, 20),
      height: 80,
      decoration: BoxDecoration(
        color: surfaceColor,
        borderRadius: BorderRadius.circular(40),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 30,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _buildNavItem(context, fixedItems[0]),
          _buildNavItem(context, fixedItems[1]),
          _buildCenterPlusButton(context, remainingItems),
          _buildNavItem(context, fixedItems[2]),
          _buildNavItem(context, fixedItems[3]),
        ],
      ),
    );
  }

  Widget _buildNavItem(BuildContext context, Map<String, dynamic> item) {
    bool isSelected = selectedIndex == item["index"];
    return GestureDetector(
      onTap: () => onIndexChanged(item["index"]),
      behavior: HitTestBehavior.opaque,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            item["icon"],
            color: isSelected ? primaryColor : textSecondaryColor.withValues(alpha: 0.7),
            size: 24,
          ),
          const SizedBox(height: 4),
          Text(
            item["title"],
            style: TextStyle(
              fontSize: 10,
              fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
              color: isSelected ? primaryColor : textSecondaryColor,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCenterPlusButton(BuildContext context, List<Map<String, dynamic>> remainingItems) {
    return GestureDetector(
      onTap: () => _showFullMenu(context, remainingItems),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [Color(0xFF6366F1), Color(0xFFA855F7)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: const Color(0xFF6366F1).withValues(alpha: 0.4),
              blurRadius: 15,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: const Icon(Icons.apps_rounded, color: Colors.white, size: 30),
      ),
    );
  }

  void _showFullMenu(BuildContext context, List<Map<String, dynamic>> items) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) {
        return Container(
          height: MediaQuery.of(context).size.height * 0.75,
          decoration: const BoxDecoration(
            color: surfaceColor,
            borderRadius: BorderRadius.vertical(top: Radius.circular(35)),
          ),
          child: Column(
            children: [
              const SizedBox(height: 12),
              Container(
                width: 45,
                height: 5,
                decoration: BoxDecoration(
                  color: Colors.grey.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(24, 28, 24, 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: const [
                        Text(
                          "Operations Hub",
                          style: TextStyle(fontSize: 22, fontWeight: FontWeight.w900, color: textPrimaryColor),
                        ),
                        SizedBox(height: 4),
                        Text(
                          "Access all modules and utilities",
                          style: TextStyle(fontSize: 12, color: textSecondaryColor, fontWeight: FontWeight.w500),
                        ),
                      ],
                    ),
                    IconButton(
                      onPressed: () => Navigator.pop(context),
                      icon: const Icon(Icons.close_rounded, color: textSecondaryColor),
                      style: IconButton.styleFrom(
                        backgroundColor: Colors.black.withValues(alpha: 0.05),
                        padding: const EdgeInsets.all(8),
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: GridView.builder(
                  padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    mainAxisSpacing: 16,
                    crossAxisSpacing: 16,
                    childAspectRatio: 0.95,
                  ),
                  itemCount: items.length,
                  itemBuilder: (context, index) {
                    final item = items[index];
                    bool isSelected = selectedIndex == item["index"];
                    return GestureDetector(
                      onTap: () {
                        onIndexChanged(item["index"]);
                        Navigator.pop(context);
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          color: isSelected ? primaryColor.withValues(alpha: 0.1) : const Color(0xFFF8FAFC),
                          borderRadius: BorderRadius.circular(24),
                          border: Border.all(
                            color: isSelected ? primaryColor.withValues(alpha: 0.2) : Colors.transparent,
                            width: 1.5,
                          ),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              padding: const EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                color: isSelected ? primaryColor.withValues(alpha: 0.1) : Colors.white,
                                shape: BoxShape.circle,
                                boxShadow: [
                                  if (!isSelected)
                                    BoxShadow(
                                      color: Colors.black.withValues(alpha: 0.03),
                                      blurRadius: 10,
                                      offset: const Offset(0, 4),
                                    ),
                                ],
                              ),
                              child: Icon(
                                item["icon"],
                                color: isSelected ? primaryColor : const Color(0xFF64748B),
                                size: 24,
                              ),
                            ),
                            const SizedBox(height: 10),
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 4),
                              child: Text(
                                item["title"],
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: 11,
                                  fontWeight: isSelected ? FontWeight.w900 : FontWeight.w700,
                                  color: isSelected ? primaryColor : textPrimaryColor,
                                  letterSpacing: -0.2,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
