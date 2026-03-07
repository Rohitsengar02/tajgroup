import 'package:flutter/material.dart';
import '../../constants.dart';
import '../../responsive.dart';

class TargetScreen extends StatelessWidget {
  const TargetScreen({super.key});

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
            const _TargetStats(),
            const SizedBox(height: defaultPadding * 1.5),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  flex: 5,
                  child: const _RegionalTargets(),
                ),
                if (!Responsive.isMobile(context)) const SizedBox(width: defaultPadding),
                if (!Responsive.isMobile(context))
                  Expanded(
                    flex: 4,
                    child: const _TeamPerformance(),
                  ),
              ],
            ),
            if (Responsive.isMobile(context)) ...[
              const SizedBox(height: defaultPadding),
              const _TeamPerformance(),
            ],
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
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Target Tracking",
          style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: textPrimaryColor),
        ),
        const SizedBox(height: 4),
        Text(
          "Monitor sales goals and team achievements",
          style: TextStyle(fontSize: 14, color: textSecondaryColor, fontWeight: FontWeight.w500),
        ),
      ],
    );
  }
}

class _TargetStats extends StatelessWidget {
  const _TargetStats();

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      int crossAxisCount = Responsive.isMobile(context) ? 2 : 4;
      return GridView.count(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        crossAxisCount: crossAxisCount,
        crossAxisSpacing: defaultPadding,
        mainAxisSpacing: defaultPadding,
        childAspectRatio: 2.2,
        children: [
          _buildGradientStatCard("Total Target", "₹125.0L", Icons.track_changes_rounded, [const Color(0xFF6366F1), const Color(0xFF818CF8)]),
          _buildGradientStatCard("Achieved", "₹116.0L", Icons.trending_up_rounded, [const Color(0xFF22C55E), const Color(0xFF4ADE80)]),
          _buildGradientStatCard("Achievement", "93%", Icons.auto_graph_rounded, [const Color(0xFFA855F7), const Color(0xFFC084FC)]),
          _buildGradientStatCard("On Track", "32/42", Icons.groups_rounded, [const Color(0xFFF59E0B), const Color(0xFFFBBF24)]),
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

class _RegionalTargets extends StatelessWidget {
  const _RegionalTargets();

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
          const Text("Regional Targets", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: textPrimaryColor)),
          const SizedBox(height: 32),
          _buildTargetRow("North Zone", 0.85, "₹21.3L", "₹25.0L"),
          const SizedBox(height: 24),
          _buildTargetRow("South Zone", 0.95, "₹28.5L", "₹30.0L"),
          const SizedBox(height: 24),
          _buildTargetRow("East Zone", 0.84, "₹16.8L", "₹20.0L"),
          const SizedBox(height: 24),
          _buildTargetRow("West Zone", 1.10, "₹24.2L", "₹22.0L"),
          const SizedBox(height: 24),
          _buildTargetRow("Central Zone", 0.90, "₹25.2L", "₹28.0L"),
        ],
      ),
    );
  }

  Widget _buildTargetRow(String label, double progress, String achieved, String target) {
    Color progressColor = progress >= 1.0 ? const Color(0xFF22C55E) : const Color(0xFF6366F1);
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(label, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: textPrimaryColor)),
            RichText(
              text: TextSpan(
                children: [
                  TextSpan(
                    text: "${(progress * 100).toInt()}% ",
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: progressColor),
                  ),
                  TextSpan(
                    text: "$achieved / $target",
                    style: const TextStyle(fontSize: 12, color: textSecondaryColor, fontWeight: FontWeight.w500),
                  ),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Stack(
          children: [
            Container(
              height: 8,
              width: double.infinity,
              decoration: BoxDecoration(color: const Color(0xFFF1F5F9), borderRadius: BorderRadius.circular(10)),
            ),
            FractionallySizedBox(
              widthFactor: progress.clamp(0.0, 1.0),
              child: Container(
                height: 8,
                decoration: BoxDecoration(
                  gradient: LinearGradient(colors: [progressColor, progressColor.withValues(alpha: 0.6)]),
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _TeamPerformance extends StatelessWidget {
  const _TeamPerformance();

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
          const Text("Team Performance", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: textPrimaryColor)),
          const SizedBox(height: 24),
          _buildTeamMemberRow("RK", "Rajesh Kumar", "North Zone", 0.85),
          const Divider(height: 40),
          _buildTeamMemberRow("PS", "Priya Sharma", "South Zone", 0.94),
          const Divider(height: 40),
          _buildTeamMemberRow("AP", "Amit Patel", "West Zone", 1.07),
          const Divider(height: 40),
          _buildTeamMemberRow("NS", "Neha Singh", "East Zone", 0.64),
          const Divider(height: 40),
          _buildTeamMemberRow("VG", "Vikram Gupta", "Central Zone", 0.90),
        ],
      ),
    );
  }

  Widget _buildTeamMemberRow(String initial, String name, String zone, double progress) {
    Color badgeColor = progress >= 1.0 
        ? const Color(0xFF6366F1) 
        : (progress < 0.7 ? const Color(0xFFEF4444) : const Color(0xFF94A3B8).withValues(alpha: 0.2));
    Color badgeTextColor = progress >= 1.0 
        ? Colors.white 
        : (progress < 0.7 ? Colors.white : textPrimaryColor);

    return Column(
      children: [
        Row(
          children: [
            CircleAvatar(
              radius: 18,
              backgroundColor: const Color(0xFFF1F5F9),
              child: Text(initial, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: textSecondaryColor)),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(name, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: textPrimaryColor)),
                  Text(zone, style: const TextStyle(fontSize: 12, color: textSecondaryColor, fontWeight: FontWeight.w500)),
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                color: badgeColor,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Text(
                "${(progress * 100).toInt()}%",
                style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: badgeTextColor),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Stack(
          children: [
            Container(
              height: 4,
              width: double.infinity,
              decoration: BoxDecoration(color: const Color(0xFFF1F5F9), borderRadius: BorderRadius.circular(10)),
            ),
            FractionallySizedBox(
              widthFactor: progress.clamp(0.0, 1.0),
              child: Container(
                height: 4,
                decoration: BoxDecoration(
                  color: const Color(0xFF6366F1),
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
