import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../../constants.dart';
import '../../responsive.dart';
import 'create_scheme_screen.dart';

class SchemesScreen extends StatefulWidget {
  const SchemesScreen({super.key});

  @override
  State<SchemesScreen> createState() => _SchemesScreenState();
}

class _SchemesScreenState extends State<SchemesScreen> {
  List<dynamic> schemesList = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchSchemes();
  }

  Future<void> _fetchSchemes() async {
    setState(() => isLoading = true);
    try {
      final response = await http.get(Uri.parse('$backendUrl/api/schemes'));
      if (response.statusCode == 200) {
        if (mounted) {
          setState(() {
            schemesList = json.decode(response.body);
            isLoading = false;
          });
        }
      } else {
        throw Exception('Failed to load schemes');
      }
    } catch (error) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error fetching: $error'), backgroundColor: errorColor),
        );
        setState(() => isLoading = false);
      }
    }
  }

  Future<void> _deleteScheme(String id) async {
    try {
      final response = await http.delete(Uri.parse('$backendUrl/api/schemes/$id'));
      if (response.statusCode == 200) {
        _fetchSchemes();
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Scheme Deleted')));
        }
      }
    } catch (e) {
      debugPrint("Error deleting: $e");
    }
  }

  void _editScheme(Map<String, dynamic> scheme) async {
    final result = await Navigator.push(context, MaterialPageRoute(builder: (context) => CreateSchemeScreen(schemeData: scheme)));
    if (result == true) {
      _fetchSchemes();
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(defaultPadding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const _Header(),
            const SizedBox(height: defaultPadding),
            _SchemesStats(schemes: schemesList),
            const SizedBox(height: defaultPadding * 1.5),
            _ActionRow(onRefresh: _fetchSchemes),
            const SizedBox(height: defaultPadding * 1.5),
            isLoading
                ? const Center(child: Padding(padding: EdgeInsets.all(50), child: CircularProgressIndicator()))
                : schemesList.isEmpty
                    ? const Center(child: Padding(padding: EdgeInsets.all(50), child: Text("No schemes active. Create one!", style: TextStyle(color: textSecondaryColor, fontSize: 16))))
                    : _SchemesGrid(schemes: schemesList, onDelete: _deleteScheme, onEdit: _editScheme),
            const SizedBox(height: defaultPadding * 2),
          ],
        ),
      ),
    );
  }
}

class _Header extends StatelessWidget {
  const _Header();

  @override
  Widget build(BuildContext context) {
    bool isMobile = Responsive.isMobile(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Promotion Schemes",
          style: TextStyle(fontSize: isMobile ? 24 : 28, fontWeight: FontWeight.bold, color: textPrimaryColor),
        ),
        const SizedBox(height: 4),
        Text(
          isMobile ? "Manage trade offers" : "Manage trade offers, discounts, and rewards",
          style: TextStyle(fontSize: isMobile ? 12 : 14, color: textSecondaryColor, fontWeight: FontWeight.w500),
        ),
      ],
    );
  }
}

class _SchemesStats extends StatelessWidget {
  final List<dynamic> schemes;
  const _SchemesStats({required this.schemes});

