import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../../constants.dart';
import '../../responsive.dart';

class DeliveryChallanScreen extends StatefulWidget {
  const DeliveryChallanScreen({super.key});

  @override
  State<DeliveryChallanScreen> createState() => _DeliveryChallanScreenState();
}

class _DeliveryChallanScreenState extends State<DeliveryChallanScreen> {
  List<dynamic> challans = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchChallans();
  }

  Future<void> _fetchChallans() async {
    setState(() => isLoading = true);
    try {
      final response = await http.get(Uri.parse('$backendUrl/api/challans'));
      if (response.statusCode == 200) {
        if (mounted) setState(() { challans = json.decode(response.body); isLoading = false; });
      } else throw Exception('Failed to load');
    } catch (e) {
      if (mounted) setState(() => isLoading = false);
    }
  }

  Future<void> _deleteChallan(String id) async {
    try {
       final response = await http.delete(Uri.parse('$backendUrl/api/challans/$id'));
       if (response.statusCode == 200) _fetchChallans();
    } catch (e) {
      debugPrint("Error: $e");
    }
  }

  void _showChallanDialog({Map<String, dynamic>? data}) {
    final cId = TextEditingController(text: data?['challanId'] ?? "");
    final cCustomer = TextEditingController(text: data?['customer'] ?? "");
    final cDate = TextEditingController(text: data?['date'] ?? "");
    final cDriver = TextEditingController(text: data?['driver'] ?? "");
    final cItems = TextEditingController(text: data?['items'] ?? "");
    String status = data?['status'] ?? "In Transit";

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
                        gradient: const LinearGradient(colors: [Color(0xFF3B82F6), Color(0xFF60A5FA)], begin: Alignment.topLeft, end: Alignment.bottomRight),
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [BoxShadow(color: const Color(0xFF3B82F6).withValues(alpha: 0.3), blurRadius: 8, offset: const Offset(0, 4))],
                      ),
                      child: const Icon(Icons.local_shipping_rounded, color: Colors.white, size: 28),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(data == null ? "New Challan" : "Edit Challan", style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.black87)),
                          const Text("Record dispatch details automatically", style: TextStyle(fontSize: 13, color: Colors.black54)),
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
                
                _buildModernTextField(cId, "Challan ID", Icons.tag_rounded),
                const SizedBox(height: 16),
                _buildModernTextField(cCustomer, "Customer / Destination", Icons.location_on_rounded),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(child: _buildModernTextField(cDate, "Date & Time", Icons.access_time_filled_rounded)),
                    const SizedBox(width: 16),
                    Expanded(child: _buildModernTextField(cItems, "Items Count", Icons.inventory_2_rounded)),
                  ],
                ),
                const SizedBox(height: 16),
                _buildModernTextField(cDriver, "Driver Name", Icons.person_rounded),
                const SizedBox(height: 16),
                
                DropdownButtonFormField<String>(
                  value: status,
                  icon: const Icon(Icons.keyboard_arrow_down_rounded, color: textSecondaryColor),
                  decoration: InputDecoration(
                    labelText: "Transit Status",
                    prefixIcon: const Icon(Icons.local_shipping_outlined, color: primaryColor),
                    filled: true,
                    fillColor: Colors.grey.withValues(alpha: 0.05),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
                  ),
                  items: ["In Transit", "Delivered", "Pending Sign"].map((e) => DropdownMenuItem(value: e, child: Text(e, style: const TextStyle(fontWeight: FontWeight.w600)))).toList(),
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
                          gradient: const LinearGradient(colors: [primaryColor, Color(0xFF3B82F6)], begin: Alignment.centerLeft, end: Alignment.centerRight),
                          borderRadius: BorderRadius.circular(12),
                          boxShadow: [BoxShadow(color: primaryColor.withValues(alpha: 0.3), blurRadius: 8, offset: const Offset(0, 4))],
                        ),
                        child: ElevatedButton(
                          onPressed: () async {
                            Navigator.pop(ctx);
                            setState(() => isLoading = true);
                            final payload = json.encode({
                              "challanId": cId.text, "customer": cCustomer.text, "date": cDate.text, "driver": cDriver.text, "items": cItems.text, "status": status
                            });
                            try {
                              if (data == null) {
                                await http.post(Uri.parse('$backendUrl/api/challans'), headers: {'Content-Type': 'application/json'}, body: payload);
                              } else {
                                await http.put(Uri.parse('$backendUrl/api/challans/${data['_id']}'), headers: {'Content-Type': 'application/json'}, body: payload);
                              }
                              _fetchChallans();
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
                          child: const Text("Save Challan", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16)),
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
            _ChallanAnalytics(challans: challans),
            const SizedBox(height: defaultPadding * 1.5),
            _ActionRow(onAdd: _showChallanDialog),
            const SizedBox(height: defaultPadding),
            isLoading
              ? const Center(child: Padding(padding: EdgeInsets.all(50), child: CircularProgressIndicator()))
              : _ChallanTable(challans: challans, onEdit: (d) => _showChallanDialog(data: d), onDelete: _deleteChallan),
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
          "Delivery Challans",
          style: TextStyle(fontSize: isMobile ? 24 : 28, fontWeight: FontWeight.bold, color: textPrimaryColor),
        ),
        const SizedBox(height: 4),
        Text(
          "Manage goods dispatch and delivery confirmations",
          style: TextStyle(fontSize: isMobile ? 13 : 14, color: textSecondaryColor, fontWeight: FontWeight.w500),
        ),
      ],
    );
  }
}

