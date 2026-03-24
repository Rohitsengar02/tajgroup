import 'package:flutter/material.dart';
import '../../constants.dart';
import '../../responsive.dart';
import 'order_creation_screen.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:intl/intl.dart';
import 'order_details_screen.dart';
import 'package:excel/excel.dart' as exc;
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'dart:html' as html;

class OrdersScreen extends StatefulWidget {
  const OrdersScreen({super.key});

  @override
  State<OrdersScreen> createState() => _OrdersScreenState();
}

class _OrdersScreenState extends State<OrdersScreen> {
  List<dynamic> orders = [];
  List<dynamic> filteredOrders = [];
  bool _isLoading = true;
  String searchQuery = "";
  String statusFilter = "All";
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _fetchOrders();
  }

  Future<void> _fetchOrders() async {
    setState(() => _isLoading = true);
    try {
      final response = await http.get(Uri.parse('$backendUrl/api/orders'));
      if (response.statusCode == 200) {
        setState(() {
          orders = jsonDecode(response.body);
          _applyFilters();
          _isLoading = false;
        });
      }
    } catch (e) {
      print("Error fetching orders: $e");
      if (mounted) setState(() => _isLoading = false);
    }
  }

  void _addOrder(Map<String, dynamic> newOrder) {
    _fetchOrders(); // Refresh from server
  }

  void _applyFilters() {
    setState(() {
      filteredOrders = orders.where((order) {
        final matchesSearch = (order['orderId'] ?? "").toString().toLowerCase().contains(searchQuery.toLowerCase()) ||
            (order['customerName'] ?? "").toString().toLowerCase().contains(searchQuery.toLowerCase());
        final matchesStatus = statusFilter == "All" || order['status'] == statusFilter;
        return matchesSearch && matchesStatus;
      }).toList();
    });
  }

  Future<void> _exportToExcel() async {
    var excel = exc.Excel.createExcel();
    exc.Sheet sheetObject = excel['Orders'];
    excel.delete('Sheet1');

    // Headers
    sheetObject.appendRow([
      exc.TextCellValue("Order ID"),
      exc.TextCellValue("Date"),
      exc.TextCellValue("Customer Name"),
      exc.TextCellValue("Sales Person"),
      exc.TextCellValue("Type"),
      exc.TextCellValue("Payment Type"),
      exc.TextCellValue("Godown"),
      exc.TextCellValue("PO No"),
      exc.TextCellValue("Invoice No"),
      exc.TextCellValue("State of Supply"),
      exc.TextCellValue("Delivery Location"),
      exc.TextCellValue("Total Items"),
      exc.TextCellValue("Total Amount"),
      exc.TextCellValue("Status")
    ]);

    for (var order in filteredOrders) {
      final items = order['items'] as List<dynamic>? ?? [];
      sheetObject.appendRow([
        exc.TextCellValue(order['orderId'] ?? ""),
        exc.TextCellValue(order['orderDate'] != null ? DateFormat('yyyy-MM-dd HH:mm').format(DateTime.parse(order['orderDate'])) : ""),
        exc.TextCellValue(order['customerName'] ?? ""),
        exc.TextCellValue(order['salesPerson'] ?? ""),
        exc.TextCellValue(order['orderType'] ?? ""),
        exc.TextCellValue(order['paymentType'] ?? ""),
        exc.TextCellValue(order['godown'] ?? ""),
        exc.TextCellValue(order['poNo'] ?? ""),
        exc.TextCellValue(order['invoiceNumber'] ?? ""),
        exc.TextCellValue(order['stateOfSupply'] ?? ""),
        exc.TextCellValue(order['deliveryLocation'] ?? ""),
        exc.IntCellValue(items.length),
        exc.DoubleCellValue(double.tryParse(order['totalAmount']?.toString() ?? "0") ?? 0),
        exc.TextCellValue(order['status'] ?? ""),
      ]);
    }

    if (kIsWeb) {
      final bytes = excel.save();
      final blob = html.Blob([bytes], 'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet');
      final url = html.Url.createObjectUrlFromBlob(blob);
      final anchor = html.AnchorElement(href: url)
        ..setAttribute("download", "Orders_Export_${DateTime.now().millisecondsSinceEpoch}.xlsx")
        ..click();
      html.Url.revokeObjectUrl(url);
    } else {
      final bytes = excel.save();
      final directory = await getApplicationDocumentsDirectory();
      final file = File('${directory.path}/Orders_Export_${DateTime.now().millisecondsSinceEpoch}.xlsx');
      await file.writeAsBytes(bytes!);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Excel saved to: ${file.path}")));
      }
    }
  }

  void _openOrderDetails(Map<String, dynamic> order) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => OrderDetailsScreen(order: order)),
    );
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
                Expanded(
                  child: Row(
                    children: [
                      const SizedBox(width: 40), // Gap from title
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
                              hintText: "Search Invoice, Customer...",
                              border: InputBorder.none,
                              isDense: true,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      _buildFilterDropdown(),
                      const SizedBox(width: 8),
                      _buildSecondaryButton(Icons.download_outlined, "Export", onTap: _exportToExcel),
                      const SizedBox(width: 12),
                      _buildPrimaryButton(Icons.add, "New Order", () => _openCreateOrder(context)),
                    ],
                  ),
                ),
            ],
          ),
          const SizedBox(height: defaultPadding),

          // Order KPI Cards
          OrderKpiSection(
            totalOrders: orders.length.toString(),
            confirmedCount: orders.where((o) => o['status'] == "Confirmed").length.toString(),
            processingCount: orders.where((o) => o['status'] == "Processing").length.toString(),
            deliveredCount: orders.where((o) => o['status'] == "Delivered").length.toString(),
          ),

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
          _isLoading 
            ? const Center(child: CircularProgressIndicator())
            : Responsive.isMobile(context) ? _buildOrderCardsList() : _buildOrderTable(),
          
          const SizedBox(height: 80), // Padding for mobile bottom bar
        ],
      ),
    );
  }

  Widget _buildSecondaryButton(IconData icon, String text, {VoidCallback? onTap}) {
    return InkWell(
      onTap: onTap,
      child: Container(
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
      ),
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
          items: ["All", "Pending", "Confirmed", "Processing", "Delivered", "Cancelled"].map((s) => DropdownMenuItem(
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
          ...filteredOrders.map((order) => _buildOrderRow(order as Map<String, dynamic>)),
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
          Expanded(flex: 2, child: Text(order["orderId"] ?? "N/A", style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13))),
          Expanded(flex: 2, child: Text(order["orderDate"] != null ? DateFormat('MMM dd, yyyy').format(DateTime.parse(order["orderDate"])) : "N/A", style: const TextStyle(fontSize: 13, color: textSecondaryColor))),
          Expanded(flex: 2, child: Text(order["customerName"] ?? "Walk-in", style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600))),
          Expanded(flex: 2, child: Text(order["salesPerson"] ?? "N/A", style: const TextStyle(fontSize: 13, color: textSecondaryColor))),
          Expanded(flex: 2, child: Text(order["orderType"] ?? "Secondary", style: const TextStyle(fontSize: 13))),
          Expanded(flex: 2, child: Text(order["paymentType"] ?? "Cash", style: TextStyle(fontSize: 13, color: order["paymentType"] == "Online" ? successColor : Colors.amber, fontWeight: FontWeight.bold))),
          Expanded(flex: 2, child: Text(order["stateOfSupply"] ?? "N/A", style: const TextStyle(fontSize: 13))),
          Expanded(flex: 2, child: Text("₹${order["totalAmount"]}", style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold))),
          Expanded(flex: 2, child: _buildStatusBadge(order["status"] ?? "Pending")),
          Expanded(flex: 1, child: IconButton(
            icon: const Icon(Icons.arrow_forward_ios_rounded, size: 14, color: textSecondaryColor),
            onPressed: () => _openOrderDetails(order),
          )),
        ],
      ),
    );
  }

  Widget _buildOrderCardsList() {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: filteredOrders.length,
      itemBuilder: (context, index) => _buildOrderCard(filteredOrders[index] as Map<String, dynamic>),
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
                Text(order["orderId"] ?? "N/A", style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                _buildStatusBadge(order["status"] ?? "Pending"),
              ],
            ),
            const Divider(height: 24),
            Row(
              children: [
                _buildInfoColumn("Date", order["orderDate"] != null ? DateFormat('MMM dd, yyyy').format(DateTime.parse(order["orderDate"])) : "N/A"),
                const Spacer(),
                _buildInfoColumn("Customer", order["customerName"] ?? "Walk-in"),
                const Spacer(),
                _buildInfoColumn("Total", "₹${order["totalAmount"]}", isBold: true),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                _buildInfoColumn("Sales Person", order["salesPerson"] ?? "N/A"),
                const Spacer(),
                const Icon(Icons.location_on_outlined, size: 14, color: textSecondaryColor),
                const SizedBox(width: 4),
                Text(order["stateOfSupply"] ?? "N/A", style: const TextStyle(fontSize: 12, color: textSecondaryColor)),
                const Spacer(),
                Text(order["orderType"] ?? "Secondary", style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: primaryColor)),
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
  final String confirmedCount;
  final String processingCount;
  final String deliveredCount;

  const OrderKpiSection({
    super.key, 
    required this.totalOrders,
    required this.confirmedCount,
    required this.processingCount,
    required this.deliveredCount,
  });

  @override
  Widget build(BuildContext context) {
    bool isMobile = Responsive.isMobile(context);
    
    List<Widget> cards = [
      _buildCardWrapper(isMobile, _buildKpiCard("TOTAL ORDERS", totalOrders, Colors.blue)),
      const SizedBox(width: 12),
      _buildCardWrapper(isMobile, _buildKpiCard("CONFIRMED", confirmedCount, Colors.teal)),
      const SizedBox(width: 12),
      _buildCardWrapper(isMobile, _buildKpiCard("PROCESSING", processingCount, Colors.amber)),
      const SizedBox(width: 12),
      _buildCardWrapper(isMobile, _buildKpiCard("DELIVERED", deliveredCount, Colors.green)),
    ];

    if (isMobile) {
      return SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(children: cards),
      );
    }

    return Row(children: cards);
  }

  Widget _buildCardWrapper(bool isMobile, Widget child) {
    if (isMobile) {
      return SizedBox(width: 160, child: child);
    }
    return Expanded(child: child);
  }

  Widget _buildKpiCard(String label, String value, Color color) {
    return Container(
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
    );
  }
}
