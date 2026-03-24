import 'package:flutter/material.dart';
import '../../constants.dart';
import '../../responsive.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'add_member_screen.dart';

class TeamMemberDetailsScreen extends StatefulWidget {
  final Map<String, dynamic> member;

  const TeamMemberDetailsScreen({super.key, required this.member});

  @override
  State<TeamMemberDetailsScreen> createState() => _TeamMemberDetailsScreenState();
}

class _TeamMemberDetailsScreenState extends State<TeamMemberDetailsScreen> {
  late Map<String, dynamic> _member;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _member = widget.member;
  }

  Future<void> _refreshData() async {
    setState(() => _isLoading = true);
    try {
      final response = await http.get(Uri.parse('$backendUrl/api/team/${_member['_id']}'));
      if (response.statusCode == 200) {
        setState(() {
          _member = jsonDecode(response.body);
        });
      }
    } catch (e) {
      debugPrint("Error fetching member details: $e");
    } finally {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _deleteMember() async {
    bool confirm = await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Delete Member"),
        content: Text("Are you sure you want to delete ${_member['name']}?"),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context, false), child: const Text("Cancel")),
          TextButton(onPressed: () => Navigator.pop(context, true), child: const Text("Delete", style: TextStyle(color: errorColor))),
        ],
      ),
    ) ?? false;

    if (confirm) {
      try {
        final response = await http.delete(Uri.parse('$backendUrl/api/team/${_member['_id']}'));
        if (response.statusCode == 200) {
          if (mounted) Navigator.pop(context, true);
        }
      } catch (e) {
        debugPrint("Error deleting: $e");
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    bool isMobile = Responsive.isMobile(context);
    
    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        title: const Text("Member Details", style: TextStyle(fontWeight: FontWeight.bold, color: textPrimaryColor)),
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, color: textPrimaryColor),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit_note_rounded, color: primaryColor),
            onPressed: () async {
              bool? updated = await Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => AddMemberScreen(member: _member)),
              );
              if (updated == true) _refreshData();
            },
          ),
          IconButton(
            icon: const Icon(Icons.delete_outline_rounded, color: errorColor),
            onPressed: _deleteMember,
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: _isLoading 
        ? const Center(child: CircularProgressIndicator())
        : SingleChildScrollView(
            padding: const EdgeInsets.all(defaultPadding),
            child: Column(
              children: [
                _buildProfileHeader(isMobile),
                const SizedBox(height: 24),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      flex: 2,
                      child: Column(
                        children: [
                          _buildInfoCard("Personal Information", [
                            _buildDetailRow("Email", _member['email'] ?? "N/A", Icons.email_outlined),
                            _buildDetailRow("Phone", _member['phone'] ?? "N/A", Icons.phone_outlined),
                            _buildDetailRow("Join Date", _member['joiningDate'] != null ? DateFormat('dd MMM yyyy').format(DateTime.parse(_member['joiningDate'])) : "N/A", Icons.calendar_today_outlined),
                            _buildDetailRow("Address", _member['address'] ?? "N/A", Icons.location_on_outlined),
                          ]),
                          const SizedBox(height: 24),
                          _buildInfoCard("Performance & Career", [
                            _buildDetailRow("Role", _member['role'] ?? "N/A", Icons.work_outline_rounded),
                            _buildDetailRow("Territory", _member['territory'] ?? "N/A", Icons.map_outlined),
                            _buildDetailRow("Reports To", _member['reportsTo'] ?? "N/A", Icons.supervisor_account_outlined),
                            _buildDetailRow("Commission", "${_member['commission'] ?? 0}%", Icons.percent_rounded),
                          ]),
                        ],
                      ),
                    ),
                    if (!isMobile) const SizedBox(width: 24),
                    if (!isMobile) 
                      Expanded(
                        child: _buildTargetCard(),
                      ),
                  ],
                ),
                if (isMobile) const SizedBox(height: 24),
                if (isMobile) _buildTargetCard(),
                const SizedBox(height: 40),
              ],
            ),
          ),
    );
  }

  Widget _buildProfileHeader(bool isMobile) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.02), blurRadius: 10)],
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: isMobile ? 40 : 50,
            backgroundColor: textPrimaryColor,
            backgroundImage: _member['profileImage'] != null ? NetworkImage(_member['profileImage']) : null,
            child: _member['profileImage'] == null 
              ? Text(_member['name']?.substring(0, 1).toUpperCase() ?? "T", style: TextStyle(color: Colors.white, fontSize: isMobile ? 30 : 40, fontWeight: FontWeight.bold))
              : null,
          ),
          const SizedBox(width: 24),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(_member['name'] ?? "N/A", style: TextStyle(fontSize: isMobile ? 20 : 26, fontWeight: FontWeight.bold, color: textPrimaryColor)),
                const SizedBox(height: 8),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                  decoration: BoxDecoration(
                    color: primaryColor.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(_member['role'] ?? "Salesman", style: const TextStyle(color: primaryColor, fontSize: 13, fontWeight: FontWeight.bold)),
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Icon(Icons.circle, size: 10, color: (_member['isActive'] ?? true) ? successColor : errorColor),
                    const SizedBox(width: 8),
                    Text((_member['isActive'] ?? true) ? "Active Member" : "Inactive", style: TextStyle(color: (_member['isActive'] ?? true) ? successColor : errorColor, fontWeight: FontWeight.w600, fontSize: 13)),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoCard(String title, List<Widget> children) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: textPrimaryColor)),
          const Divider(height: 32),
          ...children,
        ],
      ),
    );
  }

  Widget _buildDetailRow(String label, String value, IconData icon) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(color: bgColor, borderRadius: BorderRadius.circular(10)),
            child: Icon(icon, size: 20, color: textSecondaryColor),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label, style: const TextStyle(fontSize: 12, color: textSecondaryColor, fontWeight: FontWeight.w500)),
                const SizedBox(height: 4),
                Text(value, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: textPrimaryColor)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTargetCard() {
    double target = (_member['monthlyTarget'] ?? 0).toDouble();
    double achieved = (_member['achieved'] ?? 0).toDouble();
    double progress = target > 0 ? (achieved / target).clamp(0.0, 1.0) : 0.0;

    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: textPrimaryColor,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [BoxShadow(color: primaryColor.withValues(alpha: 0.2), blurRadius: 20, offset: const Offset(0, 10))],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text("Monthly Performance", style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
          const SizedBox(height: 32),
          Center(
            child: Stack(
              alignment: Alignment.center,
              children: [
                SizedBox(
                  width: 150,
                  height: 150,
                  child: CircularProgressIndicator(
                    value: progress,
                    strokeWidth: 12,
                    backgroundColor: Colors.white.withValues(alpha: 0.1),
                    valueColor: const AlwaysStoppedAnimation<Color>(Colors.white),
                  ),
                ),
                Column(
                  children: [
                    Text("${(progress * 100).toInt()}%", style: const TextStyle(color: Colors.white, fontSize: 32, fontWeight: FontWeight.w900)),
                    const Text("Achieved", style: TextStyle(color: Colors.white70, fontSize: 12)),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 32),
          _buildPerformanceRow("Target", "₹$target"),
          _buildPerformanceRow("Achieved", "₹$achieved"),
          _buildPerformanceRow("Remaining", "₹${(target - achieved).clamp(0, double.infinity)}"),
        ],
      ),
    );
  }

  Widget _buildPerformanceRow(String label, String val) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(color: Colors.white70, fontSize: 13)),
          Text(val, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 15)),
        ],
      ),
    );
  }
}
