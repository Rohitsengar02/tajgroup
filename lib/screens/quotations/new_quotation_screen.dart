import 'package:flutter/material.dart';
import '../../constants.dart';
import '../../responsive.dart';

class NewQuotationScreen extends StatefulWidget {
  const NewQuotationScreen({super.key});

  @override
  State<NewQuotationScreen> createState() => _NewQuotationScreenState();
}

class _NewQuotationScreenState extends State<NewQuotationScreen> {
  final List<Map<String, dynamic>> _items = [
    {"product": "Taj Premium Tea 500g", "batch": "BT-992", "mrp": "250", "qty": "10", "unit": "Box", "price": "220", "discount": "5", "tax": "12", "total": "2100"},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.close_rounded, color: textPrimaryColor),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text("Create New Quotation", style: TextStyle(color: textPrimaryColor, fontWeight: FontWeight.bold)),
        actions: [
          _buildAppBarAction("Draft", Icons.save_outlined),
          const SizedBox(width: 12),
          _buildAppBarAction("Convert to Order", Icons.swap_horiz_rounded, isPrimary: true),
          const SizedBox(width: 16),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(defaultPadding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  flex: 3,
                  child: Column(
                    children: [
                      _buildFormSection("Basic Information", [
                        _Row([
                          _Field(label: "Quotation #", value: "QT-1028", isReadOnly: true),
                          _Field(label: "Salesperson", value: "Rajesh Kumar"),
                        ]),
                        const SizedBox(height: 16),
                        _Row([
                          _Field(label: "Quotation Date", value: "2026-03-06", icon: Icons.calendar_today_rounded),
                          _Field(label: "Expiry Date", value: "2026-03-13", icon: Icons.event_available_rounded),
                        ]),
                        const SizedBox(height: 16),
                        _Row([
                          _Field(label: "Payment Terms", value: "Net 30 Days"),
                          _Field(label: "Delivery Location", value: "Primary Warehouse"),
                        ]),
                      ]),
                      const SizedBox(height: 24),
                      _buildFormSection("Customer Information", [
                        _Row([
                          _Field(label: "Customer Name", value: "ABC Retail Store", icon: Icons.person_search_rounded),
                          _Field(label: "Shop Name", value: "ABC Mega Mart"),
                        ]),
                        const SizedBox(height: 16),
                        _Row([
                          _Field(label: "GST Number", value: "27AAACR1234A1Z1"),
                          _Field(label: "Phone", value: "+91 98765 43210"),
                        ]),
                        const SizedBox(height: 16),
                        _Field(label: "Address", value: "123, Commercial Lane, Downtown Area, Mumbai - 400001"),
                      ]),
                      const SizedBox(height: 24),
                      _buildProductTable(),
                    ],
                  ),
                ),
                if (!Responsive.isMobile(context)) const SizedBox(width: 24),
                if (!Responsive.isMobile(context))
                  Expanded(
                    flex: 1,
                    child: Column(
                      children: [
                        _buildPriceSummary(),
                        const SizedBox(height: 24),
                        _buildNotesSection(),
                        const SizedBox(height: 24),
                        _buildActivityTimeline(),
                      ],
                    ),
                  ),
              ],
            ),
            if (Responsive.isMobile(context)) ...[
              const SizedBox(height: 24),
              _buildPriceSummary(),
              const SizedBox(height: 24),
              _buildNotesSection(),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildAppBarAction(String label, IconData icon, {bool isPrimary = false}) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8),
      decoration: BoxDecoration(
        color: isPrimary ? primaryColor : Colors.white,
        borderRadius: BorderRadius.circular(10),
        border: isPrimary ? null : Border.all(color: Colors.grey.withValues(alpha: 0.2)),
        boxShadow: isPrimary ? [
          BoxShadow(color: primaryColor.withValues(alpha: 0.3), blurRadius: 8, offset: const Offset(0, 4))
        ] : null,
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () {},
          borderRadius: BorderRadius.circular(10),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: [
                Icon(icon, color: isPrimary ? Colors.white : textPrimaryColor, size: 18),
                const SizedBox(width: 8),
                Text(label, style: TextStyle(color: isPrimary ? Colors.white : textPrimaryColor, fontWeight: FontWeight.bold, fontSize: 13)),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildFormSection(String title, List<Widget> children) {
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
          Text(title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: textPrimaryColor)),
          const SizedBox(height: 24),
          ...children,
        ],
      ),
    );
  }

  Widget _buildProductTable() {
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
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text("Product Selection", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: textPrimaryColor)),
              ElevatedButton.icon(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  backgroundColor: primaryColor.withValues(alpha: 0.1),
                  foregroundColor: primaryColor,
                  elevation: 0,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                ),
                icon: const Icon(Icons.add_rounded, size: 18),
                label: const Text("Add Product", style: TextStyle(fontWeight: FontWeight.bold)),
              ),
            ],
          ),
          const SizedBox(height: 24),
          _buildTableHeader(),
          const Divider(),
          ...List.generate(_items.length, (index) => _buildProductRow(index)),
        ],
      ),
    );
  }

  Widget _buildTableHeader() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: const [
          Expanded(flex: 3, child: Text("PRODUCT", style: tableHeaderStyle)),
          Expanded(flex: 1, child: Text("QTY", style: tableHeaderStyle)),
          Expanded(flex: 1, child: Text("PRICE", style: tableHeaderStyle)),
          Expanded(flex: 1, child: Text("TAX", style: tableHeaderStyle)),
          Expanded(flex: 1, child: Text("TOTAL", style: tableHeaderStyle)),
          SizedBox(width: 40),
        ],
      ),
    );
  }

  Widget _buildProductRow(int index) {
    final item = _items[index];
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Row(
        children: [
          Expanded(
            flex: 3,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(item["product"], style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                Text("Batch: ${item["batch"]}", style: const TextStyle(fontSize: 10, color: textSecondaryColor)),
              ],
            ),
          ),
          Expanded(flex: 1, child: Text("${item["qty"]} ${item["unit"]}", style: const TextStyle(fontWeight: FontWeight.bold))),
          Expanded(flex: 1, child: Text("₹${item["price"]}", style: const TextStyle(fontWeight: FontWeight.bold))),
          Expanded(flex: 1, child: Text("${item["tax"]}%", style: const TextStyle(color: textSecondaryColor, fontWeight: FontWeight.w600))),
          Expanded(flex: 1, child: Text("₹${item["total"]}", style: const TextStyle(fontWeight: FontWeight.bold, color: primaryColor))),
          IconButton(onPressed: () {}, icon: const Icon(Icons.delete_outline, color: Colors.red, size: 20)),
        ],
      ),
    );
  }

  Widget _buildPriceSummary() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: const LinearGradient(colors: [Color(0xFF6366F1), Color(0xFFA855F7)], begin: Alignment.topLeft, end: Alignment.bottomRight),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(color: const Color(0xFF6366F1).withValues(alpha: 0.3), blurRadius: 15, offset: const Offset(0, 8))
        ],
      ),
      child: Column(
        children: [
          _SummaryRow("Subtotal", "₹12,450", isBold: false),
          _SummaryRow("Discount", "-₹450", isBold: false),
          _SummaryRow("Tax (GST)", "+₹1,240", isBold: false),
          const Divider(color: Colors.white24, height: 32),
          _SummaryRow("Total Amount", "₹13,240", isTotal: true),
          const SizedBox(height: 24),
          _buildSummaryAction("Download PDF", Icons.picture_as_pdf_outlined),
          const SizedBox(height: 12),
          _buildSummaryAction("Send to Customer", Icons.send_rounded, isWhite: false),
        ],
      ),
    );
  }

  Widget _buildSummaryAction(String label, IconData icon, {bool isWhite = true}) {
    return Container(
      width: double.infinity,
      height: 48,
      decoration: BoxDecoration(
        color: isWhite ? Colors.white : Colors.white.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () {},
          borderRadius: BorderRadius.circular(12),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, color: isWhite ? primaryColor : Colors.white, size: 18),
              const SizedBox(width: 8),
              Text(label, style: TextStyle(color: isWhite ? primaryColor : Colors.white, fontWeight: FontWeight.bold)),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNotesSection() {
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
        children: const [
          Text("Notes & Terms", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: textPrimaryColor)),
          SizedBox(height: 16),
          _Field(label: "Internal Notes", value: "Customer requested pricing breakdown for next quarter.", maxLines: 2),
          SizedBox(height: 16),
          _Field(label: "Terms & Conditions", value: "1. Quotation valid for 7 days.\n2. Delivery within 3 business days of order confirmation.", maxLines: 3),
        ],
      ),
    );
  }

  Widget _buildActivityTimeline() {
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
          const Text("Activity Timeline", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: textPrimaryColor)),
          const SizedBox(height: 20),
          _buildTimelineItem("Quotation Draft Created", "Today, 10:45 AM", "Rajesh Kumar", true),
          _buildTimelineItem("Sent to Customer", "Pending", "-", false),
        ],
      ),
    );
  }

  Widget _buildTimelineItem(String title, String time, String user, bool isDone) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Column(
          children: [
            Container(width: 12, height: 12, decoration: BoxDecoration(color: isDone ? primaryColor : Colors.grey.withValues(alpha: 0.3), shape: BoxShape.circle)),
            Container(width: 2, height: 40, color: Colors.grey.withValues(alpha: 0.1)),
          ],
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
              Text("$time • $user", style: const TextStyle(fontSize: 11, color: textSecondaryColor)),
            ],
          ),
        ),
      ],
    );
  }
}

