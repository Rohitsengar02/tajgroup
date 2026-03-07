import 'package:flutter/material.dart';
import '../../constants.dart';
import '../../responsive.dart';

class LoyaltyScreen extends StatelessWidget {
  const LoyaltyScreen({super.key});

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
            const _LoyaltyStats(),
            const SizedBox(height: defaultPadding * 1.5),
            const _TiersSection(),
            const SizedBox(height: defaultPadding * 1.5),
            const _TopMembersSection(),
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
          "Loyalty Program",
          style: TextStyle(fontSize: isMobile ? 24 : 28, fontWeight: FontWeight.bold, color: textPrimaryColor),
        ),
        const SizedBox(height: 4),
        Text(
          isMobile ? "Customer retention" : "Customer retention and reward point management",
          style: TextStyle(fontSize: isMobile ? 12 : 14, color: textSecondaryColor, fontWeight: FontWeight.w500),
        ),
      ],
    );
  }
}

class _LoyaltyStats extends StatelessWidget {
  const _LoyaltyStats();

  @override
  Widget build(BuildContext context) {
    bool isMobile = Responsive.isMobile(context);
    List<Widget> stats = [
      _buildGradientStatCard("Active Members", "900", Icons.card_giftcard_rounded, [const Color(0xFF6366F1), const Color(0xFF818CF8)]),
      _buildGradientStatCard("Points Issued", "2.4M", Icons.star_rounded, [const Color(0xFFF59E0B), const Color(0xFFFBBF24)]),
      _buildGradientStatCard("Redeemed", "1.8M", Icons.verified_rounded, [const Color(0xFF22C55E), const Color(0xFF4ADE80)]),
      _buildGradientStatCard("Engagement", "78%", Icons.trending_up_rounded, [const Color(0xFF3B82F6), const Color(0xFF60A5FA)]),
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

class _TiersSection extends StatelessWidget {
  const _TiersSection();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: surfaceColor,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(color: Colors.black.withValues(alpha: 0.02), blurRadius: 10, offset: const Offset(0, 5))
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text("Loyalty Tiers", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: textPrimaryColor)),
          const SizedBox(height: 24),
          LayoutBuilder(builder: (context, constraints) {
            int crossAxisCount = Responsive.isMobile(context) ? 1 : (Responsive.isTablet(context) ? 2 : 4);
            return GridView.count(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisCount: crossAxisCount,
              crossAxisSpacing: defaultPadding,
              mainAxisSpacing: defaultPadding,
              childAspectRatio: 1.2,
              children: const [
                _TierCard(name: "Bronze", customers: "450", points: "0 - 1,000 pts", benefit: "5% discount", color: Color(0xFFD97706)),
                _TierCard(name: "Silver", customers: "280", points: "1,001 - 5,000 pts", benefit: "10% discount + Free delivery", color: Color(0xFF64748B)),
                _TierCard(name: "Gold", customers: "125", points: "5,001 - 15,000 pts", benefit: "15% discount + Priority support", color: Color(0xFFF59E0B)),
                _TierCard(name: "Platinum", customers: "45", points: "15,001 - 50,000 pts", benefit: "20% discount + Exclusive offers", color: Color(0xFFA855F7)),
              ],
            );
          }),
        ],
      ),
    );
  }
}

class _TierCard extends StatefulWidget {
  final String name, customers, points, benefit;
  final Color color;

  const _TierCard({required this.name, required this.customers, required this.points, required this.benefit, required this.color});

  @override
  State<_TierCard> createState() => _TierCardState();
}

class _TierCardState extends State<_TierCard> {
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
          color: _isHovered ? widget.color.withValues(alpha: 0.05) : const Color(0xFFF8FAFC),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: _isHovered ? widget.color.withValues(alpha: 0.3) : Colors.transparent, width: 2),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(width: 8, height: 8, decoration: BoxDecoration(color: widget.color, shape: BoxShape.circle)),
                const SizedBox(width: 8),
                Text(widget.name, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: widget.color)),
              ],
            ),
            const Spacer(),
            Text(widget.customers, style: const TextStyle(fontSize: 24, fontWeight: FontWeight.w900, color: textPrimaryColor)),
            const Text("customers", style: TextStyle(fontSize: 12, color: textSecondaryColor, fontWeight: FontWeight.w500)),
            const Spacer(),
            Text(widget.points, style: const TextStyle(fontSize: 11, color: textSecondaryColor, fontWeight: FontWeight.w600)),
            const SizedBox(height: 4),
            Text(widget.benefit, style: TextStyle(fontSize: 11, color: widget.color, fontWeight: FontWeight.bold)),
          ],
        ),
      ),
    );
  }
}

class _TopMembersSection extends StatelessWidget {
  const _TopMembersSection();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: surfaceColor,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(color: Colors.black.withValues(alpha: 0.02), blurRadius: 10, offset: const Offset(0, 5))
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text("Top Loyalty Members", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: textPrimaryColor)),
              TextButton(onPressed: () {}, child: const Text("View All", style: TextStyle(fontWeight: FontWeight.bold))),
            ],
          ),
          const SizedBox(height: 16),
          _buildMemberRow("Sharma Kirana Store", "48,500 pts", "Platinum", const Color(0xFFA855F7)),
          _buildMemberRow("Global Retailers", "12,200 pts", "Gold", const Color(0xFFF59E0B)),
          _buildMemberRow("Priya General Store", "8,900 pts", "Gold", const Color(0xFFF59E0B)),
          _buildMemberRow("Metro Distributors", "4,200 pts", "Silver", const Color(0xFF64748B)),
        ],
      ),
    );
  }

  Widget _buildMemberRow(String name, String points, String tier, Color tierColor) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Row(
        children: [
          CircleAvatar(
            backgroundColor: tierColor.withValues(alpha: 0.1),
            child: Text(name[0], style: TextStyle(color: tierColor, fontWeight: FontWeight.bold)),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(name, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: textPrimaryColor)),
                 Text(tier, style: TextStyle(fontSize: 12, color: tierColor, fontWeight: FontWeight.bold)),
              ],
            ),
          ),
          Text(points, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: textPrimaryColor)),
        ],
      ),
    );
  }
}
