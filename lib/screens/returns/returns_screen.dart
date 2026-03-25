import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:intl/intl.dart';
import '../../constants.dart';
import '../../responsive.dart';
import 'add_return_screen.dart';

class SalesReturnScreen extends StatefulWidget {
  const SalesReturnScreen({super.key});

  @override
  State<SalesReturnScreen> createState() => _SalesReturnScreenState();
}

class _SalesReturnScreenState extends State<SalesReturnScreen> {
  List<dynamic> _returns = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchReturns();
  }

  Future<void> _fetchReturns() async {
    setState(() => _isLoading = true);
    try {
      final response = await http.get(Uri.parse('$backendUrl/api/returns'));
      if (response.statusCode == 200) {
        setState(() => _returns = jsonDecode(response.body));
      }
    } catch (e) {
      debugPrint("Error fetching returns: $e");
    } finally {
      setState(() => _isLoading = false);
    }
  }

  void _navigateToAdd() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const AddReturnScreen()),
    );
    if (result == true) _fetchReturns();
  }

  void _navigateToEdit(Map<String, dynamic> data) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => AddReturnScreen(returnData: data)),
    );
    if (result == true) _fetchReturns();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: RefreshIndicator(
        onRefresh: _fetchReturns,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(defaultPadding),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const _Header(),
              const SizedBox(height: defaultPadding),
              _ReturnAnalytics(returns: _returns),
              const SizedBox(height: defaultPadding * 1.5),
              _ReasonDistribution(returns: _returns),
              const SizedBox(height: defaultPadding * 1.5),
              _ActionRow(onAdd: _navigateToAdd),
              const SizedBox(height: defaultPadding),
              _isLoading 
                  ? const Center(child: CircularProgressIndicator())
                  : _ReturnTable(returns: _returns, onEdit: _navigateToEdit),
              const SizedBox(height: defaultPadding * 2),
            ],
          ),
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
          "Sales Returns",
          style: TextStyle(fontSize: isMobile ? 24 : 28, fontWeight: FontWeight.bold, color: textPrimaryColor),
        ),
        const SizedBox(height: 4),
        Text(
          "Manage product returns, replacements, and quality claims",
          style: TextStyle(fontSize: isMobile ? 12 : 14, color: textSecondaryColor, fontWeight: FontWeight.w500),
        ),
      ],
    );
  }
}

class _ReturnAnalytics extends StatelessWidget {
  final List<dynamic> returns;
  const _ReturnAnalytics({required this.returns});

