import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../../constants.dart';
import '../../responsive.dart';

class ProformaInvoiceScreen extends StatefulWidget {
  const ProformaInvoiceScreen({super.key});

  @override
  State<ProformaInvoiceScreen> createState() => _ProformaInvoiceScreenState();
}

class _ProformaInvoiceScreenState extends State<ProformaInvoiceScreen> {
  List<dynamic> invoices = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchInvoices();
  }

  Future<void> _fetchInvoices() async {
    setState(() => isLoading = true);
    try {
      final response = await http.get(Uri.parse('$backendUrl/api/proformas'));
      if (response.statusCode == 200) {
        if (mounted) setState(() { invoices = json.decode(response.body); isLoading = false; });
      } else throw Exception('Failed to load');
    } catch (e) {
      if (mounted) setState(() => isLoading = false);
    }
  }

  Future<void> _deleteInvoice(String id) async {
    try {
      final response = await http.delete(Uri.parse('$backendUrl/api/proformas/$id'));
      if (response.statusCode == 200) _fetchInvoices();
    } catch (e) {
      debugPrint("Error: $e");
    }
  }

  void _showInvoiceDialog({Map<String, dynamic>? data}) {
    final cId = TextEditingController(text: data?['invoiceId'] ?? "");
    final cCustomer = TextEditingController(text: data?['customer'] ?? "");
    final cDate = TextEditingController(text: data?['date'] ?? "");
    final cDue = TextEditingController(text: data?['due'] ?? "");
    final cAmount = TextEditingController(text: data?['amount'] ?? "");
    String status = data?['status'] ?? "Pending";

    showDialog(
      context: context, 
      barrierColor: Colors.black.withValues(alpha: 0.5),
      builder: (ctx) => Dialog(
        backgroundColor: Colors.transparent,
        insetPadding: const EdgeInsets.all(20),
        child: Container(
          width: 500,
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(24),
            boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.1), blurRadius: 40, offset: const Offset(0, 10))],
          ),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(colors: [Color(0xFF6366F1), Color(0xFF818CF8)], begin: Alignment.topLeft, end: Alignment.bottomRight),
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [BoxShadow(color: const Color(0xFF6366F1).withValues(alpha: 0.3), blurRadius: 8, offset: const Offset(0, 4))],
                      ),
                      child: const Icon(Icons.receipt_long_rounded, color: Colors.white, size: 28),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(data == null ? "Create Proforma" : "Edit Proforma", style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.black87)),
                          const Text("Fill out the invoice details", style: TextStyle(fontSize: 13, color: Colors.black54)),
                        ],
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.close_rounded, color: Colors.black54),
                      onPressed: () => Navigator.pop(ctx),
                    ),
                  ],
                ),
                const SizedBox(height: 32),
                
                _buildModernTextField(cId, "Invoice ID", Icons.tag_rounded),
                const SizedBox(height: 16),
                _buildModernTextField(cCustomer, "Customer Name", Icons.business_rounded),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(child: _buildModernTextField(cDate, "Issue Date", Icons.calendar_today_rounded)),
                    const SizedBox(width: 16),
                    Expanded(child: _buildModernTextField(cDue, "Due Date", Icons.event_rounded)),
                  ],
                ),
                const SizedBox(height: 16),
                _buildModernTextField(cAmount, "Amount (e.g. ₹42,000)", Icons.currency_rupee_rounded),
                const SizedBox(height: 16),
                
                DropdownButtonFormField<String>(
                  value: status,
                  icon: const Icon(Icons.keyboard_arrow_down_rounded, color: textSecondaryColor),
                  decoration: InputDecoration(
                    labelText: "Invoice Status",
                    prefixIcon: const Icon(Icons.flag_rounded, color: primaryColor),
                    filled: true,
                    fillColor: Colors.grey.withValues(alpha: 0.05),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
                  ),
                  items: ["Pending", "Converted", "Overdue"].map((e) => DropdownMenuItem(value: e, child: Text(e, style: const TextStyle(fontWeight: FontWeight.w600)))).toList(),
                  onChanged: (v) => status = v!,
                ),
                
                const SizedBox(height: 32),
                
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () => Navigator.pop(ctx),
                        style: OutlinedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          side: BorderSide(color: Colors.grey.withValues(alpha: 0.3)),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        ),
                        child: const Text("Cancel", style: TextStyle(color: Colors.black87, fontWeight: FontWeight.bold)),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Container(
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(colors: [primaryColor, Color(0xFF6366F1)], begin: Alignment.centerLeft, end: Alignment.centerRight),
                          borderRadius: BorderRadius.circular(12),
                          boxShadow: [BoxShadow(color: primaryColor.withValues(alpha: 0.3), blurRadius: 8, offset: const Offset(0, 4))],
                        ),
                        child: ElevatedButton(
                          onPressed: () async {
                            Navigator.pop(ctx);
                            setState(() => isLoading = true);
                            final payload = json.encode({
                              "invoiceId": cId.text, "customer": cCustomer.text, "date": cDate.text, "due": cDue.text, "amount": cAmount.text, "status": status
                            });
                            try {
                              if (data == null) {
                                await http.post(Uri.parse('$backendUrl/api/proformas'), headers: {'Content-Type': 'application/json'}, body: payload);
                              } else {
                                await http.put(Uri.parse('$backendUrl/api/proformas/${data['_id']}'), headers: {'Content-Type': 'application/json'}, body: payload);
                              }
                              _fetchInvoices();
                            } catch (e) {
                               setState(() => isLoading = false);
                            }
                          }, 
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.transparent, 
                            shadowColor: Colors.transparent,
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                          ),
                          child: const Text("Save Invoice", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16)),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildModernTextField(TextEditingController controller, String label, IconData icon) {
    return TextField(
      controller: controller,
      style: const TextStyle(fontWeight: FontWeight.w500),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(color: textSecondaryColor),
        prefixIcon: Icon(icon, color: primaryColor),
        filled: true,
        fillColor: Colors.grey.withValues(alpha: 0.05),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
        contentPadding: const EdgeInsets.symmetric(vertical: 16),
      ),
    );
  }

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
            _ProformaAnalytics(invoices: invoices),
            const SizedBox(height: defaultPadding * 1.5),
            _ActionRow(onAdd: _showInvoiceDialog),
            const SizedBox(height: defaultPadding),
            isLoading
              ? const Center(child: Padding(padding: EdgeInsets.all(50), child: CircularProgressIndicator()))
              : _ProformaTable(invoices: invoices, onEdit: (d) => _showInvoiceDialog(data: d), onDelete: _deleteInvoice),
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
          "Proforma Invoices",
          style: TextStyle(fontSize: isMobile ? 24 : 28, fontWeight: FontWeight.bold, color: textPrimaryColor),
        ),
        const SizedBox(height: 4),
        Text(
          "Pre-shipment preliminary bills for shipment of goods",
          style: TextStyle(fontSize: isMobile ? 13 : 14, color: textSecondaryColor, fontWeight: FontWeight.w500),
        ),
      ],
    );
  }
}

