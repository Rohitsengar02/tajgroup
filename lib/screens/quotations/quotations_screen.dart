import 'package:flutter/material.dart';
import '../../constants.dart';
import '../../responsive.dart';
import 'new_quotation_screen.dart';

class QuotationsScreen extends StatelessWidget {
  const QuotationsScreen({super.key});

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
            const _QuotationAnalytics(),
            const SizedBox(height: defaultPadding * 1.5),
            const _QuotationTableActions(),
            const SizedBox(height: defaultPadding),
            const _QuotationsTable(),
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
    return isMobile 
      ? Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Estimates / Quotations",
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: textPrimaryColor),
            ),
            const SizedBox(height: 4),
            Text(
              "Manage and track sales proposals",
              style: TextStyle(fontSize: 13, color: textSecondaryColor, fontWeight: FontWeight.w500),
            ),
            const SizedBox(height: 16),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  _buildHeaderButton(
                    context,
                    "+ New",
                    Icons.add_rounded,
                    primaryColor,
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const NewQuotationScreen()),
                    ),
                  ),
                  const SizedBox(width: 8),
                  _buildHeaderButton(context, "Import", Icons.upload_file_rounded, textSecondaryColor, isOutline: true),
                  const SizedBox(width: 8),
                  _buildHeaderButton(context, "Export", Icons.download_rounded, textSecondaryColor, isOutline: true),
                ],
              ),
            ),
          ],
        )
      : Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Estimates / Quotations",
                  style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: textPrimaryColor),
                ),
                const SizedBox(height: 4),
                Text(
                  "Manage and track sales proposals",
                  style: TextStyle(fontSize: 14, color: textSecondaryColor, fontWeight: FontWeight.w500),
                ),
              ],
            ),
            Row(
              children: [
                _buildHeaderButton(
                  context,
                  "+ New Quotation",
                  Icons.add_rounded,
                  primaryColor,
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const NewQuotationScreen()),
                  ),
                ),
                const SizedBox(width: 12),
                _buildHeaderButton(context, "Import", Icons.upload_file_rounded, textSecondaryColor, isOutline: true),
                const SizedBox(width: 12),
                _buildHeaderButton(context, "Export", Icons.download_rounded, textSecondaryColor, isOutline: true),
              ],
            ),
          ],
        );
  }

  Widget _buildHeaderButton(BuildContext context, String label, IconData icon, Color color, {bool isOutline = false, VoidCallback? onTap}) {
    bool isMobile = Responsive.isMobile(context);
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
          onTap: onTap ?? () {},
          borderRadius: BorderRadius.circular(10),
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: isMobile ? 12 : 16, vertical: 10),
            child: Row(
              children: [
                Icon(icon, color: isOutline ? textPrimaryColor : Colors.white, size: 18),
                const SizedBox(width: 8),
                Text(
                  label,
                  style: TextStyle(
                    color: isOutline ? textPrimaryColor : Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: isMobile ? 12 : 13,
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

class _QuotationAnalytics extends StatelessWidget {
  const _QuotationAnalytics();

  @override
  Widget build(BuildContext context) {
    bool isMobile = Responsive.isMobile(context);
    List<Widget> cards = [
      _buildAnalyticCard("Total Quotes", "124", "12%", Icons.description_outlined, const Color(0xFF6366F1)),
      _buildAnalyticCard("Pending", "45", "5%", Icons.pending_actions_rounded, const Color(0xFFF59E0B)),
      _buildAnalyticCard("Approved", "68", "8%", Icons.check_circle_outline_rounded, const Color(0xFF22C55E)),
      _buildAnalyticCard("Rejected", "11", "2%", Icons.cancel_outlined, const Color(0xFFEF4444)),
      _buildAnalyticCard("Converted", "52", "15%", Icons.swap_horiz_rounded, const Color(0xFFA855F7)),
    ];

    if (isMobile) {
      return SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: cards.map((card) => Container(
            width: MediaQuery.of(context).size.width * 0.42,
            margin: const EdgeInsets.only(right: 12),
            child: card,
          )).toList(),
        ),
      );
    }

    return GridView.count(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: 5,
      crossAxisSpacing: defaultPadding,
      mainAxisSpacing: defaultPadding,
      childAspectRatio: 1.8,
      children: cards,
    );
  }

  Widget _buildAnalyticCard(String title, String value, String percent, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [color, color.withValues(alpha: 0.8)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(color: color.withValues(alpha: 0.3), blurRadius: 10, offset: const Offset(0, 4))
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(color: Colors.white.withValues(alpha: 0.2), borderRadius: BorderRadius.circular(8)),
                child: Icon(icon, color: Colors.white, size: 16),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(color: Colors.white.withValues(alpha: 0.2), borderRadius: BorderRadius.circular(12)),
                child: Row(
                  children: [
                    const Icon(Icons.trending_up, color: Colors.white, size: 10),
                    const SizedBox(width: 2),
                    Text(percent, style: const TextStyle(color: Colors.white, fontSize: 9, fontWeight: FontWeight.bold)),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          FittedBox(
            fit: BoxFit.scaleDown,
            child: Text(value, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w900, color: Colors.white)),
          ),
          Text(title, style: const TextStyle(fontSize: 10, color: Colors.white70, fontWeight: FontWeight.w600), maxLines: 1, overflow: TextOverflow.ellipsis),
        ],
      ),
    );
  }
}

class _QuotationTableActions extends StatelessWidget {
  const _QuotationTableActions();

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
                  hintText: "Search Quotation ID, Customer...",
                  hintStyle: TextStyle(fontSize: 13, color: textSecondaryColor),
                  prefixIcon: Icon(Icons.search, size: 20, color: textSecondaryColor),
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.symmetric(vertical: 14),
                ),
              ),
            ),
            const SizedBox(height: 12),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  _buildFilterChip("Customer", Icons.person_outline),
                  const SizedBox(width: 8),
                  _buildFilterChip("Status", Icons.info_outline),
                  const SizedBox(width: 8),
                  _buildFilterChip("Date", Icons.calendar_today_outlined),
                ],
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
                    hintText: "Search Quotation ID, Customer...",
                    hintStyle: TextStyle(fontSize: 13, color: textSecondaryColor),
                    prefixIcon: Icon(Icons.search, size: 20, color: textSecondaryColor),
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.symmetric(vertical: 14),
                  ),
                ),
              ),
            ),
            const SizedBox(width: 12),
            _buildFilterChip("Customer", Icons.person_outline),
            const SizedBox(width: 8),
            _buildFilterChip("Status", Icons.info_outline),
            const SizedBox(width: 8),
            _buildFilterChip("Date", Icons.calendar_today_outlined),
          ],
        );
  }

  Widget _buildFilterChip(String label, IconData icon) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: surfaceColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.withValues(alpha: 0.1)),
      ),
      child: Row(
        children: [
          Icon(icon, size: 16, color: textSecondaryColor),
          const SizedBox(width: 8),
          Text(label, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: textPrimaryColor)),
          const SizedBox(width: 4),
          const Icon(Icons.keyboard_arrow_down_rounded, size: 16, color: textSecondaryColor),
        ],
      ),
    );
  }
}

