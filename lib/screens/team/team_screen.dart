import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../constants.dart';
import '../../responsive.dart';
import 'add_member_screen.dart';
import 'team_details_screen.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:excel/excel.dart' as exc;
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'dart:html' as html;

class TeamScreen extends StatefulWidget {
  const TeamScreen({super.key});

  @override
  State<TeamScreen> createState() => _TeamScreenState();
}

class _TeamScreenState extends State<TeamScreen> {
  List<dynamic> members = [];
  List<dynamic> filteredMembers = [];
  bool _isLoading = true;
  String searchQuery = "";
  String roleFilter = "All Roles";

  @override
  void initState() {
    super.initState();
    _fetchMembers();
  }

  Future<void> _fetchMembers() async {
    setState(() => _isLoading = true);
    try {
      final response = await http.get(Uri.parse('$backendUrl/api/team?role=$roleFilter&search=$searchQuery'));
      if (response.statusCode == 200) {
        setState(() {
          members = jsonDecode(response.body);
          filteredMembers = members;
          _isLoading = false;
        });
      }
    } catch (e) {
      debugPrint("Error fetching team: $e");
      if (mounted) setState(() => _isLoading = false);
    }
  }

  void _applyFilters() {
    _fetchMembers(); // Re-fetch with query params
  }