class _ChallanAnalytics extends StatelessWidget {
  final List<dynamic> challans;
  const _ChallanAnalytics({required this.challans});

  @override
  Widget build(BuildContext context) {
    bool isMobile = Responsive.isMobile(context);
    int total = challans.length;
    int transit = challans.where((i) => i['status'] == 'In Transit').length;
    int delivered = challans.where((i) => i['status'] == 'Delivered').length;

    List<Widget> stats = [
      _buildStatCard("Total Challans", "$total", Icons.local_shipping_rounded, [const Color(0xFF3B82F6), const Color(0xFF60A5FA)]),
      _buildStatCard("In Transit", "$transit", Icons.moving_rounded, [const Color(0xFFF59E0B), const Color(0xFFFBBF24)]),
      _buildStatCard("Delivered", "$delivered", Icons.verified_rounded, [const Color(0xFF22C55E), const Color(0xFF4ADE80)]),
      _buildStatCard("Pending Sign", "${total - transit - delivered}", Icons.pending_actions_rounded, [const Color(0xFFEF4444), const Color(0xFFF87171)]),
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
            Container(height: 48, decoration: BoxDecoration(color: surfaceColor, borderRadius: BorderRadius.circular(12), border: Border.all(color: Colors.grey.withValues(alpha: 0.1))), child: const TextField(decoration: InputDecoration(hintText: "Search...", prefixIcon: Icon(Icons.search, size: 20), border: InputBorder.none, contentPadding: EdgeInsets.symmetric(vertical: 14)))),
            const SizedBox(height: 12),
            SizedBox(width: double.infinity, child: ElevatedButton.icon(onPressed: onAdd, style: ElevatedButton.styleFrom(backgroundColor: primaryColor, padding: const EdgeInsets.symmetric(vertical: 14), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))), icon: const Icon(Icons.add_rounded, color: Colors.white), label: const Text("New Challan", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)))),
          ],
        )
      : Row(
          children: [
            Expanded(child: Container(height: 48, decoration: BoxDecoration(color: surfaceColor, borderRadius: BorderRadius.circular(12), border: Border.all(color: Colors.grey.withValues(alpha: 0.1))), child: const TextField(decoration: InputDecoration(hintText: "Search...", prefixIcon: Icon(Icons.search, size: 20), border: InputBorder.none, contentPadding: EdgeInsets.symmetric(vertical: 14))))),
            const SizedBox(width: 12),
            ElevatedButton.icon(onPressed: onAdd, style: ElevatedButton.styleFrom(backgroundColor: primaryColor, padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))), icon: const Icon(Icons.add_rounded, color: Colors.white), label: const Text("New Challan", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold))),
          ],
        );
  }
}

class _ChallanTable extends StatelessWidget {
  final List<dynamic> challans;
  final Function(Map<String,dynamic>) onEdit;
  final Function(String) onDelete;
  const _ChallanTable({required this.challans, required this.onEdit, required this.onDelete});

  @override
  Widget build(BuildContext context) {
    bool isMobile = Responsive.isMobile(context);
    if (challans.isEmpty) return const Center(child: Padding(padding: EdgeInsets.all(30), child: Text("No Challans Found")));
    if (isMobile) {
      return ListView.separated(shrinkWrap: true, physics: const NeverScrollableScrollPhysics(), itemCount: challans.length, separatorBuilder: (c, i) => const SizedBox(height: 12), itemBuilder: (c, i) => _ChallanMobileCard(data: challans[i], onEdit: onEdit, onDelete: onDelete));
    }
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(color: surfaceColor, borderRadius: BorderRadius.circular(20), boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.02), blurRadius: 10, offset: const Offset(0, 5))]),
      child: Column(
        children: [
          const _TableHeader(),
          ListView.separated(shrinkWrap: true, physics: const NeverScrollableScrollPhysics(), itemCount: challans.length, separatorBuilder: (c, i) => Divider(height: 1, color: Colors.grey.withValues(alpha: 0.05)), itemBuilder: (c, i) => _ChallanRow(data: challans[i], onEdit: onEdit, onDelete: onDelete)),
        ],
      ),
    );
  }
}

class _ChallanMobileCard extends StatelessWidget {
  final dynamic data;
  final Function(Map<String,dynamic>) onEdit;
  final Function(String) onDelete;
  const _ChallanMobileCard({required this.data, required this.onEdit, required this.onDelete});