class _ProformaAnalytics extends StatelessWidget {
  final List<dynamic> invoices;
  const _ProformaAnalytics({required this.invoices});

  @override
  Widget build(BuildContext context) {
    bool isMobile = Responsive.isMobile(context);
    int total = invoices.length;
    int pending = invoices.where((i) => i['status'] == 'Pending').length;
    int converted = invoices.where((i) => i['status'] == 'Converted').length;

    List<Widget> stats = [
      _buildStatCard("Total Issued", "$total", Icons.receipt_long_rounded, [const Color(0xFF6366F1), const Color(0xFF818CF8)]),
      _buildStatCard("Pending Payment", "$pending", Icons.hourglass_top_rounded, [const Color(0xFFF59E0B), const Color(0xFFFBBF24)]),
      _buildStatCard("Converted (SO)", "$converted", Icons.check_circle_rounded, [const Color(0xFF22C55E), const Color(0xFF4ADE80)]),
      _buildStatCard("Est. Value", "Tap to sum", Icons.currency_rupee_rounded, [const Color(0xFFA855F7), const Color(0xFFC084FC)]),
    ];

    if (isMobile) {
      return SingleChildScrollView(scrollDirection: Axis.horizontal, child: Row(children: stats.map((s) => Container(width: MediaQuery.of(context).size.width * 0.65, margin: const EdgeInsets.only(right: 16), child: s)).toList()));
    }

    return GridView.count(
      shrinkWrap: true, physics: const NeverScrollableScrollPhysics(), crossAxisCount: 4, crossAxisSpacing: defaultPadding, mainAxisSpacing: defaultPadding, childAspectRatio: 2.2, children: stats,
    );
  }

