import 'package:flutter/material.dart';
import '../../constants.dart';
import '../../responsive.dart';
import 'new_quotation_screen.dart';
import 'quotation_details_screen.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:intl/intl.dart';
import 'package:excel/excel.dart' as exc;
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'dart:html' as html;

class QuotationsScreen extends StatefulWidget {
  const QuotationsScreen({super.key});

  @override
  State<QuotationsScreen> createState() => _QuotationsScreenState();
}

class _QuotationsScreenState extends State<QuotationsScreen> {
  List<dynamic> quotations = [];
  List<dynamic> filteredQuotations = [];
  bool _isLoading = true;
  String searchQuery = "";
  String statusFilter = "All";
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _fetchQuotations();
  }

  Future<void> _fetchQuotations() async {
    setState(() => _isLoading = true);
    try {
      final response = await http.get(Uri.parse('$backendUrl/api/quotations'));
      if (response.statusCode == 200) {
        setState(() {
          quotations = jsonDecode(response.body);
          _applyFilters();
          _isLoading = false;
        });
      }
    } catch (e) {
      print("Error fetching quotations: $e");
      if (mounted) setState(() => _isLoading = false);
    }
  }

  void _applyFilters() {
    setState(() {
      filteredQuotations = quotations.where((q) {
        final matchesSearch = (q['quotationId'] ?? "").toString().toLowerCase().contains(searchQuery.toLowerCase()) ||
            (q['customerName'] ?? "").toString().toLowerCase().contains(searchQuery.toLowerCase());
        final matchesStatus = statusFilter == "All" || q['status'] == statusFilter;
        return matchesSearch && matchesStatus;
      }).toList();
    });
  }

  Future<void> _exportToExcel() async {
    var excel = exc.Excel.createExcel();
    exc.Sheet sheetObject = excel['Quotations'];
    excel.delete('Sheet1');

    sheetObject.appendRow([
      exc.TextCellValue("Quotation ID"),
      exc.TextCellValue("Date"),
      exc.TextCellValue("Customer"),
      exc.TextCellValue("Type"),
      exc.TextCellValue("Sales Person"),
      exc.TextCellValue("Valid Until"),
      exc.TextCellValue("Billing Address"),
      exc.TextCellValue("Shipping Address"),
      exc.TextCellValue("State of Supply"),
      exc.TextCellValue("Delivery Location"),
      exc.TextCellValue("Total Amount"),
      exc.TextCellValue("Status")
    ]);

    for (var q in filteredQuotations) {
      sheetObject.appendRow([
        exc.TextCellValue(q['quotationId'] ?? ""),
        exc.TextCellValue(q['quotationDate'] != null ? DateFormat('yyyy-MM-dd').format(DateTime.parse(q['quotationDate'])) : ""),
        exc.TextCellValue(q['customerName'] ?? ""),
        exc.TextCellValue(q['quotationType'] ?? ""),
        exc.TextCellValue(q['salesPerson'] ?? ""),
        exc.TextCellValue(q['validUntil'] != null ? DateFormat('yyyy-MM-dd').format(DateTime.parse(q['validUntil'])) : ""),
        exc.TextCellValue(q['billingAddress'] ?? ""),
        exc.TextCellValue(q['shippingAddress'] ?? ""),
        exc.TextCellValue(q['stateOfSupply'] ?? ""),
        exc.TextCellValue(q['deliveryLocation'] ?? ""),
        exc.DoubleCellValue(double.tryParse(q['totalAmount']?.toString() ?? "0") ?? 0),
        exc.TextCellValue(q['status'] ?? ""),
      ]);
    }

    if (kIsWeb) {
      final bytes = excel.save();
      final blob = html.Blob([bytes], 'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet');
      final url = html.Url.createObjectUrlFromBlob(blob);
      html.AnchorElement(href: url)
        ..setAttribute("download", "Quotations_Export_${DateTime.now().millisecondsSinceEpoch}.xlsx")
        ..click();
      html.Url.revokeObjectUrl(url);
    } else {
      final bytes = excel.save();
      final directory = await getApplicationDocumentsDirectory();
      final file = File('${directory.path}/Quotations_Export_${DateTime.now().millisecondsSinceEpoch}.xlsx');
      await file.writeAsBytes(bytes!);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Excel saved to: ${file.path}")));
      }
    }
  }

  void _openCreateQuotation(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const NewQuotationScreen()),
    ).then((_) => _fetchQuotations());
  }

  void _openDetails(Map<String, dynamic> quotation) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => QuotationDetailsScreen(quotation: quotation)),
    ).then((_) => _fetchQuotations());
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(defaultPadding),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHeader(),
          const SizedBox(height: defaultPadding),
          _buildStats(),
          const SizedBox(height: defaultPadding),
          _isLoading 
            ? const Center(child: CircularProgressIndicator()) 
            : _buildQuotationsTable(),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Quotations", style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: textPrimaryColor)),
            Text("Manage customer estimations", style: TextStyle(fontSize: 14, color: textSecondaryColor)),
          ],
        ),
        if (!Responsive.isMobile(context))
          Expanded(
            child: Row(
              children: [
                const SizedBox(width: 40),
                Expanded(
                  child: Container(
                    height: 42,
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    decoration: BoxDecoration(
                      color: surfaceColor,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: textSecondaryColor.withValues(alpha: 0.2)),
                    ),
                    child: TextField(
                      controller: _searchController,
                      onChanged: (v) {
                        searchQuery = v;
                        _applyFilters();
                      },
                      decoration: const InputDecoration(
                        icon: Icon(Icons.search, size: 18),
                        hintText: "Search Quotation...",
                        border: InputBorder.none,
                        isDense: true,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                _buildFilterDropdown(),
                const SizedBox(width: 8),
                _buildActionButton(Icons.download_outlined, "Export", _exportToExcel, isPrimary: false),
                const SizedBox(width: 12),
                _buildActionButton(Icons.add, "New Quotation", () => _openCreateQuotation(context), isPrimary: true),
              ],
            ),
          ),
      ],
    );
  }

  Widget _buildFilterDropdown() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        color: surfaceColor,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: textSecondaryColor.withValues(alpha: 0.2)),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: statusFilter,
          items: ["All", "Draft", "Sent", "Accepted", "Rejected", "Expired"].map((s) => DropdownMenuItem(
            value: s,
            child: Text(s, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold)),
          )).toList(),
          onChanged: (v) {
            setState(() {
              statusFilter = v!;
              _applyFilters();
            });
          },
        ),
      ),
    );
  }

  Widget _buildActionButton(IconData icon, String text, VoidCallback onTap, {required bool isPrimary}) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        decoration: BoxDecoration(
          color: isPrimary ? null : surfaceColor,
          gradient: isPrimary ? primaryGradient : null,
          borderRadius: BorderRadius.circular(8),
          border: isPrimary ? null : Border.all(color: textSecondaryColor.withValues(alpha: 0.2)),
          boxShadow: isPrimary ? [BoxShadow(color: primaryColor.withValues(alpha: 0.3), blurRadius: 10, offset: const Offset(0, 4))] : null,
        ),
        child: Row(
          children: [
            Icon(icon, size: 18, color: isPrimary ? Colors.white : textPrimaryColor),
            const SizedBox(width: 8),
            Text(text, style: TextStyle(color: isPrimary ? Colors.white : textPrimaryColor, fontSize: 13, fontWeight: FontWeight.bold)),
          ],
        ),
      ),
    );
  }

  Widget _buildStats() {
    bool isMobile = Responsive.isMobile(context);
    List<Widget> cards = [
      _buildStatCard("TOTAL", quotations.length.toString(), Colors.blue, isMobile),
      _buildStatCard("ACCEPTED", quotations.where((q) => q['status'] == "Accepted").length.toString(), Colors.teal, isMobile),
      _buildStatCard("SENT", quotations.where((q) => q['status'] == "Sent").length.toString(), Colors.amber, isMobile),
      _buildStatCard("DRAFT", quotations.where((q) => q['status'] == "Draft").length.toString(), Colors.grey, isMobile),
    ];

    if (isMobile) {
      return SingleChildScrollView(scrollDirection: Axis.horizontal, child: Row(children: cards.expand((w) => [w, const SizedBox(width: 12)]).toList()));
    }
    return Row(children: cards.expand((w) => [Expanded(child: w), const SizedBox(width: 12)]).toList()..removeLast());
  }

  Widget _buildStatCard(String label, String value, Color color, bool isMobile) {
    return Container(
      width: isMobile ? 150 : null,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: surfaceColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: textSecondaryColor.withValues(alpha: 0.05)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: TextStyle(fontSize: 10, letterSpacing: 1.2, fontWeight: FontWeight.bold, color: color)),
          const SizedBox(height: 8),
          Text(value, style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: textPrimaryColor)),
        ],
      ),
    );
  }

  Widget _buildQuotationsTable() {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: surfaceColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: textSecondaryColor.withValues(alpha: 0.05)),
      ),
      child: Column(
        children: [
          _buildTableHeader(),
          ...filteredQuotations.map((q) => _buildTableRow(q as Map<String, dynamic>)),
        ],
      ),
    );
  }

  Widget _buildTableHeader() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
      decoration: BoxDecoration(color: textSecondaryColor.withValues(alpha: 0.03), borderRadius: const BorderRadius.only(topLeft: Radius.circular(16), topRight: Radius.circular(16))),
      child: const Row(
        children: [
          Expanded(flex: 2, child: _HeaderText("ID")),
          Expanded(flex: 3, child: _HeaderText("CUSTOMER")),
          Expanded(flex: 2, child: _HeaderText("DATE")),
          Expanded(flex: 2, child: _HeaderText("AMOUNT")),
          Expanded(flex: 2, child: _HeaderText("STATUS")),
          Expanded(flex: 1, child: _HeaderText("")),
        ],
      ),
    );
  }

  Widget _buildTableRow(Map<String, dynamic> q) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      decoration: BoxDecoration(border: Border(bottom: BorderSide(color: textSecondaryColor.withValues(alpha: 0.05)))),
      child: Row(
        children: [
          Expanded(flex: 2, child: Text(q['quotationId'] ?? "N/A", style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13))),
          Expanded(flex: 3, child: Text(q['customerName'] ?? "N/A", style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13))),
          Expanded(flex: 2, child: Text(q['quotationDate'] != null ? DateFormat('dd MMM yyyy').format(DateTime.parse(q['quotationDate'])) : "N/A", style: const TextStyle(fontSize: 12, color: textSecondaryColor))),
          Expanded(flex: 2, child: Text("₹${q['totalAmount']}", style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13))),
          Expanded(flex: 2, child: _buildStatusBadge(q['status'] ?? "Draft")),
          Expanded(flex: 1, child: IconButton(icon: const Icon(Icons.arrow_forward_ios_rounded, size: 14), onPressed: () => _openDetails(q))),
        ],
      ),
    );
  }

  Widget _buildStatusBadge(String status) {
    Color color = Colors.grey;
    if (status == "Accepted") color = successColor;
    if (status == "Sent") color = Colors.amber;
    if (status == "Rejected") color = errorColor;
    
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(color: color.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(20)),
      child: Text(status, style: TextStyle(color: color, fontSize: 10, fontWeight: FontWeight.bold)),
    );
  }
}

class _HeaderText extends StatelessWidget {
  final String text;
  const _HeaderText(this.text);
  @override
  Widget build(BuildContext context) {
    return Text(text, style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: textSecondaryColor));
  }
}
