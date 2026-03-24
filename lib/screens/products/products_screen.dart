import 'package:flutter/material.dart';
import '../../constants.dart';
import '../../responsive.dart';
import 'product_creation_screen.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ProductsScreen extends StatefulWidget {
  const ProductsScreen({super.key});

  @override
  State<ProductsScreen> createState() => _ProductsScreenState();
}

class _ProductsScreenState extends State<ProductsScreen> {
  List<dynamic> _products = [];
  List<dynamic> _filteredProducts = [];
  bool _isLoading = true;
  String _searchQuery = "";
  String _selectedCategory = "All";
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _fetchProducts();
  }

  Future<void> _fetchProducts() async {
    setState(() => _isLoading = true);
    try {
      final response = await http.get(Uri.parse('$backendUrl/api/products'));
      if (response.statusCode == 200) {
        setState(() {
          _products = jsonDecode(response.body);
          _applyFilters();
          _isLoading = false;
        });
      }
    } catch (e) {
      print("Error fetching products: $e");
      if (mounted) setState(() => _isLoading = false);
    }
  }

  void _applyFilters() {
    setState(() {
      _filteredProducts = _products.where((product) {
        final matchesSearch = product['name'].toString().toLowerCase().contains(_searchQuery.toLowerCase()) ||
            product['sku'].toString().toLowerCase().contains(_searchQuery.toLowerCase());
        final matchesCategory = _selectedCategory == "All" || product['category'] == _selectedCategory;
        return matchesSearch && matchesCategory;
      }).toList();
    });
  }

  void _openCreateProduct() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ProductCreationScreen(
          onProductCreated: (newProduct) {
            _fetchProducts(); // Refresh list
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(defaultPadding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _ProductsHeader(onAddPressed: _openCreateProduct),
            const SizedBox(height: defaultPadding),
            _InventoryAnalytics(
              totalSkus: _products.length,
              outOfStock: _products.where((p) => p['status'] == 'Out of Stock' || (p['currentStock'] ?? 0) <= 0).length,
              lowStock: _products.where((p) => (p['currentStock'] ?? 0) < (p['minStockLevel'] ?? 10) && (p['currentStock'] ?? 0) > 0).length,
            ),
            const SizedBox(height: defaultPadding * 1.5),
            _ActionRow(
              onSearchChanged: (value) {
                _searchQuery = value;
                _applyFilters();
              },
              onCategoryChanged: (value) {
                _selectedCategory = value;
                _applyFilters();
              },
              selectedCategory: _selectedCategory,
              searchController: _searchController,
            ),
            const SizedBox(height: defaultPadding),
            if (_isLoading)
              const Center(child: CircularProgressIndicator())
            else
              _ProductsGrid(products: _filteredProducts),
            const SizedBox(height: defaultPadding * 2),
          ],
        ),
      ),
    );
  }
}

class _ProductsHeader extends StatelessWidget {
  final VoidCallback onAddPressed;
  const _ProductsHeader({required this.onAddPressed});

  @override
  Widget build(BuildContext context) {
    bool isMobile = Responsive.isMobile(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Products & SKU",
                  style: TextStyle(fontSize: isMobile ? 24 : 28, fontWeight: FontWeight.bold, color: textPrimaryColor),
                ),
                const SizedBox(height: 4),
                Text(
                  isMobile ? "Manage catalog" : "Monitor inventory levels and product performance across SKUs",
                  style: TextStyle(fontSize: isMobile ? 12 : 14, color: textSecondaryColor, fontWeight: FontWeight.w500),
                ),
              ],
            ),
            if (!isMobile)
              ElevatedButton.icon(
                onPressed: onAddPressed,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF1E293B),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                ),
                icon: const Icon(Icons.add_rounded, size: 20),
                label: const Text("Add Product", style: TextStyle(fontWeight: FontWeight.bold)),
              ),
          ],
        ),
        if (isMobile) ...[
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: onAddPressed,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF1E293B),
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              ),
              icon: const Icon(Icons.add_rounded, size: 20),
              label: const Text("Add New SKU", style: TextStyle(fontWeight: FontWeight.bold)),
            ),
          ),
        ],
      ],
    );
  }
}

