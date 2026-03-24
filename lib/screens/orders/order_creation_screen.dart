import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:image_picker/image_picker.dart';
import '../../constants.dart';
import '../../responsive.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:intl/intl.dart';
import 'dart:typed_data';
// Note: image_picker would be needed for real image picking, 
// for now implementation focuses on the upload logic as requested.

class CreateOrderScreen extends StatefulWidget {
  final Function(Map<String, dynamic>) onOrderCreated;
  const CreateOrderScreen({super.key, required this.onOrderCreated});

  @override
  State<CreateOrderScreen> createState() => _CreateOrderScreenState();
}

class _CreateOrderScreenState extends State<CreateOrderScreen> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  final TextEditingController _customerController = TextEditingController();
  final TextEditingController _billingNameController = TextEditingController();
  final TextEditingController _billingAddressController = TextEditingController();
  final TextEditingController _shippingAddressController = TextEditingController();
  final TextEditingController _poNoController = TextEditingController();
  final TextEditingController _ewayBillController = TextEditingController();
  final TextEditingController _invoiceNoController = TextEditingController();
  final TextEditingController _deliveryLocationController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  
  // Financial controllers
  final TextEditingController _discountController = TextEditingController(text: "0");
  final TextEditingController _shippingController = TextEditingController(text: "0");
  final TextEditingController _packagingController = TextEditingController(text: "0");
  final TextEditingController _adjustmentController = TextEditingController(text: "0");

  String _orderType = "Secondary";
  String _salesPerson = "Select Sales Person";
  String _paymentType = "Cash";
  String _godown = "Select Godown";
  String _stateOfSupply = "Select state";
  String _status = "Confirmed";
  
  bool _isSaving = false;
  List<String> _attachmentUrls = [];

  List<dynamic> _availableProducts = [];
  DateTime _orderDate = DateTime.now();
  DateTime _poDate = DateTime.now();
  DateTime _invoiceDate = DateTime.now();
  TimeOfDay _orderTime = TimeOfDay.now();

  final List<Map<String, dynamic>> _items = [
    {
      "product": null, // Storing full product object or ID
      "productName": "Select Product",
      "batch": "",
      "exp_date": "dd/mm/yyyy",
      "mrp": "0",
      "qty": "0",
      "unit": "PC",
      "price": "0",
      "disc": "0",
      "tax": "0",
      "amount": "0.00"
    }
  ];

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );
    _fadeAnimation = CurvedAnimation(parent: _controller, curve: Curves.easeIn);
    _slideAnimation = Tween<Offset>(begin: const Offset(0, 0.1), end: Offset.zero).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOutCubic),
    );
    _controller.forward();
    _fetchProducts();
  }

  Future<void> _fetchProducts() async {
    try {
      final response = await http.get(Uri.parse('$backendUrl/api/products'));
      if (response.statusCode == 200) {
        setState(() {
          _availableProducts = jsonDecode(response.body);
        });
      }
    } catch (e) {
      print("Error fetching products for orders: $e");
    }
  }

  Future<void> _selectDate(BuildContext context, Function(DateTime) onPicked, DateTime initial) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: initial,
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: primaryColor,
              onPrimary: Colors.white,
              onSurface: textPrimaryColor,
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null) {
      setState(() => onPicked(picked));
    }
  }

  Future<void> _selectTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: _orderTime,
    );
    if (picked != null) {
      setState(() => _orderTime = picked);
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    _customerController.dispose();
    _billingNameController.dispose();
    _billingAddressController.dispose();
    _shippingAddressController.dispose();
    _poNoController.dispose();
    _ewayBillController.dispose();
    _invoiceNoController.dispose();
    _deliveryLocationController.dispose();
    _descriptionController.dispose();
    _discountController.dispose();
    _shippingController.dispose();
    _packagingController.dispose();
    _adjustmentController.dispose();
    super.dispose();
  }

  Future<void> _pickAndUploadImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);
    
    if (image != null) {
      setState(() => _isSaving = true);
      final bytes = await image.readAsBytes();
      final url = await _uploadToCloudinary(bytes, image.name);
      if (url != null) {
        setState(() {
          _attachmentUrls.add(url);
          _isSaving = false;
        });
      } else {
        setState(() => _isSaving = false);
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Failed to upload image to Cloudinary")),
          );
        }
      }
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
        final responseString = String.fromCharCodes(responseData);
        final jsonResponse = jsonDecode(responseString);
        return jsonResponse['secure_url'];
      }
    } catch (e) {
      print("Cloudinary upload error: $e");
    }
    return null;
  }

  double _calculateGrandTotal() {
    double subtotal = 0;
    for (var item in _items) {
      double qty = double.tryParse(item['qty'].toString()) ?? 0;
      double price = double.tryParse(item['price'].toString()) ?? 0;
      double disc = double.tryParse(item['disc'].toString()) ?? 0;
      double amount = (qty * price) * (1 - disc / 100);
      subtotal += amount;
    }
    
    double discPercent = double.tryParse(_discountController.text) ?? 0;
    double shipping = double.tryParse(_shippingController.text) ?? 0;
    double packaging = double.tryParse(_packagingController.text) ?? 0;
    double adjustment = double.tryParse(_adjustmentController.text) ?? 0;
    
    double discountAmount = subtotal * (discPercent / 100);
    return subtotal - discountAmount + shipping + packaging + adjustment;
  }

  Future<void> _createOrder() async {
    setState(() => _isSaving = true);
    
    try {
      final orderData = {
        "orderId": "ORD-${DateTime.now().millisecondsSinceEpoch}",
        "orderType": _orderType,
        "customerName": _customerController.text,
        "salesPerson": _salesPerson,
        "paymentType": _paymentType,
        "godown": _godown,
        "billingName": _billingNameController.text,
        "billingAddress": _billingAddressController.text,
        "shippingAddress": _shippingAddressController.text,
        "poNo": _poNoController.text,
        "poDate": _poDate.toIso8601String(),
        "ewayBillNo": _ewayBillController.text,
        "invoiceNumber": _invoiceNoController.text,
        "invoiceDate": _invoiceDate.toIso8601String(),
        "time": _orderTime.format(context),
        "deliveryLocation": _deliveryLocationController.text,
        "description": _descriptionController.text,
        "stateOfSupply": _stateOfSupply,
        "status": _status,
        "createdBy": "admin@tajpro.com",
        "items": _items.map((item) {
          return {
            "productName": item['productName'],
            "batchNo": item['batch'],
            "expiryDate": item['exp_date'],
            "mrp": double.tryParse(item['mrp'].toString()) ?? 0,
            "quantity": double.tryParse(item['qty'].toString()) ?? 0,
            "price": double.tryParse(item['price'].toString()) ?? 0,
            "amount": double.tryParse(item['amount'].toString()) ?? 0,
            "unit": item['unit'],
            "discount": double.tryParse(item['disc'].toString()) ?? 0,
            "tax": double.tryParse(item['tax'].toString()) ?? 0,
          };
        }).toList(),
        "totalAmount": _calculateGrandTotal(),
        "discountPercentage": double.tryParse(_discountController.text) ?? 0,
        "shippingCharges": double.tryParse(_shippingController.text) ?? 0,
        "packagingCharges": double.tryParse(_packagingController.text) ?? 0,
        "adjustment": double.tryParse(_adjustmentController.text) ?? 0,
        "attachments": _attachmentUrls,
        "orderDate": _orderDate.toIso8601String(),
      };

      final response = await http.post(
        Uri.parse('$backendUrl/api/orders'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(orderData),
      );

      if (response.statusCode == 201) {
        if (mounted) {
          widget.onOrderCreated(jsonDecode(response.body));
          Navigator.pop(context);
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

  void _addItem() {
    setState(() {
      _items.add({
        "product": null,
        "productName": "Select Product",
        "batch": "",
        "exp_date": "dd/mm/yyyy",
        "mrp": "0",
        "qty": "0",
        "unit": "PC",
        "price": "0",
        "disc": "0",
        "tax": "0",
        "amount": "0.00"
      });
    });
  }

  void _updateItemAmount(int index) {
     var item = _items[index];
     double qty = double.tryParse(item['qty'].toString()) ?? 0;
     double price = double.tryParse(item['price'].toString()) ?? 0;
     double disc = double.tryParse(item['disc'].toString()) ?? 0;
     double amount = (qty * price) * (1 - disc / 100);
     setState(() {
       item['amount'] = amount.toStringAsFixed(2);
     });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
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
                      padding: const EdgeInsets.all(defaultPadding),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildFormSection(),
                          const SizedBox(height: 32),
                          _buildItemsSection(),
                          const SizedBox(height: 32),
                          _buildBottomFormSection(),
                          const SizedBox(height: 100),
                        ],
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
        border: Border(bottom: BorderSide(color: Colors.grey.withValues(alpha: 0.15))),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text(
            "New Order",
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Color(0xFF1E293B)),
          ),
          IconButton(
            icon: const Icon(Icons.close_rounded, color: Color(0xFF475569)),
            onPressed: () => Navigator.pop(context),
          ),
        ],
      ),
    );
  }

  Widget _buildFormSection() {
    return Container(
      padding: const EdgeInsets.all(defaultPadding),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.withValues(alpha: 0.08)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildRow([
            _buildDropdownField("ORDER TYPE", ["Secondary", "Primary"], (v) => setState(() => _orderType = v!)),
            _buildTextField("CUSTOMER / PARTY *", "Select Customer", controller: _customerController),
            _buildDropdownField("SALES PERSON", ["Select Sales Person", "Rahul Sharma", "Amit Kumar"], (v) => setState(() => _salesPerson = v!)),
            _buildDropdownField("PAYMENT", ["Credit", "Cash", "Online"], (v) => setState(() => _paymentType = v!)),
          ]),
          const SizedBox(height: 24),
          _buildRow([
            _buildDropdownField("GODOWN", ["Select Godown", "Main Warehouse", "North Depot"], (v) => setState(() => _godown = v!)),
            _buildTextField("BILLING NAME", "Optional", controller: _billingNameController),
            _buildTextField("BILLING ADDRESS", "Enter billing address", controller: _billingAddressController, maxLines: 2),
            _buildTextField("SHIPPING ADDRESS", "Enter shipping address", controller: _shippingAddressController, maxLines: 2),
          ]),
          const SizedBox(height: 24),
          _buildRow([
            _buildTextField("PO NO.", "", controller: _poNoController),
            _buildDateField("PO DATE", DateFormat('dd/MM/yyyy').format(_poDate), onTap: () => _selectDate(context, (d) => _poDate = d, _poDate)),
            _buildTextField("E-WAY BILL NO.", "", controller: _ewayBillController),
            _buildTextField("INVOICE NUMBER", "", controller: _invoiceNoController),
          ]),
          const SizedBox(height: 24),
          _buildRow([
            _buildDateField("INVOICE DATE", DateFormat('dd/MM/yyyy').format(_invoiceDate), onTap: () => _selectDate(context, (d) => _invoiceDate = d, _invoiceDate)),
            _buildTimeField("TIME", _orderTime.format(context), onTap: () => _selectTime(context)),
            _buildDropdownField("STATE OF SUPPLY", ["Select state", "Delhi", "Mumbai", "Bangalore", "Add More..."], (v) {
              if (v == "Add More...") {
                // Logic to add more
              } else {
                setState(() => _stateOfSupply = v!);
              }
            }),
            _buildDateField("DATE", DateFormat('dd/MM/yyyy').format(_orderDate), onTap: () => _selectDate(context, (d) => _orderDate = d, _orderDate)),
          ]),
          const SizedBox(height: 24),
          _buildDropdownField("STATUS", ["Confirmed", "Pending", "Processing"], (v) => setState(() => _status = v!), widthFactor: 0.25),
        ],
      ),
    );
  }

  Widget _buildItemsSection() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.withValues(alpha: 0.08)),
      ),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text("Order Items", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Color(0xFF1E293B))),
                TextButton.icon(
                  onPressed: () {},
                  icon: const Icon(Icons.picture_as_pdf_outlined, size: 18),
                  label: const Text("Attach PDF Invoice", style: TextStyle(fontSize: 13)),
                  style: TextButton.styleFrom(foregroundColor: primaryColor),
                ),
              ],
            ),
          ),
          _buildItemsTable(),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: const Color(0xFFF8FAFC),
              borderRadius: const BorderRadius.only(bottomLeft: Radius.circular(16), bottomRight: Radius.circular(16)),
            ),
            child: Row(
              children: [
                TextButton.icon(
                  onPressed: _addItem,
                  icon: const Icon(Icons.add_circle_outline_rounded, size: 18),
                  label: const Text("ADD ROW", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                  style: TextButton.styleFrom(foregroundColor: primaryColor),
                ),
                const Spacer(),
                const Text("TOTAL", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: Color(0xFF475569))),
                const SizedBox(width: 24),
                Text("₹${_items.fold(0.0, (sum, item) => sum + (double.tryParse(item['amount'].toString()) ?? 0))}", style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: Color(0xFF1E293B))),
                const SizedBox(width: 20),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildItemsTable() {
    if (Responsive.isMobile(context)) {
      return Column(
        children: _items.map((item) => _buildMobileItemCard(item)).toList(),
      );
    }

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      physics: const BouncingScrollPhysics(),
      child: SizedBox(
        width: 1200,
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
              color: const Color(0xFFF1F5F9),
              child: const Row(
                children: [
                  SizedBox(width: 30, child: Text("#", style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Color(0xFF475569)))),
                  Expanded(flex: 4, child: Text("PRODUCT", style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Color(0xFF475569)))),
                  SizedBox(width: 80, child: Text("BATCH NO.", style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Color(0xFF475569)))),
                  SizedBox(width: 120, child: Text("EXP. DATE", style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Color(0xFF475569)))),
                  SizedBox(width: 70, child: Text("MRP", style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Color(0xFF475569)))),
                  SizedBox(width: 60, child: Text("QTY", style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Color(0xFF475569)))),
                  SizedBox(width: 80, child: Text("UNIT", style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Color(0xFF475569)))),
                  SizedBox(width: 70, child: Text("PRICE", style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Color(0xFF475569)))),
                  SizedBox(width: 60, child: Text("DISC %", style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Color(0xFF475569)))),
                  SizedBox(width: 60, child: Text("TAX %", style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Color(0xFF475569)))),
                  SizedBox(width: 90, child: Text("AMOUNT", textAlign: TextAlign.right, style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Color(0xFF475569)))),
                  SizedBox(width: 40),
                ],
              ),
            ),
            ..._items.asMap().entries.map((entry) => _buildTableItemRow(entry.key + 1, entry.value)),
          ],
        ),
      ),
    );
  }

  Widget _buildTableItemRow(int index, Map<String, dynamic> item) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(bottom: BorderSide(color: Colors.grey.withValues(alpha: 0.1))),
      ),
      child: Row(
        children: [
          SizedBox(width: 30, child: Text(index.toString(), style: const TextStyle(fontSize: 13, color: Color(0xFF1E293B)))),
          Expanded(
            flex: 4,
            child: _TableProductDropdown(
              products: _availableProducts,
              selectedProduct: item['product'],
              onChanged: (p) {
                setState(() {
                  item['product'] = p;
                  item['productName'] = p['name'];
                  item['price'] = p['price'].toString();
                  item['unit'] = p['unit'] ?? "PC";
                  _updateItemAmount(index - 1);
                });
              },
            ),
          ),
          const SizedBox(width: 8),
          SizedBox(width: 80, child: _TableInput(initialValue: item['batch'], onChanged: (v) => item['batch'] = v)),
          const SizedBox(width: 8),
          SizedBox(width: 120, child: _TableDateInput(value: item['exp_date'], onTap: () => _selectDate(context, (d) => setState(() => item['exp_date'] = DateFormat('dd/MM/yyyy').format(d)), DateTime.now()))),
          const SizedBox(width: 8),
          SizedBox(width: 70, child: _TableInput(initialValue: item['mrp'], onChanged: (v) => item['mrp'] = v)),
          const SizedBox(width: 8),
          SizedBox(width: 60, child: _TableInput(initialValue: item['qty'], onChanged: (v) {
            item['qty'] = v;
            _updateItemAmount(index - 1);
          })),
          const SizedBox(width: 8),
          SizedBox(width: 80, child: _TableDropdown(value: item['unit'])),
          const SizedBox(width: 8),
          SizedBox(width: 70, child: _TableInput(initialValue: item['price'], onChanged: (v) {
            item['price'] = v;
            _updateItemAmount(index - 1);
          })),
          const SizedBox(width: 8),
          SizedBox(width: 60, child: _TableInput(initialValue: item['disc'], onChanged: (v) {
            item['disc'] = v;
            _updateItemAmount(index - 1);
          })),
          const SizedBox(width: 8),
          const SizedBox(width: 60, child: _TableDropdown(value: "0%")),
          const SizedBox(width: 8),
          SizedBox(
            width: 90,
            child: Text("₹${item['amount']}", textAlign: TextAlign.right, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: Color(0xFF1E293B))),
          ),
          const SizedBox(width: 8),
          GestureDetector(
            onTap: () => setState(() => _items.removeAt(index - 1)),
            child: const SizedBox(
              width: 32,
              child: Icon(Icons.close_rounded, color: Colors.redAccent, size: 16),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMobileItemCard(Map<String, dynamic> item) {
      return Container(
        padding: const EdgeInsets.all(12),
        margin: const EdgeInsets.only(bottom: 8),
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border(bottom: BorderSide(color: Colors.grey.withValues(alpha: 0.15))),
        ),
        child: Column(
          children: [
             _buildDropdownField("PRODUCT", ["Select Product"], (v) {
               setState(() => item['product'] = v!);
             }),
             const SizedBox(height: 12),
             Row(
               children: [
                 Expanded(child: _buildTextField("QTY", "0")),
                 const SizedBox(width: 12),
                 Expanded(child: _buildTextField("PRICE", "0.00")),
               ],
             )
          ],
        ),
      );
  }

  Widget _buildBottomFormSection() {
    // If screen is smaller than 1200, stack the logistics and summary sections
    if (MediaQuery.of(context).size.width < 1200) {
      return Column(
        children: [
          _buildLogisticsColumn(),
          const SizedBox(height: 32),
          _buildSummaryCard(),
        ],
      );
    }

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(flex: 4, child: _buildLogisticsColumn()),
        const SizedBox(width: 32),
        Expanded(flex: 3, child: _buildSummaryCard()),
      ],
    );
  }

  Widget _buildLogisticsColumn() {
    return Column(
      children: [
        _buildLargeSectionCard([
          _buildTextField("DELIVERY LOCATION", "Enter delivery location", controller: _deliveryLocationController),
          const SizedBox(height: 20),
          _buildTextField("ADD DESCRIPTION", "Write detailed notes here...", controller: _descriptionController, maxLines: 4),
        ]),
        const SizedBox(height: 20),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: GestureDetector(
                onTap: _pickAndUploadImage,
                child: Container(
                  height: 120,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: Colors.grey.withValues(alpha: 0.1), style: BorderStyle.none),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(16),
                    child: CustomPaint(
                      painter: DashedPainter(),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          if (_attachmentUrls.isNotEmpty)
                             const Icon(Icons.check_circle, color: successColor, size: 32)
                          else
                             const Icon(Icons.image_outlined, color: Color(0xFF64748B), size: 32),
                          const SizedBox(height: 8),
                          Text(
                            _attachmentUrls.isNotEmpty ? "${_attachmentUrls.length} File(s) Attached" : "Click to upload", 
                            style: const TextStyle(color: Color(0xFF64748B), fontSize: 13)
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(width: 20),
            Expanded(
              child: _buildDropdownField("NO. OF COPIES", ["Original, Duplicate", "Original Only", "Copy Only"], (v) {}),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildSummaryCard() {
    return Container(
      padding: const EdgeInsets.all(defaultPadding),
      decoration: BoxDecoration(
        color: const Color(0xFFF8FAFC),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.withValues(alpha: 0.1)),
      ),
      child: Column(
        children: [
          _buildSummaryRow("Discount (%)", "-", isInput: true, controller: _discountController),
          _buildSummaryRow("Shipping", "-", isInput: true, controller: _shippingController),
          _buildSummaryRow("Packaging", "-", isInput: true, controller: _packagingController),
          _buildSummaryRow("Adjustment", "-", isInput: true, controller: _adjustmentController),
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 12),
            child: Divider(),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text("Total", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: Color(0xFF1E293B))),
              Text("₹${_calculateGrandTotal().toStringAsFixed(2)}", style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 24, color: primaryColor)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryRow(String label, String value, {bool isInput = false, TextEditingController? controller}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(color: Color(0xFF475569), fontSize: 14)),
          if (isInput)
            SizedBox(
              width: 100,
              height: 36,
              child: TextField(
                controller: controller,
                onChanged: (_) => setState(() {}),
                textAlign: TextAlign.right,
                style: const TextStyle(fontSize: 13, color: Color(0xFF1E293B)),
                decoration: InputDecoration(
                  hintText: "0.00",
                  hintStyle: TextStyle(color: Colors.grey.withValues(alpha: 0.5)),
                  contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  fillColor: Colors.white,
                  filled: true,
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(6), borderSide: BorderSide(color: Colors.grey.withValues(alpha: 0.1))),
                  enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(6), borderSide: BorderSide(color: Colors.grey.withValues(alpha: 0.1))),
                ),
              ),
            )
          else
            Text(value, style: const TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF1E293B))),
        ],
      ),
    );
  }

  Widget _buildLargeSectionCard(List<Widget> children) {
    return Container(
      padding: const EdgeInsets.all(defaultPadding),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.withValues(alpha: 0.08)),
      ),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: children),
    );
  }

  Widget _buildRow(List<Widget> children) {
    if (Responsive.isMobile(context)) {
      return Column(children: children.map((c) => Padding(padding: const EdgeInsets.only(bottom: 16), child: c)).toList());
    }
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: children.map((c) => Expanded(child: Padding(padding: const EdgeInsets.only(right: 16), child: c))).toList(),
    );
  }

  Widget _buildTextField(String label, String hint, {TextEditingController? controller, int maxLines = 1}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Color(0xFF64748B), letterSpacing: 1.1)),
        const SizedBox(height: 8),
        TextField(
          controller: controller,
          maxLines: maxLines,
          style: const TextStyle(fontSize: 13, color: Color(0xFF1E293B)),
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: const TextStyle(color: Color(0xFF94A3B8)),
            filled: true,
            fillColor: const Color(0xFFF8FAFC),
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: BorderSide(color: Colors.grey.withValues(alpha: 0.15))),
            enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: BorderSide(color: Colors.grey.withValues(alpha: 0.15))),
          ),
        ),
      ],
    );
  }

  Widget _buildDropdownField(String label, List<String> options, Function(String?)? onChanged, {double? widthFactor}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Color(0xFF64748B), letterSpacing: 1.1)),
        const SizedBox(height: 8),
        Container(
          width: widthFactor != null ? MediaQuery.of(context).size.width * widthFactor : null,
          padding: const EdgeInsets.symmetric(horizontal: 16),
          decoration: BoxDecoration(
            color: const Color(0xFFF8FAFC),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: Colors.grey.withValues(alpha: 0.15)),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              value: options.contains(_status) && label == "STATUS" ? _status : options.first,
              icon: const Icon(Icons.keyboard_arrow_down_rounded, color: Color(0xFF64748B)),
              style: const TextStyle(fontSize: 13, color: Color(0xFF1E293B)),
              items: options.map((String value) {
                return DropdownMenuItem<String>(value: value, child: Text(value));
              }).toList(),
              onChanged: onChanged,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildDateField(String label, String value, {VoidCallback? onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Color(0xFF64748B), letterSpacing: 1.1)),
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: const Color(0xFFF8FAFC),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.grey.withValues(alpha: 0.15)),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(value, style: const TextStyle(fontSize: 13, color: Color(0xFF1E293B))),
                const Icon(Icons.calendar_today_rounded, size: 16, color: Color(0xFF64748B)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTimeField(String label, String value, {VoidCallback? onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Color(0xFF64748B), letterSpacing: 1.1)),
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: const Color(0xFFF8FAFC),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.grey.withValues(alpha: 0.15)),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(value, style: const TextStyle(fontSize: 13, color: Color(0xFF1E293B))),
                const Icon(Icons.access_time_rounded, size: 16, color: Color(0xFF64748B)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFooter(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(defaultPadding),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(top: BorderSide(color: Colors.grey.withValues(alpha: 0.15))),
        boxShadow: [
          BoxShadow(color: Colors.black.withValues(alpha: 0.02), blurRadius: 10, offset: const Offset(0, -5))
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          _buildSecondaryButton("Cancel", () => Navigator.pop(context)),
          const SizedBox(width: 16),
          _buildPrimaryButton("Create Order", () {
            if (_isSaving) return;
            _createOrder();
          }),
        ],
      ),
    );
  }

  Widget _buildSecondaryButton(String text, VoidCallback onPressed) {
    return OutlinedButton(
      onPressed: onPressed,
      style: OutlinedButton.styleFrom(
        foregroundColor: const Color(0xFF475569),
        side: BorderSide(color: Colors.grey.withValues(alpha: 0.3)),
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
      child: Text(text, style: const TextStyle(fontWeight: FontWeight.bold)),
    );
  }

  Widget _buildPrimaryButton(String text, VoidCallback onPressed) {
    return Container(
      decoration: BoxDecoration(
        gradient: primaryGradient,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(color: primaryColor.withValues(alpha: 0.3), blurRadius: 10, offset: const Offset(0, 4))
        ],
      ),
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.transparent,
          shadowColor: Colors.transparent,
          padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
        child: _isSaving 
          ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
          : Text(text, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
      ),
    );
  }
}

