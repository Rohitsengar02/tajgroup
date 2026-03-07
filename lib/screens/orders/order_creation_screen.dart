import 'package:flutter/material.dart';
import '../../constants.dart';
import '../../responsive.dart';

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
  final TextEditingController _deliveryLocationController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();

  final List<Map<String, dynamic>> _items = [
    {
      "product": "Select Product",
      "batch": "",
      "exp_date": "dd/mm/yyyy",
      "mrp": "",
      "qty": "",
      "unit": "PC!",
      "price": "",
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
  }

  @override
  void dispose() {
    _controller.dispose();
    _customerController.dispose();
    _billingNameController.dispose();
    _deliveryLocationController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  void _addItem() {
    setState(() {
      _items.add({
        "product": "Select Product",
        "batch": "",
        "exp_date": "dd/mm/yyyy",
        "mrp": "",
        "qty": "",
        "unit": "PC!",
        "price": "",
        "disc": "0",
        "tax": "0",
        "amount": "0.00"
      });
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
            _buildDropdownField("ORDER TYPE", ["Secondary", "Primary"]),
            _buildTextField("CUSTOMER / PARTY *", "Select Customer", controller: _customerController),
            _buildDropdownField("SALES PERSON", ["Select Sales Person", "Rahul Sharma", "Amit Kumar"]),
            _buildDropdownField("PAYMENT", ["Credit", "Cash", "Online"]),
          ]),
          const SizedBox(height: 24),
          _buildRow([
            _buildDropdownField("GODOWN", ["Select Godown", "Main Warehouse", "North Depot"]),
            _buildTextField("BILLING NAME", "Optional", controller: _billingNameController),
            _buildTextField("BILLING ADDRESS", "Enter billing address", maxLines: 2),
            _buildTextField("SHIPPING ADDRESS", "Enter shipping address", maxLines: 2),
          ]),
          const SizedBox(height: 24),
          _buildRow([
            _buildTextField("PO NO.", ""),
            _buildDateField("PO DATE", "dd/mm/yyyy"),
            _buildTextField("E-WAY BILL NO.", ""),
            _buildTextField("INVOICE NUMBER", ""),
          ]),
          const SizedBox(height: 24),
          _buildRow([
            _buildDateField("INVOICE DATE", "23/02/2026"),
            _buildTimeField("TIME", "13:24"),
            _buildDropdownField("STATE OF SUPPLY", ["Select state", "Delhi", "Mumbai", "Bangalore"]),
            _buildDateField("DATE", "23/02/2026"),
          ]),
          const SizedBox(height: 24),
          _buildDropdownField("STATUS", ["Confirmed", "Pending", "Processing"], widthFactor: 0.25),
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
                const Text("₹0.00", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: Color(0xFF1E293B))),
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
          const Expanded(
            flex: 4,
            child: _TableDropdown(value: "Select Product"),
          ),
          const SizedBox(width: 8),
          const SizedBox(width: 80, child: _TableInput()),
          const SizedBox(width: 8),
          const SizedBox(width: 120, child: _TableDateInput()),
          const SizedBox(width: 8),
          const SizedBox(width: 70, child: _TableInput()),
          const SizedBox(width: 8),
          const SizedBox(width: 60, child: _TableInput()),
          const SizedBox(width: 8),
          const SizedBox(width: 80, child: _TableDropdown(value: "PC!")),
          const SizedBox(width: 8),
          const SizedBox(width: 70, child: _TableInput()),
          const SizedBox(width: 8),
          const SizedBox(width: 60, child: _TableInput()),
          const SizedBox(width: 8),
          const SizedBox(width: 60, child: _TableDropdown(value: "0%")),
          const SizedBox(width: 8),
          const SizedBox(
            width: 90,
            child: Text("₹0.00", textAlign: TextAlign.right, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: Color(0xFF1E293B))),
          ),
          const SizedBox(width: 8),
          const SizedBox(
            width: 32,
            child: Icon(Icons.close_rounded, color: Colors.redAccent, size: 16),
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
             _buildDropdownField("PRODUCT", ["Select Product"]),
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
                    child: const Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.image_outlined, color: Color(0xFF64748B), size: 32),
                        SizedBox(height: 8),
                        Text("Click to upload", style: TextStyle(color: Color(0xFF64748B), fontSize: 13)),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(width: 20),
            Expanded(
              child: _buildDropdownField("NO. OF COPIES", ["Original, Duplicate", "Original Only", "Copy Only"]),
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
          _buildSummaryRow("Discount (%)", "-", isInput: true),
          _buildSummaryRow("Shipping", "-", isInput: true),
          _buildSummaryRow("Packaging", "-", isInput: true),
          _buildSummaryRow("Adjustment", "-", isInput: true),
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 12),
            child: Divider(),
          ),
          const Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("Total", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: Color(0xFF1E293B))),
              Text("₹0.00", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24, color: primaryColor)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryRow(String label, String value, {bool isInput = false}) {
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

  Widget _buildDropdownField(String label, List<String> options, {double? widthFactor}) {
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
              value: options.first,
              icon: const Icon(Icons.keyboard_arrow_down_rounded, color: Color(0xFF64748B)),
              style: const TextStyle(fontSize: 13, color: Color(0xFF1E293B)),
              items: options.map((String value) {
                return DropdownMenuItem<String>(value: value, child: Text(value));
              }).toList(),
              onChanged: (_) {},
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildDateField(String label, String value) {
    return Column(
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
              Text(value, style: const TextStyle(fontSize: 13, color: Color(0xFF64748B))),
              const Icon(Icons.calendar_today_rounded, size: 16, color: Color(0xFF64748B)),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildTimeField(String label, String value) {
    return Column(
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
              Text(value, style: const TextStyle(fontSize: 13, color: Color(0xFF64748B))),
              const Icon(Icons.access_time_rounded, size: 16, color: Color(0xFF64748B)),
            ],
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
            widget.onOrderCreated({
              "id": "#INV-10${DateTime.now().millisecond}",
              "customer": _customerController.text.isEmpty ? "Walk-in Customer" : _customerController.text,
              "date": "Oct 24, 2026",
              "status": "Confirmed",
              "total": "₹15,200",
            });
            Navigator.pop(context);
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
        child: Text(text, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
      ),
    );
  }
}

class _TableInput extends StatelessWidget {
  const _TableInput();
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 38,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: Colors.grey.withValues(alpha: 0.2)),
      ),
      child: const TextField(
        textAlign: TextAlign.center,
        style: TextStyle(fontSize: 12, color: Color(0xFF1E293B)),
        decoration: InputDecoration(
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
  const _TableDateInput();
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 38,
      padding: const EdgeInsets.symmetric(horizontal: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: Colors.grey.withValues(alpha: 0.2)),
      ),
      child: const Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(child: Text("dd/mm/yyyy", style: TextStyle(fontSize: 11, color: Color(0xFF64748B)), overflow: TextOverflow.ellipsis)),
          Icon(Icons.calendar_today_rounded, size: 12, color: Color(0xFF64748B)),
        ],
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