class _QuotationsTable extends StatelessWidget {
  const _QuotationsTable();

  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> quotations = [
      {"id": "QT-1023", "customer": "ABC Retail Store", "sales": "Rajesh Kumar", "date": "20 Feb 2026", "expiry": "25 Feb 2026", "amount": "₹12,500", "status": "Pending"},
      {"id": "QT-1024", "customer": "Global Mart", "sales": "Priya Sharma", "date": "21 Feb 2026", "expiry": "26 Feb 2026", "amount": "₹45,200", "status": "Approved"},
      {"id": "QT-1025", "customer": "Sahani General", "sales": "Amit Patel", "date": "22 Feb 2026", "expiry": "27 Feb 2026", "amount": "₹8,900", "status": "Draft"},
      {"id": "QT-1026", "customer": "Metro Traders", "sales": "Neha Singh", "date": "22 Feb 2026", "expiry": "27 Feb 2026", "amount": "₹1,20,000", "status": "Converted"},
      {"id": "QT-1027", "customer": "Elite Distributions", "sales": "Vikram Gupta", "date": "23 Feb 2026", "expiry": "28 Feb 2026", "amount": "₹32,000", "status": "Rejected"},
    ];

    bool isMobile = Responsive.isMobile(context);

    if (isMobile) {
      return ListView.separated(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: quotations.length,
        separatorBuilder: (context, index) => const SizedBox(height: 12),
        itemBuilder: (context, index) {
          return _QuotationMobileCard(quotation: quotations[index]);
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
          // Header
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
            decoration: BoxDecoration(
              color: const Color(0xFFF8FAFC),
              borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
              border: Border(bottom: BorderSide(color: Colors.grey.withValues(alpha: 0.1))),
            ),
            child: Row(
              children: const [
                Expanded(flex: 2, child: Text("QUOTATION ID", style: tableHeaderStyle)),
                Expanded(flex: 3, child: Text("CUSTOMER", style: tableHeaderStyle)),
                Expanded(flex: 2, child: Text("SALESPERSON", style: tableHeaderStyle)),
                Expanded(flex: 2, child: Text("DATE / EXPIRY", style: tableHeaderStyle)),
                Expanded(flex: 2, child: Text("TOTAL AMOUNT", style: tableHeaderStyle)),
                Expanded(flex: 2, child: Text("STATUS", style: tableHeaderStyle)),
                Expanded(flex: 2, child: Text("ACTIONS", style: tableHeaderStyle)),
              ],
            ),
          ),
          // Rows
          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: quotations.length,
            separatorBuilder: (context, index) => Divider(height: 1, color: Colors.grey.withValues(alpha: 0.1)),
            itemBuilder: (context, index) {
              return _QuotationRow(quotation: quotations[index]);
            },
          ),
        ],
      ),
    );
  }
}

