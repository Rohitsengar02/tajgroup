import 'package:flutter/material.dart';
import '../../constants.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:intl/intl.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'dart:typed_data';

class NewQuotationScreen extends StatefulWidget {
  const NewQuotationScreen({super.key});

  @override
  State<NewQuotationScreen> createState() => _NewQuotationScreenState();
}

class _NewQuotationScreenState extends State<NewQuotationScreen> {
  final _customerController = TextEditingController();
  final _billingNameController = TextEditingController();
  final _billingAddressController = TextEditingController();
  final _shippingAddressController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _deliveryLocationController = TextEditingController();
  final _poNoController = TextEditingController();
  final _discountController = TextEditingController(text: "0");
  final _shippingController = TextEditingController(text: "0");
  final _packagingController = TextEditingController(text: "0");
  final _adjustmentController = TextEditingController(text: "0");

  String _quotationType = "Standard";
  String _paymentType = "Cash";
  String _stateOfSupply = "Delhi";
  String _godown = "Default Godown";
  DateTime _quotationDate = DateTime.now();
  DateTime _validUntil = DateTime.now().add(const Duration(days: 30));
  DateTime _poDate = DateTime.now();
  TimeOfDay _quotationTime = TimeOfDay.now();
  String _status = "Draft";
  String _salesPerson = "Admin";

  List<Map<String, dynamic>> _items = [];
  List<dynamic> _products = [];
  bool _isSaving = false;
  List<String> _attachmentUrls = [];

  final List<String> _states = ["Delhi", "Mumbai", "Bangalore", "Chennai", "Kolkata", "Hyderabad"];
  final List<String> _godowns = ["Default Godown", "Main Warehouse", "Secondary Store"];
  final List<String> _salesPersons = ["Admin", "John Doe", "Jane Smith", "Sales Team A"];

  @override
  void initState() {
    super.initState();
    _fetchProducts();
    _addNewItem();
  }

  Future<void> _fetchProducts() async {
    try {
      final response = await http.get(Uri.parse('$backendUrl/api/products'));
      if (response.statusCode == 200) {
        setState(() => _products = jsonDecode(response.body));
      }
    } catch (e) {
      print("Error fetching products: $e");
    }
  }

  void _addNewItem() {
    setState(() {
      _items.add({
        "productName": null,
        "batch": "",
        "exp_date": DateFormat('dd/MM/yyyy').format(DateTime.now().add(const Duration(days: 365))),
        "mrp": "0",
        "qty": "1",
        "unit": "PC",
        "price": "0",
        "disc": "0",
        "tax": "0",
        "amount": "0",
      });
    });
  }

  void _updateItemAmount(int index) {
    double qty = double.tryParse(_items[index]['qty'].toString()) ?? 0;
    double price = double.tryParse(_items[index]['price'].toString()) ?? 0;
    double disc = double.tryParse(_items[index]['disc'].toString()) ?? 0;
    double tax = double.tryParse(_items[index]['tax'].toString()) ?? 0;

    double amount = qty * price;
    amount = amount - (amount * (disc / 100));
    amount = amount + (amount * (tax / 100));

    setState(() {
      _items[index]['amount'] = amount.toStringAsFixed(2);
    });
  }

  double _calculateSubtotal() {
    double s = 0;
    for (var i in _items) s += double.tryParse(i['amount'].toString()) ?? 0;
    return s;
  }

  double _calculateGrandTotal() {
    double subtotal = _calculateSubtotal();
    double discount = double.tryParse(_discountController.text) ?? 0;
    double shipping = double.tryParse(_shippingController.text) ?? 0;
    double packaging = double.tryParse(_packagingController.text) ?? 0;
    double adjustment = double.tryParse(_adjustmentController.text) ?? 0;
    double discountAmount = subtotal * (discount / 100);
    return subtotal - discountAmount + shipping + packaging + adjustment;
  }