  Widget _buildStatCard(String title, String value, IconData icon, List<Color> colors) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(gradient: LinearGradient(colors: colors, begin: Alignment.topLeft, end: Alignment.bottomRight), borderRadius: BorderRadius.circular(16), boxShadow: [BoxShadow(color: colors[0].withValues(alpha: 0.3), blurRadius: 10, offset: const Offset(0, 5))]),
      child: Row(
        children: [
          Container(padding: const EdgeInsets.all(10), decoration: BoxDecoration(color: Colors.white.withValues(alpha: 0.2), borderRadius: BorderRadius.circular(12)), child: Icon(icon, color: Colors.white, size: 24)),
          const SizedBox(width: 16),
          Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, mainAxisAlignment: MainAxisAlignment.center, children: [
            Text(value, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w900, color: Colors.white)),
            Text(title, style: const TextStyle(fontSize: 11, color: Colors.white70, fontWeight: FontWeight.w600), overflow: TextOverflow.ellipsis),
          ])),
        ],
      ),
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
            Container(height: 48, decoration: BoxDecoration(color: surfaceColor, borderRadius: BorderRadius.circular(12), border: Border.all(color: Colors.grey.withValues(alpha: 0.1))), child: const TextField(decoration: InputDecoration(hintText: "Search Invoice ID...", prefixIcon: Icon(Icons.search, size: 20), border: InputBorder.none, contentPadding: EdgeInsets.symmetric(vertical: 14)))),
            const SizedBox(height: 12),
            SizedBox(width: double.infinity, child: ElevatedButton.icon(onPressed: onAdd, style: ElevatedButton.styleFrom(backgroundColor: primaryColor, padding: const EdgeInsets.symmetric(vertical: 14), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))), icon: const Icon(Icons.add_rounded, color: Colors.white), label: const Text("Create Proforma", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)))),
          ],
        )
      : Row(
          children: [
            Expanded(child: Container(height: 48, decoration: BoxDecoration(color: surfaceColor, borderRadius: BorderRadius.circular(12), border: Border.all(color: Colors.grey.withValues(alpha: 0.1))), child: const TextField(decoration: InputDecoration(hintText: "Search Invoice ID...", prefixIcon: Icon(Icons.search, size: 20), border: InputBorder.none, contentPadding: EdgeInsets.symmetric(vertical: 14))))),
            const SizedBox(width: 12),
            ElevatedButton.icon(onPressed: onAdd, style: ElevatedButton.styleFrom(backgroundColor: primaryColor, padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))), icon: const Icon(Icons.add_rounded, color: Colors.white), label: const Text("Create Proforma", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold))),
          ],
        );
  }
}

class _ProformaTable extends StatelessWidget {
  final List<dynamic> invoices;
  final Function(Map<String,dynamic>) onEdit;
  final Function(String) onDelete;
  const _ProformaTable({required this.invoices, required this.onEdit, required this.onDelete});

  @override
  Widget build(BuildContext context) {
    bool isMobile = Responsive.isMobile(context);
    if (invoices.isEmpty) return const Center(child: Padding(padding: EdgeInsets.all(30), child: Text("No Proforma Invoices Found")));
    if (isMobile) {
      return ListView.separated(shrinkWrap: true, physics: const NeverScrollableScrollPhysics(), itemCount: invoices.length, separatorBuilder: (c, i) => const SizedBox(height: 12), itemBuilder: (c, i) => _InvoiceMobileCard(data: invoices[i], onEdit: onEdit, onDelete: onDelete));
    }
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(color: surfaceColor, borderRadius: BorderRadius.circular(20), boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.02), blurRadius: 10, offset: const Offset(0, 5))]),
      child: Column(
        children: [
          const _TableHeader(),
          ListView.separated(shrinkWrap: true, physics: const NeverScrollableScrollPhysics(), itemCount: invoices.length, separatorBuilder: (c, i) => Divider(height: 1, color: Colors.grey.withValues(alpha: 0.05)), itemBuilder: (c, i) => _InvoiceRow(data: invoices[i], onEdit: onEdit, onDelete: onDelete)),
        ],
      ),
    );
  }
}

class _InvoiceMobileCard extends StatelessWidget {
  final dynamic data;
  final Function(Map<String,dynamic>) onEdit;
  final Function(String) onDelete;
  const _InvoiceMobileCard({required this.data, required this.onEdit, required this.onDelete});

