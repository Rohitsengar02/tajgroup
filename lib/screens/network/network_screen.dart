import 'package:flutter/material.dart';
import '../../constants.dart';
import '../../responsive.dart';
import 'add_node_screen.dart';

class NetworkScreen extends StatefulWidget {
  const NetworkScreen({super.key});

  @override
  State<NetworkScreen> createState() => _NetworkScreenState();
}

class _NetworkScreenState extends State<NetworkScreen> {
  String selectedNode = "TAJRYNA HQ";

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(defaultPadding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const _NetworkHeader(),
            const SizedBox(height: defaultPadding),
            const _NetworkStats(),
            const SizedBox(height: defaultPadding * 2),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  flex: 2,
                  child: _HierarchyPanel(
                    selectedNode: selectedNode,
                    onNodeSelected: (name) {
                      setState(() {
                        selectedNode = name;
                      });
                    },
                  ),
                ),
                if (!Responsive.isMobile(context)) const SizedBox(width: defaultPadding),
                if (!Responsive.isMobile(context))
                  Expanded(
                    flex: 1,
                    child: _DetailsPanel(selectedNode: selectedNode),
                  ),
              ],
            ),
            if (Responsive.isMobile(context)) const SizedBox(height: defaultPadding),
            if (Responsive.isMobile(context)) _DetailsPanel(selectedNode: selectedNode),
            const SizedBox(height: defaultPadding * 2),
            const _NetworkTable(),
            const SizedBox(height: defaultPadding * 2),
          ],
        ),
      ),
    );
  }
}