class _Row extends StatelessWidget {
  final List<Widget> children;
  const _Row(this.children);
  @override
  Widget build(BuildContext context) {
    return Row(children: children.expand((w) => [Expanded(child: w), const SizedBox(width: 16)]).toList()..removeLast());
  }
}

class _Field extends StatelessWidget {
  final String label, value;
  final bool isReadOnly;
  final IconData? icon;
  final int maxLines;
  const _Field({required this.label, required this.value, this.isReadOnly = false, this.icon, this.maxLines = 1});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: textSecondaryColor)),
        const SizedBox(height: 8),
        Container(
          height: maxLines == 1 ? 48 : null,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: BoxDecoration(color: const Color(0xFFF8FAFC), borderRadius: BorderRadius.circular(12)),
          child: Row(
            children: [
              if (icon != null) ...[Icon(icon, size: 16, color: textSecondaryColor), const SizedBox(width: 12)],
              Expanded(child: Text(value, style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: isReadOnly ? textSecondaryColor : textPrimaryColor))),
            ],
          ),
        ),
      ],
    );
  }
}

class _SummaryRow extends StatelessWidget {
  final String label, value;
  final bool isBold, isTotal;
  const _SummaryRow(this.label, this.value, {this.isBold = true, this.isTotal = false});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: TextStyle(color: isTotal ? Colors.white : Colors.white70, fontSize: isTotal ? 16 : 14, fontWeight: isTotal ? FontWeight.w900 : FontWeight.w500)),
          Text(value, style: TextStyle(color: Colors.white, fontSize: isTotal ? 22 : 14, fontWeight: FontWeight.w900)),
        ],
      ),
    );
  }
}
const tableHeaderStyle = TextStyle(fontSize: 10, fontWeight: FontWeight.w900, color: Color(0xFF64748B), letterSpacing: 0.5);
