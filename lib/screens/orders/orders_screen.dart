import 'package:flutter/material.dart';
import '../../constants.dart';
import '../../responsive.dart';
import 'order_creation_screen.dart';

class OrdersScreen extends StatefulWidget {
  const OrdersScreen({super.key});

  @override
  State<OrdersScreen> createState() => _OrdersScreenState();
}

class _OrdersScreenState extends State<OrdersScreen> {
  // Initial demo data
  List<Map<String, dynamic>> orders = [
    {"id": "#INV-1020", "date": "Oct 24, 2026", "customer": "Rohit Retailers", "salesPerson": "Rahul Sharma", "type": "B2B", "payment": "Paid", "state": "Delhi", "total": "₹12,450", "status": "Delivered"},
    {"id": "#INV-1021", "date": "Oct 24, 2026", "customer": "Aman General Store", "salesPerson": "Amit Kumar", "type": "B2C", "payment": "Paid", "state": "Mumbai", "total": "₹8,200", "status": "Processing"},
    {"id": "#INV-1022", "date": "Oct 24, 2026", "customer": "Sunny Distributors", "salesPerson": "Rahul Sharma", "type": "B2B", "payment": "Pending", "state": "Delhi", "total": "₹45,000", "status": "Confirmed"},
    {"id": "#INV-1023", "date": "Oct 24, 2026", "customer": "Lucky Mart", "salesPerson": "Rahul Sharma", "type": "B2B", "payment": "Paid", "state": "Bangalore", "total": "₹15,200", "status": "Pending"},
    {"id": "#INV-1024", "date": "Oct 24, 2026", "customer": "Metro Traders", "salesPerson": "Amit Kumar", "type": "B2B", "payment": "Paid", "state": "Delhi", "total": "₹22,100", "status": "Cancelled"},
  ];

  void _addOrder(Map<String, dynamic> newOrder) {
    setState(() {
      orders.insert(0, {
        "id": newOrder["id"],
        "date": newOrder["date"],
        "customer": newOrder["customer"],
        "salesPerson": "Rahul Sharma", // Default for demo
        "type": "B2B", // Default for demo
        "payment": "Paid", // Default for demo
        "state": "Delhi", // Default for demo
        "total": newOrder["total"],
        "status": newOrder["status"],
      });
    });
  }