  @override
  Widget build(BuildContext context) {
    int replaced = returns.where((r) => r['status'] == 'Replaced').length;
    int refunded = returns.where((r) => r['status'] == 'Refunded').length;
    
    bool isMobile = Responsive.isMobile(context);
    List<Widget> stats = [
      _buildStatCard("Total Returns", returns.length.toString(), Icons.assignment_return_rounded, [const Color(0xFFEF4444), const Color(0xFFF87171)]),
      _buildStatCard("Replaced", replaced.toString(), Icons.cached_rounded, [const Color(0xFF6366F1), const Color(0xFF818CF8)]),
      _buildStatCard("Refunded", refunded.toString(), Icons.account_balance_wallet_rounded, [const Color(0xFFF59E0B), const Color(0xFFFBBF24)]),
      _buildStatCard("Return Rate", "2.4%", Icons.show_chart_rounded, [const Color(0xFF22C55E), const Color(0xFF4ADE80)]),
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

  Widget _buildStatCard(String title, String value, IconData icon, List<Color> colors) {
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

class _ReasonDistribution extends StatelessWidget {
  final List<dynamic> returns;
  const _ReasonDistribution({required this.returns});

  @override
  Widget build(BuildContext context) {
    int total = returns.isEmpty ? 1 : returns.length;
    double expired = returns.where((r) => r['reason'] == 'Expired').length / total;
    double damaged = returns.where((r) => r['reason'] == 'Damaged').length / total;
    double other = returns.where((r) => r['reason'] == 'Wrong Item' || r['reason'] == 'Quality Issue' || r['reason'] == 'Other').length / total;

    bool isMobile = Responsive.isMobile(context);
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
          const Text("Return Reasons", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          const SizedBox(height: 24),
          isMobile 
            ? Column(
                children: [
                  _buildReasonBar("Expired", expired, const Color(0xFFEF4444)),
                  const SizedBox(height: 16),
                  _buildReasonBar("Damaged", damaged, const Color(0xFFF59E0B)),
                  const SizedBox(height: 16),
                  _buildReasonBar("Other Issues", other, const Color(0xFF6366F1)),
                ],
              )
            : Row(
                children: [
                  Expanded(child: _buildReasonBar("Expired", expired, const Color(0xFFEF4444))),
                  const SizedBox(width: 24),
                  Expanded(child: _buildReasonBar("Damaged", damaged, const Color(0xFFF59E0B))),
                  const SizedBox(width: 24),
                  Expanded(child: _buildReasonBar("Other Issues", other, const Color(0xFF6366F1))),
                ],
              ),
        ],
      ),
    );
  }

  Widget _buildReasonBar(String label, double percent, Color color) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(label, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600)),
            Text("${(percent * 100).toInt()}%", style: TextStyle(color: color, fontWeight: FontWeight.bold, fontSize: 12)),
          ],
        ),
        const SizedBox(height: 12),
        SizedBox(
          width: double.infinity,
          height: 6,
          child: Stack(
            children: [
              Container(
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              FractionallySizedBox(
                widthFactor: percent,
                child: Container(
                  decoration: BoxDecoration(
                    color: color,
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _ActionRow extends StatelessWidget {
  final VoidCallback onAdd;
  const _ActionRow({required this.onAdd});

  @override
  Widget build(BuildContext context) {
    bool isMobile = Responsive.isMobile(context);
    return isMobile 
      ? Column(
          children: [
            Container(
              height: 48,
              decoration: BoxDecoration(
                color: surfaceColor,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.grey.withValues(alpha: 0.1)),
              ),
              child: const TextField(
                decoration: InputDecoration(
                  hintText: "Search Return ID, Customer...",
                  prefixIcon: Icon(Icons.search, size: 20),
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.symmetric(vertical: 14),
                ),
              ),
            ),
            const SizedBox(height: 12),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: onAdd,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFEF4444),
                  elevation: 0,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                icon: const Icon(Icons.add_rounded, color: Colors.white),
                label: const Text("Log Return", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
              ),
            ),
          ],
        )
      : Row(
          children: [
            Expanded(
              child: Container(
                height: 48,
                decoration: BoxDecoration(
                  color: surfaceColor,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.grey.withValues(alpha: 0.1)),
                ),
                child: const TextField(
                  decoration: InputDecoration(
                    hintText: "Search Return ID, Customer...",
                    prefixIcon: Icon(Icons.search, size: 20),
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.symmetric(vertical: 14),
                  ),
                ),
              ),
            ),
            const SizedBox(width: 12),
            ElevatedButton.icon(
              onPressed: onAdd,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFEF4444),
                elevation: 0,
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
              icon: const Icon(Icons.add_rounded, color: Colors.white),
              label: const Text("Log Return", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
            ),
          ],
        );
  }
}

class _ReturnTable extends StatelessWidget {
  final List<dynamic> returns;
  final Function(Map<String, dynamic>) onEdit;
  const _ReturnTable({required this.returns, required this.onEdit});

  @override
  Widget build(BuildContext context) {
    bool isMobile = Responsive.isMobile(context);

    if (returns.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(40.0),
          child: Column(
            children: [
              Icon(Icons.assignment_return_outlined, size: 64, color: textSecondaryColor.withValues(alpha: 0.2)),
              const SizedBox(height: 16),
              const Text("No return records found.", style: TextStyle(color: textSecondaryColor, fontWeight: FontWeight.w600)),
            ],
          ),
        ),
      );
    }

    if (isMobile) {
      return ListView.separated(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: returns.length,
        separatorBuilder: (context, index) => const SizedBox(height: 12),
        itemBuilder: (context, index) => InkWell(
          onTap: () => onEdit(returns[index]),
          child: _ReturnMobileCard(data: returns[index])),
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
          const _TableHeader(),
          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: returns.length,
            separatorBuilder: (context, index) => Divider(height: 1, color: Colors.grey.withValues(alpha: 0.05)),
            itemBuilder: (context, index) => InkWell(
              onTap: () => onEdit(returns[index]),
              child: _ReturnRow(data: returns[index])),
          ),
        ],
      ),
    );
  }
}

