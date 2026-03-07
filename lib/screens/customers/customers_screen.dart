import 'package:flutter/material.dart';
import '../../constants.dart';
import '../../responsive.dart';
import 'add_customer_screen.dart';

class CustomersScreen extends StatelessWidget {
  const CustomersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(defaultPadding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const _CustomersHeader(),
            const SizedBox(height: defaultPadding),
            const _CustomersStats(),
            const SizedBox(height: defaultPadding * 1.5),
            const _SearchAndFilterBar(),
            const SizedBox(height: defaultPadding * 1.5),
            const _CustomersGrid(),
            const SizedBox(height: defaultPadding * 2),
          ],
        ),
      ),
    );
  }
}

class _CustomersHeader extends StatelessWidget {
  const _CustomersHeader();

  @override
  Widget build(BuildContext context) {
    bool isMobile = Responsive.isMobile(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Customers",
                  style: TextStyle(fontSize: isMobile ? 24 : 28, fontWeight: FontWeight.bold, color: textPrimaryColor),
                ),
                const SizedBox(height: 4),
                Text(
                  isMobile ? "Manage connections" : "Manage retail outlets & distribution network",
                  style: TextStyle(fontSize: isMobile ? 12 : 14, color: textSecondaryColor, fontWeight: FontWeight.w500),
                ),
              ],
            ),
            if (!isMobile)
              Row(
                children: [
                  _buildHeaderButton(icon: Icons.file_download_outlined, label: "Import", onPressed: () {}, isOutlined: true),
                  const SizedBox(width: 12),
                  _buildHeaderButton(
                    icon: Icons.add_rounded,
                    label: "Add Customer",
                    onPressed: () => _navigateToAdd(context),
                    isOutlined: false,
                  ),
                ],
              ),
          ],
        ),
        if (isMobile) ...[
          const SizedBox(height: 20),
          Row(
            children: [
              Expanded(
                child: _buildHeaderButton(
                  icon: Icons.add_rounded,
                  label: "Add New",
                  onPressed: () => _navigateToAdd(context),
                  isOutlined: false,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildHeaderButton(
                  icon: Icons.file_download_outlined,
                  label: "Import",
                  onPressed: () {},
                  isOutlined: true,
                ),
              ),
            ],
          ),
        ],
      ],
    );
  }

  void _navigateToAdd(BuildContext context) {
    Navigator.of(context).push(
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) => const AddCustomerScreen(),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          return FadeTransition(opacity: animation, child: child);
        },
        opaque: false,
        barrierColor: Colors.black.withValues(alpha: 0.5),
      ),
    );
  }

  Widget _buildHeaderButton({required IconData icon, required String label, required VoidCallback onPressed, required bool isOutlined}) {
    if (isOutlined) {
      return OutlinedButton.icon(
        onPressed: onPressed,
        style: OutlinedButton.styleFrom(
          foregroundColor: textPrimaryColor,
          side: BorderSide(color: textSecondaryColor.withValues(alpha: 0.3)),
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        ),
        icon: Icon(icon, size: 20),
        label: Text(label, style: const TextStyle(fontWeight: FontWeight.bold)),
      );
    }
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF1E293B),
        borderRadius: BorderRadius.circular(10),
      ),
      child: ElevatedButton.icon(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.transparent,
          shadowColor: Colors.transparent,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        ),
        icon: Icon(icon, size: 20),
        label: Text(label, style: const TextStyle(fontWeight: FontWeight.bold)),
      ),
    );
  }
}

class _CustomersStats extends StatelessWidget {
  const _CustomersStats();