  @override
  Widget build(BuildContext context) {
    Color statusColor;
    switch (data["status"]) {
      case "Delivered": statusColor = const Color(0xFF22C55E); break;
      case "In Transit": statusColor = const Color(0xFF3B82F6); break;
      default: statusColor = const Color(0xFFEF4444);
    }
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(color: surfaceColor, borderRadius: BorderRadius.circular(16), boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 10, offset: const Offset(0, 4))]),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(data["challanId"] ?? "", style: const TextStyle(fontWeight: FontWeight.bold, color: primaryColor)),
              Container(padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4), decoration: BoxDecoration(color: statusColor.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(6)), child: Text(data["status"] ?? "", style: TextStyle(color: statusColor, fontSize: 10, fontWeight: FontWeight.bold))),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text(data["customer"] ?? "", style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
                Text(data["routeInfo"] ?? "", style: const TextStyle(fontSize: 11, color: textSecondaryColor)),
              ])),
              Column(crossAxisAlignment: CrossAxisAlignment.end, children: [
                const Text("ITEMS", style: TextStyle(fontSize: 8, fontWeight: FontWeight.bold, color: textSecondaryColor)),
                Text(data["items"] ?? "", style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 14)),
              ]),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text(data["date"] ?? "", style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold)),
                Text("Driver: ${data["driver"] ?? ""}", style: const TextStyle(fontSize: 10, color: textSecondaryColor)),
              ]),
              Row(
                children: [
                  InkWell(onTap: () => onEdit(data), child: _buildIconButton(Icons.edit_outlined)),
                  const SizedBox(width: 8),
                  InkWell(onTap: () => onDelete(data["_id"]), child: _buildIconButton(Icons.delete_outline, color: Colors.red)),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildIconButton(IconData icon, {Color color = textPrimaryColor}) {
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
        Expanded(flex: 2, child: Text("CHALLAN ID", style: TextStyle(fontSize: 10, fontWeight: FontWeight.w900, color: Color(0xFF64748B)))),
        Expanded(flex: 3, child: Text("DESTINATION", style: TextStyle(fontSize: 10, fontWeight: FontWeight.w900, color: Color(0xFF64748B)))),
        Expanded(flex: 2, child: Text("DISPATCH INFO", style: TextStyle(fontSize: 10, fontWeight: FontWeight.w900, color: Color(0xFF64748B)))),
        Expanded(flex: 2, child: Text("MANIFEST", style: TextStyle(fontSize: 10, fontWeight: FontWeight.w900, color: Color(0xFF64748B)))),
        Expanded(flex: 2, child: Text("STATUS", style: TextStyle(fontSize: 10, fontWeight: FontWeight.w900, color: Color(0xFF64748B)))),
        Expanded(flex: 2, child: Text("ACTIONS", style: TextStyle(fontSize: 10, fontWeight: FontWeight.w900, color: Color(0xFF64748B)))),
      ]),
    );
  }
}

class _ChallanRow extends StatelessWidget {
  final dynamic data;
  final Function(Map<String,dynamic>) onEdit;
  final Function(String) onDelete;
  const _ChallanRow({required this.data, required this.onEdit, required this.onDelete});

  @override
  Widget build(BuildContext context) {
    Color statusColor;
    switch (data["status"]) {
      case "Delivered": statusColor = const Color(0xFF22C55E); break;
      case "In Transit": statusColor = const Color(0xFF3B82F6); break;
      default: statusColor = const Color(0xFFEF4444);
    }
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      child: Row(
        children: [
          Expanded(flex: 2, child: Text(data["challanId"] ?? "", style: const TextStyle(fontWeight: FontWeight.bold, color: primaryColor))),
          Expanded(flex: 3, child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(data["customer"] ?? "", style: const TextStyle(fontWeight: FontWeight.bold)),
            Text(data["routeInfo"] ?? "", style: const TextStyle(fontSize: 10, color: textSecondaryColor)),
          ])),
          Expanded(flex: 2, child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(data["date"] ?? "", style: const TextStyle(fontSize: 12)),
            Text("Driver: ${data["driver"] ?? ""}", style: const TextStyle(fontSize: 10, color: textSecondaryColor)),
          ])),
          Expanded(flex: 2, child: Text(data["items"] ?? "", style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13))),
          Expanded(flex: 2, child: Container(padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4), decoration: BoxDecoration(color: statusColor.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(8)), child: Text(data["status"] ?? "", style: TextStyle(color: statusColor, fontSize: 11, fontWeight: FontWeight.bold)))),
          Expanded(flex: 2, child: Row(children: [
            InkWell(onTap: () => onEdit(data), child: _buildIconButton(Icons.edit_outlined)),
            const SizedBox(width: 8),
            InkWell(onTap: () => onDelete(data["_id"]), child: _buildIconButton(Icons.delete_outline, color: Colors.red)),
          ])),
        ],
      ),
    );
  }

  Widget _buildIconButton(IconData icon, {Color color = textSecondaryColor}) {
    return Container(padding: const EdgeInsets.all(8), decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(8), border: Border.all(color: Colors.grey.withValues(alpha: 0.1))), child: Icon(icon, size: 16, color: color));
  }
}
