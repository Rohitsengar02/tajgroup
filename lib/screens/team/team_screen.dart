import 'package:flutter/material.dart';
import '../../constants.dart';
import '../../responsive.dart';
import 'add_member_screen.dart';

class TeamScreen extends StatelessWidget {
  const TeamScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(defaultPadding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const _TeamHeader(),
            const SizedBox(height: defaultPadding),
            const _TeamStats(),
            const SizedBox(height: defaultPadding * 1.5),
            const _SearchAndFilterBar(),
            const SizedBox(height: defaultPadding * 1.5),
            const _TeamGrid(),
            const SizedBox(height: defaultPadding * 2),
          ],
        ),
      ),
    );
  }
}

class _TeamHeader extends StatelessWidget {
  const _TeamHeader();

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
                  "Team",
                  style: TextStyle(
                    fontSize: isMobile ? 24 : 28,
                    fontWeight: FontWeight.bold,
                    color: textPrimaryColor,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  isMobile ? "Team management" : "Sales team management & performance",
                  style: TextStyle(
                    fontSize: isMobile ? 12 : 14,
                    color: textSecondaryColor,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
            if (!isMobile)
              Row(
                children: [
                  _buildHeaderButton(
                    icon: Icons.file_upload_outlined,
                    label: "Export",
                    onPressed: () {},
                    isOutlined: true,
                  ),
                  const SizedBox(width: 12),
                  _buildHeaderButton(
                    icon: Icons.add_rounded,
                    label: "Add Member",
                    onPressed: () => _navigateToAdd(context),
                    isOutlined: false,
                  ),
                ],
              ),
          ],
        ),
        if (isMobile) ...[
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: _buildHeaderButton(
                  icon: Icons.add_rounded,
                  label: "Add Member",
                  onPressed: () => _navigateToAdd(context),
                  isOutlined: false,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildHeaderButton(
                  icon: Icons.file_upload_outlined,
                  label: "Export",
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
        pageBuilder: (context, animation, secondaryAnimation) => const AddMemberScreen(),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          return FadeTransition(opacity: animation, child: child);
        },
        opaque: false,
        barrierColor: Colors.black.withValues(alpha: 0.5),
      ),
    );
  }

  Widget _buildHeaderButton({
    required IconData icon,
    required String label,
    required VoidCallback onPressed,
    required bool isOutlined,
  }) {
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
        color: const Color(0xFF1E293B), // Darker professional button as per image
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

class _TeamStats extends StatelessWidget {
  const _TeamStats();

  @override
  Widget build(BuildContext context) {
    bool isMobile = Responsive.isMobile(context);
    List<Widget> stats = [
      _buildStatCard("Total Team", "3", Icons.groups_outlined, const Color(0xFF6366F1)),
      _buildStatCard("Super Stockists", "1", Icons.business_rounded, const Color(0xFFA855F7)),
      _buildStatCard("Distributors", "1", Icons.hub_outlined, const Color(0xFF22C55E)),
      _buildStatCard("Salesmen", "1", Icons.person_pin_rounded, const Color(0xFFF59E0B)),
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
      crossAxisCount: Responsive.isTablet(context) ? 2 : 4,
      crossAxisSpacing: defaultPadding,
      mainAxisSpacing: defaultPadding,
      childAspectRatio: 2.5,
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
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.02),
            blurRadius: 10,
            offset: const Offset(0, 5),
          )
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: color, size: 24),
          ),
          const SizedBox(width: 16),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                value,
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w900,
                   color: textPrimaryColor,
                ),
              ),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 12,
                  color: textSecondaryColor,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
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
                    hintText: "Search team...",
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
                    value: "All Roles",
                    items: ["All Roles", "Super Stockist", "Distributor", "Salesman"]
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
              children: ["All Roles", "Super Stockists", "Distributors", "Salesmen"].map((role) {
                bool isSelected = role == "All Roles";
                return Container(
                  margin: const EdgeInsets.only(right: 8),
                  child: FilterChip(
                    label: Text(role),
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

class _TeamGrid extends StatelessWidget {
  const _TeamGrid();

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
        childAspectRatio: isMobile ? 1.5 : 1.7,
      ),
      itemCount: 3,
      itemBuilder: (context, index) {
        if (index == 0) {
          return const _TeamMemberCard(
            initial: "A",
            name: "AASHA FOOD AND BEVERAGES",
            role: "Distributor",
            roleColor: Color(0xFF22C55E),
            email: "aashafoodandbeverages@gmail.com",
            phone: "987955543",
            territory: "CENTRAL GUJARAT",
            achieved: 851.757,
            target: 500000,
          );
        } else if (index == 1) {
          return const _TeamMemberCard(
            initial: "A",
            name: "AASHA FOOD AND BEVERAGES",
            role: "Super Stockist",
            roleColor: Color(0xFFA855F7),
            email: "aashafoodandbeverages@gmail.com",
            phone: "9825559243",
            territory: "CENTRAL GUJARAT",
            achieved: 851.757,
            target: 5000000,
          );
        }
        return const _TeamMemberCard(
          initial: "R",
          name: "Ravindra Parmar",
          role: "Salesman",
          roleColor: Color(0xFFF59E0B),
          email: "aashafoodandbeverages@gmail.com",
          phone: "7777988806",
          territory: "Vadodara",
          achieved: 851.757,
          target: 500000,
        );
      },
    );
  }
}

class _TeamMemberCard extends StatefulWidget {
  final String initial, name, role, email, phone, territory;
  final Color roleColor;
  final double achieved, target;

  const _TeamMemberCard({
    required this.initial,
    required this.name,
    required this.role,
    required this.roleColor,
    required this.email,
    required this.phone,
    required this.territory,
    required this.achieved,
    required this.target,
  });

  @override
  State<_TeamMemberCard> createState() => _TeamMemberCardState();
}

class _TeamMemberCardState extends State<_TeamMemberCard> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    double progress = (widget.achieved / widget.target).clamp(0.0, 1.0);
    
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
              color: _isHovered 
                ? primaryColor.withValues(alpha: 0.1) 
                : Colors.black.withValues(alpha: 0.03),
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
                CircleAvatar(
                  radius: 24,
                  backgroundColor: textPrimaryColor,
                  child: Text(
                    widget.initial,
                    style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.name,
                        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: textPrimaryColor),
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 4),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                        decoration: BoxDecoration(
                          color: widget.roleColor.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(
                          widget.role,
                          style: TextStyle(color: widget.roleColor, fontSize: 11, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ],
                  ),
                ),
                const Icon(Icons.more_vert_rounded, color: textSecondaryColor, size: 20),
              ],
            ),
            const SizedBox(height: 16),
            _buildIconInfo(Icons.email_outlined, widget.email),
            const SizedBox(height: 8),
            _buildIconInfo(Icons.phone_outlined, widget.phone),
            const SizedBox(height: 8),
            _buildIconInfo(Icons.location_on_outlined, widget.territory),
            const Spacer(),
            const Divider(height: 24, thickness: 0.5),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: const [
                     Icon(Icons.track_changes_rounded, size: 16, color: textSecondaryColor),
                     SizedBox(width: 8),
                     Text("Target Progress", style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: textPrimaryColor)),
                  ],
                ),
                Text("${(progress * 100).toInt()}%", style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: textPrimaryColor)),
              ],
            ),
            const SizedBox(height: 10),
            ClipRRect(
              borderRadius: BorderRadius.circular(4),
              child: LinearProgressIndicator(
                value: progress,
                minHeight: 6,
                backgroundColor: bgColor,
                valueColor: AlwaysStoppedAnimation<Color>(primaryColor.withValues(alpha: 0.8)),
              ),
            ),
            const SizedBox(height: 6),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("₹${widget.achieved}", style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: textSecondaryColor)),
                Text("₹${widget.target}", style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: textSecondaryColor)),
              ],
            ),
            const SizedBox(height: 12),
             Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: successColor.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Text(
                  "Active",
                  style: TextStyle(color: successColor, fontSize: 11, fontWeight: FontWeight.bold),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildIconInfo(IconData icon, String text) {
    return Row(
      children: [
        Icon(icon, size: 16, color: textSecondaryColor),
        const SizedBox(width: 10),
        Expanded(
          child: Text(
            text,
            style: const TextStyle(fontSize: 12, color: textSecondaryColor, fontWeight: FontWeight.w500),
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }
}