  void _openCreateOrder(BuildContext context) {
    Navigator.push(
      context,
      PageRouteBuilder(
        opaque: false,
        pageBuilder: (context, _, __) => CreateOrderScreen(
          onOrderCreated: (newOrder) {
            _addOrder(newOrder);
          },
        ),
        transitionsBuilder: (context, animation, _, child) {
          return FadeTransition(opacity: animation, child: child);
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(defaultPadding),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Orders",
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: textPrimaryColor,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    "All sales orders across channels",
                    style: TextStyle(
                      fontSize: 14,
                      color: textSecondaryColor.withValues(alpha: 0.7),
                    ),
                  ),
                ],
              ),
              if (!Responsive.isMobile(context))
                Row(
                  children: [
                    _buildSecondaryButton(Icons.upload_file_outlined, "Import Invoice"),
                    const SizedBox(width: 8),
                    _buildSecondaryButton(Icons.filter_list_rounded, "Filter"),
                    const SizedBox(width: 8),
                    _buildSecondaryButton(Icons.download_outlined, "Export"),
                    const SizedBox(width: 12),
                    _buildPrimaryButton(Icons.add, "New Order", () => _openCreateOrder(context)),
                  ],
                ),
            ],
          ),
          const SizedBox(height: defaultPadding),

          // Order KPI Cards
          OrderKpiSection(totalOrders: orders.length.toString()),

          const SizedBox(height: defaultPadding),

          // Filters / Search Bar for Mobile
          if (Responsive.isMobile(context))
            Padding(
              padding: const EdgeInsets.only(bottom: 16),
              child: Row(
                children: [
                  Expanded(
                    child: _buildSecondaryButton(Icons.filter_list_rounded, "Filter"),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: _buildPrimaryButton(Icons.add, "New Order", () => _openCreateOrder(context)),
                  ),
                ],
              ),
            ),

          // Main Content
          Responsive.isMobile(context) ? _buildOrderCardsList() : _buildOrderTable(),
          
          const SizedBox(height: 80), // Padding for mobile bottom bar
        ],
      ),
    );
  }

  Widget _buildSecondaryButton(IconData icon, String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: surfaceColor,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: textSecondaryColor.withValues(alpha: 0.2)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 18, color: textPrimaryColor),
          const SizedBox(width: 8),
          Text(text, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }

  Widget _buildPrimaryButton(IconData icon, String text, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        decoration: BoxDecoration(
          gradient: primaryGradient,
          borderRadius: BorderRadius.circular(8),
          boxShadow: [
            BoxShadow(
              color: primaryColor.withValues(alpha: 0.3),
              blurRadius: 10,
              offset: const Offset(0, 4),
            )
          ],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 18, color: Colors.white),
            const SizedBox(width: 8),
            Text(
              text,
              style: const TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildOrderTable() {
    final headers = [
      "INVOICE NO.", "DATE", "CUSTOMER", "SALES PERSON", "TYPE", "PAYMENT", "STATE", "TOTAL", "STATUS", "ACTIONS"
    ];

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: surfaceColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: textSecondaryColor.withValues(alpha: 0.05)),
      ),
      child: Column(
        children: [
          // Header
          Container(
            padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
            decoration: BoxDecoration(
              color: textSecondaryColor.withValues(alpha: 0.03),
              borderRadius: const BorderRadius.only(topLeft: Radius.circular(16), topRight: Radius.circular(16)),
            ),
            child: Row(
              children: headers.map((h) => Expanded(
                flex: h == "ACTIONS" ? 1 : 2,
                child: Text(
                  h,
                  style: const TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                    color: textSecondaryColor,
                  ),
                ),
              )).toList(),
            ),
          ),
          
          // Data Rows
          ...orders.map((order) => _buildOrderRow(order)),
        ],
      ),
    );
  }

  Widget _buildOrderRow(Map<String, dynamic> order) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      decoration: BoxDecoration(
        border: Border(bottom: BorderSide(color: textSecondaryColor.withValues(alpha: 0.1))),
      ),
      child: Row(
        children: [
          Expanded(flex: 2, child: Text(order["id"], style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13))),
          Expanded(flex: 2, child: Text(order["date"], style: const TextStyle(fontSize: 13, color: textSecondaryColor))),
          Expanded(flex: 2, child: Text(order["customer"], style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600))),
          Expanded(flex: 2, child: Text(order["salesPerson"], style: const TextStyle(fontSize: 13, color: textSecondaryColor))),
          Expanded(flex: 2, child: Text(order["type"], style: const TextStyle(fontSize: 13))),
          Expanded(flex: 2, child: Text(order["payment"], style: TextStyle(fontSize: 13, color: order["payment"] == "Paid" ? successColor : Colors.amber, fontWeight: FontWeight.bold))),
          Expanded(flex: 2, child: Text(order["state"], style: const TextStyle(fontSize: 13))),
          Expanded(flex: 2, child: Text(order["total"], style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold))),
          Expanded(flex: 2, child: _buildStatusBadge(order["status"])),
          Expanded(flex: 1, child: const Icon(Icons.more_horiz, color: textSecondaryColor)),
        ],
      ),
    );
  }

  Widget _buildOrderCardsList() {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: orders.length,
      itemBuilder: (context, index) => _buildOrderCard(orders[index]),
    );
  }

  Widget _buildOrderCard(Map<String, dynamic> order) {
      return Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: surfaceColor,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 10, offset: const Offset(0, 4))
          ]
        ),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(order["id"], style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                _buildStatusBadge(order["status"]),
              ],
            ),
            const Divider(height: 24),
            Row(
              children: [
                _buildInfoColumn("Date", order["date"]),
                const Spacer(),
                _buildInfoColumn("Customer", order["customer"]),
                const Spacer(),
                _buildInfoColumn("Total", order["total"], isBold: true),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                _buildInfoColumn("Sales Person", order["salesPerson"]),
                const Spacer(),
                const Icon(Icons.location_on_outlined, size: 14, color: textSecondaryColor),
                const SizedBox(width: 4),
                Text(order["state"], style: const TextStyle(fontSize: 12, color: textSecondaryColor)),
                const Spacer(),
                Text(order["type"], style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: primaryColor)),
              ],
            )
          ],
        ),
      );
  }

  Widget _buildInfoColumn(String label, String value, {bool isBold = false}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(color: textSecondaryColor, fontSize: 11)),
        const SizedBox(height: 4),
        Text(value, style: TextStyle(fontWeight: isBold ? FontWeight.bold : FontWeight.w600, fontSize: 13)),
      ],
    );
  }

  Widget _buildStatusBadge(String status) {
    Color color = Colors.grey;
    if (status == "Delivered") color = successColor;
    if (status == "Processing") color = Colors.amber;
    if (status == "Confirmed") color = Colors.blue;
    if (status == "Cancelled") color = errorColor;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        status,
        style: TextStyle(color: color, fontSize: 11, fontWeight: FontWeight.bold),
      ),
    );
  }
}

class OrderKpiSection extends StatelessWidget {
  final String totalOrders;
  const OrderKpiSection({super.key, required this.totalOrders});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        _buildKpiCard("TOTAL ORDERS", totalOrders, Colors.blue),
        const SizedBox(width: 12),
        _buildKpiCard("CONFIRMED", "450", Colors.teal),
        const SizedBox(width: 12),
        _buildKpiCard("PROCESSING", "124", Colors.amber),
        const SizedBox(width: 12),
        _buildKpiCard("DELIVERED", "706", Colors.green),
      ],
    );
  }

  Widget _buildKpiCard(String label, String value, Color color) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: surfaceColor,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: textSecondaryColor.withValues(alpha: 0.05)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.02),
              blurRadius: 10,
              offset: const Offset(0, 5),
            )
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: TextStyle(
                fontSize: 10,
                letterSpacing: 1.2,
                fontWeight: FontWeight.bold,
                color: textSecondaryColor.withValues(alpha: 0.6),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              value,
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: textPrimaryColor,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