  Future<void> _selectDate(BuildContext context, {required Function(DateTime) onPicked, DateTime? initial}) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: initial ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (picked != null) {
      setState(() => onPicked(picked));
    }
  }

  Future<void> _selectTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(context: context, initialTime: _quotationTime);
    if (picked != null) setState(() => _quotationTime = picked);
  }

  void _showQuickAddDialog(String title, List<String> list, Function(String) onAdd) {
    final ctrl = TextEditingController();
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Add New $title"),
        content: TextField(controller: ctrl, decoration: InputDecoration(hintText: "Enter $title name")),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text("Cancel")),
          ElevatedButton(onPressed: () {
            if (ctrl.text.isNotEmpty) {
              setState(() => onAdd(ctrl.text));
              Navigator.pop(context);
            }
          }, child: const Text("Add")),
        ],
      ),
    );
  }

  Future<void> _pickAndUploadImage() async {
    final picker = ImagePicker();
    final image = await picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      setState(() => _isSaving = true);
      final bytes = await image.readAsBytes();
      final url = await _uploadToCloudinary(bytes, image.name);
      if (url != null) setState(() => _attachmentUrls.add(url));
      setState(() => _isSaving = false);
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
    } catch (e) { print("Upload error: $e"); }
    return null;
  }

  Future<void> _saveQuotation() async {
    if (_customerController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Customer Name is required")));
      return;
    }
    setState(() => _isSaving = true);
    try {
      final data = {
        "quotationId": "QTN-${DateTime.now().millisecondsSinceEpoch}",
        "quotationType": _quotationType,
        "customerName": _customerController.text,
        "salesPerson": _salesPerson,
        "paymentType": _paymentType,
        "godown": _godown,
        "quotationDate": _quotationDate.toIso8601String(),
        "validUntil": _validUntil.toIso8601String(),
        "poNo": _poNoController.text,
        "poDate": _poDate.toIso8601String(),
        "time": _quotationTime.format(context),
        "billingName": _billingNameController.text,
        "billingAddress": _billingAddressController.text,
        "shippingAddress": _shippingAddressController.text,
        "description": _descriptionController.text,
        "stateOfSupply": _stateOfSupply,
        "deliveryLocation": _deliveryLocationController.text,
        "status": _status,
        "createdBy": "admin@tajpro.com",
        "attachments": _attachmentUrls,
        "items": _items.map((item) => {
          "productName": item['productName'],
          "batchNo": item['batch'],
          "expiryDate": item['exp_date'],
          "mrp": double.tryParse(item['mrp'].toString()) ?? 0,
          "quantity": double.tryParse(item['qty'].toString()) ?? 1,
          "unit": item['unit'],
          "price": double.tryParse(item['price'].toString()) ?? 0,
          "discount": double.tryParse(item['disc'].toString()) ?? 0,
          "tax": double.tryParse(item['tax'].toString()) ?? 0,
          "amount": double.tryParse(item['amount'].toString()) ?? 0,
        }).toList(),
        "totalAmount": _calculateGrandTotal(),
        "discountPercentage": double.tryParse(_discountController.text) ?? 0,
        "shippingCharges": double.tryParse(_shippingController.text) ?? 0,
        "packagingCharges": double.tryParse(_packagingController.text) ?? 0,
        "adjustment": double.tryParse(_adjustmentController.text) ?? 0,
      };
      final response = await http.post(Uri.parse('$backendUrl/api/quotations'), headers: {"Content-Type": "application/json"}, body: jsonEncode(data));
      if (response.statusCode == 201) {
        if (mounted) {
          Navigator.pop(context);
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Quotation saved successfully!")));
        }
      }
    } catch (e) { print("Save error: $e"); }
    finally { if (mounted) setState(() => _isSaving = false); }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        title: const Text("Generate Quotation", style: TextStyle(fontWeight: FontWeight.bold, color: textPrimaryColor, fontSize: 18)),
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(icon: const Icon(Icons.arrow_back_ios_new_rounded, color: textPrimaryColor), onPressed: () => Navigator.pop(context)),
        actions: [
          if (_isSaving) const Center(child: Padding(padding: EdgeInsets.only(right: 20), child: CircularProgressIndicator(strokeWidth: 2)))
          else Padding(padding: const EdgeInsets.only(right: 8), child: TextButton.icon(onPressed: _saveQuotation, icon: const Icon(Icons.check_circle, color: successColor), label: const Text("SAVE", style: TextStyle(fontWeight: FontWeight.bold, color: successColor)))),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(defaultPadding),
        child: Column(
          children: [
            _buildCard("General Information", [
              _buildInput("Customer Name*", _customerController, hint: "Search customer..."),
              const SizedBox(height: 20),
              Row(children: [
                Expanded(child: _buildDropdown("Quotation Type", ["Standard", "Urgent"], _quotationType, (v) => setState(() => _quotationType = v!))),
                const SizedBox(width: 16),
                Expanded(child: _buildDropdown("Sales Person", _salesPersons, _salesPerson, (v) => setState(() => _salesPerson = v!), hasAdd: true, onAdd: () => _showQuickAddDialog("Sales Person", _salesPersons, (v) => _salesPersons.add(v)))),
              ]),
              const SizedBox(height: 20),
              Row(children: [
                Expanded(child: _buildDropdown("Payment Type", ["Cash", "Credit", "Online"], _paymentType, (v) => setState(() => _paymentType = v!))),
                const SizedBox(width: 16),
                Expanded(child: _buildDropdown("Godown", _godowns, _godown, (v) => setState(() => _godown = v!), hasAdd: true, onAdd: () => _showQuickAddDialog("Godown", _godowns, (v) => _godowns.add(v)))),
              ]),
            ]),
            const SizedBox(height: 20),
            _buildCard("Dates & Logistics", [
              Row(children: [
                Expanded(child: _buildDatePicker("Date", _quotationDate, (d) => _quotationDate = d)),
                const SizedBox(width: 16),
                Expanded(child: _buildTimePicker("Time", _quotationTime, () => _selectTime(context))),
              ]),
              const SizedBox(height: 20),
              Row(children: [
                Expanded(child: _buildDatePicker("Valid Until", _validUntil, (d) => _validUntil = d)),
                const SizedBox(width: 16),
                Expanded(child: _buildInput("PO Number", _poNoController)),
              ]),
              const SizedBox(height: 20),
              _buildDatePicker("PO Date", _poDate, (d) => _poDate = d),
            ]),
            const SizedBox(height: 20),
            _buildCard("Addresses", [
              _buildInput("Billing Name", _billingNameController),
              const SizedBox(height: 20),
              _buildInput("Billing Address", _billingAddressController, maxLines: 2),
              const SizedBox(height: 20),
              _buildInput("Shipping Address", _shippingAddressController, hint: "Same as billing if empty", maxLines: 2),
              const SizedBox(height: 20),
              Row(children: [
                Expanded(child: _buildDropdown("State", _states, _stateOfSupply, (v) => setState(() => _stateOfSupply = v!))),
                const SizedBox(width: 16),
                Expanded(child: _buildInput("Delivery Loc", _deliveryLocationController)),
              ]),
            ]),
            const SizedBox(height: 20),
            _buildItemsSection(),
            const SizedBox(height: 20),
            _buildSummaryCard(),
          ],
        ),
      ),
    );
  }

  Widget _buildCard(String title, List<Widget> children) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16), boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.02), blurRadius: 10)]),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(children: [
          Container(width: 4, height: 16, decoration: BoxDecoration(color: primaryColor, borderRadius: BorderRadius.circular(2))),
          const SizedBox(width: 8),
          Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
        ]),
        const Divider(height: 32),
        ...children,
      ]),
    );
  }

  Widget _buildInput(String label, TextEditingController ctrl, {String? hint, int maxLines = 1}) {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Text(label, style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: textSecondaryColor)),
      TextField(controller: ctrl, maxLines: maxLines, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold), decoration: InputDecoration(hintText: hint, border: const UnderlineInputBorder())),
    ]);
  }

  Widget _buildDropdown(String label, List<String> list, String val, Function(String?) onChg, {bool hasAdd = false, VoidCallback? onAdd}) {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Text(label, style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: textSecondaryColor)),
      Row(children: [
        Expanded(child: DropdownButton<String>(isExpanded: true, value: list.contains(val) ? val : list.first, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: textPrimaryColor), items: list.map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(), onChanged: onChg)),
        if (hasAdd) IconButton(icon: const Icon(Icons.add_box_rounded, color: primaryColor, size: 22), onPressed: onAdd),
      ]),
    ]);
  }

  Widget _buildDatePicker(String label, DateTime date, Function(DateTime) onPicked) {
    return InkWell(
      onTap: () => _selectDate(context, onPicked: onPicked, initial: date),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text(label, style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: textSecondaryColor)),
        const SizedBox(height: 12),
        Row(children: [
          const Icon(Icons.calendar_month, size: 16, color: textSecondaryColor),
          const SizedBox(width: 8),
          Text(DateFormat('dd MMM, yyyy').format(date), style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
        ]),
        const Divider(),
      ]),
    );
  }

  Widget _buildTimePicker(String label, TimeOfDay time, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text(label, style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: textSecondaryColor)),
        const SizedBox(height: 12),
        Row(children: [
          const Icon(Icons.schedule, size: 16, color: textSecondaryColor),
          const SizedBox(width: 8),
          Text(time.format(context), style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
        ]),
        const Divider(),
      ]),
    );
  }

  Widget _buildItemsSection() {
    return Container(
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16)),
      child: Column(children: [
        Padding(padding: const EdgeInsets.all(24), child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          const Text("Items & Estimates", style: TextStyle(fontWeight: FontWeight.bold)),
          TextButton.icon(onPressed: _pickAndUploadImage, icon: const Icon(Icons.attachment, size: 16), label: Text("${_attachmentUrls.length} Files")),
        ])),
        const Divider(height: 0),
        ..._items.asMap().entries.map((e) => _buildItemRow(e.key, e.value)),
        const SizedBox(height: 20),
        ElevatedButton.icon(onPressed: _addNewItem, icon: const Icon(Icons.add), label: const Text("Add More Product")),
        const SizedBox(height: 24),
      ]),
    );
  }

  Widget _buildItemRow(int index, Map<String, dynamic> item) {
    return Container(
      padding: const EdgeInsets.all(20),
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(color: bgColor.withValues(alpha: 0.5), borderRadius: BorderRadius.circular(12)),
      child: Column(children: [
        Row(children: [
          Expanded(flex: 3, child: DropdownButtonHideUnderline(child: DropdownButton<dynamic>(isExpanded: true, hint: const Text("Select Product"), value: item['productName'], items: _products.map((p) => DropdownMenuItem(value: p['name'], child: Text(p['name']))).toList(), onChanged: (v) {
            final p = _products.firstWhere((p) => p['name'] == v);
            setState(() { item['productName'] = v; item['price'] = p['price'].toString(); _updateItemAmount(index); });
          }))),
          const SizedBox(width: 12),
          Expanded(child: TextField(keyboardType: TextInputType.number, textAlign: TextAlign.center, decoration: const InputDecoration(hintText: "Qty", isDense: true), onChanged: (v) { item['qty'] = v; _updateItemAmount(index); })),
          IconButton(icon: const Icon(Icons.delete_sweep, color: errorColor), onPressed: () => setState(() { if(_items.length > 1) _items.removeAt(index); })),
        ]),
        const SizedBox(height: 12),
        Row(children: [
          Expanded(child: _smallField("Batch", (v) => item['batch'] = v)),
          const SizedBox(width: 8),
          Expanded(child: InkWell(onTap:()=> _selectDate(context, onPicked:(d)=> setState(()=> item['exp_date']=DateFormat('dd/MM/yyyy').format(d))), child: _smallField("Exp: ${item['exp_date']}", null, enabled: false))),
          const SizedBox(width: 8),
          Expanded(child: _smallField("Price", (v) { item['price'] = v; _updateItemAmount(index); }, initial: item['price'])),
        ]),
        const SizedBox(height: 12),
        Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          Text("Disc: ${item['disc']}%  |  Tax: ${item['tax']}%", style: const TextStyle(fontSize: 11, color: textSecondaryColor)),
          Text("Amount: ₹${item['amount']}", style: const TextStyle(fontWeight: FontWeight.bold, color: primaryColor)),
        ]),
      ]),
    );
  }

  Widget _smallField(String hint, Function(String)? onChg, {bool enabled = true, String? initial}) {
    return TextField(enabled: enabled, controller: initial!=null?TextEditingController(text: initial):null, onChanged: onChg, style: const TextStyle(fontSize: 12), decoration: InputDecoration(hintText: hint, isDense: true, border: const OutlineInputBorder()));
  }

  Widget _buildSummaryCard() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(color: textPrimaryColor, borderRadius: BorderRadius.circular(16)),
      child: Column(children: [
        _sumRow("Subtotal", "₹${_calculateSubtotal().toStringAsFixed(2)}"),
        _sumRowEditable("Discount %", _discountController),
        _sumRowEditable("Shipping", _shippingController),
        const Divider(color: Colors.white12, height: 32),
        Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          const Text("GRAND TOTAL", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16)),
          Text("₹${_calculateGrandTotal().toStringAsFixed(2)}", style: const TextStyle(color: Colors.white, fontSize: 26, fontWeight: FontWeight.bold)),
        ]),
      ]),
    );
  }

  Widget _sumRow(String label, String val) => Padding(padding: const EdgeInsets.only(bottom: 12), child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [Text(label, style: const TextStyle(color: Colors.white70, fontSize: 13)), Text(val, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold))]));
  Widget _sumRowEditable(String label, TextEditingController ctrl) => Padding(padding: const EdgeInsets.only(bottom: 12), child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [Text(label, style: const TextStyle(color: Colors.white70, fontSize: 13)), SizedBox(width: 60, child: TextField(controller: ctrl, style: const TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.bold), textAlign: TextAlign.right, decoration: const InputDecoration(border: InputBorder.none), onChanged: (_)=>setState(() {})))]));
}