  Future<void> _exportToExcel() async {
    var excel = exc.Excel.createExcel();
    exc.Sheet sheetObject = excel['Team'];
    excel.delete('Sheet1');

    sheetObject.appendRow([
      exc.TextCellValue("Name"),
      exc.TextCellValue("Email"),
      exc.TextCellValue("Phone"),
      exc.TextCellValue("Role"),
      exc.TextCellValue("Territory"),
      exc.TextCellValue("Monthly Target"),
      exc.TextCellValue("Achieved"),
      exc.TextCellValue("Status")
    ]);

    for (var m in filteredMembers) {
      sheetObject.appendRow([
        exc.TextCellValue(m['name'] ?? ""),
        exc.TextCellValue(m['email'] ?? ""),
        exc.TextCellValue(m['phone'] ?? ""),
        exc.TextCellValue(m['role'] ?? ""),
        exc.TextCellValue(m['territory'] ?? ""),
        exc.DoubleCellValue((m['monthlyTarget'] ?? 0).toDouble()),
        exc.DoubleCellValue((m['achieved'] ?? 0).toDouble()),
        exc.TextCellValue((m['isActive'] ?? true) ? "Active" : "Inactive"),
      ]);
    }

    if (kIsWeb) {
      final bytes = excel.save();
      final blob = html.Blob([bytes], 'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet');
      final url = html.Url.createObjectUrlFromBlob(blob);
      html.AnchorElement(href: url)
        ..setAttribute("download", "Team_Export_${DateTime.now().millisecondsSinceEpoch}.xlsx")
        ..click();
      html.Url.revokeObjectUrl(url);
    } else {
      final bytes = excel.save();
      final directory = await getApplicationDocumentsDirectory();
      final file = File('${directory.path}/Team_Export_${DateTime.now().millisecondsSinceEpoch}.xlsx');
      await file.writeAsBytes(bytes!);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Excel saved to: ${file.path}")));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(defaultPadding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader(),
            const SizedBox(height: defaultPadding),
            _buildStats(),
            const SizedBox(height: defaultPadding * 1.5),
            _buildSearchAndFilter(),
            const SizedBox(height: defaultPadding * 1.5),
            _isLoading 
              ? const Center(child: Padding(padding: EdgeInsets.all(50), child: CircularProgressIndicator()))
              : _buildTeamGrid(),
            const SizedBox(height: defaultPadding * 2),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
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
                Text("Team", style: TextStyle(fontSize: isMobile ? 24 : 28, fontWeight: FontWeight.bold, color: textPrimaryColor)),
                const SizedBox(height: 4),
                Text(isMobile ? "Team management" : "Sales team management & performance", style: TextStyle(fontSize: isMobile ? 12 : 14, color: textSecondaryColor, fontWeight: FontWeight.w500)),
              ],
            ),
            if (!isMobile)
              Row(
                children: [
                  _buildHeaderButton(icon: Icons.file_upload_outlined, label: "Export", onPressed: _exportToExcel, isOutlined: true),
                  const SizedBox(width: 12),
                  _buildHeaderButton(icon: Icons.add_rounded, label: "Add Member", onPressed: () => _navigateToAdd(context), isOutlined: false),
                ],
              ),
          ],
        ),
        if (isMobile) ...[
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(child: _buildHeaderButton(icon: Icons.add_rounded, label: "Add Member", onPressed: () => _navigateToAdd(context), isOutlined: false)),
              const SizedBox(width: 12),
              Expanded(child: _buildHeaderButton(icon: Icons.file_upload_outlined, label: "Export", onPressed: _exportToExcel, isOutlined: true)),
            ],
          ),
        ],
      ],
    );
  }

  void _navigateToAdd(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (context) => const AddMemberScreen()),
    ).then((_) => _fetchMembers());
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
      decoration: BoxDecoration(color: const Color(0xFF1E293B), borderRadius: BorderRadius.circular(10)),
      child: ElevatedButton.icon(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(backgroundColor: Colors.transparent, shadowColor: Colors.transparent, foregroundColor: Colors.white, padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))),
        icon: Icon(icon, size: 20),
        label: Text(label, style: const TextStyle(fontWeight: FontWeight.bold)),
      ),
    );
  }

  Widget _buildStats() {
    bool isMobile = Responsive.isMobile(context);
    List<Widget> stats = [
      _buildStatCard("Total Team", members.length.toString(), Icons.groups_outlined, const Color(0xFF6366F1)),
      _buildStatCard("Super Stockists", members.where((m) => m['role'] == "Super Stockist").length.toString(), Icons.business_rounded, const Color(0xFFA855F7)),
      _buildStatCard("Distributors", members.where((m) => m['role'] == "Distributor").length.toString(), Icons.hub_outlined, const Color(0xFF22C55E)),
      _buildStatCard("Sales Persons", members.where((m) => m['role'] == "Sales Person").length.toString(), Icons.person_pin_rounded, const Color(0xFFF59E0B)),
    ];
    if (isMobile) {
      return SingleChildScrollView(scrollDirection: Axis.horizontal, child: Row(children: stats.map((stat) => Container(width: MediaQuery.of(context).size.width * 0.65, margin: const EdgeInsets.only(right: 16), child: stat)).toList()));
    }
    return GridView.count(shrinkWrap: true, physics: const NeverScrollableScrollPhysics(), crossAxisCount: Responsive.isTablet(context) ? 2 : 4, crossAxisSpacing: defaultPadding, mainAxisSpacing: defaultPadding, childAspectRatio: 2.5, children: stats);
  }

  Widget _buildStatCard(String title, String value, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(color: surfaceColor, borderRadius: BorderRadius.circular(16), boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.02), blurRadius: 10, offset: const Offset(0, 5))]),
      child: Row(
        children: [
          Container(padding: const EdgeInsets.all(12), decoration: BoxDecoration(color: color.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(12)), child: Icon(icon, color: color, size: 24)),
          const SizedBox(width: 16),
          Column(crossAxisAlignment: CrossAxisAlignment.start, mainAxisAlignment: MainAxisAlignment.center, children: [
            Text(value, style: const TextStyle(fontSize: 24, fontWeight: FontWeight.w900, color: textPrimaryColor)),
            Text(title, style: const TextStyle(fontSize: 12, color: textSecondaryColor, fontWeight: FontWeight.w600)),
          ]),
        ],
      ),
    );
  }

  Widget _buildSearchAndFilter() {
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
                decoration: BoxDecoration(color: surfaceColor, borderRadius: BorderRadius.circular(12), border: Border.all(color: textSecondaryColor.withValues(alpha: 0.1))),
                child: TextField(
                  onChanged: (v) { searchQuery = v; _applyFilters(); },
                  decoration: const InputDecoration(hintText: "Search team...", hintStyle: TextStyle(fontSize: 14, color: textSecondaryColor), icon: Icon(Icons.search, size: 20, color: textSecondaryColor), border: InputBorder.none),
                ),
              ),
            ),
            if (!isMobile) ...[
              const SizedBox(width: 16),
              Container(
                height: 48,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                decoration: BoxDecoration(color: surfaceColor, borderRadius: BorderRadius.circular(12), border: Border.all(color: textSecondaryColor.withValues(alpha: 0.1))),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<String>(
                    value: roleFilter,
                    items: ["All Roles", "Admin", "Super Stockist", "Distributor", "Sales Person", "Retailer"]
                        .map((e) => DropdownMenuItem(value: e, child: Text(e, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold))))
                        .toList(),
                    onChanged: (v) { setState(() { roleFilter = v!; _applyFilters(); }); },
                  ),
                ),
              ),
            ],
          ],
        ),
      ],
    );
  }

  Widget _buildTeamGrid() {
    bool isMobile = Responsive.isMobile(context);
    bool isTablet = Responsive.isTablet(context);
    if (filteredMembers.isEmpty) return const Center(child: Padding(padding: EdgeInsets.all(40), child: Text("No team members found", style: TextStyle(color: textSecondaryColor))));
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: isMobile ? 1 : (isTablet ? 2 : 3),
        crossAxisSpacing: defaultPadding,
        mainAxisSpacing: defaultPadding,
        childAspectRatio: isMobile ? 1.8 : 1.4,
      ),
      itemCount: filteredMembers.length,
      itemBuilder: (context, index) => _TeamMemberCard(member: filteredMembers[index], onUpdate: _fetchMembers),
    );
  }
}

class _TeamMemberCard extends StatefulWidget {
  final Map<String, dynamic> member;
  final VoidCallback onUpdate;
  const _TeamMemberCard({required this.member, required this.onUpdate});
  @override
  State<_TeamMemberCard> createState() => _TeamMemberCardState();
}

class _TeamMemberCardState extends State<_TeamMemberCard> {
  bool _isHovered = false;

