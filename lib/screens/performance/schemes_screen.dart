import 'package:flutter/material.dart';
import '../../constants.dart';
import '../../responsive.dart';

class SchemesScreen extends StatelessWidget {
  const SchemesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(defaultPadding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const _Header(),
            const SizedBox(height: defaultPadding),
            const _SchemesStats(),
            const SizedBox(height: defaultPadding * 1.5),
            const _ActionRow(),
            const SizedBox(height: defaultPadding * 1.5),
            const _SchemesGrid(),
            const SizedBox(height: defaultPadding * 2),
          ],
        ),
      ),
    );
  }
}

class _Header extends StatelessWidget {
  const _Header();

  @override
  Widget build(BuildContext context) {
    bool isMobile = Responsive.isMobile(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Promotion Schemes",
          style: TextStyle(fontSize: isMobile ? 24 : 28, fontWeight: FontWeight.bold, color: textPrimaryColor),
        ),
        const SizedBox(height: 4),
        Text(
          isMobile ? "Manage trade offers" : "Manage trade offers, discounts, and rewards",
          style: TextStyle(fontSize: isMobile ? 12 : 14, color: textSecondaryColor, fontWeight: FontWeight.w500),
        ),
      ],
    );
  }
}

class _SchemesStats extends StatelessWidget {
  const _SchemesStats();

  @override
  Widget build(BuildContext context) {
    bool isMobile = Responsive.isMobile(context);
    List<Widget> stats = [
      _buildGradientStatCard("Active Schemes", "12", Icons.local_offer_outlined, [const Color(0xFF22C55E), const Color(0xFF4ADE80)]),
      _buildGradientStatCard("Upcoming", "4", Icons.calendar_month_outlined, [const Color(0xFF6366F1), const Color(0xFF818CF8)]),
      _buildGradientStatCard("Avg. Redemption", "57%", Icons.percent_rounded, [const Color(0xFFF59E0B), const Color(0xFFFBBF24)]),
      _buildGradientStatCard("Value Given", "₹4.2L", Icons.card_giftcard_rounded, [const Color(0xFFA855F7), const Color(0xFFC084FC)]),
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

class _ActionRow extends StatelessWidget {
  const _ActionRow();

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Container(
          height: 48,
          decoration: BoxDecoration(
            color: const Color(0xFF6366F1),
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(color: const Color(0xFF6366F1).withValues(alpha: 0.3), blurRadius: 10, offset: const Offset(0, 4))
            ],
          ),
          child: ElevatedButton.icon(
            onPressed: () {},
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.transparent,
              shadowColor: Colors.transparent,
              padding: const EdgeInsets.symmetric(horizontal: 24),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
            icon: const Icon(Icons.add_rounded, color: Colors.white, size: 20),
            label: const Text("Create Scheme", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
          ),
        ),
      ],
    );
  }
}

class _SchemesGrid extends StatelessWidget {
  const _SchemesGrid();

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
          final schemes = [
            {"type": "Quantity", "status": "Active", "title": "Buy 2 Get 1 Free", "products": "Rice, Flour", "date": "Jan 15 - Feb 15", "usage": "68%", "progress": 0.68, "typeColor": Colors.purple},
            {"type": "Percentage", "status": "Active", "title": "Festive Discount", "products": "All Products", "date": "Jan 20 - Jan 31", "usage": "45%", "progress": 0.45, "typeColor": Colors.orange},
            {"type": "Value", "status": "Active", "title": "Bulk Purchase Bonus", "products": "Oils, Ghee", "date": "Jan 1 - Mar 31", "usage": "82%", "progress": 0.82, "typeColor": Colors.blue},
            {"type": "Flat", "status": "Active", "title": "New Retailer Welcome", "products": "First Order", "date": "Ongoing", "usage": "34%", "progress": 0.34, "typeColor": Colors.teal},
            {"type": "Combo", "status": "Upcoming", "title": "Diwali Special", "products": "Gift Packs", "date": "Oct 15 - Nov 15", "usage": "0%", "progress": 0.0, "typeColor": Colors.pink},
            {"type": "Percentage", "status": "Expired", "title": "Summer Sale", "products": "Beverages", "date": "Dec 1 - Dec 31", "usage": "100%", "progress": 1.0, "typeColor": Colors.orange},
          ];
          final scheme = schemes[index % schemes.length];
          return _SchemeCard(
            type: scheme["type"] as String,
            status: scheme["status"] as String,
            title: scheme["title"] as String,
            products: scheme["products"] as String,
            date: scheme["date"] as String,
            usage: scheme["usage"] as String,
            progress: scheme["progress"] as double,
            typeColor: scheme["typeColor"] as Color,
          );
        },
      );
    });
  }
}

class _SchemeCard extends StatefulWidget {
  final String type, status, title, products, date, usage;
  final double progress;
  final Color typeColor;

  const _SchemeCard({
    required this.type,
    required this.status,
    required this.title,
    required this.products,
    required this.date,
    required this.usage,
    required this.progress,
    required this.typeColor,
  });

  @override
  State<_SchemeCard> createState() => _SchemeCardState();
}

class _SchemeCardState extends State<_SchemeCard> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    Color statusColor = widget.status == "Active" 
        ? const Color(0xFF22C55E) 
        : (widget.status == "Upcoming" ? const Color(0xFF6366F1) : const Color(0xFF94A3B8));

    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: AnimatedScale(
        scale: _isHovered ? 1.02 : 1.0,
        duration: const Duration(milliseconds: 200),
        child: Container(
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
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: widget.typeColor.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      widget.type,
                      style: TextStyle(color: widget.typeColor, fontSize: 10, fontWeight: FontWeight.bold),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: statusColor.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      widget.status,
                      style: TextStyle(color: statusColor, fontSize: 10, fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Text(
                widget.title,
                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: textPrimaryColor),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 4),
              Text(
                "Products: ${widget.products}",
                style: const TextStyle(fontSize: 12, color: textSecondaryColor, fontWeight: FontWeight.w500),
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  const Icon(Icons.calendar_today_rounded, size: 14, color: textSecondaryColor),
                  const SizedBox(width: 8),
                  Text(widget.date, style: const TextStyle(fontSize: 12, color: textSecondaryColor, fontWeight: FontWeight.w500)),
                ],
              ),
              const Spacer(),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text("Usage", style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: textPrimaryColor)),
                  Text(widget.usage, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: textPrimaryColor)),
                ],
              ),
              const SizedBox(height: 8),
              Stack(
                children: [
                  Container(
                    height: 6,
                    width: double.infinity,
                    decoration: BoxDecoration(color: const Color(0xFFF1F5F9), borderRadius: BorderRadius.circular(10)),
                  ),
                  FractionallySizedBox(
                    widthFactor: widget.progress,
                    child: Container(
                      height: 6,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(colors: [primaryColor, primaryColor.withValues(alpha: 0.6)]),
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