class _QuotationMobileCard extends StatelessWidget {
  final Map<String, dynamic> quotation;
  const _QuotationMobileCard({required this.quotation});

  @override
  Widget build(BuildContext context) {
    Color statusColor;
    switch (quotation["status"]) {
      case "Approved": statusColor = const Color(0xFF22C55E); break;
      case "Pending": statusColor = const Color(0xFFF59E0B); break;
      case "Rejected": statusColor = const Color(0xFFEF4444); break;
      case "Converted": statusColor = const Color(0xFF6366F1); break;
      default: statusColor = const Color(0xFF94A3B8);
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
              Text(quotation["id"], style: const TextStyle(fontWeight: FontWeight.bold, color: primaryColor)),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(color: statusColor.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(6)),
                child: Text(quotation["status"], style: TextStyle(color: statusColor, fontSize: 10, fontWeight: FontWeight.bold)),
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
                    Text(quotation["customer"], style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
                    const SizedBox(height: 4),
                    Text("By: ${quotation["sales"]}", style: const TextStyle(fontSize: 12, color: textSecondaryColor)),
                  ],
                ),
              ),
              Text(quotation["amount"], style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 16)),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text("DATE", style: TextStyle(fontSize: 9, fontWeight: FontWeight.bold, color: textSecondaryColor)),
                  Text(quotation["date"], style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600)),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text("EXPIRY", style: TextStyle(fontSize: 9, fontWeight: FontWeight.bold, color: textSecondaryColor)),
                  Text(quotation["expiry"], style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600)),
                ],
              ),
              Row(
                children: [
                  _buildCardAction(Icons.visibility_outlined),
                  const SizedBox(width: 8),
                  _buildCardAction(Icons.edit_outlined),
                  const SizedBox(width: 8),
                  _buildCardAction(Icons.swap_horiz_rounded),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildCardAction(IconData icon) {
    return Container(
      padding: const EdgeInsets.all(6),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Icon(icon, size: 16, color: textPrimaryColor),
    );
  }
}

const tableHeaderStyle = TextStyle(fontSize: 10, fontWeight: FontWeight.w900, color: Color(0xFF64748B), letterSpacing: 0.5);

class _QuotationRow extends StatefulWidget {
  final Map<String, dynamic> quotation;
  const _QuotationRow({required this.quotation});

  @override
  State<_QuotationRow> createState() => _QuotationRowState();
}

class _QuotationRowState extends State<_QuotationRow> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    Color statusColor;
    switch (widget.quotation["status"]) {
      case "Approved": statusColor = const Color(0xFF22C55E); break;
      case "Pending": statusColor = const Color(0xFFF59E0B); break;
      case "Rejected": statusColor = const Color(0xFFEF4444); break;
      case "Converted": statusColor = const Color(0xFF6366F1); break;
      default: statusColor = const Color(0xFF94A3B8);
    }

    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        decoration: BoxDecoration(color: _isHovered ? const Color(0xFFF8FAFC) : Colors.transparent),
        child: Row(
          children: [
            Expanded(flex: 2, child: Text(widget.quotation["id"], style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: primaryColor))),
            Expanded(flex: 3, child: Text(widget.quotation["customer"], style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14))),
            Expanded(flex: 2, child: Text(widget.quotation["sales"], style: const TextStyle(fontSize: 13, color: textSecondaryColor))),
            Expanded(
              flex: 2,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(widget.quotation["date"], style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
                  Text("Exp: ${widget.quotation["expiry"]}", style: const TextStyle(fontSize: 10, color: textSecondaryColor)),
                ],
              ),
            ),
            Expanded(flex: 2, child: Text(widget.quotation["amount"], style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 14))),
            Expanded(
              flex: 2,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(color: statusColor.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(8)),
                child: Text(widget.quotation["status"], style: TextStyle(color: statusColor, fontSize: 11, fontWeight: FontWeight.bold), textAlign: TextAlign.center),
              ),
            ),
            Expanded(
              flex: 2,
              child: Row(
                children: [
                  _buildRowAction(Icons.visibility_outlined, "View"),
                  _buildRowAction(Icons.edit_outlined, "Edit"),
                  _buildRowAction(Icons.swap_horiz_rounded, "Convert"),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRowAction(IconData icon, String tooltip) {
    return Tooltip(
      message: tooltip,
      child: Container(
        margin: const EdgeInsets.only(right: 8),
        padding: const EdgeInsets.all(6),
        decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(8), border: Border.all(color: Colors.grey.withValues(alpha: 0.1))),
        child: Icon(icon, size: 16, color: textSecondaryColor),
      ),
    );
  }
}
