import 'package:flutter/material.dart';
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

  @override
  void initState() {
    super.initState();
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
    super.dispose();
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
                                    _buildInputField("Customer Name *", "Enter customer name"),
                                    _buildInputField("Shop Owner Name", "Enter shop owner name"),
                                  ]),
                                ],
                              ),
                              _buildFormSection(
                                icon: Icons.storefront_rounded,
                                title: "SHOP DETAILS",
                                children: [
                                  _buildResponsiveRow([
                                    _buildInputField("Shop Name *", "Enter shop/business name"),
                                    _buildInputField("GST Number", "e.g., 22AAAAA0000A1Z5"),
                                  ]),
                                  const SizedBox(height: 24),
                                  _buildInputField("Shop Address", "Enter complete shop address", maxLines: 3),
                                  const SizedBox(height: 24),
                                  _buildResponsiveRow([
                                    _buildInputField("Town/City", "Enter town/city"),
                                    _buildInputField("Territory", "Enter territory/region"),
                                  ]),
                                ],
                              ),
                              _buildFormSection(
                                icon: Icons.phone_outlined,
                                title: "CONTACT INFORMATION",
                                children: [
                                  _buildResponsiveRow([
                                    _buildInputField("Phone Number *", "Enter phone number"),
                                    _buildInputField("Mobile Number", "Enter mobile number"),
                                  ]),
                                  const SizedBox(height: 24),
                                  _buildInputField("Email ID", "Enter email address"),
                                ],
                              ),
                              _buildFormSection(
                                 icon: Icons.location_on_outlined,
                                 title: "BEAT & ASSIGNMENT",
                                 children: [
                                   Responsive.isMobile(context)
                                     ? Column(
                                         children: [
                                           _buildInputField("Beat (Optional)", "Enter beat/route"),
                                           const SizedBox(height: 24),
                                           _buildDropdownField("Assigned Salesman", ["Select salesman", "Rajesh Kumar", "Priya Singh"]),
                                           const SizedBox(height: 24),
                                           _buildDropdownField("Assigned Distributor", ["Select distributor", "Mumbai Super Stockist"]),
                                         ],
                                       )
                                     : Row(
                                         crossAxisAlignment: CrossAxisAlignment.start,
                                         children: [
                                           Expanded(
                                             flex: 2,
                                             child: _buildInputField("Beat (Optional)", "Enter beat/route"),
                                           ),
                                           const SizedBox(width: 16),
                                           Expanded(
                                             flex: 3,
                                             child: _buildDropdownField("Assigned Salesman", ["Select salesman", "Rajesh Kumar", "Priya Singh"]),
                                           ),
                                           const SizedBox(width: 16),
                                           Expanded(
                                             flex: 3,
                                             child: _buildDropdownField("Assigned Distributor", ["Select distributor", "Mumbai Super Stockist"]),
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
                                        child: _buildDropdownField("", ["Select product to add", "Product A", "Product B"]),
                                      ),
                                      const SizedBox(width: 12),
                                      Container(
                                        height: 52,
                                        width: 52,
                                        decoration: BoxDecoration(
                                          border: Border.all(color: Colors.grey.withValues(alpha: 0.3)),
                                          borderRadius: BorderRadius.circular(8),
                                        ),
                                        child: const Icon(Icons.add_rounded, color: textPrimaryColor),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                              const SizedBox(height: 24),
                              _buildResponsiveRow([
                                _buildInputField("Credit Limit (₹)", "0"),
                                _buildStatusToggle(),
                              ]),
                              const SizedBox(height: 24),
                              _buildInputField("Notes", "Enter any special notes here", maxLines: 2),
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
            text: const TextSpan(
              style: TextStyle(fontSize: 14, color: Color(0xFF64748B)),
              children: [
                TextSpan(text: "Customer ID: "),
                TextSpan(text: "CUS33505102", style: TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF1E293B))),
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

  Widget _buildInputField(String label, String hint, {int maxLines = 1}) {
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
            maxLines: maxLines,
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

  Widget _buildDropdownField(String label, List<String> options) {
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
              value: options.first,
              isExpanded: true,
              icon: const Icon(Icons.keyboard_arrow_down_rounded, color: Color(0xFF64748B)),
              style: const TextStyle(fontSize: 14, color: textPrimaryColor, fontWeight: FontWeight.w500),
              items: options.map((String val) => DropdownMenuItem(value: val, child: Text(val))).toList(),
              onChanged: (_) {},
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
                onPressed: () => Navigator.pop(context),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF1E293B),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 18),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                  elevation: 0,
                ),
                child: const Text("Add Customer", style: TextStyle(fontWeight: FontWeight.bold)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