class _TableInput extends StatefulWidget {
  final String? initialValue;
  final Function(String)? onChanged;
  const _TableInput({this.initialValue, this.onChanged});

  @override
  State<_TableInput> createState() => _TableInputState();
}

class _TableInputState extends State<_TableInput> {
  late TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.initialValue);
  }

  @override
  void didUpdateWidget(_TableInput oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.initialValue != oldWidget.initialValue && widget.initialValue != _controller.text) {
      _controller.text = widget.initialValue ?? "";
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 38,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: Colors.grey.withValues(alpha: 0.2)),
      ),
      child: TextField(
        controller: _controller,
        onChanged: widget.onChanged,
        textAlign: TextAlign.center,
        style: const TextStyle(fontSize: 12, color: Color(0xFF1E293B)),
        decoration: const InputDecoration(
          border: InputBorder.none, 
          contentPadding: EdgeInsets.zero,
          hintText: "0",
          hintStyle: TextStyle(color: Color(0xFF94A3B8), fontSize: 11),
        ),
      ),
    );
  }
}

class _TableDateInput extends StatelessWidget {
  final String value;
  final VoidCallback? onTap;
  const _TableDateInput({required this.value, this.onTap});
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 38,
        padding: const EdgeInsets.symmetric(horizontal: 8),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(6),
          border: Border.all(color: Colors.grey.withValues(alpha: 0.2)),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(child: Text(value, style: const TextStyle(fontSize: 11, color: Color(0xFF1E293B)), overflow: TextOverflow.ellipsis)),
            const Icon(Icons.calendar_today_rounded, size: 12, color: Color(0xFF64748B)),
          ],
        ),
      ),
    );
  }
}

