import 'package:flutter/material.dart';
import '../../constants.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class OrderDetailsScreen extends StatefulWidget {
  final Map<String, dynamic> order;

  const OrderDetailsScreen({super.key, required this.order});

  @override
  State<OrderDetailsScreen> createState() => _OrderDetailsScreenState();
}

class _OrderDetailsScreenState extends State<OrderDetailsScreen> {
  late String _currentStatus;
  bool _isUpdatingStatus = false;

  @override
  void initState() {
    super.initState();
    _currentStatus = widget.order['status'] ?? "Pending";
  }

  Future<void> _updateStatus(String? newStatus) async {
    if (newStatus == null || newStatus == _currentStatus) return;

    setState(() => _isUpdatingStatus = true);
    try {
      final response = await http.put(
        Uri.parse('$backendUrl/api/orders/${widget.order['_id']}/status'),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({"status": newStatus}),
      );

      if (response.statusCode == 200) {
        setState(() {
          _currentStatus = newStatus;
          _isUpdatingStatus = false;
        });
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("Status updated to $newStatus")),
          );
        }
      }
    } catch (e) {
      print("Error updating status: $e");
      if (mounted) setState(() => _isUpdatingStatus = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        title: Text("Order: ${widget.order['orderId']}", 
          style: const TextStyle(fontWeight: FontWeight.bold, color: textPrimaryColor)),
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, color: textPrimaryColor, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(defaultPadding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildStatusHeader(),
            const SizedBox(height: 20),
            if (widget.order['attachments'] != null && (widget.order['attachments'] as List).isNotEmpty) ...[
              const Text("Attachments", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: textPrimaryColor)),
              const SizedBox(height: 12),
              _buildImageGallery(widget.order['attachments']),
              const SizedBox(height: 20),
            ],
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(flex: 2, child: _buildOrderInfo()),
                const SizedBox(width: 20),
                Expanded(child: _buildCustomerCard()),
              ],
            ),
            const SizedBox(height: 20),
            _buildItemsTable(),
            const SizedBox(height: 20),
            _buildFinancialSummary(),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  Widget _buildStatusHeader() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.02), blurRadius: 10)],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: primaryColor.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(Icons.shopping_bag_outlined, color: primaryColor),
          ),
          const SizedBox(width: 16),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("Order Status", style: TextStyle(color: textSecondaryColor, fontSize: 12, fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              _isUpdatingStatus 
                ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2))
                : Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    decoration: BoxDecoration(
                      color: bgColor,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: textSecondaryColor.withValues(alpha: 0.1)),
                    ),
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton<String>(
                        value: _currentStatus,
                        style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: textPrimaryColor),
                        items: ["Pending", "Confirmed", "Processing", "Shipped", "Delivered", "Cancelled"].map((s) => DropdownMenuItem(
                          value: s,
                          child: Text(s),
                        )).toList(),
                        onChanged: _updateStatus,
                      ),
                    ),
                  ),
            ],
          ),
          const Spacer(),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text("Order Date", style: TextStyle(color: textSecondaryColor, fontSize: 12, fontWeight: FontWeight.bold)),
              const SizedBox(height: 4),
              Text(widget.order['orderDate'] != null 
                ? DateFormat('MMM dd, yyyy HH:mm').format(DateTime.parse(widget.order['orderDate'])) 
                : "N/A", 
                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: textPrimaryColor)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildImageGallery(List<dynamic> urls) {
    return SizedBox(
      height: 120,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: urls.length,
        itemBuilder: (context, index) => Container(
          margin: const EdgeInsets.only(right: 12),
          width: 120,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            image: DecorationImage(image: NetworkImage(urls[index]), fit: BoxFit.cover),
            border: Border.all(color: textSecondaryColor.withValues(alpha: 0.1)),
          ),
        ),
      ),
    );
  }

  Widget _buildOrderInfo() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text("Logistics & Details", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: textPrimaryColor)),
          const Divider(height: 32),
          _buildDetailRow("Sales Person", widget.order['salesPerson'] ?? "N/A"),
          _buildDetailRow("Type", widget.order['orderType'] ?? "Secondary"),
          _buildDetailRow("Payment", widget.order['paymentType'] ?? "Cash"),
          _buildDetailRow("Godown", widget.order['godown'] ?? "N/A"),
          _buildDetailRow("PO Number", widget.order['poNo'] ?? "N/A"),
          _buildDetailRow("Invoice No", widget.order['invoiceNumber'] ?? "N/A"),
          _buildDetailRow("E-Way Bill", widget.order['ewayBillNo'] ?? "N/A"),
          _buildDetailRow("Location", widget.order['deliveryLocation'] ?? "N/A"),
          if (widget.order['description'] != null) ...[
            const SizedBox(height: 16),
            Text("Notes", style: TextStyle(color: textSecondaryColor, fontSize: 12, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Text(widget.order['description'], style: const TextStyle(fontSize: 13, color: textPrimaryColor)),
          ]
        ],
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(color: textSecondaryColor, fontSize: 13)),
          Text(value, style: const TextStyle(fontWeight: FontWeight.bold, color: textPrimaryColor, fontSize: 13)),
        ],
      ),
    );
  }

  Widget _buildCustomerCard() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text("Customer Info", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: textPrimaryColor)),
          const Divider(height: 32),
          Text(widget.order['customerName'] ?? "Walk-in Customer", 
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: textPrimaryColor)),
          const SizedBox(height: 8),
          Text(widget.order['billingAddress'] ?? "No address provided", 
            style: const TextStyle(color: textSecondaryColor, fontSize: 13)),
          const SizedBox(height: 24),
          const Text("STATE OF SUPPLY", style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: textSecondaryColor)),
          const SizedBox(height: 4),
          Text(widget.order['stateOfSupply'] ?? "N/A", style: const TextStyle(fontWeight: FontWeight.bold, color: textPrimaryColor)),
        ],
      ),
    );
  }

  Widget _buildItemsTable() {
    final items = widget.order['items'] as List<dynamic>? ?? [];
    return Container(
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.all(24.0),
            child: Text("Ordered Items", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: textPrimaryColor)),
          ),
          Table(
            columnWidths: const {
              0: FlexColumnWidth(4),
              1: FlexColumnWidth(2),
              2: FlexColumnWidth(2),
              3: FlexColumnWidth(2),
            },
            children: [
              TableRow(
                decoration: BoxDecoration(color: bgColor.withValues(alpha: 0.5)),
                children: const [
                  _TableHeader("PRODUCT"),
                  _TableHeader("QTY"),
                  _TableHeader("PRICE"),
                  _TableHeader("AMOUNT"),
                ],
              ),
              ...items.map((item) => TableRow(
                children: [
                  _TableCell(item['productName'] ?? "N/A"),
                  _TableCell("${item['quantity']} ${item['unit'] ?? ''}"),
                  _TableCell("₹${item['price']}"),
                  _TableCell("₹${item['amount']}", isBold: true),
                ],
              )).toList(),
            ],
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget _buildFinancialSummary() {
    return Align(
      alignment: Alignment.centerRight,
      child: Container(
        width: 350,
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(color: textPrimaryColor, borderRadius: BorderRadius.circular(16)),
        child: Column(
          children: [
            _buildSummaryRow("Discount", "${widget.order['discountPercentage']}%", Colors.white70),
            _buildSummaryRow("Shipping", "₹${widget.order['shippingCharges']}", Colors.white70),
            _buildSummaryRow("Packaging", "₹${widget.order['packagingCharges']}", Colors.white70),
            _buildSummaryRow("Adjustment", "₹${widget.order['adjustment']}", Colors.white70),
            const Divider(color: Colors.white24, height: 32),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text("Total Amount", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16)),
                Text("₹${widget.order['totalAmount']}", 
                  style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 22)),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSummaryRow(String label, String value, Color color) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: TextStyle(color: color, fontSize: 14)),
          Text(value, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }
}

class _TableHeader extends StatelessWidget {
  final String text;
  const _TableHeader(this.text);
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
      child: Text(text, style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: textSecondaryColor)),
    );
  }
}

class _TableCell extends StatelessWidget {
  final String text;
  final bool isBold;
  const _TableCell(this.text, {this.isBold = false});
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
      child: Text(text, style: TextStyle(fontSize: 13, fontWeight: isBold ? FontWeight.bold : FontWeight.w500, color: textPrimaryColor)),
    );
  }
}
