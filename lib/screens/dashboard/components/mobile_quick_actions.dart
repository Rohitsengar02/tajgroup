import 'package:flutter/material.dart';
import '../../../../constants.dart';
import '../../../../responsive.dart';

class MobileQuickActions extends StatefulWidget {
  final Function(int) onIndexChanged;
  const MobileQuickActions({super.key, required this.onIndexChanged});

  @override
  State<MobileQuickActions> createState() => _MobileQuickActionsState();
}

class _MobileQuickActionsState extends State<MobileQuickActions> {
  bool _isExpanded = false;

  final List<Map<String, dynamic>> _allActions = [
    {"title": "Orders", "icon": Icons.shopping_cart_outlined, "gradient": [const Color(0xFF6366F1), const Color(0xFF818CF8)], "index": 1},
    {"title": "Quotes", "icon": Icons.request_page_outlined, "gradient": [const Color(0xFFA855F7), const Color(0xFFC084FC)], "index": 2},
    {"title": "Proforma", "icon": Icons.receipt_long_outlined, "gradient": [const Color(0xFFEC4899), const Color(0xFFF472B6)], "index": 3},
    {"title": "Payments", "icon": Icons.payments_outlined, "gradient": [const Color(0xFFF59E0B), const Color(0xFFFBBF24)], "index": 4},
    {"title": "Customers", "icon": Icons.people_outline, "gradient": [const Color(0xFF10B981), const Color(0xFF34D399)], "index": 9},
    {"title": "Products", "icon": Icons.inventory_2_outlined, "gradient": [const Color(0xFF3B82F6), const Color(0xFF60A5FA)], "index": 15},
    {"title": "Team", "icon": Icons.groups_outlined, "gradient": [const Color(0xFF64748B), const Color(0xFF94A3B8)], "index": 11},
    {"title": "Challan", "icon": Icons.local_shipping_outlined, "gradient": [const Color(0xFFEF4444), const Color(0xFFF87171)], "index": 5},
    {"title": "Returns", "icon": Icons.assignment_return_outlined, "gradient": [const Color(0xFF06B6D4), const Color(0xFF22D3EE)], "index": 6},
    {"title": "Secondary", "icon": Icons.storefront_outlined, "gradient": [const Color(0xFF8B5CF6), const Color(0xFFA78BFA)], "index": 7},
    {"title": "Primary", "icon": Icons.business_outlined, "gradient": [const Color(0xFFF97316), const Color(0xFFFB923C)], "index": 8},
    {"title": "Beats", "icon": Icons.map_outlined, "gradient": [const Color(0xFF14B8A6), const Color(0xFF2DD4BF)], "index": 12},
    {"title": "Routes", "icon": Icons.route_outlined, "gradient": [const Color(0xFF2563EB), const Color(0xFF3B82F6)], "index": 13},
    {"title": "Network", "icon": Icons.hub_outlined, "gradient": [const Color(0xFF7C3AED), const Color(0xFF8B5CF6)], "index": 14},
    {"title": "Growth", "icon": Icons.trending_up_rounded, "gradient": [const Color(0xFF059669), const Color(0xFF10B981)], "index": 16},
    {"title": "Loyalty", "icon": Icons.loyalty_outlined, "gradient": [const Color(0xFFDB2777), const Color(0xFFEC4899)], "index": 17},
    {"title": "Schemes", "icon": Icons.card_giftcard_outlined, "gradient": [const Color(0xFFD97706), const Color(0xFFF59E0B)], "index": 18},
    {"title": "Targets", "icon": Icons.track_changes_outlined, "gradient": [const Color(0xFF1D4ED8), const Color(0xFF2563EB)], "index": 19},
    {"title": "Attendance", "icon": Icons.how_to_reg_outlined, "gradient": [const Color(0xFF4F46E5), const Color(0xFF6366F1)], "index": 20},
    {"title": "Payroll", "icon": Icons.account_balance_wallet_outlined, "gradient": [const Color(0xFF9333EA), const Color(0xFFA855F7)], "index": 21},
    {"title": "Reports", "icon": Icons.assessment_outlined, "gradient": [const Color(0xFF2563EB), const Color(0xFF3B82F6)], "index": 22},
    {"title": "Settings", "icon": Icons.settings_outlined, "gradient": [const Color(0xFF475569), const Color(0xFF64748B)], "index": 23},
  ];

  @override
  Widget build(BuildContext context) {
    if (!Responsive.isMobile(context)) return const SizedBox();

    final visibleActions = _isExpanded ? _allActions : _allActions.take(7).toList();

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: defaultPadding),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                "Quick Access",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w900, color: textPrimaryColor, letterSpacing: -0.5),
              ),
              if (_isExpanded)
                TextButton(
                  onPressed: () => setState(() => _isExpanded = false),
                  child: const Text("Show Less", style: TextStyle(color: primaryColor, fontWeight: FontWeight.bold, fontSize: 12)),
                ),
            ],
          ),
          const SizedBox(height: 16),
          AnimatedSize(
            duration: const Duration(milliseconds: 400),
            curve: Curves.fastOutSlowIn,
            child: GridView.count(
              crossAxisCount: 4,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              mainAxisSpacing: 12,
              crossAxisSpacing: 12,
              childAspectRatio: 0.85,
              children: [
                ...visibleActions.map((action) => _buildActionItem(
                  action["icon"], 
                  action["title"], 
                  action["gradient"] as List<Color>,
                  action["index"] as int,
                )),
                if (!_isExpanded)
                  _buildMoreItem(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionItem(IconData icon, String title, List<Color> gradient, int index) {
    return GestureDetector(
      onTap: () => widget.onIndexChanged(index),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 56,
            height: 56,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: gradient,
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(18),
              boxShadow: [
                BoxShadow(
                  color: gradient[0].withValues(alpha: 0.3),
                  blurRadius: 10,
                  offset: const Offset(0, 5),
                ),
              ],
            ),
            child: Icon(icon, color: Colors.white, size: 24),
          ),
          const SizedBox(height: 8),
          Text(
            title,
            style: const TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.w700,
              color: textPrimaryColor,
              letterSpacing: -0.2,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }

  Widget _buildMoreItem() {
    return GestureDetector(
      onTap: () => setState(() => _isExpanded = true),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 56,
            height: 56,
            decoration: BoxDecoration(
              color: surfaceColor,
              borderRadius: BorderRadius.circular(18),
              border: Border.all(color: Colors.grey.withValues(alpha: 0.1), width: 1.5),
            ),
            child: const Icon(Icons.keyboard_arrow_down_rounded, color: textSecondaryColor, size: 28),
          ),
          const SizedBox(height: 8),
          const Text(
            "More",
            style: TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.w700,
              color: textPrimaryColor,
            ),
          ),
        ],
      ),
    );
  }
}
