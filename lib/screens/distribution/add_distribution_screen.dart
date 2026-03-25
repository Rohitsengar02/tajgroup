import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../../constants.dart';

class AddDistributionScreen extends StatefulWidget {
  final Map<String, dynamic>? distribution;
  const AddDistributionScreen({super.key, this.distribution});

  @override
  State<AddDistributionScreen> createState() => _AddDistributionScreenState();
}

class _AddDistributionScreenState extends State<AddDistributionScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late TextEditingController _vehicleController;
  late TextEditingController _routeController;
  late TextEditingController _totalOrdersController;
  late TextEditingController _completedOrdersController;
  late TextEditingController _etaController;
  String _status = "Pending";
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.distribution?['driverName'] ?? "");
    _vehicleController = TextEditingController(text: widget.distribution?['vehicleNumber'] ?? "");
    _routeController = TextEditingController(text: widget.distribution?['route'] ?? "");
    _totalOrdersController = TextEditingController(text: widget.distribution?['totalOrders']?.toString() ?? "0");
    _completedOrdersController = TextEditingController(text: widget.distribution?['completedOrders']?.toString() ?? "0");
    _etaController = TextEditingController(text: widget.distribution?['eta'] ?? "");
    _status = widget.distribution?['status'] ?? "Pending";
  }

  Future<void> _saveDistribution() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);
    
    final data = {
      "driverName": _nameController.text,
      "vehicleNumber": _vehicleController.text,
      "route": _routeController.text,
      "status": _status,
      "totalOrders": int.tryParse(_totalOrdersController.text) ?? 0,
      "completedOrders": int.tryParse(_completedOrdersController.text) ?? 0,
      "eta": _etaController.text,
    };

    try {
      final url = widget.distribution == null 
          ? Uri.parse('$backendUrl/api/distribution')
          : Uri.parse('$backendUrl/api/distribution/${widget.distribution!['_id']}');
      
      final response = widget.distribution == null
          ? await http.post(url, headers: {"Content-Type": "application/json"}, body: jsonEncode(data))
          : await http.put(url, headers: {"Content-Type": "application/json"}, body: jsonEncode(data));

      if (response.statusCode == 201 || response.statusCode == 200) {
        if (mounted) Navigator.pop(context, true);
      } else {
        throw Exception("Failed to save distribution");
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Error: $e")));
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        title: Text(widget.distribution == null ? "Add New Distribution" : "Update Distribution", 
            style: const TextStyle(fontWeight: FontWeight.bold, color: textPrimaryColor)),
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: textPrimaryColor),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildModernTextField(_nameController, "Driver Name", Icons.person_outline, "Enter driver's name"),
              const SizedBox(height: 16),
              _buildModernTextField(_vehicleController, "Vehicle Number", Icons.local_shipping_outlined, "MH-12-XX-0000"),
              const SizedBox(height: 16),
              _buildModernTextField(_routeController, "Route Name", Icons.route_outlined, "e.g., Downtown Area"),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(child: _buildModernTextField(_totalOrdersController, "Total Orders", Icons.list_alt, "0", isNumber: true)),
                  const SizedBox(width: 16),
                  Expanded(child: _buildModernTextField(_completedOrdersController, "Completed", Icons.check_circle_outline, "0", isNumber: true)),
                ],
              ),
              const SizedBox(height: 16),
              _buildModernTextField(_etaController, "ETA (Estimated Time)", Icons.access_time, "e.g., 4:30 PM"),
              const SizedBox(height: 16),
              
              const Text("Current Status", style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: textPrimaryColor)),
              const SizedBox(height: 8),
              DropdownButtonFormField<String>(
                value: _status,
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
                ),
                items: ["In Transit", "Completed", "Pending"].map((s) => DropdownMenuItem(value: s, child: Text(s))).toList(),
                onChanged: (v) => setState(() => _status = v!),
              ),
              
              const SizedBox(height: 48),
              
              SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton(
                  onPressed: _isLoading ? null : _saveDistribution,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: primaryColor,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  ),
                  child: _isLoading 
                      ? const CircularProgressIndicator(color: Colors.white)
                      : Text(widget.distribution == null ? "Save Distribution" : "Update Changes", 
                          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Colors.white)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildModernTextField(TextEditingController controller, String label, IconData icon, String hint, {bool isNumber = false}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: textPrimaryColor)),
        const SizedBox(height: 8),
        TextFormField(
          controller: controller,
          keyboardType: isNumber ? TextInputType.number : TextInputType.text,
          validator: (v) => (v == null || v.isEmpty) ? "Field is required" : null,
          decoration: InputDecoration(
            hintText: hint,
            prefixIcon: Icon(icon, color: textSecondaryColor, size: 20),
            filled: true,
            fillColor: Colors.white,
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
          ),
        ),
      ],
    );
  }
}