class _InventoryAnalytics extends StatelessWidget {
  final int totalSkus;
  final int outOfStock;
  final int lowStock;
  const _InventoryAnalytics({required this.totalSkus, required this.outOfStock, required this.lowStock});

  @override
  Widget build(BuildContext context) {
    bool isMobile = Responsive.isMobile(context);
    List<Widget> stats = [
      _buildStatCard("Total SKUs", totalSkus.toString(), Icons.inventory_2_outlined, const Color(0xFF6366F1)),
      _buildStatCard("Out of Stock", outOfStock.toString(), Icons.warning_amber_rounded, const Color(0xFFEF4444)),
      _buildStatCard("Low Stock", lowStock.toString(), Icons.trending_down_rounded, const Color(0xFFF59E0B)),
      _buildStatCard("New Arrivals", "0", Icons.stars_rounded, const Color(0xFF22C55E)),
    ];

    if (isMobile) {
      return SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: stats.map((stat) => Container(
            width: MediaQuery.of(context).size.width * 0.65,
            margin: const EdgeInsets.only(right: 16),
            child: stat,
          )).toList(),
        ),
      );
    }

    return GridView.count(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: 4,
      crossAxisSpacing: defaultPadding,
      mainAxisSpacing: defaultPadding,
      childAspectRatio: 2.2,
      children: stats,
    );
  }

  Widget _buildStatCard(String title, String value, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: surfaceColor,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(color: Colors.black.withValues(alpha: 0.02), blurRadius: 10, offset: const Offset(0, 5))
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(color: color.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(12)),
            child: Icon(icon, color: color, size: 24),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(value, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w900, color: textPrimaryColor)),
                Text(title, style: const TextStyle(fontSize: 11, color: textSecondaryColor, fontWeight: FontWeight.w600), overflow: TextOverflow.ellipsis),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _ActionRow extends StatelessWidget {
  final Function(String) onSearchChanged;
  final Function(String) onCategoryChanged;
  final String selectedCategory;
  final TextEditingController searchController;

  const _ActionRow({
    required this.onSearchChanged,
    required this.onCategoryChanged,
    required this.selectedCategory,
    required this.searchController,
  });

  @override
  Widget build(BuildContext context) {
    bool isMobile = Responsive.isMobile(context);
    final List<String> categories = ["All", "General", "Electronics", "Groceries", "Healthcare", "Fashion"];

    return Column(
      children: [
        Row(
          children: [
            Expanded(
              flex: 5,
              child: Container(
                height: 48,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                decoration: BoxDecoration(
                  color: surfaceColor,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: textSecondaryColor.withValues(alpha: 0.1)),
                ),
                child: TextField(
                  controller: searchController,
                  onChanged: onSearchChanged,
                  decoration: const InputDecoration(
                    hintText: "Search items, SKU code...",
                    hintStyle: TextStyle(fontSize: 14, color: textSecondaryColor),
                    icon: Icon(Icons.search, size: 20, color: textSecondaryColor),
                    border: InputBorder.none,
                  ),
                ),
              ),
            ),
            if (!isMobile) ...[
              const SizedBox(width: 16),
              _buildCategoryDropdown(context, categories),
              const SizedBox(width: 8),
              _buildFilterButton(context, "Brand"),
            ],
          ],
        ),
        if (isMobile) ...[
          const SizedBox(height: 12),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: categories.map((cat) => _buildMobileFilterChip(cat)).toList(),
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildCategoryDropdown(BuildContext context, List<String> categories) {
    return Container(
      height: 48,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: surfaceColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: textSecondaryColor.withValues(alpha: 0.1)),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: selectedCategory,
          icon: const Icon(Icons.keyboard_arrow_down_rounded, size: 18),
          items: categories.map((cat) => DropdownMenuItem(
            value: cat,
            child: Text(cat, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600)),
          )).toList(),
          onChanged: (val) {
            if (val != null) onCategoryChanged(val);
          },
        ),
      ),
    );
  }

  Widget _buildFilterButton(BuildContext context, String label) {
    return Container(
      height: 48,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: surfaceColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: textSecondaryColor.withValues(alpha: 0.1)),
      ),
      child: Center(
        child: Row(
          children: [
            Text(label, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600)),
            const SizedBox(width: 8),
            const Icon(Icons.keyboard_arrow_down_rounded, size: 18),
          ],
        ),
      ),
    );
  }

  Widget _buildMobileFilterChip(String label) {
    bool isSelected = selectedCategory == label;
    return GestureDetector(
      onTap: () => onCategoryChanged(label),
      child: Container(
        margin: const EdgeInsets.only(right: 8),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? primaryColor : surfaceColor,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: isSelected ? primaryColor : textSecondaryColor.withValues(alpha: 0.1)),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w500,
            color: isSelected ? Colors.white : textPrimaryColor,
          ),
        ),
      ),
    );
  }
}

