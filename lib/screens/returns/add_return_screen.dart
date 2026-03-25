import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../../constants.dart';

class AddReturnScreen extends StatefulWidget {
  final Map<String, dynamic>? returnData;
  const AddReturnScreen({super.key, this.returnData});

  @override
  State<AddReturnScreen> createState() => _AddReturnScreenState();
}

class _AddReturnScreenState extends State<AddReturnScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _customerController;
  late TextEditingController _itemsController;
  late TextEditingController _notesController;
  String _reason = 'Expired';
  String _status = 'Pending';
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _customerController = TextEditingController(text: widget.returnData?['customerName'] ?? "");
    _itemsController = TextEditingController(text: widget.returnData?['items'] ?? "");
    _notesController = TextEditingController(text: widget.returnData?['notes'] ?? "");
    _reason = widget.returnData?['reason'] ?? 'Expired';
    _status = widget.returnData?['status'] ?? 'Pending';
  }

  Future<void> _saveReturn() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);
    
    final data = {
      "customerName": _customerController.text,
      "items": _itemsController.text,
      "reason": _reason,
      "status": _status,
      "notes": _notesController.text,
    };

    try {
      final url = widget.returnData == null 
          ? Uri.parse('$backendUrl/api/returns')
          : Uri.parse('$backendUrl/api/returns/${widget.returnData!['_id']}');
      
      final response = widget.returnData == null
          ? await http.post(url, headers: {"Content-Type": "application/json"}, body: jsonEncode(data))
          : await http.put(url, headers: {"Content-Type": "application/json"}, body: jsonEncode(data));

      if (response.statusCode == 201 || response.statusCode == 200) {
        if (mounted) Navigator.pop(context, true);
      } else {
        throw Exception("Failed to save return record");
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
        title: Text(widget.returnData == null ? "Log New Return" : "Edit Return Record", 
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
              _buildFieldLabel("Customer Name"),
              const SizedBox(height: 8),
              _buildModernTextField(_customerController, "Enter customer or agency name", Icons.storefront_outlined),
              const SizedBox(height: 16),
              
              _buildFieldLabel("Items to Return"),
              const SizedBox(height: 8),
              _buildModernTextField(_itemsController, "e.g., 5 Boxes of Taj Tea", Icons.inventory_2_outlined),
              const SizedBox(height: 16),
              
              _buildFieldLabel("Return Reason"),
              const SizedBox(height: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12)),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<String>(
                    value: _reason,
                    isExpanded: true,
                    items: ['Expired', 'Damaged', 'Wrong Item', 'Quality Issue', 'Other']
                        .map((s) => DropdownMenuItem(value: s, child: Text(s))).toList(),
                    onChanged: (v) => setState(() => _reason = v!),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              
              _buildFieldLabel("Notes / Additional Details"),
              const SizedBox(height: 8),
              TextFormField(
                controller: _notesController,
                maxLines: 3,
                decoration: InputDecoration(
                  hintText: "Enter any special instructions or details...",
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
                ),
              ),
              const SizedBox(height: 16),
              
              if (widget.returnData != null) ...[
                _buildFieldLabel("Current Status"),
                const SizedBox(height: 8),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12)),
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton<String>(
                      value: _status,
                      isExpanded: true,
                      items: ['Pending', 'Approved', 'Rejected', 'Replaced', 'Refunded']
                          .map((s) => DropdownMenuItem(value: s, child: Text(s))).toList(),
                      onChanged: (v) => setState(() => _status = v!),
                    ),
                  ),
                ),
              ],
              
              const SizedBox(height: 48),
              
              SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton(
                  onPressed: _isLoading ? null : _saveReturn,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: errorColor,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  ),
                  child: _isLoading 
                      ? const CircularProgressIndicator(color: Colors.white)
                      : Text(widget.returnData == null ? "Log Sales Return" : "Update Record", 
                          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Colors.white)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFieldLabel(String label) {
    return Text(label, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: textPrimaryColor));
  }

  Widget _buildModernTextField(TextEditingController controller, String hint, IconData icon) {
    return TextFormField(
      controller: controller,
      validator: (v) => (v == null || v.isEmpty) ? "Required" : null,
      decoration: InputDecoration(
        hintText: hint,
        prefixIcon: Icon(icon, color: textSecondaryColor, size: 20),
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
      ),
    );
  }
}
