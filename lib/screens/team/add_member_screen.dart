import 'package:flutter/material.dart';
import '../../constants.dart';
import '../../responsive.dart';

class AddMemberScreen extends StatefulWidget {
  final Map<String, dynamic>? member; 
  const AddMemberScreen({super.key, this.member});

  @override
  State<AddMemberScreen> createState() => _AddMemberScreenState();
}

class _AddMemberScreenState extends State<AddMemberScreen> with SingleTickerProviderStateMixin {
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
    _slideAnimation = Tween<Offset>(begin: const Offset(0, 0.1), end: Offset.zero).animate(
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
                          constraints: const BoxConstraints(maxWidth: 800),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              _buildProfileImagePicker(),
                              const SizedBox(height: 32),
                              _buildForm(),
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
            widget.member == null ? "Add Team Member" : "Edit Team Member",
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

  Widget _buildProfileImagePicker() {
    return Center(
      child: Stack(
        children: [
          Container(
            width: 100,
            height: 100,
            decoration: BoxDecoration(
              color: const Color(0xFFF1F5F9),
              shape: BoxShape.circle,
              border: Border.all(color: Colors.grey.withValues(alpha: 0.2)),
            ),
            child: const Icon(Icons.person_rounded, size: 50, color: Color(0xFF94A3B8)),
          ),
          Positioned(
            bottom: 0,
            right: 0,
            child: Container(
              padding: const EdgeInsets.all(8),
              decoration: const BoxDecoration(
                color: Color(0xFF1E293B),
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.camera_alt_rounded, size: 16, color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildForm() {
    return Column(
      children: [
        _buildInputField("Full Name *", "Enter full name"),
        const SizedBox(height: 24),
        _buildInputField("Email *", "Enter email"),
        const SizedBox(height: 24),
        _buildResponsiveRow([
          _buildInputField("Phone", "Phone number"),
          _buildDropdownField("Role *", [
            "Salesman",
            "General Manager",
            "Senior Manager",
            "Sales Manager",
            "Zonal Sales Manager",
            "Regional Sales Manager",
            "Area Sales Manager",
            "Sales Officer",
          ], value: "Salesman"),
        ]),
        const SizedBox(height: 24),
        _buildResponsiveRow([
          _buildInputField("Territory", "Assigned territory"),
          _buildDropdownField("Reports To", ["Select supervisor", "Admin", "Manager"], value: "Select supervisor"),
        ]),
        const SizedBox(height: 24),
        _buildResponsiveRow([
          _buildInputField("Monthly Target (₹)", "0"),
          _buildInputField("Commission (%)", "0"),
        ]),
        const SizedBox(height: 24),
        _buildResponsiveRow([
           _buildInputField("Joining Date", "23/02/2026", icon: Icons.calendar_today_rounded),
           _buildStatusToggle(),
        ]),
        const SizedBox(height: 24),
        _buildInputField("Address", "Address"),
      ],
    );
  }

  Widget _buildStatusToggle() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text("Active Status", style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: Color(0xFF1E293B))),
        const SizedBox(height: 10),
        Row(
          children: [
            Switch(
              value: isActive,
              activeColor: const Color(0xFF1E293B),
              onChanged: (val) {
                setState(() {
                  isActive = val;
                });
              },
            ),
          ],
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

  Widget _buildInputField(String label, String hint, {IconData? icon}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
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
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: Colors.grey.withValues(alpha: 0.3)),
          ),
          child: TextField(
            style: const TextStyle(fontSize: 14, color: textPrimaryColor, fontWeight: FontWeight.w500),
            decoration: InputDecoration(
              hintText: hint,
              hintStyle: const TextStyle(color: Color(0xFF94A3B8), fontWeight: FontWeight.w400),
              suffixIcon: icon != null ? Icon(icon, size: 20, color: const Color(0xFF64748B)) : null,
              contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
              border: InputBorder.none,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildDropdownField(String label, List<String> options, {required String value}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
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
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: Colors.grey.withValues(alpha: 0.3)),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              value: value,
              isExpanded: true,
              icon: const Icon(Icons.keyboard_arrow_down_rounded, color: Color(0xFF64748B)),
              style: const TextStyle(fontSize: 14, color: textPrimaryColor, fontWeight: FontWeight.w500),
              items: options.map((String val) {
                return DropdownMenuItem<String>(value: val, child: Text(val));
              }).toList(),
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
          constraints: const BoxConstraints(maxWidth: 800),
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
                  padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 18),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                  elevation: 0,
                ),
                child: Text(
                  widget.member == null ? "Add Member" : "Save Changes",
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