class _NetworkHeader extends StatelessWidget {
  const _NetworkHeader();

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
                  "Network",
                  style: TextStyle(fontSize: isMobile ? 24 : 28, fontWeight: FontWeight.bold, color: textPrimaryColor),
                ),
                const SizedBox(height: 4),
                Text(
                  isMobile ? "Structure & Nodes" : "HQ → Super Stockist → Distributor → Sales Person hierarchy",
                  style: TextStyle(fontSize: isMobile ? 12 : 14, color: textSecondaryColor, fontWeight: FontWeight.w500),
                ),
              ],
            ),
            if (!isMobile)
              Row(
                children: [
                  _buildHeaderIconButton(Icons.filter_list_rounded, "Filter"),
                  const SizedBox(width: 8),
                  _buildHeaderIconButton(Icons.file_upload_outlined, "Export"),
                  const SizedBox(width: 12),
                  _buildAddButton(context),
                ],
              ),
          ],
        ),
        if (isMobile) ...[
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(child: _buildAddButton(context)),
              const SizedBox(width: 12),
              _buildHeaderIconButton(Icons.filter_list_rounded, ""),
              const SizedBox(width: 8),
              _buildHeaderIconButton(Icons.file_upload_outlined, ""),
            ],
          ),
        ],
      ],
    );
  }

  Widget _buildAddButton(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: primaryGradient,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(color: primaryColor.withValues(alpha: 0.3), blurRadius: 10, offset: const Offset(0, 4))
        ],
      ),
      child: ElevatedButton.icon(
        onPressed: () {
          Navigator.of(context).push(
            PageRouteBuilder(
              pageBuilder: (context, animation, secondaryAnimation) => const AddNodeScreen(),
              transitionsBuilder: (context, animation, secondaryAnimation, child) {
                return FadeTransition(opacity: animation, child: child);
              },
              opaque: false,
              barrierColor: Colors.black.withValues(alpha: 0.5),
            ),
          );
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.transparent,
          shadowColor: Colors.transparent,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        ),
        icon: const Icon(Icons.add_rounded, size: 20),
        label: const Text("Add Node", style: TextStyle(fontWeight: FontWeight.bold)),
      ),
    );
  }

  Widget _buildHeaderIconButton(IconData icon, String label) {
    return OutlinedButton.icon(
      onPressed: () {},
      style: OutlinedButton.styleFrom(
        foregroundColor: textPrimaryColor,
        side: BorderSide(color: textSecondaryColor.withValues(alpha: 0.3)),
        padding: EdgeInsets.symmetric(horizontal: label.isEmpty ? 12 : 16, vertical: 16),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
      icon: Icon(icon, size: 18),
      label: label.isEmpty 
        ? const SizedBox() 
        : Text(label, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
    );
  }
}

class _NetworkStats extends StatelessWidget {
  const _NetworkStats();

  @override
  Widget build(BuildContext context) {
    bool isMobile = Responsive.isMobile(context);
    List<Widget> stats = [
      _buildStatCard("HEAD QUARTERS", "1", primaryGradient, isMobile),
      _buildStatCard("SUPER STOCKISTS", "2", successGradient, isMobile),
      _buildStatCard("DISTRIBUTORS", "3", secondaryGradient, isMobile),
      _buildStatCard("SALES PERSONS", "4", const LinearGradient(colors: [Color(0xFF6366F1), Color(0xFF8B5CF6)]), isMobile),
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
      final double cardWidth = (constraints.maxWidth - (defaultPadding * 3)) / 4;
      return Row(
        children: [
          _buildStatCard("HEAD QUARTERS", "1", primaryGradient, false, width: cardWidth),
          const SizedBox(width: defaultPadding),
          _buildStatCard("SUPER STOCKISTS", "2", successGradient, false, width: cardWidth),
          const SizedBox(width: defaultPadding),
          _buildStatCard("DISTRIBUTORS", "3", secondaryGradient, false, width: cardWidth),
          const SizedBox(width: defaultPadding),
          _buildStatCard("SALES PERSONS", "4", const LinearGradient(colors: [Color(0xFF6366F1), Color(0xFF8B5CF6)]), false, width: cardWidth),
        ],
      );
    });
  }

  Widget _buildStatCard(String title, String value, Gradient gradient, bool isMobile, {double? width}) {
    return Container(
      width: width,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: surfaceColor,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(color: Colors.black.withValues(alpha: 0.03), blurRadius: 10, offset: const Offset(0, 5))
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: textSecondaryColor, letterSpacing: 0.5)),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(value, style: TextStyle(fontSize: isMobile ? 22 : 26, fontWeight: FontWeight.w900, color: textPrimaryColor)),
              Container(
                width: isMobile ? 30 : 35,
                height: isMobile ? 30 : 35,
                decoration: BoxDecoration(
                  gradient: gradient,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(color: (gradient as LinearGradient).colors.first.withValues(alpha: 0.2), blurRadius: 8, offset: const Offset(0, 4))
                  ],
                ),
                child: Icon(Icons.hub_outlined, color: Colors.white, size: isMobile ? 14 : 16),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _HierarchyPanel extends StatelessWidget {
  final String selectedNode;
  final Function(String) onNodeSelected;
  const _HierarchyPanel({required this.selectedNode, required this.onNodeSelected});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(defaultPadding),
      decoration: BoxDecoration(
        color: surfaceColor,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(color: Colors.black.withValues(alpha: 0.02), blurRadius: 10, offset: const Offset(0, 5))
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text("Network Hierarchy", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: textPrimaryColor)),
          const Divider(height: 32),
          _buildHierarchyItem(
            name: "TAJRYNA HQ",
            type: "HQ",
            location: "Mumbai, Maharashtra",
            icon: Icons.business_rounded,
            isParent: true,
            indent: 0,
          ),
          const SizedBox(height: 12),
          _buildHierarchyItem(
            name: "Mumbai Super Stockist",
            type: "SuperStockist",
            location: "Mumbai, Maharashtra",
            icon: Icons.groups_rounded,
            indent: 40,
          ),
          const SizedBox(height: 12),
          _buildHierarchyItem(
            name: "Delhi Super Stockist",
            type: "SuperStockist",
            location: "Delhi",
            icon: Icons.groups_rounded,
            indent: 40,
          ),
        ],
      ),
    );
  }

  Widget _buildHierarchyItem({
    required String name,
    required String type,
    required String location,
    required IconData icon,
    bool isParent = false,
    double indent = 0,
  }) {
    bool isSelected = selectedNode == name;
    return GestureDetector(
      onTap: () => onNodeSelected(name),
      child: Padding(
        padding: EdgeInsets.only(left: indent),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: BoxDecoration(
            color: isSelected ? primaryColor.withValues(alpha: 0.05) : Colors.transparent,
            borderRadius: BorderRadius.circular(12),
            border: isSelected ? Border.all(color: primaryColor.withValues(alpha: 0.1)) : null,
          ),
          child: Row(
            children: [
              Icon(
                isParent ? Icons.keyboard_arrow_down_rounded : Icons.keyboard_arrow_right_rounded,
                color: isSelected ? primaryColor : textSecondaryColor,
                size: 20,
              ),
              const SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: isSelected ? primaryColor.withValues(alpha: 0.15) : primaryColor.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(icon, color: isSelected ? primaryColor : primaryColor.withValues(alpha: 0.7), size: 18),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(name, 
                      style: TextStyle(
                        fontWeight: isSelected ? FontWeight.bold : FontWeight.w600, 
                        fontSize: 15, 
                        color: isSelected ? primaryColor : textPrimaryColor
                      )
                    ),
                    Text("$type • $location", style: const TextStyle(fontSize: 11, color: textSecondaryColor)),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: successColor.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Text("Active", style: TextStyle(color: successColor, fontSize: 10, fontWeight: FontWeight.bold)),
              ),
              const SizedBox(width: 12),
              _buildActionIcon(Icons.edit_outlined, Colors.indigo),
              const SizedBox(width: 8),
              _buildActionIcon(Icons.delete_outline_rounded, Colors.redAccent),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildActionIcon(IconData icon, Color color) {
    return InkWell(
      onTap: () {},
      child: Icon(icon, color: color.withValues(alpha: 0.6), size: 18),
    );
  }
}

class _DetailsPanel extends StatelessWidget {
  final String selectedNode;
  const _DetailsPanel({required this.selectedNode});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(defaultPadding),
      decoration: BoxDecoration(
        color: surfaceColor,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(color: Colors.black.withValues(alpha: 0.02), blurRadius: 10, offset: const Offset(0, 5))
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text("Details", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: textPrimaryColor)),
          const Divider(height: 32),
          Row(
            children: [
              Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  color: primaryColor.withValues(alpha: 0.1),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.business_rounded, color: primaryColor, size: 28),
              ),
              const SizedBox(width: 16),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(selectedNode, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: textPrimaryColor)),
                  const Text("HQ", style: TextStyle(fontSize: 13, color: textSecondaryColor, fontWeight: FontWeight.w500)),
                ],
              ),
            ],
          ),
          const SizedBox(height: 24),
          _buildDetailRow("Location", "Mumbai, Maharashtra"),
          _buildDetailRow("Zone", "All India"),
          _buildDetailRow("Contact", "+91 22 1234 5678"),
          _buildDetailRow("Email", "hq@tajryna.com"),
          _buildDetailRow("Status", "Active", isStatus: true),
          const Divider(height: 40, thickness: 0.5),
          const Text("Children: 2", style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: textSecondaryColor)),
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            child: OutlinedButton.icon(
              onPressed: () {
                Navigator.of(context).push(
                  PageRouteBuilder(
                    pageBuilder: (context, animation, secondaryAnimation) => const AddNodeScreen(),
                    transitionsBuilder: (context, animation, secondaryAnimation, child) {
                      return FadeTransition(opacity: animation, child: child);
                    },
                    opaque: false,
                    barrierColor: Colors.black.withValues(alpha: 0.5),
                  ),
                );
              },
              icon: const Icon(Icons.add_rounded, size: 18),
              label: const Text("Add Child Node", style: TextStyle(fontWeight: FontWeight.bold)),
              style: OutlinedButton.styleFrom(
                foregroundColor: textPrimaryColor,
                padding: const EdgeInsets.symmetric(vertical: 16),
                side: BorderSide(color: textSecondaryColor.withValues(alpha: 0.2)),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailRow(String label, String value, {bool isStatus = false}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(color: textSecondaryColor, fontSize: 13, fontWeight: FontWeight.w500)),
          if (isStatus)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                color: successColor.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Text("Active", style: TextStyle(color: successColor, fontSize: 11, fontWeight: FontWeight.bold)),
            )
          else
            Text(value, style: const TextStyle(color: textPrimaryColor, fontSize: 13, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }
}

class _NetworkTable extends StatelessWidget {
  const _NetworkTable();

  @override
  Widget build(BuildContext context) {
    bool isMobile = Responsive.isMobile(context);
    final List<Map<String, String>> data = [
      {"name": "TAJRYNA HQ", "type": "HQ", "location": "Mumbai, Maharashtra", "zone": "All India", "contact": "+91 22 1234 5678"},
      {"name": "Mumbai Super Stockist", "type": "SuperStockist", "location": "Mumbai, Maharashtra", "zone": "Mumbai", "contact": "+91 98765 43210"},
      {"name": "Delhi Super Stockist", "type": "SuperStockist", "location": "Delhi", "zone": "Delhi NCR", "contact": "+91 98765 43211"},
    ];

    if (isMobile) {
      return Column(
        children: data.map((item) => _buildMobileCard(item)).toList(),
      );
    }

    return Container(
      padding: const EdgeInsets.all(defaultPadding),
      decoration: BoxDecoration(
        color: surfaceColor,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(color: Colors.black.withValues(alpha: 0.02), blurRadius: 10, offset: const Offset(0, 5))
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: DataTable(
              headingRowColor: WidgetStateProperty.all(bgColor.withValues(alpha: 0.3)),
              horizontalMargin: 20,
              columnSpacing: 40,
              columns: const [
                DataColumn(label: Text("NAME", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12, color: textPrimaryColor))),
                DataColumn(label: Text("TYPE", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12, color: textPrimaryColor))),
                DataColumn(label: Text("LOCATION", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12, color: textPrimaryColor))),
                DataColumn(label: Text("ZONE", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12, color: textPrimaryColor))),
                DataColumn(label: Text("CONTACT", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12, color: textPrimaryColor))),
                DataColumn(label: Text("STATUS", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12, color: textPrimaryColor))),
                DataColumn(label: Text("ACTIONS", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12, color: textPrimaryColor))),
              ],
              rows: data.map((item) => _buildDataRow(item)).toList(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMobileCard(Map<String, String> item) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
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
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(item["name"]!, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: textPrimaryColor)),
                    const SizedBox(height: 4),
                    Text(item["type"]!, style: const TextStyle(color: primaryColor, fontSize: 12, fontWeight: FontWeight.bold)),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: successColor.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: const Text("Active", style: TextStyle(color: successColor, fontSize: 11, fontWeight: FontWeight.bold)),
              ),
            ],
          ),
          const Divider(height: 24),
          _buildMobileRow(Icons.location_on_outlined, item["location"]!),
          const SizedBox(height: 8),
          _buildMobileRow(Icons.public_outlined, item["zone"]!),
          const SizedBox(height: 8),
          _buildMobileRow(Icons.phone_outlined, item["contact"]!),
          const Divider(height: 24),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              TextButton.icon(
                onPressed: () {},
                icon: const Icon(Icons.edit_outlined, size: 18),
                label: const Text("Edit"),
                style: TextButton.styleFrom(foregroundColor: Colors.indigo),
              ),
              const SizedBox(width: 16),
              TextButton.icon(
                onPressed: () {},
                icon: const Icon(Icons.delete_outline_rounded, size: 18),
                label: const Text("Delete"),
                style: TextButton.styleFrom(foregroundColor: Colors.redAccent),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildMobileRow(IconData icon, String text) {
    return Row(
      children: [
        Icon(icon, size: 16, color: textSecondaryColor),
        const SizedBox(width: 8),
        Text(text, style: const TextStyle(color: textSecondaryColor, fontSize: 13)),
      ],
    );
  }

  DataRow _buildDataRow(Map<String, String> item) {
    return DataRow(cells: [
      DataCell(Text(item["name"]!, style: const TextStyle(fontWeight: FontWeight.w600, color: textPrimaryColor))),
      DataCell(Text(item["type"]!, style: const TextStyle(color: textSecondaryColor))),
      DataCell(Text(item["location"]!, style: const TextStyle(color: textSecondaryColor))),
      DataCell(Text(item["zone"]!, style: const TextStyle(color: textSecondaryColor))),
      DataCell(Text(item["contact"]!, style: const TextStyle(color: textSecondaryColor))),
      DataCell(
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
          decoration: BoxDecoration(
            color: successColor.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(20),
          ),
          child: const Text("Active", style: TextStyle(color: successColor, fontSize: 11, fontWeight: FontWeight.bold)),
        ),
      ),
      DataCell(
        Row(
          children: [
            Icon(Icons.edit_outlined, color: Colors.indigo.withValues(alpha: 0.6), size: 18),
            const SizedBox(width: 12),
            Icon(Icons.delete_outline_rounded, color: Colors.redAccent.withValues(alpha: 0.6), size: 18),
          ],
        ),
      ),
    ]);
  }
}
