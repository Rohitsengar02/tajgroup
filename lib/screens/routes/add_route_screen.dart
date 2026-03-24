import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../../constants.dart';
import '../../responsive.dart';

class AddRouteScreen extends StatefulWidget {
  final Map<String, dynamic>? routeData;
  const AddRouteScreen({super.key, this.routeData});

  @override
  State<AddRouteScreen> createState() => _AddRouteScreenState();
}

class _AddRouteScreenState extends State<AddRouteScreen> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;
  
  bool isLoading = false;
  
  late TextEditingController _nameController;
  late TextEditingController _startLocationController;
  late TextEditingController _endLocationController;
  late TextEditingController _stopsController;
  late TextEditingController _distanceController;
  late TextEditingController _durationController;
  late TextEditingController _vehicleController;
  late TextEditingController _driverController;
  late TextEditingController _helperController;
  late TextEditingController _revenueController;
  late TextEditingController _ordersController;

  String _selectedStatus = "Active";
  final List<String> statusOptions = ["Active", "Pending", "Inactive"];

  bool get isEditing => widget.routeData != null;

  @override
  void initState() {
    super.initState();
    
    _nameController = TextEditingController(text: widget.routeData?['name'] ?? '');
    _startLocationController = TextEditingController(text: widget.routeData?['startLocation'] ?? '');
    _endLocationController = TextEditingController(text: widget.routeData?['endLocation'] ?? '');
    _stopsController = TextEditingController(text: widget.routeData?['stops']?.toString() ?? "0");
    _distanceController = TextEditingController(text: widget.routeData?['distance'] ?? '');
    _durationController = TextEditingController(text: widget.routeData?['duration'] ?? '');
    _vehicleController = TextEditingController(text: widget.routeData?['vehicle'] ?? '');
    _driverController = TextEditingController(text: widget.routeData?['driver'] ?? '');
    _helperController = TextEditingController(text: widget.routeData?['assignedHelper'] ?? '');
    _revenueController = TextEditingController(text: widget.routeData?['expectedRevenue']?.toString() ?? "0");
    _ordersController = TextEditingController(text: widget.routeData?['totalOrders']?.toString() ?? "0");

    if (widget.routeData != null && statusOptions.contains(widget.routeData!['status'])) {
      _selectedStatus = widget.routeData!['status'];
    }

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
    _fadeAnimation = CurvedAnimation(parent: _controller, curve: Curves.easeIn);
    _slideAnimation = Tween<Offset>(begin: const Offset(0, 0.05), end: Offset.zero).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOutCubic),
    );
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    _nameController.dispose();
    _startLocationController.dispose();
    _endLocationController.dispose();
    _stopsController.dispose();
    _distanceController.dispose();
    _durationController.dispose();
    _vehicleController.dispose();
    _driverController.dispose();
    _helperController.dispose();
    _revenueController.dispose();
    _ordersController.dispose();
    super.dispose();
  }

  Future<void> _submitData() async {
    if (_nameController.text.isEmpty || 
        _startLocationController.text.isEmpty ||
        _endLocationController.text.isEmpty ||
        _distanceController.text.isEmpty || 
        _durationController.text.isEmpty ||
        _vehicleController.text.isEmpty ||
        _driverController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Please fill all required fields (*)')));
      return;
    }

    setState(() => isLoading = true);
    try {
      final body = json.encode({
        'name': _nameController.text,
        'status': _selectedStatus,
        'startLocation': _startLocationController.text,
        'endLocation': _endLocationController.text,
        'stops': int.tryParse(_stopsController.text) ?? 0,
        'distance': _distanceController.text,
        'duration': _durationController.text,
        'vehicle': _vehicleController.text,
        'driver': _driverController.text,
        'assignedHelper': _helperController.text,
        'expectedRevenue': double.tryParse(_revenueController.text) ?? 0,
        'totalOrders': int.tryParse(_ordersController.text) ?? 0,
      });

      http.Response response;
      if (isEditing) {
        final routeId = widget.routeData!['_id'];
        response = await http.put(
          Uri.parse('$backendUrl/api/routes/$routeId'),
          headers: {'Content-Type': 'application/json'},
          body: body,
        );
      } else {
        response = await http.post(
          Uri.parse('$backendUrl/api/routes'),
          headers: {'Content-Type': 'application/json'},
          body: body,
        );
      }

      if (response.statusCode == 200 || response.statusCode == 201) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(isEditing ? 'Route updated successfully' : 'Route added successfully')));
          Navigator.pop(context, true); 
        }
      } else {
        throw Exception('Failed to save route: ${response.body}');
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error: $e'), backgroundColor: Colors.red));
      }
    } finally {
      if (mounted) {
        setState(() => isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Material(
        color: Colors.white,
        child: FadeTransition(
          opacity: _fadeAnimation,
          child: SlideTransition(
            position: _slideAnimation,
            child: SafeArea(
              child: Column(
                children: [
                  _buildHeader(context),
                  Expanded(
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.all(defaultPadding * 1.5),
                      child: Center(
                        child: Container(
                          constraints: const BoxConstraints(maxWidth: 900),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              _buildFormSection(
                                icon: Icons.route_outlined,
                                title: "BASIC ROUTE INFO",
                                children: [
                                  _buildResponsiveRow([
                                    _buildInputField("Route Name *", "Enter route name (e.g., Highway A)", controller: _nameController),
                                    _buildDropdownField("Status", statusOptions, _selectedStatus, (val) => setState(() => _selectedStatus = val!)),
                                  ]),
                                  const SizedBox(height: 24),
                                  _buildResponsiveRow([
                                    _buildInputField("Start Location *", "Enter start point", controller: _startLocationController),
                                    _buildInputField("End Location *", "Enter end point", controller: _endLocationController),
                                  ]),
                                ],
                              ),
                              _buildFormSection(
                                icon: Icons.map_outlined,
                                title: "METRICS & DISTRIBUTIONS",
                                children: [
                                  _buildResponsiveRow([
                                    _buildInputField("Distance *", "e.g., 45 km", controller: _distanceController),
                                    _buildInputField("Estimated Duration *", "e.g., 4.5 hrs", controller: _durationController),
                                  ]),
                                  const SizedBox(height: 24),
                                  _buildResponsiveRow([
                                    _buildInputField("Total Stops", "e.g., 12", controller: _stopsController, keyboardType: TextInputType.number),
                                    _buildInputField("Total Target Orders", "e.g., 150", controller: _ordersController, keyboardType: TextInputType.number),
                                  ]),
                                ],
                              ),
                              _buildFormSection(
                                icon: Icons.local_shipping_outlined,
                                title: "LOGISTICS & CREW",
                                children: [
                                  _buildResponsiveRow([
                                    _buildInputField("Assigned Vehicle *", "e.g., MH-12-AB-1234", controller: _vehicleController),
                                    _buildInputField("Driver Name *", "Enter driver name", controller: _driverController),
                                  ]),
                                  const SizedBox(height: 24),
                                  _buildResponsiveRow([
                                    _buildInputField("Co-Driver/Helper", "Enter helper name (Optional)", controller: _helperController),
                                    _buildInputField("Expected Revenue (₹)", "e.g., 50000", controller: _revenueController, keyboardType: TextInputType.number),
                                  ]),
                                ],
                              ),
                              const SizedBox(height: 100),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                  _buildFooter(context),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: defaultPadding, vertical: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(bottom: BorderSide(color: Colors.grey.withValues(alpha: 0.1))),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            isEditing ? "Edit Route" : "Create Route",
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Color(0xFF1E293B)),
          ),
          IconButton(
            icon: const Icon(Icons.close_rounded, color: textSecondaryColor),
            onPressed: () => Navigator.pop(context),
          ),
        ],
      ),
    );
  }

  Widget _buildFormSection({required IconData icon, required String title, required List<Widget> children}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 32),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, size: 18, color: const Color(0xFF64748B)),
              const SizedBox(width: 8),
              Text(
                 title,
                style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Color(0xFF64748B), letterSpacing: 0.5),
              ),
            ],
          ),
          const SizedBox(height: 20),
          ...children,
        ],
      ),
    );
  }

  Widget _buildResponsiveRow(List<Widget> children) {
     if (Responsive.isMobile(context)) {
      return Column(children: children.map((c) => Padding(padding: const EdgeInsets.only(bottom: 24), child: c)).toList());
    }
     return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: children.map((c) => Expanded(child: Padding(padding: const EdgeInsets.only(right: 24), child: c))).toList(),
    );
  }

  Widget _buildInputField(String label, String hint, {int maxLines = 1, TextEditingController? controller, TextInputType? keyboardType}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
       children: [
        if (label.isNotEmpty) ...[
          RichText(
            text: TextSpan(
               children: [
                TextSpan(text: label.replaceAll(" *", ""), style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: Color(0xFF1E293B))),
                if (label.contains("*"))
                  const TextSpan(text: " *", style: TextStyle(color: Colors.red, fontSize: 14, fontWeight: FontWeight.bold)),
              ],
            ),
          ),
          const SizedBox(height: 10),
        ],
        Container(
           decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: Colors.grey.withValues(alpha: 0.3)),
          ),
          child: TextField(
            controller: controller,
            maxLines: maxLines,
            keyboardType: keyboardType,
            style: const TextStyle(fontSize: 14, color: textPrimaryColor, fontWeight: FontWeight.w500),
            decoration: InputDecoration(
               hintText: hint,
              hintStyle: const TextStyle(color: Color(0xFF94A3B8), fontWeight: FontWeight.w400),
              contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
              border: InputBorder.none,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildDropdownField(String label, List<String> options, String currentValue, ValueChanged<String?> onChanged) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
       children: [
        if (label.isNotEmpty) ...[
          Text(label, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: Color(0xFF1E293B))),
          const SizedBox(height: 10),
        ],
        Container(
           padding: const EdgeInsets.symmetric(horizontal: 16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: Colors.grey.withValues(alpha: 0.3)),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
               value: currentValue,
              isExpanded: true,
              icon: const Icon(Icons.keyboard_arrow_down_rounded, color: Color(0xFF64748B)),
              style: const TextStyle(fontSize: 14, color: textPrimaryColor, fontWeight: FontWeight.w500),
              items: options.map((String val) => DropdownMenuItem(value: val, child: Text(val))).toList(),
              onChanged: onChanged,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildFooter(BuildContext context) {
     return Container(
      padding: const EdgeInsets.all(defaultPadding),
      decoration: BoxDecoration(
         color: Colors.white,
        border: Border(top: BorderSide(color: Colors.grey.withValues(alpha: 0.1))),
      ),
      child: Center(
        child: Container(
           constraints: const BoxConstraints(maxWidth: 900),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              OutlinedButton(
                 onPressed: () => Navigator.pop(context),
                style: OutlinedButton.styleFrom(
                   foregroundColor: const Color(0xFF1E293B),
                  side: BorderSide(color: Colors.grey.withValues(alpha: 0.3)),
                  padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 18),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                ),
                child: const Text("Cancel", style: TextStyle(fontWeight: FontWeight.bold)),
              ),
              const SizedBox(width: 16),
              ElevatedButton(
                 onPressed: isLoading ? null : _submitData,
                style: ElevatedButton.styleFrom(
                   backgroundColor: const Color(0xFF1E293B),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 18),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                  elevation: 0,
                  disabledBackgroundColor: Colors.grey,
                ),
                child: isLoading
                    ? const SizedBox(height: 20, width: 20, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
                    : Text(isEditing ? "Save Changes" : "Create Route", style: const TextStyle(fontWeight: FontWeight.bold)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
