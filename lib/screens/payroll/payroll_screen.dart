import 'package:flutter/material.dart';
import '../../constants.dart';
import '../../responsive.dart';

class PayrollScreen extends StatelessWidget {
  const PayrollScreen({super.key});

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
            const _PayrollStats(),
            const SizedBox(height: defaultPadding * 2),
            const _PayrollTable(),
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
                  "Payroll & Salary",
                  style: TextStyle(fontSize: isMobile ? 24 : 32, fontWeight: FontWeight.bold, color: textPrimaryColor),
                ),
                const SizedBox(height: 4),
                Text(
                  isMobile ? "Automate payouts" : "Manage and automate employee salary payouts",
                  style: TextStyle(fontSize: isMobile ? 12 : 14, color: textSecondaryColor, fontWeight: FontWeight.w500),
                ),
              ],
            ),
            if (!isMobile)
              Row(
                children: [
                  _buildActionButton("Auto Generate", Icons.refresh_rounded, const Color(0xFF22C55E)),
                  const SizedBox(width: 12),
                  _buildActionButton("Filter", Icons.filter_list_rounded, textSecondaryColor, isOutline: true),
                  const SizedBox(width: 12),
                  _buildActionButton("Export", Icons.download_rounded, textSecondaryColor, isOutline: true),
                ],
              ),
          ],
        ),
        if (isMobile) ...[
          const SizedBox(height: 16),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                _buildActionButton("Auto Generate", Icons.refresh_rounded, const Color(0xFF22C55E)),
                const SizedBox(width: 8),
                _buildActionButton("Filter", Icons.filter_list_rounded, textSecondaryColor, isOutline: true),
                const SizedBox(width: 8),
                _buildActionButton("Export", Icons.download_rounded, textSecondaryColor, isOutline: true),
              ],
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildActionButton(String label, IconData icon, Color color, {bool isOutline = false}) {
    return Container(
      decoration: BoxDecoration(
        color: isOutline ? Colors.transparent : color,
        borderRadius: BorderRadius.circular(10),
        border: isOutline ? Border.all(color: Colors.grey.withValues(alpha: 0.2)) : null,
        boxShadow: isOutline ? null : [
          BoxShadow(color: color.withValues(alpha: 0.3), blurRadius: 8, offset: const Offset(0, 4))
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () {},
          borderRadius: BorderRadius.circular(10),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            child: Row(
              children: [
                Icon(icon, color: isOutline ? textPrimaryColor : Colors.white, size: 18),
                const SizedBox(width: 8),
                Text(
                  label,
                  style: TextStyle(
                    color: isOutline ? textPrimaryColor : Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 13,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _PayrollStats extends StatelessWidget {
  const _PayrollStats();

  @override
  Widget build(BuildContext context) {
    bool isMobile = Responsive.isMobile(context);
    List<Widget> stats = [
      _buildGradientStatCard("EMPLOYEES", "42", Icons.groups_rounded, [const Color(0xFF6366F1), const Color(0xFF818CF8)]),
      _buildGradientStatCard("TOTAL PAYROLL", "₹12.5L", Icons.account_balance_wallet_rounded, [const Color(0xFFA855F7), const Color(0xFFC084FC)]),
      _buildGradientStatCard("PENDING", "12", Icons.pending_actions_rounded, [const Color(0xFFF59E0B), const Color(0xFFFBBF24)]),
      _buildGradientStatCard("PAID", "30", Icons.check_circle_rounded, [const Color(0xFF22C55E), const Color(0xFF4ADE80)]),
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

    return LayoutBuilder(builder: (context, constraints) {
      return GridView.count(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        crossAxisCount: Responsive.isTablet(context) ? 2 : 4,
        crossAxisSpacing: defaultPadding,
        mainAxisSpacing: defaultPadding,
        childAspectRatio: 2.2,
        children: stats,
      );
    });
  }

  Widget _buildGradientStatCard(String title, String value, IconData icon, List<Color> colors) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(colors: colors, begin: Alignment.topLeft, end: Alignment.bottomRight),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(color: colors[0].withValues(alpha: 0.3), blurRadius: 12, offset: const Offset(0, 6))
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
                Text(
                  title,
                  style: const TextStyle(fontSize: 10, color: Colors.white70, fontWeight: FontWeight.w900, letterSpacing: 1.1),
                ),
                const SizedBox(height: 4),
                Text(
                  value,
                  style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w900, color: Colors.white),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _PayrollTable extends StatelessWidget {
  const _PayrollTable();

  @override
  Widget build(BuildContext context) {
    bool isMobile = Responsive.isMobile(context);
    final List<Map<String, dynamic>> payrollData = [
      {
        "id": "SAL-001",
        "employee": "Rahul Mehta",
        "month": "Jan 2024",
        "basic": "₹45,000",
        "allowance": "₹5,000",
        "net": "₹50,000",
        "status": "Paid",
        "statusColor": const Color(0xFF22C55E),
      },
      {
        "id": "SAL-002",
        "employee": "Sneha Roy",
        "month": "Jan 2024",
        "basic": "₹32,000",
        "allowance": "₹3,000",
        "net": "₹35,000",
        "status": "Pending",
        "statusColor": const Color(0xFFF59E0B),
      },
      {
        "id": "SAL-003",
        "employee": "Vikram Singh",
        "month": "Jan 2024",
        "basic": "₹28,000",
        "allowance": "₹2,000",
        "net": "₹30,000",
        "status": "Paid",
        "statusColor": const Color(0xFF22C55E),
      },
    ];

    if (isMobile) {
      return ListView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: payrollData.length,
        itemBuilder: (context, index) {
          final data = payrollData[index];
          return Container(
            margin: const EdgeInsets.symmetric(vertical: 8),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: surfaceColor,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(color: Colors.black.withValues(alpha: 0.02), blurRadius: 10, offset: const Offset(0, 5))
              ],
            ),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(data["employee"], style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                        const SizedBox(height: 4),
                        Text(data["id"], style: const TextStyle(fontSize: 12, color: textSecondaryColor)),
                      ],
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: (data["statusColor"] as Color).withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        data["status"],
                        style: TextStyle(color: data["statusColor"], fontSize: 10, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                ),
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 12),
                  child: Divider(height: 1),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _buildMobileInfo("MONTH", data["month"]),
                    _buildMobileInfo("BASIC", data["basic"]),
                    _buildMobileInfo("NET", data["net"]),
                  ],
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () {},
                        style: OutlinedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                          side: BorderSide(color: Colors.grey.withValues(alpha: 0.2)),
                        ),
                        child: const Text("View Details", style: TextStyle(fontSize: 12, color: textPrimaryColor)),
                      ),
                    ),
                    const SizedBox(width: 8),
                    IconButton(
                      onPressed: () {},
                      icon: const Icon(Icons.download_rounded, color: primaryColor, size: 20),
                      style: IconButton.styleFrom(
                        backgroundColor: primaryColor.withValues(alpha: 0.1),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          );
        },
      );
    }

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: surfaceColor,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(color: Colors.black.withValues(alpha: 0.02), blurRadius: 10, offset: const Offset(0, 5))
        ],
      ),
      child: Column(
        children: [
          // Table Header
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
            decoration: BoxDecoration(
              color: const Color(0xFFF8FAFC),
              borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
              border: Border(bottom: BorderSide(color: Colors.grey.withValues(alpha: 0.1))),
            ),
            child: Row(
              children: const [
                _HeaderCell(label: "SALARY ID", flex: 2),
                _HeaderCell(label: "EMPLOYEE", flex: 3),
                _HeaderCell(label: "MONTH", flex: 2),
                _HeaderCell(label: "BASIC", flex: 2),
                _HeaderCell(label: "ALLOWANCE", flex: 2),
                _HeaderCell(label: "NET SALARY", flex: 2),
                _HeaderCell(label: "STATUS", flex: 2),
                _HeaderCell(label: "ACTIONS", flex: 1),
              ],
            ),
          ),
          // Table Body
          ...payrollData.map((data) => Container(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
            decoration: BoxDecoration(
              border: Border(bottom: BorderSide(color: Colors.grey.withValues(alpha: 0.05))),
            ),
            child: Row(
              children: [
                Expanded(flex: 2, child: Text(data["id"], style: const TextStyle(fontSize: 13, color: textSecondaryColor, fontWeight: FontWeight.w500))),
                Expanded(flex: 3, child: Text(data["employee"], style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: textPrimaryColor))),
                Expanded(flex: 2, child: Text(data["month"], style: const TextStyle(fontSize: 13, color: textSecondaryColor))),
                Expanded(flex: 2, child: Text(data["basic"], style: const TextStyle(fontSize: 13, color: textSecondaryColor))),
                Expanded(flex: 2, child: Text(data["allowance"], style: const TextStyle(fontSize: 13, color: textSecondaryColor))),
                Expanded(flex: 2, child: Text(data["net"], style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: textPrimaryColor))),
                Expanded(
                  flex: 2,
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: (data["statusColor"] as Color).withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(
                          data["status"],
                          style: TextStyle(color: data["statusColor"], fontSize: 11, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: IconButton(
                    onPressed: () {},
                    icon: const Icon(Icons.more_horiz_rounded, color: textSecondaryColor),
                  ),
                ),
              ],
            ),
          )).toList(),
        ],
      ),
    );
  }

  Widget _buildMobileInfo(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontSize: 9, color: textSecondaryColor, fontWeight: FontWeight.w900, letterSpacing: 0.5)),
        const SizedBox(height: 4),
        Text(value, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: textPrimaryColor)),
      ],
    );
  }
}

class _HeaderCell extends StatelessWidget {
  final String label;
  final int flex;
  const _HeaderCell({required this.label, required this.flex});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      flex: flex,
      child: Text(
        label,
        style: const TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w900,
          color: Color(0xFF64748B),
          letterSpacing: 0.5,
        ),
      ),
    );
  }
}