class _ReturnMobileCard extends StatelessWidget {
  final Map<String, dynamic> data;
  const _ReturnMobileCard({required this.data});

  @override
  Widget build(BuildContext context) {
    Color statusColor;
    switch (data["status"]) {
      case "Approved":
      case "Replaced": statusColor = const Color(0xFF22C55E); break;
      case "Pending Inspection": statusColor = const Color(0xFFF59E0B); break;
      default: statusColor = const Color(0xFF64748B);
    }

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: surfaceColor,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 10, offset: const Offset(0, 4))
        ],
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(data["returnId"] ?? "RT-XXXX", style: const TextStyle(fontWeight: FontWeight.bold, color: Color(0xFFEF4444))),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(color: statusColor.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(6)),
                child: Text(data["status"] ?? "Pending", style: TextStyle(color: statusColor, fontSize: 10, fontWeight: FontWeight.bold)),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(data["customerName"] ?? "Unknown", style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
                    const SizedBox(height: 4),
                    Text(data["items"] ?? "-", style: const TextStyle(fontSize: 12, color: textSecondaryColor)),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(color: Colors.grey.withValues(alpha: 0.05), borderRadius: BorderRadius.circular(4)),
                child: Text(data["reason"] ?? "-", style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold)),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                data["returnDate"] != null 
                  ? DateFormat('dd MMM yyyy').format(DateTime.parse(data["returnDate"]))
                  : "-", 
                style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: textSecondaryColor)),
              Icon(Icons.chevron_right_rounded, color: textSecondaryColor.withValues(alpha: 0.5)),
            ],
          ),
        ],
      ),
    );
  }
}

class _TableHeader extends StatelessWidget {
  const _TableHeader();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
      decoration: BoxDecoration(
        color: const Color(0xFFF8FAFC),
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Row(
        children: const [
          Expanded(flex: 2, child: Text("RETURN ID", style: tableHeaderStyle)),
          Expanded(flex: 3, child: Text("CUSTOMER / ITEMS", style: tableHeaderStyle)),
          Expanded(flex: 2, child: Text("REASON", style: tableHeaderStyle)),
          Expanded(flex: 2, child: Text("DATE", style: tableHeaderStyle)),
          Expanded(flex: 2, child: Text("STATUS", style: tableHeaderStyle)),
        ],
      ),
    );
  }
}

class _ReturnRow extends StatelessWidget {
  final Map<String, dynamic> data;
  const _ReturnRow({required this.data});

  @override
  Widget build(BuildContext context) {
    Color statusColor;
    switch (data["status"]) {
      case "Approved":
      case "Replaced": statusColor = const Color(0xFF22C55E); break;
      case "Pending Inspection": statusColor = const Color(0xFFF59E0B); break;
      default: statusColor = const Color(0xFF64748B);
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      child: Row(
        children: [
          Expanded(flex: 2, child: Text(data["returnId"] ?? "RT-XXXX", style: const TextStyle(fontWeight: FontWeight.bold, color: Color(0xFFEF4444)))),
          Expanded(flex: 3, child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(data["customerName"] ?? "Unknown", style: const TextStyle(fontWeight: FontWeight.bold)),
              Text(data["items"] ?? "-", style: const TextStyle(fontSize: 10, color: textSecondaryColor)),
            ],
          )),
          Expanded(flex: 2, child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(color: Colors.grey.withValues(alpha: 0.05), borderRadius: BorderRadius.circular(6)),
            child: Text(data["reason"] ?? "-", style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w600), textAlign: TextAlign.center),
          )),
          Expanded(flex: 2, child: Text(
            data["returnDate"] != null 
              ? DateFormat('dd MMM yyyy').format(DateTime.parse(data["returnDate"]))
              : "-", 
            style: const TextStyle(fontSize: 12))),
          Expanded(flex: 2, child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(color: statusColor.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(8)),
            child: Text(data["status"] ?? "Pending", style: TextStyle(color: statusColor, fontSize: 11, fontWeight: FontWeight.bold), textAlign: TextAlign.center),
          )),
        ],
      ),
    );
  }
}

const tableHeaderStyle = TextStyle(fontSize: 10, fontWeight: FontWeight.w900, color: Color(0xFF64748B), letterSpacing: 0.5);
