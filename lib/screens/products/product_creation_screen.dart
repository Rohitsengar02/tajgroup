import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:image_picker/image_picker.dart';
import '../../constants.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ProductCreationScreen extends StatefulWidget {
  final Function(Map<String, dynamic>) onProductCreated;
  const ProductCreationScreen({super.key, required this.onProductCreated});

  @override
  State<ProductCreationScreen> createState() => _ProductCreationScreenState();
}

class _ProductCreationScreenState extends State<ProductCreationScreen> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;

  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _skuController = TextEditingController();
  final TextEditingController _brandController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  final TextEditingController _mrpController = TextEditingController();
  final TextEditingController _costPriceController = TextEditingController();
  final TextEditingController _stockController = TextEditingController(text: "0");
  final TextEditingController _minStockController = TextEditingController(text: "0");
  final TextEditingController _descriptionController = TextEditingController();

  String _category = "General";
  String _unit = "PC";
  String _status = "Active";
  
  bool _isSaving = false;
  List<String> _imageUrls = [];

  final List<String> _categories = ["General", "Electronics", "Groceries", "Healthcare", "Fashion"];
  final List<String> _units = ["PC", "KG", "LITER", "BOX", "SET"];

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );
    _fadeAnimation = CurvedAnimation(parent: _controller, curve: Curves.easeIn);
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    _nameController.dispose();
    _skuController.dispose();
    _brandController.dispose();
    _priceController.dispose();
    _mrpController.dispose();
    _costPriceController.dispose();
    _stockController.dispose();
    _minStockController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  Future<void> _pickAndUploadImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);
    
    if (image != null) {
      setState(() => _isSaving = true);
      try {
        final bytes = await image.readAsBytes();
        
        final cloudName = dotenv.get('CLOUDINARY_CLOUD_NAME');
        final uploadPreset = dotenv.get('CLOUDINARY_UPLOAD_PRESET');
        
        final uri = Uri.parse("https://api.cloudinary.com/v1_1/$cloudName/image/upload");
        final request = http.MultipartRequest("POST", uri);
        
        request.fields['upload_preset'] = uploadPreset;
        request.files.add(http.MultipartFile.fromBytes('file', bytes, filename: image.name));
        
        final response = await request.send();
        if (response.statusCode == 200) {
          final responseData = await response.stream.toBytes();
          final responseString = String.fromCharCodes(responseData);
          final jsonResponse = jsonDecode(responseString);
          setState(() {
            _imageUrls.add(jsonResponse['secure_url']);
          });
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("Upload error: $e")),
          );
        }
      } finally {
        if (mounted) setState(() => _isSaving = false);
      }
    }
  }

  Future<void> _saveProduct() async {
    if (!_formKey.currentState!.validate()) return;
    
    setState(() => _isSaving = true);
    
    try {
      final productData = {
        "name": _nameController.text,
        "sku": _skuController.text,
        "category": _category,
        "brand": _brandController.text,
        "unit": _unit,
        "price": double.tryParse(_priceController.text) ?? 0,
        "mrp": double.tryParse(_mrpController.text) ?? 0,
        "costPrice": double.tryParse(_costPriceController.text) ?? 0,
        "currentStock": int.tryParse(_stockController.text) ?? 0,
        "minStockLevel": int.tryParse(_minStockController.text) ?? 0,
        "description": _descriptionController.text,
        "images": _imageUrls,
        "status": _status,
      };

      final response = await http.post(
        Uri.parse('$backendUrl/api/products'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(productData),
      );

      if (response.statusCode == 201) {
        if (mounted) {
          widget.onProductCreated(jsonDecode(response.body));
          Navigator.pop(context);
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Product created successfully")),
          );
        }
      } else {
        final error = jsonDecode(response.body);
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("Error: ${error['message']}")),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Connection error: $e")),
        );
      }
    } finally {
      if (mounted) setState(() => _isSaving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text("Create New Product", style: TextStyle(fontWeight: FontWeight.bold, color: textPrimaryColor)),
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.close_rounded, color: textPrimaryColor),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          if (_isSaving)
            const Center(child: Padding(padding: EdgeInsets.only(right: 16), child: CircularProgressIndicator(strokeWidth: 2)))
          else
            TextButton(
              onPressed: _saveProduct,
              child: const Text("SAVE", style: TextStyle(fontWeight: FontWeight.bold, color: primaryColor)),
            ),
        ],
      ),
      body: FadeTransition(
        opacity: _fadeAnimation,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildImageSection(),
                const SizedBox(height: 32),
                _buildBasicInfo(),
                const SizedBox(height: 24),
                _buildPricingAndInventory(),
                const SizedBox(height: 24),
                _buildDescriptionSection(),
                const SizedBox(height: 48),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildImageSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text("PRODUCT IMAGES", style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: textSecondaryColor, letterSpacing: 1.2)),
        const SizedBox(height: 16),
        SizedBox(
          height: 120,
          child: ListView(
            scrollDirection: Axis.horizontal,
            children: [
              ..._imageUrls.map((url) => _buildImageThumbnail(url)),
              GestureDetector(
                onTap: _pickAndUploadImage,
                child: Container(
                  width: 120,
                  decoration: BoxDecoration(
                    color: bgColor,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: textSecondaryColor.withOpacity(0.2)),
                  ),
                  child: const Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.add_a_photo_outlined, color: textSecondaryColor),
                      SizedBox(height: 8),
                      Text("Upload", style: TextStyle(fontSize: 12, color: textSecondaryColor)),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildImageThumbnail(String url) {
    return Container(
      width: 120,
      margin: const EdgeInsets.only(right: 12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        image: DecorationImage(image: NetworkImage(url), fit: BoxFit.cover),
      ),
      child: Align(
        alignment: Alignment.topRight,
        child: IconButton(
          icon: const Icon(Icons.cancel, color: Colors.white, size: 20),
          onPressed: () => setState(() => _imageUrls.remove(url)),
        ),
      ),
    );
  }

  Widget _buildBasicInfo() {
    return _buildSectionCard(
      "Basic Information",
      Column(
        children: [
          _buildTextField("Product Name *", _nameController, validator: (v) => v!.isEmpty ? "Req" : null),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(child: _buildTextField("SKU / Item Code *", _skuController, validator: (v) => v!.isEmpty ? "Req" : null)),
              const SizedBox(width: 16),
              Expanded(child: _buildTextField("Brand", _brandController)),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(child: _buildDropdown("Category", _categories, _category, (v) => setState(() => _category = v!))),
              const SizedBox(width: 16),
              Expanded(child: _buildDropdown("Unit", _units, _unit, (v) => setState(() => _unit = v!))),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildPricingAndInventory() {
    return _buildSectionCard(
      "Pricing & Inventory",
      Column(
        children: [
          Row(
            children: [
              Expanded(child: _buildTextField("Selling Price *", _priceController, keyboardType: TextInputType.number)),
              const SizedBox(width: 16),
              Expanded(child: _buildTextField("MRP", _mrpController, keyboardType: TextInputType.number)),
              const SizedBox(width: 16),
              Expanded(child: _buildTextField("Cost Price", _costPriceController, keyboardType: TextInputType.number)),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(child: _buildTextField("Current Stock", _stockController, keyboardType: TextInputType.number)),
              const SizedBox(width: 16),
              Expanded(child: _buildTextField("Min Stock Level", _minStockController, keyboardType: TextInputType.number)),
              const SizedBox(width: 16),
              Expanded(child: _buildDropdown("Status", ["Active", "Draft", "Out of Stock"], _status, (v) => setState(() => _status = v!))),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildDescriptionSection() {
    return _buildSectionCard(
      "Description",
      _buildTextField("Product Details", _descriptionController, maxLines: 4),
    );
  }

  Widget _buildSectionCard(String title, Widget child) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: textSecondaryColor.withOpacity(0.08)),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.02), blurRadius: 10, offset: const Offset(0, 4))],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: textPrimaryColor)),
          const SizedBox(height: 20),
          child,
        ],
      ),
    );
  }

  Widget _buildTextField(String label, TextEditingController controller, {int maxLines = 1, TextInputType? keyboardType, String? Function(String?)? validator}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: textSecondaryColor)),
        const SizedBox(height: 8),
        TextFormField(
          controller: controller,
          maxLines: maxLines,
          keyboardType: keyboardType,
          validator: validator,
          decoration: InputDecoration(
            filled: true,
            fillColor: bgColor,
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: BorderSide.none),
          ),
        ),
      ],
    );
  }

  Widget _buildDropdown(String label, List<String> items, String value, Function(String?) onChanged) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: textSecondaryColor)),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          decoration: BoxDecoration(color: bgColor, borderRadius: BorderRadius.circular(8)),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              value: items.contains(value) ? value : items.first,
              isExpanded: true,
              items: items.map((e) => DropdownMenuItem(value: e, child: Text(e, style: const TextStyle(fontSize: 13)))).toList(),
              onChanged: onChanged,
            ),
          ),
        ),
      ],
    );
  }
}