class _TableDropdown extends StatelessWidget {
  final String value;
  const _TableDropdown({required this.value});
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 38,
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: Colors.grey.withValues(alpha: 0.2)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(child: Text(value, style: const TextStyle(fontSize: 12, color: Color(0xFF1E293B), fontWeight: FontWeight.w500), overflow: TextOverflow.ellipsis)),
          const Icon(Icons.keyboard_arrow_down_rounded, size: 16, color: Color(0xFF64748B)),
        ],
      ),
    );
  }
}

class DashedPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint = Paint()
      ..color = const Color(0xFF94A3B8)
      ..strokeWidth = 1
      ..style = PaintingStyle.stroke;

    const double dashWidth = 5;
    const double dashSpace = 5;

    // Top
    double x = 0;
    while (x < size.width) {
      canvas.drawLine(Offset(x, 0), Offset(x + dashWidth, 0), paint);
      x += dashWidth + dashSpace;
    }
    // Bottom
    x = 0;
    while (x < size.width) {
      canvas.drawLine(Offset(x, size.height), Offset(x + dashWidth, size.height), paint);
      x += dashWidth + dashSpace;
    }
    // Left
    double y = 0;
    while (y < size.height) {
      canvas.drawLine(Offset(0, y), Offset(0, y + dashWidth), paint);
      y += dashWidth + dashSpace;
    }
    // Right
    y = 0;
    while (y < size.height) {
      canvas.drawLine(Offset(size.width, y), Offset(size.width, y + dashWidth), paint);
      y += dashWidth + dashSpace;
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}

