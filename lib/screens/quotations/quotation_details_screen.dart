import 'package:flutter/material.dart';
import '../../constants.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class QuotationDetailsScreen extends StatefulWidget {
  final Map<String, dynamic> quotation;

  const QuotationDetailsScreen({super.key, required this.quotation});

  @override
  State<QuotationDetailsScreen> createState() => _QuotationDetailsScreenState();
}

class _QuotationDetailsScreenState extends State<QuotationDetailsScreen> {
  late String _currentStatus;
  bool _isUpdatingStatus = false;

  @override
  void initState() {
    super.initState();
    _currentStatus = widget.quotation['status'] ?? "Draft";
  }

  Future<void> _updateStatus(String? newStatus) async {
    if (newStatus == null || newStatus == _currentStatus) return;

    setState(() => _isUpdatingStatus = true);
    try {
      final response = await http.put(
        Uri.parse('$backendUrl/api/quotations/${widget.quotation['_id']}/status'),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({"status": newStatus}),
      );

      if (response.statusCode == 200) {
        setState(() {
          _currentStatus = newStatus;
          _isUpdatingStatus = false;
        });
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Status updated to $newStatus")));
        }
      }
    } catch (e) {
      debugPrint("Error updating status: $e");
      if (mounted) setState(() => _isUpdatingStatus = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        title: Text("Quotation Detail", style: const TextStyle(fontWeight: FontWeight.bold, color: textPrimaryColor)),
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(icon: const Icon(Icons.arrow_back_ios_new_rounded, color: textPrimaryColor), onPressed: () => Navigator.pop(context)),
        actions: [
          IconButton(icon: const Icon(Icons.print_outlined, color: primaryColor), onPressed: () {}),
          IconButton(icon: const Icon(Icons.share_outlined, color: primaryColor), onPressed: () {}),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(defaultPadding),
        child: Column(
          children: [
            _buildStatusHeader(),
            const SizedBox(height: 20),
            if (widget.quotation['attachments'] != null && (widget.quotation['attachments'] as List).isNotEmpty) ...[
              _buildImageGallery(widget.quotation['attachments']),
              const SizedBox(height: 20),
            ],
            _buildInfoGrid(),
            const SizedBox(height: 20),
            _buildAddressSection(),
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
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16)),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(color: primaryColor.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(12)),
            child: const Icon(Icons.description_outlined, color: primaryColor, size: 24),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(widget.quotation['quotationId'] ?? "QTN-XXXX", style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: textPrimaryColor)),
                const SizedBox(height: 4),
                Text("Type: ${widget.quotation['quotationType'] ?? 'Standard'}", style: const TextStyle(fontSize: 12, color: textSecondaryColor)),
              ],
            ),
          ),
          _isUpdatingStatus 
            ? const CircularProgressIndicator(strokeWidth: 2)
            : Container(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                decoration: BoxDecoration(color: bgColor, borderRadius: BorderRadius.circular(8)),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<String>(
                    value: _currentStatus,
                    items: ["Draft", "Sent", "Accepted", "Rejected", "Expired", "Converted"].map((s) => DropdownMenuItem(value: s, child: Text(s, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold)))).toList(),
                    onChanged: _updateStatus,
                  ),
                ),
              ),
        ],
      ),
    );
  }

  Widget _buildInfoGrid() {
    return _buildCard("Logistic & Basic Info", [
      _buildDetailRow("Sales Person", widget.quotation['salesPerson'] ?? "N/A"),
      _buildDetailRow("Godown", widget.quotation['godown'] ?? "Default"),
      _buildDetailRow("Payment Type", widget.quotation['paymentType'] ?? "Cash"),
      _buildDetailRow("Quotation Date", _formatDate(widget.quotation['quotationDate'])),
      _buildDetailRow("Time", widget.quotation['time'] ?? "N/A"),
      _buildDetailRow("Valid Until", _formatDate(widget.quotation['validUntil'])),
      _buildDetailRow("PO Number", widget.quotation['poNo'] ?? "N/A"),
      _buildDetailRow("PO Date", _formatDate(widget.quotation['poDate'])),
    ]);
  }

  Widget _buildAddressSection() {
    return Row(
      children: [
        Expanded(
          child: _buildCard("Billing To", [
            Text(widget.quotation['billingName'] ?? widget.quotation['customerName'] ?? "N/A", style: const TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Text(widget.quotation['billingAddress'] ?? "No billing address", style: const TextStyle(fontSize: 12, color: textSecondaryColor)),
            const SizedBox(height: 8),
            Text("State: ${widget.quotation['stateOfSupply'] ?? 'N/A'}", style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600)),
          ]),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: _buildCard("Shipping To", [
            Text(widget.quotation['customerName'] ?? "N/A", style: const TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Text(widget.quotation['shippingAddress'] ?? "Same as billing", style: const TextStyle(fontSize: 12, color: textSecondaryColor)),
            const SizedBox(height: 8),
            Text("Deliver To: ${widget.quotation['deliveryLocation'] ?? 'N/A'}", style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600)),
          ]),
        ),
      ],
    );
  }

  Widget _buildImageGallery(List<dynamic> urls) {
    return Container(
      height: 120,
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: urls.length,
        itemBuilder: (context, index) => Container(
          margin: const EdgeInsets.only(right: 12),
          width: 120,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.white, width: 2),
            boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.1), blurRadius: 10)],
            image: DecorationImage(image: NetworkImage(urls[index]), fit: BoxFit.cover),
          ),
        ),
      ),
    );
  }

  Widget _buildItemsTable() {
    final items = (widget.quotation['items'] as List<dynamic>?) ?? [];
    return Container(
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(padding: EdgeInsets.all(24), child: Text("Estimated Items", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16))),
          const Divider(height: 0),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            child: Row(
              children: const [
                Expanded(flex: 3, child: Text("PRODUCT", style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: textSecondaryColor))),
                Expanded(child: Text("QTY", textAlign: TextAlign.center, style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: textSecondaryColor))),
                Expanded(child: Text("TOTAL", textAlign: TextAlign.right, style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: textSecondaryColor))),
              ],
            ),
          ),
          ...items.map((item) => Container(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
            decoration: BoxDecoration(border: Border(bottom: BorderSide(color: textSecondaryColor.withValues(alpha: 0.05)))),
            child: Column(
              children: [
                Row(
                  children: [
                    Expanded(
                      flex: 3,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(item['productName'] ?? "N/A", style: const TextStyle(fontWeight: FontWeight.bold, color: textPrimaryColor)),
                          if (item['batchNo'] != null && item['batchNo'].toString().isNotEmpty)
                            Text("Batch: ${item['batchNo']}", style: const TextStyle(fontSize: 10, color: textSecondaryColor)),
                        ],
                      ),
                    ),
                    Expanded(child: Text("${item['quantity']} ${item['unit'] ?? ''}", textAlign: TextAlign.center, style: const TextStyle(fontWeight: FontWeight.w600))),
                    Expanded(child: Text("₹${item['amount']}", textAlign: TextAlign.right, style: const TextStyle(fontWeight: FontWeight.bold, color: primaryColor))),
                  ],
                ),
              ],
            ),
          )),
          const SizedBox(height: 12),
        ],
      ),
    );
  }

  Widget _buildFinancialSummary() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(color: textPrimaryColor, borderRadius: BorderRadius.circular(16), boxShadow: [BoxShadow(color: primaryColor.withValues(alpha: 0.2), blurRadius: 20, offset: const Offset(0, 10))]),
      child: Column(
        children: [
          _sumRow("Discount", "${widget.quotation['discountPercentage']}%"),
          _sumRow("Shipping Charges", "₹${widget.quotation['shippingCharges']}"),
          _sumRow("Adjustment", "₹${widget.quotation['adjustment'] ?? 0}"),
          const Divider(color: Colors.white12, height: 32),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text("ESTIMATED TOTAL", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16)),
              Text("₹${widget.quotation['totalAmount']}", style: const TextStyle(color: Colors.white, fontSize: 26, fontWeight: FontWeight.bold)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _sumRow(String label, String val) {
    return Padding(padding: const EdgeInsets.only(bottom: 12), child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
      Text(label, style: const TextStyle(color: Colors.white70, fontSize: 13)),
      Text(val, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 13)),
    ]));
  }

  Widget _buildCard(String title, List<Widget> children) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16)),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: textPrimaryColor)),
        const Divider(height: 32),
        ...children,
      ]),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(padding: const EdgeInsets.only(bottom: 12), child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
      Text(label, style: const TextStyle(color: textSecondaryColor, fontSize: 12)),
      Text(value, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: textPrimaryColor)),
    ]));
  }

  String _formatDate(dynamic date) {
    if (date == null) return "N/A";
    try {
      return DateFormat('dd MMM, yyyy').format(DateTime.parse(date.toString()));
    } catch (e) {
      return date.toString();
    }
  }
}