  @override
  Widget build(BuildContext context) {
    bool isMobile = Responsive.isMobile(context);
    int active = schemes.where((s) => s['status'] == 'Active').length;
    int upcoming = schemes.where((s) => s['status'] == 'Upcoming').length;
    int total = schemes.length;
    
    // Example computation
    double avgUsage = schemes.isEmpty ? 0 : schemes.map((s) => 0.45).reduce((a,b)=>a+b) / schemes.length;
    
    double activeProgress = total > 0 ? active / total : 0;
    double upcomingProgress = total > 0 ? upcoming / total : 0;

    List<Widget> stats = [
      _buildModernStatCard(
        id: "#SCM-ACT", 
        chipLabel: "Live Deals", 
        mainValue: "$active Active", 
        subText: "Currently running schemes", 
        progress: activeProgress, 
        progressLabel: "Active rate", 
        suffixText: "$active items", 
        themeColor: const Color(0xFFD97706), // Vivid Orange
      ),
      _buildModernStatCard(
        id: "#SCM-UPC", 
        chipLabel: "Scheduled", 
        mainValue: "$upcoming Upcoming", 
        subText: "Ready to launch soon", 
        progress: upcomingProgress, 
        progressLabel: "Queue rate", 
        suffixText: "$upcoming items", 
        themeColor: const Color(0xFF059669), // Emerald Green
      ),
      _buildModernStatCard(
        id: "#SCM-AVG", 
        chipLabel: "Performance", 
        mainValue: "${(avgUsage * 100).toInt()}% Avg.", 
        subText: "Overall redemption rate", 
        progress: avgUsage, 
        progressLabel: "Utilized", 
        suffixText: "Global", 
        themeColor: const Color(0xFF4F46E5), // Indigo
      ),
      _buildModernStatCard(
        id: "#SCM-TOT", 
        chipLabel: "Catalogue", 
        mainValue: "$total Schemes", 
        subText: "Total historical footprint", 
        progress: 1.0, 
        progressLabel: "Total base", 
        suffixText: "All time", 
        themeColor: const Color(0xFFDB2777), // Pink
      ),
    ];

    if (isMobile) {
      return SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: stats.map((stat) => Container(
            width: MediaQuery.of(context).size.width * 0.75,
            height: 140, // Decreased height
            margin: const EdgeInsets.only(right: 16),
            child: stat,
          )).toList(),
        ),
      );
    }

    return GridView.count(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: Responsive.isTablet(context) ? 2 : 4,
      crossAxisSpacing: defaultPadding,
      mainAxisSpacing: defaultPadding,
      childAspectRatio: Responsive.isTablet(context) ? 2.4 : 2.1, // Increased aspect ratio explicitly to decrease native height
      children: stats,
    );
  }

  Widget _buildModernStatCard({
    required String id, 
    required String chipLabel, 
    required String mainValue, 
    required String subText, 
    required double progress, 
    required String progressLabel, 
    required String suffixText, 
    required Color themeColor,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12), // Tighter vertical padding
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            themeColor.withValues(alpha: 0.15),
            Colors.white.withValues(alpha: 0.8),
            Colors.white,
          ],
          stops: const [0.0, 0.5, 1.0],
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 15,
            offset: const Offset(0, 8),
          ),
        ],
        border: Border.all(color: Colors.white, width: 2),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(id, style: TextStyle(color: themeColor, fontSize: 11, fontWeight: FontWeight.w700)),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey.withValues(alpha: 0.2)),
                  borderRadius: BorderRadius.circular(20),
                  color: Colors.white.withValues(alpha: 0.5),
                ),
                child: Text(chipLabel, style: const TextStyle(fontSize: 10, fontWeight: FontWeight.w600, color: Colors.black87)),
              ),
            ],
          ),
          
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(mainValue, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black87)),
                const SizedBox(height: 2),
                Text(subText, style: const TextStyle(fontSize: 11, color: Colors.black54, fontWeight: FontWeight.w500), maxLines: 1, overflow: TextOverflow.ellipsis),
              ],
            ),
          ),
          
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  SizedBox(
                    width: 28,
                    height: 28,
                    child: Stack(
                      fit: StackFit.expand,
                      children: [
                        CircularProgressIndicator(
                          value: 1.0,
                          strokeWidth: 4,
                          color: themeColor.withValues(alpha: 0.2),
                        ),
                        CircularProgressIndicator(
                          value: progress,
                          strokeWidth: 4,
                          strokeCap: StrokeCap.round,
                          color: themeColor,
                        ),
                        Center(
                          child: Text(
                            "${(progress * 100).toInt()}%",
                            style: TextStyle(fontSize: 9, fontWeight: FontWeight.bold, color: themeColor),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(progressLabel, style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: themeColor)),
                ],
              ),
              Row(
                children: [
                  Text(suffixText, style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: themeColor)),
                  const SizedBox(width: 4),
                  Icon(Icons.arrow_outward_rounded, size: 14, color: themeColor),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _ActionRow extends StatelessWidget {
  final VoidCallback onRefresh;
  const _ActionRow({required this.onRefresh});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        InkWell(
          onTap: () async {
            final result = await Navigator.push(context, MaterialPageRoute(builder: (context) => const CreateSchemeScreen()));
            if (result == true) {
              onRefresh();
            }
          },
          borderRadius: BorderRadius.circular(12),
          child: Container(
            height: 48,
            padding: const EdgeInsets.symmetric(horizontal: 24),
            decoration: BoxDecoration(
              color: const Color(0xFF6366F1),
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(color: const Color(0xFF6366F1).withValues(alpha: 0.3), blurRadius: 10, offset: const Offset(0, 4))
              ],
            ),
            child: const Row(
              children: [
                Icon(Icons.add_rounded, color: Colors.white, size: 20),
                SizedBox(width: 8),
                Text("Create Scheme", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _SchemesGrid extends StatelessWidget {
  final List<dynamic> schemes;
  final Function(String) onDelete;
  final Function(Map<String, dynamic>) onEdit;

  const _SchemesGrid({required this.schemes, required this.onDelete, required this.onEdit});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      int crossAxisCount = Responsive.isMobile(context) ? 1 : (Responsive.isTablet(context) ? 2 : 3);
      return GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: crossAxisCount,
          crossAxisSpacing: defaultPadding,
          mainAxisSpacing: defaultPadding,
          mainAxisExtent: 380, // Taller size to accommodate banner images
        ),
        itemCount: schemes.length,
        itemBuilder: (context, index) {
          final scheme = schemes[index];
          
          Color typeColor = Colors.blue;
          String type = scheme['type'] ?? 'Value';
          if(type == "Percentage") typeColor = Colors.orange;
          if(type == "Quantity") typeColor = Colors.purple;
          if(type == "Combo") typeColor = Colors.pink;
          if(type == "Flat") typeColor = Colors.teal;

          return _SchemeCard(
            id: scheme['_id'] ?? "",
            type: scheme["type"] ?? "N/A",
            status: scheme["status"] ?? "Active",
            title: scheme["title"] ?? "Untitled",
            products: scheme["products"] ?? "N/A",
            discountValue: scheme["discountValue"] ?? "N/A",
            startDate: scheme["startDate"] ?? "N/A",
            endDate: scheme["endDate"] ?? "N/A",
            usage: scheme["usage"] ?? "0%",
            progress: (scheme["progress"] as num?)?.toDouble() ?? 0.0,
            imageUrl: scheme["imageUrl"] ?? "",
            typeColor: typeColor,
            onDelete: onDelete,
            onEdit: () => onEdit(scheme),
          );
        },
      );
    });
  }
}

class _SchemeCard extends StatefulWidget {
  final String id, type, status, title, products, discountValue, startDate, endDate, usage, imageUrl;
  final double progress;
  final Color typeColor;
  final Function(String) onDelete;
  final VoidCallback onEdit;

  const _SchemeCard({
    required this.id,
    required this.type,
    required this.status,
    required this.title,
    required this.products,
    required this.discountValue,
    required this.startDate,
    required this.endDate,
    required this.usage,
    required this.progress,
    required this.typeColor,
    required this.imageUrl,
    required this.onDelete,
    required this.onEdit,
  });

  @override
  State<_SchemeCard> createState() => _SchemeCardState();
}

class _SchemeCardState extends State<_SchemeCard> {
  bool _isHovered = false;

  void _confirmDelete() {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Delete Scheme'),
        content: const Text('Remove this promotion permanently?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Cancel')),
          TextButton(
            onPressed: () {
              Navigator.pop(ctx);
              widget.onDelete(widget.id);
            },
            child: const Text('Delete', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    Color statusColor = widget.status == "Active" 
        ? const Color(0xFF22C55E) 
        : (widget.status == "Upcoming" ? const Color(0xFF6366F1) : const Color(0xFF94A3B8));

    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: AnimatedScale(
        scale: _isHovered ? 1.02 : 1.0,
        duration: const Duration(milliseconds: 200),
        child: Container(
          decoration: BoxDecoration(
            color: surfaceColor,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: _isHovered ? primaryColor.withValues(alpha: 0.1) : Colors.black.withValues(alpha: 0.03),
                blurRadius: _isHovered ? 20 : 10,
                offset: _isHovered ? const Offset(0, 10) : const Offset(0, 5),
              )
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Cloudinary Image Banner Segment
              ClipRRect(
                borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
                child: SizedBox(
                  height: 140,
                  width: double.infinity,
                  child: widget.imageUrl.isNotEmpty
                      ? Image.network(widget.imageUrl, fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) => 
                              _buildImagePlaceholder())
                      : _buildImagePlaceholder(),
                ),
              ),
              
              Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(color: widget.typeColor.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(8)),
                          child: Text(widget.type, style: TextStyle(color: widget.typeColor, fontSize: 10, fontWeight: FontWeight.bold)),
                        ),
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                              decoration: BoxDecoration(color: statusColor.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(8)),
                              child: Text(widget.status, style: TextStyle(color: statusColor, fontSize: 10, fontWeight: FontWeight.bold)),
                            ),
                            const SizedBox(width: 8),
                            PopupMenuButton<String>(
                              padding: EdgeInsets.zero,
                              iconSize: 20,
                              icon: const Icon(Icons.more_vert_rounded, color: textSecondaryColor),
                              onSelected: (value) {
                                if (value == 'edit') widget.onEdit();
                                if (value == 'delete') _confirmDelete();
                              },
                              itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
                                const PopupMenuItem<String>(
                                  value: 'edit',
                                  child: Row(
                                    children: [
                                      Icon(Icons.edit_outlined, size: 18, color: textPrimaryColor),
                                      SizedBox(width: 8),
                                      Text('Edit Scheme'),
                                    ],
                                  ),
                                ),
                                const PopupMenuItem<String>(
                                  value: 'delete',
                                  child: Row(
                                    children: [
                                      Icon(Icons.delete_outline, size: 18, color: Colors.red),
                                      SizedBox(width: 8),
                                      Text('Delete', style: TextStyle(color: Colors.red)),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Text(widget.title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 17, color: textPrimaryColor), maxLines: 1, overflow: TextOverflow.ellipsis),
                    const SizedBox(height: 4),
                    Text("Products: ${widget.products}", style: const TextStyle(fontSize: 12, color: textSecondaryColor, fontWeight: FontWeight.w500), maxLines: 1, overflow: TextOverflow.ellipsis),
                    const SizedBox(height: 4),
                    Text("Offer: ${widget.discountValue}", style: const TextStyle(fontSize: 13, color: successColor, fontWeight: FontWeight.w900), maxLines: 1, overflow: TextOverflow.ellipsis),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        const Icon(Icons.calendar_today_rounded, size: 14, color: textSecondaryColor),
                        const SizedBox(width: 6),
                        Text("${widget.startDate}  -  ${widget.endDate}", style: const TextStyle(fontSize: 11, color: textSecondaryColor, fontWeight: FontWeight.w500)),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text("Budget Depleted", style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: textPrimaryColor)),
                        Text(widget.usage, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: textPrimaryColor)),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Stack(
                      children: [
                        Container(height: 6, width: double.infinity, decoration: BoxDecoration(color: const Color(0xFFF1F5F9), borderRadius: BorderRadius.circular(10))),
                        FractionallySizedBox(
                          widthFactor: widget.progress,
                          child: Container(
                            height: 6,
                            decoration: BoxDecoration(gradient: LinearGradient(colors: [primaryColor, primaryColor.withValues(alpha: 0.6)]), borderRadius: BorderRadius.circular(10)),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildImagePlaceholder() {
    return Container(
      color: bgColor,
      child: const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.local_offer_rounded, size: 40, color: primaryColor),
            SizedBox(height: 8),
            Text("Scheme Profile", style: TextStyle(color: textSecondaryColor, fontSize: 12, fontWeight: FontWeight.bold)),
          ],
        ),
      ),
    );
  }
}
