import 'package:flutter/material.dart';
import 'package:carousel_slider_plus/carousel_slider_plus.dart';
import '../../../constants.dart';
import '../../../responsive.dart';

class KpiCards extends StatelessWidget {
  const KpiCards({super.key});

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    final isMobile = Responsive.isMobile(context);
    final isDesktop = Responsive.isDesktop(context);
    final isTablet = Responsive.isTablet(context);

    if (isMobile) {
      return CarouselSlider(
        options: CarouselOptions(
          height: 160.0,
          autoPlay: true,
          enlargeCenterPage: true,
          viewportFraction: 0.85,
        ),
        items: _buildCards(),
      );
    }

    // For Tablet and Desktop, show multi-card carousel
    return CarouselSlider(
      options: CarouselOptions(
        height: 160,
        viewportFraction: isDesktop ? 0.25 : 0.35, // 4 items (1/4) for desktop, ~3 for tablet
        enableInfiniteScroll: true,
        autoPlay: true,
        autoPlayInterval: const Duration(seconds: 4),
        autoPlayAnimationDuration: const Duration(milliseconds: 800),
        autoPlayCurve: Curves.fastOutSlowIn,
        padEnds: false, // Ensure cards align properly from the start
        disableCenter: true,
      ),
      items: _buildCards().map((card) {
        return Padding(
          padding: const EdgeInsets.only(right: defaultPadding),
          child: card,
        );
      }).toList(),
    );
  }

  List<Widget> _buildCards() {
    return [
      const GradientAnalyticsCard(
        title: "Total Sales",
        value: "₹54.3L",
        growth: "+14.5%",
        icon: Icons.account_balance_wallet,
        gradient: primaryGradient,
      ),
      const GradientAnalyticsCard(
        title: "Orders Today",
        value: "1,458",
        growth: "+5.2%",
        icon: Icons.shopping_cart,
        gradient: secondaryGradient,
      ),
      const GradientAnalyticsCard(
        title: "Active Customers",
        value: "4,263",
        growth: "+1.8%",
        icon: Icons.people,
        gradient: successGradient,
      ),
      const GradientAnalyticsCard(
        title: "Revenue",
        value: "₹68.8L",
        growth: "+2.4%",
        icon: Icons.trending_up,
        gradient: LinearGradient(
          colors: [Color(0xFF9333EA), Color(0xFFC084FC)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      const GradientAnalyticsCard(
        title: "Pending Payments",
        value: "₹4.2L",
        growth: "-0.6%",
        icon: Icons.pending_actions,
        gradient: LinearGradient(
          colors: [Color(0xFFEE5D50), Color(0xFFFCA5A5)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      const GradientAnalyticsCard(
        title: "Active Agents",
        value: "124",
        growth: "+12.0%",
        icon: Icons.support_agent,
        gradient: LinearGradient(
          colors: [Color(0xFF0EA5E9), Color(0xFF7DD3FC)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
    ];
  }
}

class GradientAnalyticsCard extends StatefulWidget {
  final String title;
  final String value;
  final String growth;
  final IconData icon;
  final LinearGradient gradient;

  const GradientAnalyticsCard({
    super.key,
    required this.title,
    required this.value,
    required this.growth,
    required this.icon,
    required this.gradient,
  });

  @override
  State<GradientAnalyticsCard> createState() => _GradientAnalyticsCardState();
}

class _GradientAnalyticsCardState extends State<GradientAnalyticsCard> {
  bool _isHovering = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovering = true),
      onExit: (_) => setState(() => _isHovering = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        transform: Matrix4.translationValues(0, _isHovering ? -5 : 0, 0),
        decoration: BoxDecoration(
          gradient: widget.gradient,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: widget.gradient.colors.first.withValues(alpha: _isHovering ? 0.4 : 0.2),
              blurRadius: _isHovering ? 20 : 10,
              offset: Offset(0, _isHovering ? 10 : 4),
            )
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.2),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Icon(widget.icon, color: Colors.white, size: 24),
                  ),
                  const Icon(Icons.more_horiz, color: Colors.white70, size: 20),
                ],
              ),
              const Spacer(),
              Text(
                widget.title,
                style: const TextStyle(
                  color: Colors.white70,
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 4),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    widget.value,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.2),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(
                      widget.growth,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
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
