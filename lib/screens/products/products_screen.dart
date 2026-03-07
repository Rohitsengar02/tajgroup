import 'package:flutter/material.dart';
import '../../constants.dart';
import '../../responsive.dart';

class ProductsScreen extends StatelessWidget {
  const ProductsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(defaultPadding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const _ProductsHeader(),
            const SizedBox(height: defaultPadding),
            const _InventoryAnalytics(),
            const SizedBox(height: defaultPadding * 1.5),
            const _ActionRow(),
            const SizedBox(height: defaultPadding),
            const _ProductsGrid(),
            const SizedBox(height: defaultPadding * 2),
          ],
        ),
      ),
    );
  }
}

class _ProductsHeader extends StatelessWidget {
  const _ProductsHeader();

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
                onPressed: () {},
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
              onPressed: () {},
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
  const _InventoryAnalytics();

  @override
  Widget build(BuildContext context) {
    bool isMobile = Responsive.isMobile(context);
    List<Widget> stats = [
      _buildStatCard("Total SKUs", "428", Icons.inventory_2_outlined, const Color(0xFF6366F1)),
      _buildStatCard("Out of Stock", "12", Icons.warning_amber_rounded, const Color(0xFFEF4444)),
      _buildStatCard("Low Stock", "34", Icons.trending_down_rounded, const Color(0xFFF59E0B)),
      _buildStatCard("New Arrivals", "8", Icons.stars_rounded, const Color(0xFF22C55E)),
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
  const _ActionRow();

  @override
  Widget build(BuildContext context) {
    bool isMobile = Responsive.isMobile(context);
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
                child: const TextField(
                  decoration: InputDecoration(
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
              _buildFilterButton(context, "Categories"),
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
              children: [
                _buildMobileFilterChip("Categories"),
                _buildMobileFilterChip("Brands"),
                _buildMobileFilterChip("Price"),
                _buildMobileFilterChip("Status"),
              ],
            ),
          ),
        ],
      ],
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
    return Container(
      margin: const EdgeInsets.only(right: 8),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      decoration: BoxDecoration(
        color: surfaceColor,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: textSecondaryColor.withValues(alpha: 0.1)),
      ),
      child: Text(label, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500)),
    );
  }
}

class _ProductsGrid extends StatelessWidget {
  const _ProductsGrid();

  @override
  Widget build(BuildContext context) {
    bool isMobile = Responsive.isMobile(context);
    bool isTablet = Responsive.isTablet(context);

    final List<Map<String, dynamic>> products = [
      {"name": "Parle-G Biscuit 800g", "sku": "SKU-440211", "category": "FMCG Snacks", "price": "₹85.00", "stock": "542", "status": "In Stock", "img": "https://images.unsplash.com/photo-1546868871-7041f2a55e12?auto=format&fit=crop&q=80&w=300&h=300"},
      {"name": "Tata Salt 1kg", "sku": "SKU-440212", "category": "Grocery", "price": "₹28.00", "stock": "0", "status": "Out of Stock", "img": "https://images.unsplash.com/photo-1550508138-062400ceae21?auto=format&fit=crop&q=80&w=300&h=300"},
      {"name": "Maggi Noodles", "sku": "SKU-440213", "category": "FMCG Snacks", "price": "₹12.00", "stock": "22", "status": "Low Stock", "img": "https://images.unsplash.com/photo-1621939514649-280e2ee25f60?auto=format&fit=crop&q=80&w=300&h=300"},
      {"name": "Amul Butter 500g", "sku": "SKU-440214", "category": "Dairy", "price": "₹260.00", "stock": "145", "status": "In Stock", "img": "https://images.unsplash.com/photo-1631451095765-2c91616fc9e6?auto=format&fit=crop&q=80&w=300&h=300"},
    ];
    
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
      itemBuilder: (context, index) => _ProductCard(data: products[index]),
    );
  }
}

class _ProductCard extends StatelessWidget {
  final Map<String, dynamic> data;
  const _ProductCard({required this.data});

  @override
  Widget build(BuildContext context) {
    Color statusColor = data["status"] == "In Stock" 
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
                    image: DecorationImage(image: NetworkImage(data["img"]), fit: BoxFit.cover),
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
                    Text(data["category"], style: const TextStyle(fontSize: 10, color: textSecondaryColor, fontWeight: FontWeight.bold)),
                    Text(data["sku"], style: const TextStyle(fontSize: 10, color: textSecondaryColor)),
                  ],
                ),
                const SizedBox(height: 8),
                Text(data["name"], style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: textPrimaryColor), overflow: TextOverflow.ellipsis),
                const SizedBox(height: 12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text("Price", style: TextStyle(fontSize: 9, color: textSecondaryColor, fontWeight: FontWeight.bold)),
                        Text(data["price"], style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w900, color: primaryColor)),
                      ],
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        const Text("Available", style: TextStyle(fontSize: 9, color: textSecondaryColor, fontWeight: FontWeight.bold)),
                        Text("${data["stock"]} Units", style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: textPrimaryColor)),
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