  @override
  Widget build(BuildContext context) {
    bool isMobile = Responsive.isMobile(context);
    List<Widget> stats = [
      _buildStatCard("Total Customers", "1,280", Icons.people_alt_outlined, const Color(0xFF6366F1)),
      _buildStatCard("Active Retailers", "942", Icons.storefront_rounded, const Color(0xFF22C55E)),
      _buildStatCard("Top Distributors", "45", Icons.local_shipping_outlined, const Color(0xFFA855F7)),
      _buildStatCard("New This Month", "+12", Icons.add_chart_rounded, const Color(0xFFF59E0B)),
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

class _SearchAndFilterBar extends StatelessWidget {
  const _SearchAndFilterBar();

  @override
  Widget build(BuildContext context) {
    bool isMobile = Responsive.isMobile(context);
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              flex: 5,
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
                    hintText: "Search customers...",
                    hintStyle: TextStyle(fontSize: 14, color: textSecondaryColor),
                    icon: Icon(Icons.search, size: 20, color: textSecondaryColor),
                    border: InputBorder.none,
                  ),
                ),
              ),
            ),
            if (!isMobile) ...[
              const SizedBox(width: 16),
              Container(
                height: 48,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                decoration: BoxDecoration(
                  color: surfaceColor,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: textSecondaryColor.withValues(alpha: 0.1)),
                ),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<String>(
                    value: "All Types",
                    items: ["All Types", "Retailer", "Wholesaler", "Distributor"]
                        .map((e) => DropdownMenuItem(value: e, child: Text(e, style: const TextStyle(fontSize: 14))))
                        .toList(),
                    onChanged: (_) {},
                  ),
                ),
              ),
            ],
          ],
        ),
        if (isMobile) ...[
          const SizedBox(height: 12),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: ["All Types", "Retailer", "Wholesaler", "Distributor"].map((type) {
                bool isSelected = type == "All Types";
                return Container(
                  margin: const EdgeInsets.only(right: 8),
                  child: FilterChip(
                    label: Text(type),
                    selected: isSelected,
                    onSelected: (_) {},
                    backgroundColor: surfaceColor,
                    selectedColor: primaryColor.withValues(alpha: 0.1),
                    labelStyle: TextStyle(
                      color: isSelected ? primaryColor : textSecondaryColor,
                      fontSize: 12,
                      fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                      side: BorderSide(
                        color: isSelected ? primaryColor : textSecondaryColor.withValues(alpha: 0.1),
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
        ],
      ],
    );
  }
}

class _CustomersGrid extends StatelessWidget {
  const _CustomersGrid();

  @override
  Widget build(BuildContext context) {
    bool isMobile = Responsive.isMobile(context);
    bool isTablet = Responsive.isTablet(context);
    
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: isMobile ? 1 : (isTablet ? 2 : 3),
        crossAxisSpacing: defaultPadding,
        mainAxisSpacing: defaultPadding,
        childAspectRatio: isMobile ? 1.6 : 1.4,
      ),
      itemCount: 6,
      itemBuilder: (context, index) {
        return _CustomerCard(
          name: index % 2 == 0 ? "Krishna General Store" : "Rajat Wholesale Mart",
          owner: index % 2 == 0 ? "Krishna Murthy" : "Rajat Sharma",
          type: index % 2 == 0 ? "Retailer" : "Wholesaler",
          typeColor: index % 2 == 0 ? const Color(0xFF22C55E) : const Color(0xFF3B82F6),
          location: "Mumbai, Maharashtra",
          phone: "+91 98765 43210",
          balance: "₹12,450",
          lastVisit: "2 days ago",
        );
      },
    );
  }
}

class _CustomerCard extends StatefulWidget {
  final String name, owner, type, location, phone, balance, lastVisit;
  final Color typeColor;

  const _CustomerCard({
    required this.name,
    required this.owner,
    required this.type,
    required this.typeColor,
    required this.location,
    required this.phone,
    required this.balance,
    required this.lastVisit,
  });

  @override
  State<_CustomerCard> createState() => _CustomerCardState();
}

class _CustomerCardState extends State<_CustomerCard> {
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
              children: [
                Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(color: widget.typeColor.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(10)),
                  child: Icon(widget.type == "Retailer" ? Icons.storefront_rounded : Icons.business_center_rounded, color: widget.typeColor, size: 22),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(widget.name, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: textPrimaryColor), overflow: TextOverflow.ellipsis),
                      Text(widget.owner, style: const TextStyle(fontSize: 12, color: textSecondaryColor, fontWeight: FontWeight.w500)),
                    ],
                  ),
                ),
                const Icon(Icons.more_vert_rounded, color: textSecondaryColor, size: 20),
              ],
            ),
            const SizedBox(height: 18),
            _buildIconInfo(Icons.location_on_outlined, widget.location),
            const SizedBox(height: 8),
            _buildIconInfo(Icons.phone_outlined, widget.phone),
            const Spacer(),
            const Divider(height: 24, thickness: 0.5),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text("Outstanding", style: TextStyle(fontSize: 10, color: textSecondaryColor, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 4),
                    Text(widget.balance, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.redAccent)),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    const Text("Last Visit", style: TextStyle(fontSize: 10, color: textSecondaryColor, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 4),
                    Text(widget.lastVisit, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: textPrimaryColor)),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildIconInfo(IconData icon, String text) {
    return Row(
      children: [
        Icon(icon, size: 16, color: textSecondaryColor.withValues(alpha: 0.6)),
        const SizedBox(width: 10),
        Expanded(child: Text(text, style: const TextStyle(fontSize: 12, color: textSecondaryColor, fontWeight: FontWeight.w500), overflow: TextOverflow.ellipsis)),
      ],
    );
  }
}