class _ProductsGrid extends StatelessWidget {
  final List<dynamic> products;
  const _ProductsGrid({required this.products});

  @override
  Widget build(BuildContext context) {
    bool isMobile = Responsive.isMobile(context);
    bool isTablet = Responsive.isTablet(context);

    // List of products passed in
    
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: isMobile ? 1 : (isTablet ? 2 : 3),
        crossAxisSpacing: defaultPadding,
        mainAxisSpacing: defaultPadding,
        childAspectRatio: isMobile ? 1.4 : 1.1,
      ),
      itemCount: products.length,
      itemBuilder: (context, index) => _ProductCard(data: products[index] as Map<String, dynamic>),
    );
  }
}

class _ProductCard extends StatelessWidget {
  final Map<String, dynamic> data;
  const _ProductCard({required this.data});

  @override
  Widget build(BuildContext context) {
    Color statusColor = data["status"] == "Active" 
        ? const Color(0xFF22C55E) 
        : data["status"] == "Low Stock" 
            ? const Color(0xFFF59E0B) 
            : const Color(0xFFEF4444);

    return Container(
      decoration: BoxDecoration(
        color: surfaceColor,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(color: Colors.black.withValues(alpha: 0.03), blurRadius: 10, offset: const Offset(0, 5))
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Stack(
              children: [
                Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: const Color(0xFFF8FAFC),
                    borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
                    image: DecorationImage(
                      image: NetworkImage(data["images"] != null && data["images"].isNotEmpty 
                          ? data["images"][0] 
                          : "https://images.unsplash.com/photo-1546868871-7041f2a55e12?auto=format&fit=crop&q=80&w=300&h=300"), 
                      fit: BoxFit.cover
                    ),
                  ),
                ),
                Positioned(
                  top: 12,
                  right: 12,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(8), boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.1), blurRadius: 4)]),
                    child: Text(data["status"], style: TextStyle(color: statusColor, fontSize: 10, fontWeight: FontWeight.bold)),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(data["category"] ?? "General", style: const TextStyle(fontSize: 10, color: textSecondaryColor, fontWeight: FontWeight.bold)),
                    Text(data["sku"] ?? "N/A", style: const TextStyle(fontSize: 10, color: textSecondaryColor)),
                  ],
                ),
                const SizedBox(height: 8),
                Text(data["name"] ?? "Unnamed Product", style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: textPrimaryColor), overflow: TextOverflow.ellipsis),
                const SizedBox(height: 12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text("Price", style: TextStyle(fontSize: 9, color: textSecondaryColor, fontWeight: FontWeight.bold)),
                        Text("₹${data["price"]}", style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w900, color: primaryColor)),
                      ],
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        const Text("Available", style: TextStyle(fontSize: 9, color: textSecondaryColor, fontWeight: FontWeight.bold)),
                        Text("${data["currentStock"] ?? 0} Units", style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: textPrimaryColor)),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