class _TableProductDropdown extends StatelessWidget {
  final List<dynamic> products;
  final dynamic selectedProduct;
  final Function(dynamic) onChanged;

  const _TableProductDropdown({
    required this.products,
    required this.selectedProduct,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 38,
      padding: const EdgeInsets.symmetric(horizontal: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: Colors.grey.withValues(alpha: 0.2)),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<dynamic>(
          value: selectedProduct,
          hint: const Text("Select Product", style: TextStyle(fontSize: 12, color: Color(0xFF94A3B8))),
          isExpanded: true,
          icon: const Icon(Icons.keyboard_arrow_down_rounded, size: 16, color: Color(0xFF64748B)),
          items: [
            ...products.map((p) => DropdownMenuItem(
                  value: p,
                  child: Text(p['name'].toString(), style: const TextStyle(fontSize: 12, color: Color(0xFF1E293B))),
                )),
            const DropdownMenuItem(
              value: "ADD_NEW",
              child: Row(
                children: [
                  Icon(Icons.add_circle_outline, size: 14, color: primaryColor),
                  SizedBox(width: 8),
                  Text("Add More...", style: TextStyle(fontSize: 12, color: primaryColor, fontWeight: FontWeight.bold)),
                ],
              ),
            ),
          ],
          onChanged: (val) {
            if (val == "ADD_NEW") {
              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Add New Product functionality coming soon!")));
            } else if (val != null) {
              onChanged(val);
            }
          },
        ),
      ),
    );
  }
}