  Color _getRoleColor(String? role) {
    switch (role) {
      case "Admin": return const Color(0xFF1E293B);
      case "Super Stockist": return const Color(0xFF6C5CE7);
      case "Distributor": return const Color(0xFF3B82F6);
      case "Sales Person": return const Color(0xFFF59E0B);
      case "Retailer": return const Color(0xFF10B981);
      default: return primaryColor;
    }
  }

  @override
  Widget build(BuildContext context) {
    var m = widget.member;
    double target = (m['monthlyTarget'] ?? 0).toDouble();
    double achieved = (m['achieved'] ?? 0).toDouble();
    double progress = target > 0 ? (achieved / target).clamp(0.0, 1.0) : 0.0;
    Color rColor = _getRoleColor(m['role']);
    
    return InkWell(
      onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => TeamMemberDetailsScreen(member: m))).then((_) => widget.onUpdate()),
      child: MouseRegion(
        onEnter: (_) => setState(() => _isHovered = true),
        onExit: (_) => setState(() => _isHovered = false),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: surfaceColor,
            borderRadius: BorderRadius.circular(24),
            border: Border.all(color: _isHovered ? rColor.withValues(alpha: 0.2) : Colors.transparent),
            boxShadow: [
              BoxShadow(
                color: _isHovered ? rColor.withValues(alpha: 0.1) : Colors.black.withValues(alpha: 0.03),
                blurRadius: _isHovered ? 24 : 12,
                offset: _isHovered ? const Offset(0, 10) : const Offset(0, 4),
              )
            ]
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Stack(
                    alignment: Alignment.bottomRight,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(2.5),
                        decoration: BoxDecoration(shape: BoxShape.circle, border: Border.all(color: rColor.withValues(alpha: 0.2), width: 2)),
                        child: CircleAvatar(
                          radius: 28,
                          backgroundColor: rColor.withValues(alpha: 0.1),
                          backgroundImage: m['profileImage'] != null ? NetworkImage(m['profileImage']) : null,
                          child: m['profileImage'] == null 
                            ? Text(m['name']?.substring(0, 1).toUpperCase() ?? "T", style: TextStyle(color: rColor, fontWeight: FontWeight.bold, fontSize: 22)) 
                            : null,
                        ),
                      ),
                      Container(
                        width: 14,
                        height: 14,
                        decoration: BoxDecoration(color: (m['isActive'] ?? true) ? successColor : errorColor, shape: BoxShape.circle, border: Border.all(color: Colors.white, width: 2.5)),
                      ),
                    ],
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(m['name'] ?? "N/A", style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 15, color: textPrimaryColor, letterSpacing: -0.5), overflow: TextOverflow.ellipsis),
                        const SizedBox(height: 6),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                          decoration: BoxDecoration(color: rColor.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(20)),
                          child: Text(m['role'] ?? "Sales Person", style: TextStyle(color: rColor, fontSize: 10, fontWeight: FontWeight.w900, letterSpacing: 0.5)),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              _buildIconInfo(Icons.email_outlined, m['email'] ?? "N/A"),
              const SizedBox(height: 12),
              _buildIconInfo(Icons.phone_iphone_rounded, m['phone'] ?? "N/A"),
              const SizedBox(height: 12),
              _buildIconInfo(Icons.location_on_rounded, m['territory'] ?? "N/A"),
              const SizedBox(height: 12),
              _buildIconInfo(Icons.calendar_today_rounded, m['joiningDate'] != null ? "Joined: ${DateFormat('dd MMM yyyy').format(DateTime.parse(m['joiningDate']))}" : "N/A"),
              const SizedBox(height: 24),
              const Divider(height: 32, thickness: 0.5),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text("Sales Progress", style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: textPrimaryColor)),
                  Text("${(progress * 100).toInt()}%", style: TextStyle(fontSize: 13, fontWeight: FontWeight.w900, color: rColor)),
                ],
              ),
              const SizedBox(height: 10),
              ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: LinearProgressIndicator(
                  value: progress,
                  minHeight: 8,
                  backgroundColor: bgColor,
                  valueColor: AlwaysStoppedAnimation<Color>(rColor.withValues(alpha: 0.8)),
                ),
              ),
              const SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                   RichText(text: TextSpan(style: const TextStyle(fontSize: 11, color: textSecondaryColor), children: [const TextSpan(text: "Got: "), TextSpan(text: "₹$achieved", style: const TextStyle(fontWeight: FontWeight.bold, color: textPrimaryColor))])),
                   RichText(text: TextSpan(style: const TextStyle(fontSize: 11, color: textSecondaryColor), children: [const TextSpan(text: "Target: "), TextSpan(text: "₹$target", style: const TextStyle(fontWeight: FontWeight.bold, color: textPrimaryColor))])),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildIconInfo(IconData icon, String text) => Row(children: [Icon(icon, size: 16, color: textSecondaryColor.withValues(alpha: 0.6)), const SizedBox(width: 10), Expanded(child: Text(text, style: const TextStyle(fontSize: 12, color: textSecondaryColor, fontWeight: FontWeight.w600), overflow: TextOverflow.ellipsis))]);
}
