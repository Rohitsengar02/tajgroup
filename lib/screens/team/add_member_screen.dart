import 'package:flutter/material.dart';
import '../../constants.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:intl/intl.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'dart:typed_data';

class AddMemberScreen extends StatefulWidget {
  final Map<String, dynamic>? member; 
  const AddMemberScreen({super.key, this.member});

  @override
  State<AddMemberScreen> createState() => _AddMemberScreenState();
}

class _AddMemberScreenState extends State<AddMemberScreen> {
  final _formKey = GlobalKey<FormState>();
  
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _phoneController = TextEditingController();
  final _territoryController = TextEditingController();
  final _targetController = TextEditingController(text: "0");
  final _commissionController = TextEditingController(text: "0");
  final _addressController = TextEditingController();
  final _reportsToController = TextEditingController();

  String _selectedRole = "Sales Person";
  bool _isActive = true;
  DateTime _joiningDate = DateTime.now();
  bool _isSaving = false;
  String? _profileUrl;
  bool _isUploading = false;
  bool _obscurePassword = true;

  final List<String> _roles = [
    "Admin",
    "Super Stockist",
    "Distributor",
    "Sales Person",
    "Retailer"
  ];

  @override
  void initState() {
    super.initState();
    if (widget.member != null) {
      _nameController.text = widget.member!['name'] ?? "";
      _emailController.text = widget.member!['email'] ?? "";
      _phoneController.text = widget.member!['phone'] ?? "";
      _territoryController.text = widget.member!['territory'] ?? "";
      _targetController.text = (widget.member!['monthlyTarget'] ?? 0).toString();
      _commissionController.text = (widget.member!['commission'] ?? 0).toString();
      _addressController.text = widget.member!['address'] ?? "";
      _reportsToController.text = widget.member!['reportsTo'] ?? "";
      _selectedRole = widget.member!['role'] ?? "Sales Person";
      _isActive = widget.member!['isActive'] ?? true;
      _profileUrl = widget.member!['profileImage'];
      if (widget.member!['joiningDate'] != null) {
        _joiningDate = DateTime.parse(widget.member!['joiningDate']);
      }
    }
  }

  Future<void> _pickAndUploadImage() async {
    final picker = ImagePicker();
    final image = await picker.pickImage(source: ImageSource.gallery, imageQuality: 50);
    if (image != null) {
      setState(() => _isUploading = true);
      final bytes = await image.readAsBytes();
      final url = await _uploadToCloudinary(bytes, image.name);
      if (url != null) {
        setState(() => _profileUrl = url);
      }
      setState(() => _isUploading = false);
    }
  }

  Future<String?> _uploadToCloudinary(Uint8List bytes, String fileName) async {
    try {
      final cloudName = dotenv.get('CLOUDINARY_CLOUD_NAME');
      final uploadPreset = dotenv.get('CLOUDINARY_UPLOAD_PRESET');
      final uri = Uri.parse("https://api.cloudinary.com/v1_1/$cloudName/image/upload");
      final request = http.MultipartRequest("POST", uri);
      request.fields['upload_preset'] = uploadPreset;
      request.files.add(http.MultipartFile.fromBytes('file', bytes, filename: fileName));
      final response = await request.send();
      if (response.statusCode == 200) {
        final responseData = await response.stream.toBytes();
        final jsonResponse = jsonDecode(String.fromCharCodes(responseData));
        return jsonResponse['secure_url'];
      }
    } catch (e) {
      debugPrint("Upload error: $e");
    }
    return null;
  }

