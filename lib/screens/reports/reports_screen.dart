import 'package:flutter/material.dart';
import '../../constants.dart';
import '../../responsive.dart';

class ReportsScreen extends StatelessWidget {
  const ReportsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(defaultPadding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const _Header(),
            const SizedBox(height: defaultPadding * 2),
            const _ReportsGrid(),
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
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Reports",
                  style: TextStyle(fontSize: isMobile ? 24 : 32, fontWeight: FontWeight.bold, color: textPrimaryColor),
                ),
                const SizedBox(height: 4),
                Text(
                  isMobile ? "Business intelligence" : "Generate and download business reports",
                  style: TextStyle(fontSize: isMobile ? 12 : 14, color: textSecondaryColor, fontWeight: FontWeight.w500),
                ),
              ],
            ),
            if (!isMobile) _buildCustomReportButton(),
          ],
        ),
        if (isMobile) ...[
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            child: _buildCustomReportButton(),
          ),
        ],
      ],
    );
  }

  Widget _buildCustomReportButton() {
    return Container(
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF6366F1), Color(0xFFA855F7)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF6366F1).withValues(alpha: 0.3),
            blurRadius: 12,
            offset: const Offset(0, 6),
          )
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () {},
          borderRadius: BorderRadius.circular(12),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: const [
                Icon(Icons.description_outlined, color: Colors.white, size: 18),
                SizedBox(width: 8),
                Text(
                  "Custom Report",
                  style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _ReportsGrid extends StatelessWidget {
  const _ReportsGrid();

  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> reports = [
      {
        "title": "Daily Sales Report",
        "description": "Summary of all sales transactions for the day",
        "lastText": "Last: 2 hrs ago",
        "icon": Icons.bar_chart_rounded,
        "isAuto": true,
        "color": const Color(0xFF6366F1),
      },
      {
        "title": "Weekly Performance Report",
        "description": "Team performance metrics and KPIs",
        "lastText": "Last: 3 days ago",
        "icon": Icons.trending_up_rounded,
        "isAuto": true,
        "color": const Color(0xFF22C55E),
      },
      {
        "title": "Monthly Revenue Report",
        "description": "Detailed revenue breakdown by zone and product",
        "lastText": "Last: 1 week ago",
        "icon": Icons.pie_chart_outline_rounded,
        "isAuto": false,
        "color": const Color(0xFFA855F7),
      },
      {
        "title": "Customer Analysis Report",
        "description": "Customer segmentation and purchase patterns",
        "lastText": "Last: 2 weeks ago",
        "icon": Icons.group_outlined,
        "isAuto": false,
        "color": const Color(0xFF3B82F6),
      },
      {
        "title": "Inventory Status Report",
        "description": "Stock levels, reorder alerts, and movement",
        "lastText": "Last: 1 day ago",
        "icon": Icons.inventory_2_outlined,
        "isAuto": true,
        "color": const Color(0xFFF59E0B),
      },
      {
        "title": "Collection Report",
        "description": "Outstanding payments and collection status",
        "lastText": "Last: 5 hrs ago",
        "icon": Icons.account_balance_wallet_outlined,
        "isAuto": true,
        "color": const Color(0xFFEF4444),
      },
    ];

    return LayoutBuilder(builder: (context, constraints) {
      int crossAxisCount = Responsive.isMobile(context) ? 1 : 3;
      return GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: crossAxisCount,
          crossAxisSpacing: defaultPadding,
          mainAxisSpacing: defaultPadding,
          childAspectRatio: 1.8,
        ),
        itemCount: reports.length,
        itemBuilder: (context, index) {
          return _ReportCard(report: reports[index]);
        },
      );
    });
  }
}

class _ReportCard extends StatefulWidget {
  final Map<String, dynamic> report;
  const _ReportCard({required this.report});

  @override
  State<_ReportCard> createState() => _ReportCardState();
}

class _ReportCardState extends State<_ReportCard> with SingleTickerProviderStateMixin {
  bool _isHovered = false;
  late AnimationController _borderController;

  @override
  void initState() {
    super.initState();
    _borderController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    );
  }

  @override
  void dispose() {
    _borderController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_isHovered) {
      _borderController.repeat();
    } else {
      _borderController.stop();
    }

    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        decoration: BoxDecoration(
          color: surfaceColor,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: _isHovered ? widget.report["color"].withValues(alpha: 0.15) : Colors.black.withValues(alpha: 0.03),
              blurRadius: _isHovered ? 20 : 10,
              offset: _isHovered ? const Offset(0, 10) : const Offset(0, 5),
            )
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: Stack(
            children: [
              // Animated Border Gradient
              if (_isHovered)
                Positioned.fill(
                  child: RotationTransition(
                    turns: _borderController,
                    child: Container(
                      decoration: BoxDecoration(
                        gradient: SweepGradient(
                          colors: [
                            widget.report["color"].withValues(alpha: 0.0),
                            widget.report["color"],
                            widget.report["color"].withValues(alpha: 0.0),
                          ],
                          stops: const [0.0, 0.5, 1.0],
                        ),
                      ),
                    ),
                  ),
                ),
              // Content Container
              Container(
                margin: const EdgeInsets.all(2), // Simulate border width
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: surfaceColor,
                  borderRadius: BorderRadius.circular(18),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: widget.report["color"].withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Icon(widget.report["icon"], color: widget.report["color"], size: 20),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                          decoration: BoxDecoration(
                            color: widget.report["isAuto"] 
                                ? const Color(0xFF22C55E).withValues(alpha: 0.1) 
                                : const Color(0xFF94A3B8).withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            widget.report["isAuto"] ? "Auto" : "Manual",
                            style: TextStyle(
                              color: widget.report["isAuto"] ? const Color(0xFF22C55E) : const Color(0xFF64748B),
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Text(
                      widget.report["title"],
                      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: textPrimaryColor),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      widget.report["description"],
                      style: const TextStyle(fontSize: 12, color: textSecondaryColor, height: 1.4),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const Spacer(),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          widget.report["lastText"],
                          style: const TextStyle(fontSize: 11, color: textSecondaryColor, fontWeight: FontWeight.w500),
                        ),
                        TextButton.icon(
                          onPressed: () {},
                          style: TextButton.styleFrom(
                            foregroundColor: widget.report["color"],
                            padding: EdgeInsets.zero,
                            minimumSize: Size.zero,
                            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                          ),
                          icon: const Icon(Icons.download_rounded, size: 16),
                          label: const Text(
                            "Download",
                            style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
