import 'package:flutter/material.dart';
import '../../constants.dart';
import '../../responsive.dart';

class PaymentsScreen extends StatelessWidget {
  const PaymentsScreen({super.key});

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
            const _PaymentAnalytics(),
            const SizedBox(height: defaultPadding * 1.5),
            const _PaymentMethods(),
            const SizedBox(height: defaultPadding * 1.5),
            const _TransactionTable(),
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
        Text(
          "Payments & Collections",
          style: TextStyle(fontSize: isMobile ? 24 : 28, fontWeight: FontWeight.bold, color: textPrimaryColor),
        ),
        const SizedBox(height: 4),
        Text(
          "Track incoming revenue and collection efficiency",
          style: TextStyle(fontSize: isMobile ? 13 : 14, color: textSecondaryColor, fontWeight: FontWeight.w500),
        ),
      ],
    );
  }
}

class _PaymentAnalytics extends StatelessWidget {
  const _PaymentAnalytics();

  @override
  Widget build(BuildContext context) {
    bool isMobile = Responsive.isMobile(context);
    List<Widget> stats = [
      _buildStatCard("Total Received", "₹42.8L", Icons.payments_rounded, [const Color(0xFF22C55E), const Color(0xFF4ADE80)]),
      _buildStatCard("Outstanding", "₹5.2L", Icons.pending_actions_rounded, [const Color(0xFFEF4444), const Color(0xFFF87171)]),
      _buildStatCard("Pending Clear", "₹1.4L", Icons.hourglass_empty_rounded, [const Color(0xFFF59E0B), const Color(0xFFFBBF24)]),
      _buildStatCard("Collection %", "89%", Icons.show_chart_rounded, [const Color(0xFF6366F1), const Color(0xFF818CF8)]),
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

class _PaymentMethods extends StatelessWidget {
  const _PaymentMethods();

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          _buildMethodCard("Bank Transfer", "₹22.4L", "52%", Icons.account_balance_rounded, const Color(0xFF6366F1)),
          const SizedBox(width: 16),
          _buildMethodCard("UPI / Digital", "₹12.2L", "28%", Icons.qr_code_scanner_rounded, const Color(0xFFA855F7)),
          const SizedBox(width: 16),
          _buildMethodCard("Cash Collection", "₹8.2L", "20%", Icons.account_balance_wallet_rounded, const Color(0xFF22C55E)),
        ],
      ),
    );
  }

  Widget _buildMethodCard(String title, String value, String share, IconData icon, Color color) {
    return Container(
      width: 220,
      padding: const EdgeInsets.all(20),
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
              Container(padding: const EdgeInsets.all(8), decoration: BoxDecoration(color: color.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(10)), child: Icon(icon, color: color, size: 20)),
              Text(share, style: TextStyle(color: color, fontWeight: FontWeight.bold, fontSize: 13)),
            ],
          ),
          const SizedBox(height: 16),
          Text(title, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: textPrimaryColor)),
          const SizedBox(height: 4),
          Text(value, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w900, color: textPrimaryColor)),
        ],
      ),
    );
  }
}

class _TransactionTable extends StatelessWidget {
  const _TransactionTable();

  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> transactions = [
      {"id": "TX-4401", "customer": "ABC Retail Store", "method": "UPI", "date": "05 Mar 2026", "amount": "₹12,450", "status": "Success"},
      {"id": "TX-4402", "customer": "Global Mart", "method": "Bank", "date": "04 Mar 2026", "amount": "₹45,200", "status": "Success"},
      {"id": "TX-4403", "customer": "Priya General", "method": "Cash", "date": "04 Mar 2026", "amount": "₹2,500", "status": "Pending"},
    ];

    bool isMobile = Responsive.isMobile(context);

    if (isMobile) {
      return ListView.separated(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: transactions.length,
        separatorBuilder: (context, index) => const SizedBox(height: 12),
        itemBuilder: (context, index) => _TransactionMobileCard(data: transactions[index]),
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
            itemCount: transactions.length,
            separatorBuilder: (context, index) => Divider(height: 1, color: Colors.grey.withValues(alpha: 0.05)),
            itemBuilder: (context, index) => _TransactionRow(data: transactions[index]),
          ),
        ],
      ),
    );
  }
}

class _TransactionMobileCard extends StatelessWidget {
  final Map<String, dynamic> data;
  const _TransactionMobileCard({required this.data});

  @override
  Widget build(BuildContext context) {
    Color statusColor = data["status"] == "Success" ? const Color(0xFF22C55E) : const Color(0xFFF59E0B);

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
              Text(data["id"], style: const TextStyle(fontWeight: FontWeight.bold, color: primaryColor)),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(color: statusColor.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(8)),
                child: Text(data["status"], style: TextStyle(color: statusColor, fontSize: 10, fontWeight: FontWeight.bold)),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(data["customer"], style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
                    const SizedBox(height: 4),
                    Text("Method: ${data["method"]}", style: const TextStyle(fontSize: 12, color: textSecondaryColor, fontWeight: FontWeight.w600)),
                  ],
                ),
              ),
              Text(data["amount"], style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 16)),
            ],
          ),
          const SizedBox(height: 12),
          Align(
            alignment: Alignment.centerLeft,
            child: Text(data["date"], style: const TextStyle(fontSize: 11, color: textSecondaryColor, fontWeight: FontWeight.bold)),
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
          Expanded(flex: 2, child: Text("TRANS ID", style: tableHeaderStyle)),
          Expanded(flex: 3, child: Text("CUSTOMER", style: tableHeaderStyle)),
          Expanded(flex: 2, child: Text("METHOD", style: tableHeaderStyle)),
          Expanded(flex: 2, child: Text("DATE", style: tableHeaderStyle)),
          Expanded(flex: 2, child: Text("AMOUNT", style: tableHeaderStyle)),
          Expanded(flex: 2, child: Text("STATUS", style: tableHeaderStyle)),
        ],
      ),
    );
  }
}

class _TransactionRow extends StatelessWidget {
  final Map<String, dynamic> data;
  const _TransactionRow({required this.data});

  @override
  Widget build(BuildContext context) {
    Color statusColor = data["status"] == "Success" ? const Color(0xFF22C55E) : const Color(0xFFF59E0B);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      child: Row(
        children: [
          Expanded(flex: 2, child: Text(data["id"], style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: primaryColor))),
          Expanded(flex: 3, child: Text(data["customer"], style: const TextStyle(fontWeight: FontWeight.bold))),
          Expanded(flex: 2, child: Text(data["method"], style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600))),
          Expanded(flex: 2, child: Text(data["date"], style: const TextStyle(fontSize: 13))),
          Expanded(flex: 2, child: Text(data["amount"], style: const TextStyle(fontWeight: FontWeight.w900, color: textPrimaryColor))),
          Expanded(flex: 2, child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(color: statusColor.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(8)),
            child: Text(data["status"], style: TextStyle(color: statusColor, fontSize: 11, fontWeight: FontWeight.bold), textAlign: TextAlign.center),
          )),
        ],
      ),
    );
  }
}

const tableHeaderStyle = TextStyle(fontSize: 10, fontWeight: FontWeight.w900, color: Color(0xFF64748B), letterSpacing: 0.5);
