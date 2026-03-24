import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import '../../constants.dart';
import '../../responsive.dart';

class CreateSchemeScreen extends StatefulWidget {
  final Map<String, dynamic>? schemeData;

  const CreateSchemeScreen({super.key, this.schemeData});

  @override
  State<CreateSchemeScreen> createState() => _CreateSchemeScreenState();
}

class _CreateSchemeScreenState extends State<CreateSchemeScreen> {
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;

  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _productsController = TextEditingController();
  final TextEditingController _discountController = TextEditingController();
  
  String _selectedType = "Percentage";
  String _selectedStatus = "Active";
  
  DateTime? _startDate;
  DateTime? _endDate;
  
  XFile? _selectedImage;
  String? _existingImageUrl;
  final ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    if (widget.schemeData != null) {
      final sd = widget.schemeData!;
      _titleController.text = sd['title'] ?? "";
      _productsController.text = sd['products'] ?? "";
      _discountController.text = sd['discountValue'] ?? "";
      
      _selectedType = sd['type'] ?? "Percentage";
      _selectedStatus = sd['status'] ?? "Active";
      
      if (sd['startDate'] != null && sd['startDate'].toString().isNotEmpty) {
        try { _startDate = DateFormat('yyyy-MM-dd').parse(sd['startDate']); } catch (_) {}
      }
      if (sd['endDate'] != null && sd['endDate'].toString().isNotEmpty) {
        try { _endDate = DateFormat('yyyy-MM-dd').parse(sd['endDate']); } catch (_) {}
      }
      
      if (sd['imageUrl'] != null && sd['imageUrl'].toString().isNotEmpty) {
        _existingImageUrl = sd['imageUrl'];
      }
    }
  }

  Future<void> _pickImage() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      setState(() {
        _selectedImage = image;
      });
    }
  }

  Future<String?> _uploadToCloudinary() async {
    if (_selectedImage == null) return null;
    try {
      final bytes = await _selectedImage!.readAsBytes();
      
      var request = http.MultipartRequest(
        'POST', 
        Uri.parse('https://api.cloudinary.com/v1_1/dkahbm2m4/image/upload')
      );
      request.fields['upload_preset'] = 'khulikitab';
      request.files.add(http.MultipartFile.fromBytes('file', bytes, filename: 'scheme_${DateTime.now().millisecondsSinceEpoch}.jpg'));

      var response = await request.send();
      var responseData = await response.stream.bytesToString();
      var jsonData = json.decode(responseData);

      if (response.statusCode == 200) {
        return jsonData['secure_url'];
      } else {
        throw Exception("Cloudinary Error: ${jsonData['error']?['message'] ?? 'Unknown'}");
      }
    } catch (e) {
      debugPrint("Image upload fail: $e");
      return null;
    }
  }

  Future<void> _submitScheme() async {
    if (!_formKey.currentState!.validate()) return;
    if (_startDate == null || _endDate == null) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Please select valid start and end dates')));
      return;
    }

    setState(() => _isLoading = true);

    try {
      // 1. Upload new image if chosen
      String? uploadedUrl = await _uploadToCloudinary();
      String finalImageUrl = uploadedUrl ?? _existingImageUrl ?? "";

      // 2. Identify if it's Edit or Create
      final isEdit = widget.schemeData != null;
      final uri = isEdit 
          ? Uri.parse('$backendUrl/api/schemes/${widget.schemeData!['_id']}')
          : Uri.parse('$backendUrl/api/schemes');

      // 3. Save to backend
      final response = await (isEdit ? http.put : http.post)(
        uri,
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'title': _titleController.text,
          'type': _selectedType,
          'status': _selectedStatus,
          'products': _productsController.text,
          'discountValue': _discountController.text,
          'startDate': DateFormat('yyyy-MM-dd').format(_startDate!),
          'endDate': DateFormat('yyyy-MM-dd').format(_endDate!),
          'imageUrl': finalImageUrl,
        }),
      );

      if (response.statusCode == 201 || response.statusCode == 200) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(isEdit ? 'Scheme Updated' : 'Scheme Created', style: const TextStyle(color: Colors.white)), backgroundColor: Colors.green));
          Navigator.pop(context, true);
        }
      } else {
        throw Exception('Failed to save scheme');
      }
    } catch (error) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error: $error'), backgroundColor: errorColor));
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  Future<void> _selectDate(BuildContext context, bool isStart) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: (isStart ? _startDate : _endDate) ?? DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime(2030),
    );
    if (picked != null) {
      setState(() {
        if (isStart) _startDate = picked;
        else _endDate = picked;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    bool isMobile = Responsive.isMobile(context);
    final String pageTitle = widget.schemeData == null ? "Create New Scheme" : "Edit Scheme";

    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        title: Text(pageTitle, style: const TextStyle(color: textPrimaryColor, fontWeight: FontWeight.bold)),
        backgroundColor: surfaceColor,
        elevation: 0,
        iconTheme: const IconThemeData(color: textPrimaryColor),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(defaultPadding * 1.5),
        child: Center(
          child: Container(
            constraints: const BoxConstraints(maxWidth: 800),
            padding: const EdgeInsets.all(defaultPadding * 1.5),
            decoration: BoxDecoration(
              color: surfaceColor,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 10, offset: const Offset(0, 5))],
            ),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                   const Text("Promotional Banner", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: textPrimaryColor)),
                   const SizedBox(height: 12),
                   Center(
                     child: InkWell(
                       onTap: _pickImage,
                       borderRadius: BorderRadius.circular(16),
                       child: Container(
                         height: 200,
                         width: double.infinity,
                         decoration: BoxDecoration(
                           color: bgColor,
                           borderRadius: BorderRadius.circular(16),
                           border: Border.all(color: primaryColor.withValues(alpha: 0.3), width: 2, style: BorderStyle.solid),
                         ),
                         child: _selectedImage != null
                             ? ClipRRect(
                                 borderRadius: BorderRadius.circular(14),
                                 child: Image.network(_selectedImage!.path, fit: BoxFit.cover, width: double.infinity),
                               )
                             : (_existingImageUrl != null 
                                 ? ClipRRect(
                                     borderRadius: BorderRadius.circular(14),
                                     child: Stack(
                                       fit: StackFit.expand,
                                       children: [
                                          Image.network(_existingImageUrl!, fit: BoxFit.cover, errorBuilder: (c, e, s) => const Center(child: Icon(Icons.broken_image, size: 40))),
                                          Container(color: Colors.black.withValues(alpha: 0.3)),
                                          const Center(child: Icon(Icons.camera_alt, color: Colors.white, size: 40)),
                                       ],
                                     ),
                                   )
                                 : const Column(
                                     mainAxisAlignment: MainAxisAlignment.center,
                                     children: [
                                       Icon(Icons.cloud_upload_outlined, size: 48, color: primaryColor),
                                       SizedBox(height: 8),
                                       Text("Upload Scheme Media", style: TextStyle(color: primaryColor, fontWeight: FontWeight.bold)),
                                       Text("JPEG, PNG, WebP via Cloudinary", style: TextStyle(color: textSecondaryColor, fontSize: 12)),
                                     ],
                                   )),
                       ),
                     ),
                   ),
                   const SizedBox(height: 24),
                   
                   Row(
                     children: [
                       Expanded(child: _buildTextField("Scheme Title", _titleController, Icons.title_rounded)),
                       if (!isMobile) const SizedBox(width: 16),
                       if (!isMobile) Expanded(
                         child: _buildDropdown("Scheme Type", _selectedType, ["Percentage", "Value", "Quantity", "Combo", "Flat"], (v) => setState(() => _selectedType = v!)),
                       ),
                     ],
                   ),
                   if (isMobile) const SizedBox(height: 16),
                   if (isMobile) _buildDropdown("Scheme Type", _selectedType, ["Percentage", "Value", "Quantity", "Combo", "Flat"], (v) => setState(() => _selectedType = v!)),
                   
                   const SizedBox(height: 16),
                   _buildTextField("Target Products", _productsController, Icons.inventory_2_outlined),
                   const SizedBox(height: 16),
                   _buildTextField("Offer / Discount (e.g., 20%, Flat 50, Buy 1 Get 1)", _discountController, Icons.local_offer_rounded),
                   const SizedBox(height: 16),
                   
                   Row(
                     children: [
                       Expanded(
                         child: InkWell(
                           onTap: () => _selectDate(context, true),
                           child: _buildDateDisplay("Start Date", _startDate),
                         ),
                       ),
                       const SizedBox(width: 16),
                       Expanded(
                         child: InkWell(
                           onTap: () => _selectDate(context, false),
                           child: _buildDateDisplay("End Date", _endDate),
                         ),
                       ),
                     ],
                   ),
                   const SizedBox(height: 16),
                   _buildDropdown("Status", _selectedStatus, ["Active", "Upcoming", "Expired"], (v) => setState(() => _selectedStatus = v!)),
                   
                   const SizedBox(height: 32),
                   _isLoading 
                    ? const Center(child: CircularProgressIndicator())
                    : SizedBox(
                        width: double.infinity,
                        height: 56,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: primaryColor,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                          ),
                          onPressed: _submitScheme,
                          child: Text(widget.schemeData == null ? "Launch Scheme" : "Save Changes", style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white)),
                        ),
                      )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDateDisplay(String label, DateTime? date) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.withValues(alpha: 0.2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: const TextStyle(fontSize: 12, color: textSecondaryColor)),
          const SizedBox(height: 4),
          Row(
            children: [
              const Icon(Icons.calendar_today_rounded, size: 16, color: primaryColor),
              const SizedBox(width: 8),
               Expanded(
                 child: Text(
                  date != null ? DateFormat('dd MMM yyyy').format(date) : "Select Date",
                  style: const TextStyle(fontWeight: FontWeight.bold, color: textPrimaryColor),
                  overflow: TextOverflow.ellipsis,
                 ),
               ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTextField(String label, TextEditingController controller, IconData icon) {
    return TextFormField(
      controller: controller,
      validator: (val) => val == null || val.isEmpty ? 'Required' : null,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon, color: primaryColor),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        filled: true,
        fillColor: bgColor,
      ),
    );
  }

  Widget _buildDropdown(String label, String value, List<String> items, Function(String?) onChanged) {
    return DropdownButtonFormField<String>(
      value: value,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: const Icon(Icons.category_rounded, color: primaryColor),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        filled: true,
        fillColor: bgColor,
      ),
      items: items.map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
      onChanged: onChanged,
    );
  }
}
