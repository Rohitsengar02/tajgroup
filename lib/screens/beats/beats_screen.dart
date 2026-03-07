import 'package:flutter/material.dart';
import '../../constants.dart';
import '../../responsive.dart';

class BeatsScreen extends StatelessWidget {
  const BeatsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(defaultPadding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const _BeatsHeader(),
            const SizedBox(height: defaultPadding),
            const _BeatsStats(),
            const SizedBox(height: defaultPadding * 1.5),
            const _SearchAndActionBar(),
            const SizedBox(height: defaultPadding * 1.5),
            const _BeatsGrid(),
            const SizedBox(height: defaultPadding * 2),
          ],
        ),
      ),
    );
  }
}

class _BeatsHeader extends StatelessWidget {
  const _BeatsHeader();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Beats Planning",
          style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: textPrimaryColor),
        ),
        const SizedBox(height: 4),
        Text(
          "Manage and optimize sales representative routes",
          style: TextStyle(fontSize: 14, color: textSecondaryColor, fontWeight: FontWeight.w500),
        ),
      ],
    );
  }
}

class _BeatsStats extends StatelessWidget {
  const _BeatsStats();

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
          _buildStatCard("Total Beats", "24", Icons.location_on_outlined, const Color(0xFF6366F1)),
          _buildStatCard("Total Outlets", "486", Icons.storefront_outlined, const Color(0xFF22C55E)),
          _buildStatCard("Avg. Coverage", "89%", Icons.group_outlined, const Color(0xFFF59E0B)),
          _buildStatCard("Visited Today", "156", Icons.calendar_today_outlined, const Color(0xFFA855F7)),
        ],
      );
    });
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

class _SearchAndActionBar extends StatelessWidget {
  const _SearchAndActionBar();

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
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
                hintText: "Search beats...",
                hintStyle: TextStyle(fontSize: 14, color: textSecondaryColor),
                icon: Icon(Icons.search, size: 20, color: textSecondaryColor),
                border: InputBorder.none,
              ),
            ),
          ),
        ),
        const SizedBox(width: 16),
        _buildFilterButton(),
        const SizedBox(width: 16),
        _buildCreateBeatButton(),
      ],
    );
  }

  Widget _buildFilterButton() {
    return Container(
      height: 48,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: surfaceColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: textSecondaryColor.withValues(alpha: 0.1)),
      ),
      child: Row(
        children: const [
          Icon(Icons.filter_list_rounded, size: 20, color: textSecondaryColor),
          SizedBox(width: 8),
          Text("Filters", style: TextStyle(fontSize: 14, color: textSecondaryColor, fontWeight: FontWeight.w600)),
        ],
      ),
    );
  }

  Widget _buildCreateBeatButton() {
    return Container(
      height: 48,
      padding: const EdgeInsets.symmetric(horizontal: 20),
      decoration: BoxDecoration(
        color: const Color(0xFF6366F1),
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(color: const Color(0xFF6366F1).withValues(alpha: 0.3), blurRadius: 10, offset: const Offset(0, 4))
        ],
      ),
      child: Center(
        child: Row(
          children: const [
            Icon(Icons.add_rounded, size: 20, color: Colors.white),
            SizedBox(width: 8),
            Text("Create Beat", style: TextStyle(fontSize: 14, color: Colors.white, fontWeight: FontWeight.bold)),
          ],
        ),
      ),
    );
  }
}

class _BeatsGrid extends StatelessWidget {
  const _BeatsGrid();

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
          childAspectRatio: 1.5,
        ),
        itemCount: 6,
        itemBuilder: (context, index) {
          final beats = [
            {"name": "Downtown Central", "assigned": "Rajesh K.", "outlets": "45", "coverage": "92%", "status": "Active", "freq": "Daily", "freqColor": const Color(0xFF22C55E), "last": "Today"},
            {"name": "Market Area East", "assigned": "Priya S.", "outlets": "38", "coverage": "88%", "status": "Active", "freq": "Alternate", "freqColor": const Color(0xFF3B82F6), "last": "Yesterday"},
            {"name": "Industrial Zone", "assigned": "Amit P.", "outlets": "22", "coverage": "78%", "status": "Active", "freq": "Weekly", "freqColor": const Color(0xFFA855F7), "last": "3 days ago"},
            {"name": "Residential North", "assigned": "Neha S.", "outlets": "56", "coverage": "95%", "status": "Active", "freq": "Daily", "freqColor": const Color(0xFF22C55E), "last": "Today"},
            {"name": "Highway Cluster", "assigned": "Vikram G.", "outlets": "18", "coverage": "100%", "status": "Active", "freq": "Daily", "freqColor": const Color(0xFF22C55E), "last": "Today"},
            {"name": "Commercial Hub", "assigned": "Sunita D.", "outlets": "62", "coverage": "85%", "status": "Inactive", "freq": "Daily", "freqColor": const Color(0xFF94A3B8), "last": "Last week"},
          ];
          final beat = beats[index % 6];
          return _BeatCard(
            name: beat["name"] as String,
            assigned: beat["assigned"] as String,
            outlets: beat["outlets"] as String,
            coverage: beat["coverage"] as String,
            status: beat["status"] as String,
            freq: beat["freq"] as String,
            freqColor: beat["freqColor"] as Color,
            last: beat["last"] as String,
          );
        },
      );
    });
  }
}

class _BeatCard extends StatefulWidget {
  final String name, assigned, outlets, coverage, status, freq, last;
  final Color freqColor;

  const _BeatCard({
    required this.name,
    required this.assigned,
    required this.outlets,
    required this.coverage,
    required this.status,
    required this.freq,
    required this.freqColor,
    required this.last,
  });

  @override
  State<_BeatCard> createState() => _BeatCardState();
}

class _BeatCardState extends State<_BeatCard> {
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
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(widget.name, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: textPrimaryColor)),
                      const SizedBox(height: 4),
                      Text("Assigned to ${widget.assigned}", style: const TextStyle(fontSize: 12, color: textSecondaryColor, fontWeight: FontWeight.w500)),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: widget.status == "Active" ? const Color(0xFF6366F1) : const Color(0xFF94A3B8).withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    widget.status,
                    style: TextStyle(
                      color: widget.status == "Active" ? Colors.white : const Color(0xFF94A3B8), 
                      fontSize: 10, 
                      fontWeight: FontWeight.bold
                    ),
                  ),
                ),
              ],
            ),
            const Spacer(),
            Row(
              children: [
                _buildSubInfo("Outlets", widget.outlets),
                const SizedBox(width: 40),
                _buildSubInfo("Coverage", widget.coverage),
              ],
            ),
            const Divider(height: 32, thickness: 0.5),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                  decoration: BoxDecoration(
                    color: widget.freqColor.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    widget.freq,
                    style: TextStyle(color: widget.freqColor, fontSize: 11, fontWeight: FontWeight.bold),
                  ),
                ),
                Text(
                  "Last: ${widget.last}",
                  style: const TextStyle(fontSize: 11, color: textSecondaryColor, fontWeight: FontWeight.w600),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSubInfo(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontSize: 11, color: textSecondaryColor, fontWeight: FontWeight.w600)),
        const SizedBox(height: 4),
        Text(value, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w900, color: textPrimaryColor)),
      ],
    );
  }
}