  Future<void> _saveMember() async {
    if (!_formKey.currentState!.validate()) return;
    if (widget.member == null && _passwordController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Password is required for new members")));
      return;
    }

    setState(() => _isSaving = true);

    final data = {
      "name": _nameController.text,
      "email": _emailController.text,
      "phone": _phoneController.text,
      "role": _selectedRole,
      "territory": _territoryController.text,
      "reportsTo": _reportsToController.text,
      "monthlyTarget": double.tryParse(_targetController.text) ?? 0,
      "commission": double.tryParse(_commissionController.text) ?? 0,
      "address": _addressController.text,
      "isActive": _isActive,
      "joiningDate": _joiningDate.toIso8601String(),
      "profileImage": _profileUrl,
    };

    if (_passwordController.text.isNotEmpty) {
      data["password"] = _passwordController.text;
    }

    try {
      late http.Response response;
      if (widget.member == null) {
        response = await http.post(
          Uri.parse('$backendUrl/api/team'),
          headers: {"Content-Type": "application/json"},
          body: jsonEncode(data),
        );
      } else {
        response = await http.put(
          Uri.parse('$backendUrl/api/team/${widget.member!['_id']}'),
          headers: {"Content-Type": "application/json"},
          body: jsonEncode(data),
        );
      }

      if (response.statusCode == 201 || response.statusCode == 200) {
        if (mounted) {
          Navigator.pop(context, true);
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(widget.member == null ? "Member added successfully" : "Member updated successfully")),
          );
        }
      } else {
        final err = jsonDecode(response.body);
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(err['message'] ?? "Error occurred"), backgroundColor: errorColor),
          );
        }
      }
    } catch (e) {
      debugPrint("Error saving: $e");
    } finally {
      if (mounted) setState(() => _isSaving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        title: Text(widget.member == null ? "Add Team Member" : "Edit Member", style: const TextStyle(fontWeight: FontWeight.bold, color: textPrimaryColor)),
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(icon: const Icon(Icons.close_rounded, color: textPrimaryColor), onPressed: () => Navigator.pop(context)),
        actions: [
          if (_isSaving)
            const Center(child: Padding(padding: EdgeInsets.only(right: 20), child: CircularProgressIndicator(strokeWidth: 2)))
          else
            TextButton(
              onPressed: _saveMember,
              child: const Text("SAVE", style: TextStyle(fontWeight: FontWeight.bold, color: primaryColor)),
            ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(defaultPadding),
        child: Center(
          child: Container(
            constraints: const BoxConstraints(maxWidth: 800),
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                   Center(
                    child: Stack(
                      children: [
                        Container(
                          width: 100,
                          height: 100,
                          decoration: BoxDecoration(
                            color: bgColor,
                            shape: BoxShape.circle,
                            image: _profileUrl != null ? DecorationImage(image: NetworkImage(_profileUrl!), fit: BoxFit.cover) : null,
                          ),
                          child: _profileUrl == null ? const Icon(Icons.person, size: 50, color: textSecondaryColor) : null,
                        ),
                        if (_isUploading)
                          const Positioned.fill(child: Center(child: CircularProgressIndicator())),
                        Positioned(
                          bottom: 0,
                          right: 0,
                          child: InkWell(
                            onTap: _pickAndUploadImage,
                            child: Container(
                              padding: const EdgeInsets.all(8),
                              decoration: const BoxDecoration(color: primaryColor, shape: BoxShape.circle),
                              child: const Icon(Icons.camera_alt, size: 16, color: Colors.white),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 32),
                  _buildSection("Authentication", [
                    _buildInputField("Email Address *", _emailController, hint: "Enter email", validator: (v) => v!.isEmpty ? "Required" : null),
                    const SizedBox(height: 20),
                    _buildInputField(
                      "Login Password ${widget.member == null ? '*' : '(Leave blank to keep current)'}", 
                      _passwordController, 
                      hint: "Enter password", 
                      obscure: _obscurePassword,
                      suffix: IconButton(
                        icon: Icon(_obscurePassword ? Icons.visibility_off : Icons.visibility),
                        onPressed: () => setState(() => _obscurePassword = !_obscurePassword),
                      ),
                    ),
                  ]),
                  const SizedBox(height: 20),
                  _buildSection("Basic Information", [
                    _buildInputField("Full Name *", _nameController, hint: "Enter name", validator: (v) => v!.isEmpty ? "Required" : null),
                    const SizedBox(height: 20),
                    Row(
                      children: [
                        Expanded(child: _buildInputField("Phone", _phoneController, hint: "Enter phone")),
                        const SizedBox(width: 16),
                        Expanded(child: _buildDropdownField("Role *", _roles, _selectedRole, (v) => setState(() => _selectedRole = v!))),
                      ],
                    ),
                  ]),
                  const SizedBox(height: 20),
                  _buildSection("Territory & Reporting", [
                    Row(
                      children: [
                        Expanded(child: _buildInputField("Territory", _territoryController, hint: "Assigned area")),
                        const SizedBox(width: 16),
                        Expanded(child: _buildInputField("Reports To", _reportsToController, hint: "Supervisor name")),
                      ],
                    ),
                  ]),
                  const SizedBox(height: 20),
                  _buildSection("Performance Targets", [
                    Row(
                      children: [
                        Expanded(child: _buildInputField("Monthly Target (₹)", _targetController, keyboard: TextInputType.number)),
                        const SizedBox(width: 16),
                        Expanded(child: _buildInputField("Commission (%)", _commissionController, keyboard: TextInputType.number)),
                      ],
                    ),
                  ]),
                  const SizedBox(height: 20),
                  _buildSection("Additional Details", [
                    _buildDatePicker("Joining Date", _joiningDate, (d) => setState(() => _joiningDate = d)),
                    const SizedBox(height: 20),
                    _buildInputField("Address", _addressController, hint: "Full postal address", maxLines: 2),
                    const SizedBox(height: 20),
                    _buildStatusToggle(),
                  ]),
                  const SizedBox(height: 40),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSection(String title, List<Widget> children) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16), boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.02), blurRadius: 10)]),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: textPrimaryColor)),
          const Divider(height: 32),
          ...children,
        ],
      ),
    );
  }

  Widget _buildInputField(String label, TextEditingController ctrl, {String? hint, String? Function(String?)? validator, int maxLines = 1, TextInputType? keyboard, bool obscure = false, Widget? suffix}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: textSecondaryColor)),
        TextFormField(
          controller: ctrl,
          validator: validator,
          maxLines: maxLines,
          obscureText: obscure,
          keyboardType: keyboard,
          style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
          decoration: InputDecoration(hintText: hint, border: const UnderlineInputBorder(), suffixIcon: suffix),
        ),
      ],
    );
  }

  Widget _buildDropdownField(String label, List<String> items, String value, Function(String?) onChanged) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: textSecondaryColor)),
        DropdownButton<String>(
          isExpanded: true,
          value: items.contains(value) ? value : items.first,
          items: items.map((e) => DropdownMenuItem(value: e, child: Text(e, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold)))).toList(),
          onChanged: onChanged,
        ),
      ],
    );
  }

  Widget _buildDatePicker(String label, DateTime date, Function(DateTime) onPicked) {
    return InkWell(
      onTap: () async {
        final picked = await showDatePicker(context: context, initialDate: date, firstDate: DateTime(2000), lastDate: DateTime(2101));
        if (picked != null) onPicked(picked);
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: textSecondaryColor)),
          const SizedBox(height: 12),
          Row(
            children: [
              const Icon(Icons.calendar_month, size: 18, color: primaryColor),
              const SizedBox(width: 12),
              Text(DateFormat('dd MMM, yyyy').format(date), style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
            ],
          ),
          const Divider(),
        ],
      ),
    );
  }

  Widget _buildStatusToggle() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Text("Active Status", style: TextStyle(fontWeight: FontWeight.bold, color: textPrimaryColor)),
        Switch(
          value: _isActive,
          activeColor: primaryColor,
          onChanged: (v) => setState(() => _isActive = v),
        ),
      ],
    );
  }
}