  @override
  Widget build(BuildContext context) {
    Color statusColor;
    switch (data["status"]) {
      case "Converted": statusColor = const Color(0xFF22C55E); break;
      case "Overdue": statusColor = const Color(0xFFEF4444); break;
      default: statusColor = const Color(0xFFF59E0B);
    }
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(color: surfaceColor, borderRadius: BorderRadius.circular(16), boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 10, offset: const Offset(0, 4))]),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(data["invoiceId"] ?? "", style: const TextStyle(fontWeight: FontWeight.bold, color: primaryColor)),
              Container(padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4), decoration: BoxDecoration(color: statusColor.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(8)), child: Text(data["status"] ?? "", style: TextStyle(color: statusColor, fontSize: 10, fontWeight: FontWeight.bold))),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text(data["customer"] ?? "", style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
                Text("Issued: ${data["date"] ?? ""}", style: const TextStyle(fontSize: 12, color: textSecondaryColor)),
              ])),
              Text(data["amount"] ?? "", style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 16)),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("Due: ${data["due"] ?? ""}", style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: textSecondaryColor)),
              Row(
                children: [
                  InkWell(onTap: () => onEdit(data), child: _buildActionIcon(Icons.edit_outlined)),
                  const SizedBox(width: 8),
                  InkWell(onTap: () => onDelete(data["_id"]), child: _buildActionIcon(Icons.delete_outline, color: Colors.red)),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildActionIcon(IconData icon, {Color color = textPrimaryColor}) {
    return Container(padding: const EdgeInsets.all(6), decoration: BoxDecoration(color: bgColor, borderRadius: BorderRadius.circular(8)), child: Icon(icon, size: 16, color: color));
  }
}

class _TableHeader extends StatelessWidget {
  const _TableHeader();
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
      decoration: const BoxDecoration(color: Color(0xFFF8FAFC), borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      child: const Row(children: [
        Expanded(flex: 2, child: Text("INVOICE ID", style: TextStyle(fontSize: 10, fontWeight: FontWeight.w900, color: Color(0xFF64748B)))),
        Expanded(flex: 3, child: Text("CUSTOMER", style: TextStyle(fontSize: 10, fontWeight: FontWeight.w900, color: Color(0xFF64748B)))),
        Expanded(flex: 2, child: Text("DATE", style: TextStyle(fontSize: 10, fontWeight: FontWeight.w900, color: Color(0xFF64748B)))),
        Expanded(flex: 2, child: Text("AMOUNT", style: TextStyle(fontSize: 10, fontWeight: FontWeight.w900, color: Color(0xFF64748B)))),
        Expanded(flex: 2, child: Text("STATUS", style: TextStyle(fontSize: 10, fontWeight: FontWeight.w900, color: Color(0xFF64748B)))),
        Expanded(flex: 2, child: Text("ACTIONS", style: TextStyle(fontSize: 10, fontWeight: FontWeight.w900, color: Color(0xFF64748B)))),
      ]),
    );
  }
}

class _InvoiceRow extends StatelessWidget {
  final dynamic data;
  final Function(Map<String,dynamic>) onEdit;
  final Function(String) onDelete;
  const _InvoiceRow({required this.data, required this.onEdit, required this.onDelete});

  @override
  Widget build(BuildContext context) {
    Color statusColor;
    switch (data["status"]) {
      case "Converted": statusColor = const Color(0xFF22C55E); break;
      case "Overdue": statusColor = const Color(0xFFEF4444); break;
      default: statusColor = const Color(0xFFF59E0B);
    }
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      child: Row(
        children: [
          Expanded(flex: 2, child: Text(data["invoiceId"] ?? "", style: const TextStyle(fontWeight: FontWeight.bold, color: primaryColor))),
          Expanded(flex: 3, child: Text(data["customer"] ?? "", style: const TextStyle(fontWeight: FontWeight.bold))),
          Expanded(flex: 2, child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(data["date"] ?? "", style: const TextStyle(fontSize: 13)),
            Text("Due: ${data["due"] ?? ""}", style: const TextStyle(fontSize: 10, color: textSecondaryColor)),
          ])),
          Expanded(flex: 2, child: Text(data["amount"] ?? "", style: const TextStyle(fontWeight: FontWeight.w900))),
          Expanded(flex: 2, child: Container(padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4), decoration: BoxDecoration(color: statusColor.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(8)), child: Text(data["status"] ?? "", style: TextStyle(color: statusColor, fontSize: 11, fontWeight: FontWeight.bold)))),
          Expanded(flex: 2, child: Row(children: [
            InkWell(onTap: () => onEdit(data), child: _buildActionIcon(Icons.edit_outlined)),
            const SizedBox(width: 8),
            InkWell(onTap: () => onDelete(data["_id"]), child: _buildActionIcon(Icons.delete_outline, color: Colors.red)),
          ])),
        ],
      ),
    );
  }

  Widget _buildActionIcon(IconData icon, {Color color = textSecondaryColor}) {
    return Container(padding: const EdgeInsets.all(8), decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(8), border: Border.all(color: Colors.grey.withValues(alpha: 0.1))), child: Icon(icon, size: 16, color: color));
  }
}
