import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../../constants.dart';
import '../../responsive.dart';

class AddCustomerScreen extends StatefulWidget {
  const AddCustomerScreen({super.key});

  @override
  State<AddCustomerScreen> createState() => _AddCustomerScreenState();
}

class _AddCustomerScreenState extends State<AddCustomerScreen> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;
  
  bool isActive = true;
  bool isLoading = false;
  late String _generatedCustomerId;
  
  final _customerNameController = TextEditingController();
  final _shopOwnerNameController = TextEditingController();
  final _shopNameController = TextEditingController();
  final _gstNumberController = TextEditingController();
  final _shopAddressController = TextEditingController();
  final _townCityController = TextEditingController();
  final _territoryController = TextEditingController();
  final _phoneNumberController = TextEditingController();
  final _mobileNumberController = TextEditingController();
  final _emailController = TextEditingController();
  final _beatController = TextEditingController();
  final _creditLimitController = TextEditingController(text: "0");
  final _notesController = TextEditingController();

  String _selectedSalesman = "Select salesman";
  String _selectedDistributor = "Select distributor";
  String _selectedProduct = "Select product to add";
  List<String> _preferredProducts = [];

  final List<String> salesmanOptions = ["Select salesman", "Rajesh Kumar", "Priya Singh"];
  final List<String> distributorOptions = ["Select distributor", "Mumbai Super Stockist"];
  List<String> productOptions = ["Select product to add"];

  @override
  void initState() {
    super.initState();
    _fetchProducts();
    _generatedCustomerId = "CUS${DateTime.now().millisecondsSinceEpoch.toString().substring(5)}";
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

  Future<void> _fetchProducts() async {
    try {
      final response = await http.get(Uri.parse('$backendUrl/api/products'));
      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        if (mounted) {
          setState(() {
            final fetched = data.map((p) => p['name'].toString()).toList();
            productOptions = ["Select product to add", ...fetched];
          });
        }
      }
    } catch (e) {
      debugPrint('Error fetching products: $e');
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    _customerNameController.dispose();
    _shopOwnerNameController.dispose();
    _shopNameController.dispose();
    _gstNumberController.dispose();
    _shopAddressController.dispose();
    _townCityController.dispose();
    _territoryController.dispose();
    _phoneNumberController.dispose();
    _mobileNumberController.dispose();
    _emailController.dispose();
    _beatController.dispose();
    _creditLimitController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  Future<void> _submitData() async {
    if (_customerNameController.text.isEmpty || _shopNameController.text.isEmpty || _phoneNumberController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Please fill all required fields (*)')));
      return;
    }

    setState(() => isLoading = true);
    try {
      final response = await http.post(
        Uri.parse('$backendUrl/api/customers'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'customerId': _generatedCustomerId,
          'customerName': _customerNameController.text,
          'shopOwnerName': _shopOwnerNameController.text,
          'shopName': _shopNameController.text,
          'gstNumber': _gstNumberController.text,
          'shopAddress': _shopAddressController.text,
          'townCity': _townCityController.text,
          'territory': _territoryController.text,
          'phoneNumber': _phoneNumberController.text,
          'mobileNumber': _mobileNumberController.text,
          'email': _emailController.text,
          'beat': _beatController.text,
          'assignedSalesman': _selectedSalesman == "Select salesman" ? "" : _selectedSalesman,
          'assignedDistributor': _selectedDistributor == "Select distributor" ? "" : _selectedDistributor,
          'preferredProducts': _preferredProducts,
          'creditLimit': double.tryParse(_creditLimitController.text) ?? 0,
          'isActive': isActive,
          'notes': _notesController.text,
          'customerType': 'Retailer', 
        }),
      );

      if (response.statusCode == 201) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Customer added successfully')));
          Navigator.pop(context, true); 
        }
      } else {
        throw Exception('Failed to add customer: ${response.body}');
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

  void _addProduct() {
    if (_selectedProduct != "Select product to add" && !_preferredProducts.contains(_selectedProduct)) {
      setState(() {
        _preferredProducts.add(_selectedProduct);
        _selectedProduct = "Select product to add";
      });
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
                              _buildCustomerIdBanner(),
                              const SizedBox(height: 32),
                              _buildFormSection(
                                icon: Icons.person_outline_rounded,
                                title: "BASIC INFORMATION",
                                children: [
                                  _buildResponsiveRow([
                                    _buildInputField("Customer Name *", "Enter customer name", controller: _customerNameController),
                                    _buildInputField("Shop Owner Name", "Enter shop owner name", controller: _shopOwnerNameController),
                                  ]),
                                ],
                              ),
                              _buildFormSection(
                                icon: Icons.storefront_rounded,
                                title: "SHOP DETAILS",
                                children: [
                                  _buildResponsiveRow([
                                    _buildInputField("Shop Name *", "Enter shop/business name", controller: _shopNameController),
                                    _buildInputField("GST Number", "e.g., 22AAAAA0000A1Z5", controller: _gstNumberController),
                                  ]),
                                  const SizedBox(height: 24),
                                  _buildInputField("Shop Address", "Enter complete shop address", maxLines: 3, controller: _shopAddressController),
                                  const SizedBox(height: 24),
                                  _buildResponsiveRow([
                                    _buildInputField("Town/City", "Enter town/city", controller: _townCityController),
                                    _buildInputField("Territory", "Enter territory/region", controller: _territoryController),
                                  ]),
                                ],
                              ),
                              _buildFormSection(
                                icon: Icons.phone_outlined,
                                title: "CONTACT INFORMATION",
                                children: [
                                  _buildResponsiveRow([
                                    _buildInputField("Phone Number *", "Enter phone number", controller: _phoneNumberController, keyboardType: TextInputType.phone),
                                    _buildInputField("Mobile Number", "Enter mobile number", controller: _mobileNumberController, keyboardType: TextInputType.phone),
                                  ]),
                                  const SizedBox(height: 24),
                                  _buildInputField("Email ID", "Enter email address", controller: _emailController, keyboardType: TextInputType.emailAddress),
                                ],
                              ),
                              _buildFormSection(
                                 icon: Icons.location_on_outlined,
                                 title: "BEAT & ASSIGNMENT",
                                 children: [
                                   Responsive.isMobile(context)
                                     ? Column(
                                         children: [
                                           _buildInputField("Beat (Optional)", "Enter beat/route", controller: _beatController),
                                           const SizedBox(height: 24),
                                           _buildDropdownField("Assigned Salesman", salesmanOptions, _selectedSalesman, (val) => setState(() => _selectedSalesman = val!)),
                                           const SizedBox(height: 24),
                                           _buildDropdownField("Assigned Distributor", distributorOptions, _selectedDistributor, (val) => setState(() => _selectedDistributor = val!)),
                                         ],
                                       )
                                     : Row(
                                         crossAxisAlignment: CrossAxisAlignment.start,
                                         children: [
                                           Expanded(
                                             flex: 2,
                                             child: _buildInputField("Beat (Optional)", "Enter beat/route", controller: _beatController),
                                           ),
                                           const SizedBox(width: 16),
                                           Expanded(
                                             flex: 3,
                                             child: _buildDropdownField("Assigned Salesman", salesmanOptions, _selectedSalesman, (val) => setState(() => _selectedSalesman = val!)),
                                           ),
                                           const SizedBox(width: 16),
                                           Expanded(
                                             flex: 3,
                                             child: _buildDropdownField("Assigned Distributor", distributorOptions, _selectedDistributor, (val) => setState(() => _selectedDistributor = val!)),
                                           ),
                                         ],
                                       ),
                                 ],
                               ),
                              _buildFormSection(
                                icon: Icons.inventory_2_outlined,
                                title: "PREFERRED PRODUCTS",
                                children: [
                                  Row(
                                    children: [
                                      Expanded(
                                        child: _buildDropdownField("", productOptions, _selectedProduct, (val) => setState(() => _selectedProduct = val!)),
                                      ),
                                      const SizedBox(width: 12),
                                      InkWell(
                                        onTap: _addProduct,
                                        child: Container(
                                          height: 52,
                                          width: 52,
                                          decoration: BoxDecoration(
                                            color: Colors.grey.withValues(alpha: 0.1),
                                            border: Border.all(color: Colors.grey.withValues(alpha: 0.3)),
                                            borderRadius: BorderRadius.circular(8),
                                          ),
                                          child: const Icon(Icons.add_rounded, color: textPrimaryColor),
                                        ),
                                      ),
                                    ],
                                  ),
                                  if (_preferredProducts.isNotEmpty) ...[
                                    const SizedBox(height: 16),
                                    Wrap(
                                      spacing: 8,
                                      runSpacing: 8,
                                      children: _preferredProducts.map((prod) => Chip(
                                        label: Text(prod, style: const TextStyle(fontSize: 12)),
                                        onDeleted: () => setState(() => _preferredProducts.remove(prod)),
                                        deleteIcon: const Icon(Icons.close, size: 16),
                                      )).toList(),
                                    )
                                  ]
                                ],
                              ),
                              const SizedBox(height: 24),
                              _buildResponsiveRow([
                                _buildInputField("Credit Limit (₹)", "0", controller: _creditLimitController, keyboardType: TextInputType.number),
                                _buildStatusToggle(),
                              ]),
                              const SizedBox(height: 24),
                              _buildInputField("Notes", "Enter any special notes here", maxLines: 2, controller: _notesController),
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
          const Text(
            "Add New Customer",
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Color(0xFF1E293B)),
          ),
          IconButton(
            icon: const Icon(Icons.close_rounded, color: textSecondaryColor),
            onPressed: () => Navigator.pop(context),
          ),
        ],
      ),
    );
  }

  Widget _buildCustomerIdBanner() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFF8FAFC),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: const Color(0xFFE2E8F0)),
      ),
      child: Row(
        children: [
          const Icon(Icons.description_outlined, size: 20, color: Color(0xFF64748B)),
          const SizedBox(width: 12),
          RichText(
             text: TextSpan(
              style: const TextStyle(fontSize: 14, color: Color(0xFF64748B)),
              children: [
                const TextSpan(text: "Customer ID: "),
                TextSpan(text: _generatedCustomerId, style: const TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF1E293B))),
              ],
            ),
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

  Widget _buildStatusToggle() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
         const Text("Active Status", style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: Color(0xFF1E293B))),
        const SizedBox(height: 10),
        Switch(
          value: isActive,
          activeColor: const Color(0xFF1E293B),
          onChanged: (val) => setState(() => isActive = val),
        ),
      ],
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
                    : const Text("Add Customer", style: TextStyle(fontWeight: FontWeight.bold)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
