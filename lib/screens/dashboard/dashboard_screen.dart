import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'dart:math' as math;
import 'package:carousel_slider_plus/carousel_slider_plus.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:tajpro/responsive.dart';

// ─── Constants ───────────────────────────────────────────────
const Color primaryColor    = Color(0xFF10B981);
const Color surfaceColor    = Color(0xFFF8FAFC);
const Color textPrimaryColor = Color(0xFF0F172A);
const double defaultPadding = 20.0;

// ─── Entry Point ─────────────────────────────────────────────
void main() => runApp(const TajProApp());

class TajProApp extends StatelessWidget {
  const TajProApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'TajPro Dashboard',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorSchemeSeed: primaryColor,
        scaffoldBackgroundColor: surfaceColor,
        fontFamily: 'SF Pro Display',
      ),
      home: const MainShell(),
    );
  }
}

// ─── Main Shell ───────────────────────────────────────────────
class MainShell extends StatefulWidget {
  const MainShell({super.key});
  @override
  State<MainShell> createState() => _MainShellState();
}

class _MainShellState extends State<MainShell> with TickerProviderStateMixin {
  int _selectedIndex = 0;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey();
  late AnimationController _sidebarController;

  @override
  void initState() {
    super.initState();
    _sidebarController = AnimationController(vsync: this, duration: const Duration(milliseconds: 300));
    _sidebarController.forward();
  }

  @override
  void dispose() {
    _sidebarController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isMobile = Responsive.isMobile(context);
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: const Color(0xFFF1F5F9),
      drawer: isMobile ? _buildDrawer() : null,
      body: Row(
        children: [
          if (!isMobile)
            SlideTransition(
              position: Tween<Offset>(begin: const Offset(-1, 0), end: Offset.zero)
                  .animate(CurvedAnimation(parent: _sidebarController, curve: Curves.easeOutCubic)),
              child: _buildSidebar(),
            ),
          Expanded(
            child: DashboardScreen(
              openDrawer: () => _scaffoldKey.currentState?.openDrawer(),
              onIndexChanged: (i) => setState(() => _selectedIndex = i),
              selectedIndex: _selectedIndex,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDrawer() {
    return Drawer(
      backgroundColor: Colors.white,
      child: _buildSidebarContent(),
    );
  }

  Widget _buildSidebar() {
    return Container(
      width: 220,
      color: Colors.white,
      child: _buildSidebarContent(),
    );
  }

  Widget _buildSidebarContent() {
    final items = [
      (Icons.dashboard_rounded,     'Dashboard'),
      (Icons.receipt_long_rounded,  'Orders'),
      (Icons.inventory_2_rounded,   'Products'),
      (Icons.people_alt_rounded,    'Distributors'),
      (Icons.bar_chart_rounded,     'Analytics'),
      (Icons.settings_rounded,      'Settings'),
    ];
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 32),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Row(
            children: [
              Container(
                width: 36, height: 36,
                decoration: BoxDecoration(color: primaryColor, borderRadius: BorderRadius.circular(10)),
                child: const Icon(Icons.bolt_rounded, color: Colors.white, size: 20),
              ),
              const SizedBox(width: 10),
              const Text('TajPro', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w900, color: textPrimaryColor)),
            ],
          ),
        ),
        const SizedBox(height: 36),
        ...items.asMap().entries.map((e) {
          final active = e.key == _selectedIndex;
          return _SidebarItem(
            icon: e.value.$1,
            label: e.value.$2,
            isActive: active,
            onTap: () => setState(() => _selectedIndex = e.key),
          );
        }),
        const Spacer(),
        _SidebarItem(icon: Icons.logout_rounded, label: 'Logout', isActive: false, onTap: () {}),
        const SizedBox(height: 24),
      ],
    );
  }
}

class _SidebarItem extends StatefulWidget {
  final IconData icon;
  final String label;
  final bool isActive;
  final VoidCallback onTap;
  const _SidebarItem({required this.icon, required this.label, required this.isActive, required this.onTap});

  @override
  State<_SidebarItem> createState() => _SidebarItemState();
}

class _SidebarItemState extends State<_SidebarItem> {
  bool _hovered = false;
  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _hovered = true),
      onExit:  (_) => setState(() => _hovered = false),
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 3),
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
          decoration: BoxDecoration(
            color: widget.isActive
                ? primaryColor
                : _hovered ? primaryColor.withOpacity(0.07) : Colors.transparent,
            borderRadius: BorderRadius.circular(14),
          ),
          child: Row(
            children: [
              Icon(widget.icon,
                size: 20,
                color: widget.isActive ? Colors.white : (_hovered ? primaryColor : Colors.grey[500]),
              ),
              const SizedBox(width: 12),
              Text(widget.label,
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: widget.isActive ? FontWeight.w700 : FontWeight.w500,
                  color: widget.isActive ? Colors.white : (_hovered ? primaryColor : Colors.grey[600]),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ─── Dashboard Screen ─────────────────────────────────────────
class DashboardScreen extends StatefulWidget {
  final VoidCallback openDrawer;
  final Function(int) onIndexChanged;
  final int selectedIndex;
  const DashboardScreen({super.key, required this.openDrawer, required this.onIndexChanged, required this.selectedIndex});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> with TickerProviderStateMixin {
  late AnimationController _pageController;
  late Animation<double> _fadeAnim;
  late Animation<Offset> _slideAnim;

  @override
  void initState() {
    super.initState();
    _pageController = AnimationController(vsync: this, duration: const Duration(milliseconds: 600));
    _fadeAnim  = CurvedAnimation(parent: _pageController, curve: Curves.easeOut);
    _slideAnim = Tween<Offset>(begin: const Offset(0, 0.04), end: Offset.zero)
        .animate(CurvedAnimation(parent: _pageController, curve: Curves.easeOutCubic));
    _pageController.forward();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isMobile = Responsive.isMobile(context);
    return SafeArea(
      child: FadeTransition(
        opacity: _fadeAnim,
        child: SlideTransition(
          position: _slideAnim,
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(defaultPadding),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _TopBar(openDrawer: widget.openDrawer),
                const SizedBox(height: defaultPadding),

                // KPI Row
                const _AnimatedKpiRow(),
                const SizedBox(height: defaultPadding),

                if (isMobile)
                  _buildMobileLayout()
                else
                  _buildDesktopLayout(),

                const SizedBox(height: defaultPadding * 2),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildMobileLayout() {
    return const Column(
      children: [
        _TotalSalesOverview(),
        SizedBox(height: defaultPadding),
        _SalesPerformance(),
        SizedBox(height: defaultPadding),
        _MarketMap(),
        SizedBox(height: defaultPadding),
        _RecentTransactions(),
        SizedBox(height: defaultPadding),
        _TopMarket(),
        SizedBox(height: defaultPadding),
        _TopProducts(),
        SizedBox(height: defaultPadding),
        _PaymentAnalytics(),
        SizedBox(height: defaultPadding),
        _TeamPerformance(),
        SizedBox(height: defaultPadding),
        _RegionalGrowthChart(),
      ],
    );
  }

  Widget _buildDesktopLayout() {
    return const Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          flex: 14,
          child: Column(
            children: [
              _TotalSalesOverview(),
              SizedBox(height: defaultPadding),
              _MarketMap(),
              SizedBox(height: defaultPadding),
              _RecentTransactions(),
              SizedBox(height: defaultPadding),
              _TopProducts(),
            ],
          ),
        ),
        SizedBox(width: defaultPadding),
        Expanded(
          flex: 6,
          child: Column(
            children: [
              _SalesPerformance(),
              SizedBox(height: defaultPadding),
              _RegionalGrowthChart(),
              SizedBox(height: defaultPadding),
              _PaymentAnalytics(),
              SizedBox(height: defaultPadding),
              _TopMarket(),
              SizedBox(height: defaultPadding),
              _TeamPerformance(),
            ],
          ),
        ),
      ],
    );
  }
}

// ─── Top Bar ──────────────────────────────────────────────────
class _TopBar extends StatefulWidget {
  final VoidCallback openDrawer;
  const _TopBar({required this.openDrawer});
  @override
  State<_TopBar> createState() => _TopBarState();
}

class _TopBarState extends State<_TopBar> {
  bool _notifHover = false;
  bool _darkHover  = false;

  @override
  Widget build(BuildContext context) {
    final isMobile = Responsive.isMobile(context);
    return Row(
      children: [
        if (isMobile)
          _AnimatedIconBtn(icon: Icons.menu_rounded, onTap: widget.openDrawer)
        else
          const SizedBox(width: 4),
        const SizedBox(width: 12),
        Expanded(
          child: _SearchBar(),
        ),
        if (!isMobile) ...[
          const SizedBox(width: 16),
          MouseRegion(
            onEnter: (_) => setState(() => _darkHover = true),
            onExit:  (_) => setState(() => _darkHover = false),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: _darkHover ? primaryColor.withOpacity(0.1) : surfaceColor,
                shape: BoxShape.circle,
              ),
              child: Icon(Icons.dark_mode_outlined, color: _darkHover ? primaryColor : Colors.black87, size: 20),
            ),
          ),
          const SizedBox(width: 8),
          MouseRegion(
            onEnter: (_) => setState(() => _notifHover = true),
            onExit:  (_) => setState(() => _notifHover = false),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: _notifHover ? primaryColor.withOpacity(0.1) : surfaceColor,
                shape: BoxShape.circle,
              ),
              child: Stack(
                clipBehavior: Clip.none,
                children: [
                  Icon(Icons.notifications_none_rounded, color: _notifHover ? primaryColor : Colors.black87, size: 20),
                  Positioned(
                    top: -3, right: -3,
                    child: Container(
                      width: 8, height: 8,
                      decoration: const BoxDecoration(color: Color(0xFFEF4444), shape: BoxShape.circle),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(width: 16),
          Row(
            children: [
              const CircleAvatar(radius: 16, backgroundImage: NetworkImage("https://i.pravatar.cc/150?img=11")),
              const SizedBox(width: 4),
              const CircleAvatar(radius: 16, backgroundImage: NetworkImage("https://i.pravatar.cc/150?img=32")),
              const SizedBox(width: 8),
              const Text("+12", style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
              const SizedBox(width: 16),
              _InviteButton(),
            ],
          ),
        ],
      ],
    );
  }
}

class _SearchBar extends StatefulWidget {
  @override
  State<_SearchBar> createState() => _SearchBarState();
}

class _SearchBarState extends State<_SearchBar> {
  bool _focused = false;
  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 250),
      height: 48,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: _focused
            ? [BoxShadow(color: primaryColor.withOpacity(0.18), blurRadius: 16, offset: const Offset(0, 4))]
            : [BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 10, offset: const Offset(0, 4))],
        border: Border.all(color: _focused ? primaryColor.withOpacity(0.4) : Colors.transparent, width: 1.5),
      ),
      child: Focus(
        onFocusChange: (f) => setState(() => _focused = f),
        child: TextField(
          decoration: InputDecoration(
            hintText: "Search orders, distributors…",
            hintStyle: TextStyle(color: Colors.grey[400], fontSize: 13, fontWeight: FontWeight.w500),
            prefixIcon: Icon(Icons.search, color: _focused ? primaryColor : Colors.grey, size: 20),
            suffixIcon: Icon(Icons.tune_rounded, color: _focused ? primaryColor : Colors.grey, size: 18),
            border: InputBorder.none,
            contentPadding: const EdgeInsets.symmetric(vertical: 14),
          ),
        ),
      ),
    );
  }
}

class _InviteButton extends StatefulWidget {
  @override
  State<_InviteButton> createState() => _InviteButtonState();
}

class _InviteButtonState extends State<_InviteButton> {
  bool _hover = false;
  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _hover = true),
      onExit:  (_) => setState(() => _hover = false),
      child: GestureDetector(
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
          decoration: BoxDecoration(
            color: _hover ? primaryColor : Colors.black,
            borderRadius: BorderRadius.circular(24),
            boxShadow: _hover
                ? [BoxShadow(color: primaryColor.withOpacity(0.4), blurRadius: 12, offset: const Offset(0, 4))]
                : [],
          ),
          child: const Row(
            children: [
              Icon(Icons.person_add_alt_1_rounded, color: Colors.white, size: 14),
              SizedBox(width: 6),
              Text("Invite", style: TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold)),
            ],
          ),
        ),
      ),
    );
  }
}

class _AnimatedIconBtn extends StatefulWidget {
  final IconData icon;
  final VoidCallback onTap;
  const _AnimatedIconBtn({required this.icon, required this.onTap});
  @override
  State<_AnimatedIconBtn> createState() => _AnimatedIconBtnState();
}

class _AnimatedIconBtnState extends State<_AnimatedIconBtn> {
  bool _pressed = false;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => setState(() => _pressed = true),
      onTapUp:   (_) { setState(() => _pressed = false); widget.onTap(); },
      onTapCancel: () => setState(() => _pressed = false),
      child: AnimatedScale(
        scale: _pressed ? 0.9 : 1.0,
        duration: const Duration(milliseconds: 100),
        child: Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(color: Colors.white, shape: BoxShape.circle,
            boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.06), blurRadius: 8)]),
          child: Icon(widget.icon, color: Colors.black87, size: 20),
        ),
      ),
    );
  }
}

// ─── Animated KPI Row ─────────────────────────────────────────
class _AnimatedKpiRow extends StatelessWidget {
  const _AnimatedKpiRow();

  @override
  Widget build(BuildContext context) {
    final kpis = [
      _KpiData('Total Revenue',   '₹24.5L', '+12.4%', true,  Icons.trending_up_rounded,     const Color(0xFF10B981), const Color(0xFFF0FDF4)),
      _KpiData('Total Orders',    '1,842',  '+8.1%',  true,  Icons.receipt_long_rounded,    const Color(0xFF3B82F6), const Color(0xFFEFF6FF)),
      _KpiData('Active Clients',  '318',    '+3.2%',  true,  Icons.people_alt_rounded,      const Color(0xFF8B5CF6), const Color(0xFFF5F3FF)),
      _KpiData('Avg Order Value', '₹1,330', '-1.8%',  false, Icons.shopping_bag_rounded,    const Color(0xFFF59E0B), const Color(0xFFFFFBEB)),
    ];

    final isMobile = Responsive.isMobile(context);
    if (isMobile) {
      return CarouselSlider(
        options: CarouselOptions(
          height: 180,
          viewportFraction: 0.85,
          enlargeCenterPage: true,
          enableInfiniteScroll: true,
          autoPlay: true,
          autoPlayInterval: const Duration(seconds: 4),
          autoPlayAnimationDuration: const Duration(milliseconds: 800),
          autoPlayCurve: Curves.fastOutSlowIn,
        ),
        items: kpis.asMap().entries.map((e) {
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 10),
            child: _KpiCard(data: e.value, delay: 0), // No delay needed for carousel items
          );
        }).toList(),
      );
    }
    return Row(
      children: kpis.asMap().entries
          .map((e) => Expanded(child: Padding(
            padding: EdgeInsets.only(left: e.key == 0 ? 0 : 12),
            child: _KpiCard(data: e.value, delay: e.key * 80),
          )))
          .toList(),
    );
  }
}

class _KpiData {
  final String label, value, change;
  final bool positive;
  final IconData icon;
  final Color color, bg;
  const _KpiData(this.label, this.value, this.change, this.positive, this.icon, this.color, this.bg);
}

class _KpiCard extends StatefulWidget {
  final _KpiData data;
  final int delay;
  const _KpiCard({required this.data, required this.delay});
  @override
  State<_KpiCard> createState() => _KpiCardState();
}

class _KpiCardState extends State<_KpiCard> with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;
  late Animation<double> _scale, _fade;
  bool _hovered = false;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(vsync: this, duration: const Duration(milliseconds: 500));
    _scale = Tween<double>(begin: 0.85, end: 1.0).animate(CurvedAnimation(parent: _ctrl, curve: Curves.easeOutBack));
    _fade  = CurvedAnimation(parent: _ctrl, curve: Curves.easeOut);
    Future.delayed(Duration(milliseconds: widget.delay), () { if (mounted) _ctrl.forward(); });
  }

  @override
  void dispose() { _ctrl.dispose(); super.dispose(); }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _fade,
      child: ScaleTransition(
        scale: _scale,
        child: MouseRegion(
          onEnter: (_) => setState(() => _hovered = true),
          onExit:  (_) => setState(() => _hovered = false),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 220),
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              boxShadow: _hovered
                  ? [BoxShadow(color: widget.data.color.withOpacity(0.22), blurRadius: 24, offset: const Offset(0, 8))]
                  : [BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 12, offset: const Offset(0, 4))],
              border: Border.all(
                color: _hovered ? widget.data.color.withOpacity(0.3) : Colors.transparent,
                width: 1.5,
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    AnimatedContainer(
                      duration: const Duration(milliseconds: 220),
                      padding: const EdgeInsets.all(9),
                      decoration: BoxDecoration(
                        color: _hovered ? widget.data.color : widget.data.bg,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Icon(widget.data.icon,
                        color: _hovered ? Colors.white : widget.data.color, size: 18),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
                      decoration: BoxDecoration(
                        color: widget.data.positive
                            ? const Color(0xFF10B981).withOpacity(0.1)
                            : const Color(0xFFEF4444).withOpacity(0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            widget.data.positive ? Icons.arrow_upward_rounded : Icons.arrow_downward_rounded,
                            size: 10,
                            color: widget.data.positive ? const Color(0xFF10B981) : const Color(0xFFEF4444),
                          ),
                          const SizedBox(width: 2),
                          Text(widget.data.change,
                            style: TextStyle(
                              fontSize: 10, fontWeight: FontWeight.bold,
                              color: widget.data.positive ? const Color(0xFF10B981) : const Color(0xFFEF4444),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Text(widget.data.value,
                  style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w900, color: textPrimaryColor, letterSpacing: -0.5)),
                Text(widget.data.label,
                  style: TextStyle(fontSize: 11, color: Colors.grey[500], fontWeight: FontWeight.w600)),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// ─── Dashboard Card ───────────────────────────────────────────
class DashboardCard extends StatefulWidget {
  final Widget child;
  final EdgeInsets padding;
  final Color backgroundColor;
  final bool animate;

  const DashboardCard({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.all(24),
    this.backgroundColor = Colors.white,
    this.animate = true,
  });

  @override
  State<DashboardCard> createState() => _DashboardCardState();
}

class _DashboardCardState extends State<DashboardCard> with SingleTickerProviderStateMixin {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _hovered = true),
      onExit:  (_) => setState(() => _hovered = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        padding: widget.padding,
        decoration: BoxDecoration(
          color: widget.backgroundColor,
          borderRadius: BorderRadius.circular(24),
          boxShadow: _hovered
              ? [BoxShadow(color: Colors.black.withOpacity(0.09), blurRadius: 28, offset: const Offset(0, 10))]
              : [BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 15, offset: const Offset(0, 5))],
        ),
        child: widget.child,
      ),
    );
  }
}

// ─── Total Sales Overview ─────────────────────────────────────
class _TotalSalesOverview extends StatefulWidget {
  const _TotalSalesOverview();
  @override
  State<_TotalSalesOverview> createState() => _TotalSalesOverviewState();
}

class _TotalSalesOverviewState extends State<_TotalSalesOverview> with SingleTickerProviderStateMixin {
  late AnimationController _barCtrl;
  late Animation<double> _barAnim;
  int _touchedIndex = -1;

  @override
  void initState() {
    super.initState();
    _barCtrl = AnimationController(vsync: this, duration: const Duration(milliseconds: 900));
    _barAnim = CurvedAnimation(parent: _barCtrl, curve: Curves.easeOutCubic);
    Future.delayed(const Duration(milliseconds: 200), () { if (mounted) _barCtrl.forward(); });
  }

  @override
  void dispose() { _barCtrl.dispose(); super.dispose(); }

  @override
  Widget build(BuildContext context) {
    return DashboardCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(color: const Color(0xFFF1F5F9), borderRadius: BorderRadius.circular(10)),
                    child: const Icon(Icons.bar_chart_rounded, size: 18, color: textPrimaryColor),
                  ),
                  const SizedBox(width: 12),
                  const Text("Total Sales Overview", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: textPrimaryColor)),
                ],
              ),
              _HoverChip(label: "Month"),
            ],
          ),
          const SizedBox(height: 20),
          AnimatedSwitcher(
            duration: const Duration(milliseconds: 400),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              key: const ValueKey('sales'),
              children: [
                const Text("₹ 24,50,450", style: TextStyle(fontSize: 30, fontWeight: FontWeight.w900, color: textPrimaryColor, letterSpacing: -1)),
                const SizedBox(height: 4),
                Row(
                  children: [
                    const Icon(Icons.arrow_upward_rounded, color: primaryColor, size: 14),
                    const Text(" + ₹1,10,250", style: TextStyle(color: primaryColor, fontWeight: FontWeight.bold, fontSize: 12)),
                    Text("  vs last month", style: TextStyle(color: Colors.grey[400], fontSize: 12)),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 28),
          AnimatedBuilder(
            animation: _barAnim,
            builder: (_, __) => SizedBox(
              height: 200,
              child: BarChart(
                BarChartData(
                  alignment: BarChartAlignment.spaceAround,
                  maxY: 120,
                  barTouchData: BarTouchData(
                    enabled: true,
                    touchCallback: (event, response) {
                      setState(() {
                        _touchedIndex = response?.spot?.touchedBarGroupIndex ?? -1;
                      });
                    },
                    touchTooltipData: BarTouchTooltipData(
                      getTooltipColor: (_) => Colors.black87,
                      getTooltipItem: (group, _, rod, __) => BarTooltipItem(
                        '${rod.toY.toInt()}K',
                        const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 12),
                      ),
                    ),
                  ),
                  titlesData: FlTitlesData(
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        getTitlesWidget: (v, _) {
                          const labels = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul'];
                          return Padding(
                            padding: const EdgeInsets.only(top: 8),
                            child: Text(labels[v.toInt()],
                              style: TextStyle(color: Colors.grey[400], fontWeight: FontWeight.bold, fontSize: 11)),
                          );
                        },
                        reservedSize: 28,
                      ),
                    ),
                    leftTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        reservedSize: 36,
                        interval: 30,
                        getTitlesWidget: (v, _) => Text('${v.toInt()}K',
                          style: TextStyle(color: Colors.grey[400], fontSize: 10, fontWeight: FontWeight.w600)),
                      ),
                    ),
                    topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                    rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  ),
                  gridData: FlGridData(
                    show: true,
                    drawVerticalLine: false,
                    horizontalInterval: 30,
                    getDrawingHorizontalLine: (_) => FlLine(color: Colors.grey.withOpacity(0.08), strokeWidth: 1, dashArray: [4, 4]),
                  ),
                  borderData: FlBorderData(show: false),
                  barGroups: _buildBars(),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  List<BarChartGroupData> _buildBars() {
    final data = [40.0, 20.0, 50.0, 110.0, 30.0, 60.0, 80.0];
    return data.asMap().entries.map((e) {
      final isActive = e.key == 3;
      final isTouched = e.key == _touchedIndex;
      final animated = e.value * _barAnim.value;
      return BarChartGroupData(
        x: e.key,
        barRods: [
          BarChartRodData(
            toY: animated,
            gradient: (isActive || isTouched)
                ? const LinearGradient(
                    colors: [primaryColor, Color(0xFF059669)],
                    begin: Alignment.bottomCenter, end: Alignment.topCenter)
                : LinearGradient(
                    colors: [const Color(0xFFE2E8F0), const Color(0xFFF8FAFC)],
                    begin: Alignment.bottomCenter, end: Alignment.topCenter),
            width: 40,
            borderRadius: BorderRadius.circular(14),
          ),
        ],
      );
    }).toList();
  }
}

// ─── Sales Performance ────────────────────────────────────────
class _SalesPerformance extends StatefulWidget {
  const _SalesPerformance();
  @override
  State<_SalesPerformance> createState() => _SalesPerformanceState();
}

class _SalesPerformanceState extends State<_SalesPerformance> with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;
  late Animation<double> _anim;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(vsync: this, duration: const Duration(milliseconds: 1000));
    _anim = CurvedAnimation(parent: _ctrl, curve: Curves.easeOutCubic);
    Future.delayed(const Duration(milliseconds: 300), () { if (mounted) _ctrl.forward(); });
  }

  @override
  void dispose() { _ctrl.dispose(); super.dispose(); }

  @override
  Widget build(BuildContext context) {
    return DashboardCard(
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(color: const Color(0xFFF1F5F9), borderRadius: BorderRadius.circular(10)),
                    child: const Icon(Icons.speed_rounded, size: 18, color: textPrimaryColor),
                  ),
                  const SizedBox(width: 12),
                  const Text("Sales Performance", style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
                ],
              ),
              Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(color: const Color(0xFFF1F5F9), shape: BoxShape.circle),
                child: const Icon(Icons.more_horiz, size: 16),
              ),
            ],
          ),
          const SizedBox(height: 28),
          AnimatedBuilder(
            animation: _anim,
            builder: (_, __) => SizedBox(
              height: 140,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  PieChart(
                    PieChartData(
                      startDegreeOffset: 180,
                      sectionsSpace: 4,
                      centerSpaceRadius: 56,
                      sections: [
                        ...List.generate(8, (i) => PieChartSectionData(
                          value: _anim.value,
                          color: primaryColor,
                          radius: 22,
                          showTitle: false,
                        )),
                        ...List.generate(2, (i) => PieChartSectionData(
                          value: _anim.value,
                          color: const Color(0xFFE2E8F0),
                          radius: 22,
                          showTitle: false,
                        )),
                        PieChartSectionData(value: 10, color: Colors.transparent, radius: 22, showTitle: false),
                      ],
                    ),
                  ),
                  Positioned(
                    bottom: 16,
                    child: Column(
                      children: [
                        TweenAnimationBuilder<double>(
                          tween: Tween(begin: 0, end: 80),
                          duration: const Duration(milliseconds: 1200),
                          curve: Curves.easeOutCubic,
                          builder: (_, v, __) => Text('${v.toInt()}%',
                            style: const TextStyle(fontSize: 28, fontWeight: FontWeight.w900, color: textPrimaryColor)),
                        ),
                        Text("Sales Goal", style: TextStyle(fontSize: 11, color: Colors.grey[500], fontWeight: FontWeight.w600)),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildMetric("Sales", "1,660", "+6%", primaryColor),
              _buildMetric("Revenue", "₹92K", "-2%", const Color(0xFFEF4444)),
            ],
          ),
          const SizedBox(height: 20),
          _PulsingBanner(),
        ],
      ),
    );
  }

  Widget _buildMetric(String label, String value, String pct, Color color) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(label, style: TextStyle(fontSize: 11, color: Colors.grey[500], fontWeight: FontWeight.bold)),
            const SizedBox(width: 6),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 2),
              decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(6)),
              child: Text(pct, style: const TextStyle(color: Colors.white, fontSize: 9, fontWeight: FontWeight.bold)),
            ),
          ],
        ),
        const SizedBox(height: 4),
        Text(value, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w900, letterSpacing: -0.5)),
      ],
    );
  }
}

class _PulsingBanner extends StatefulWidget {
  @override
  State<_PulsingBanner> createState() => _PulsingBannerState();
}

class _PulsingBannerState extends State<_PulsingBanner> with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;
  late Animation<double> _pulse;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(vsync: this, duration: const Duration(milliseconds: 1500))..repeat(reverse: true);
    _pulse = Tween<double>(begin: 0.9, end: 1.0).animate(CurvedAnimation(parent: _ctrl, curve: Curves.easeInOut));
  }

  @override
  void dispose() { _ctrl.dispose(); super.dispose(); }

  @override
  Widget build(BuildContext context) {
    return ScaleTransition(
      scale: _pulse,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(color: Colors.black, borderRadius: BorderRadius.circular(18)),
        child: Row(
          children: [
            const Text("🔔", style: TextStyle(fontSize: 14)),
            const SizedBox(width: 10),
            const Expanded(child: Text("Daily customer count increased!", style: TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.w500))),
            const Icon(Icons.close, color: Colors.white38, size: 14),
          ],
        ),
      ),
    );
  }
}

// ─── Recent Transactions ──────────────────────────────────────
class _RecentTransactions extends StatelessWidget {
  const _RecentTransactions();

  static const _orders = [
    ('OD-98421', 'Metro Agencies',   '19 Mar, 10:32 AM', 'Ethan Clarke',  '₹79,000',   'Completed', Color(0xFF10B981), Colors.orange),
    ('OD-98422', 'Super Sales Inc',  '19 Mar, 11:05 AM', 'Ava Mitchell',  '₹1,59,500', 'Cancelled', Color(0xFFEF4444), Colors.blue),
    ('OD-98423', 'Raj Distributors', '19 Mar, 11:44 AM', 'Liam Parker',   '₹55,200',   'Pending',   Color(0xFF3B82F6), Colors.purple),
    ('OD-98424', 'National Traders', '19 Mar, 12:10 PM', 'Sophia Hayes',  '₹21,000',   'Completed', Color(0xFF10B981), Colors.green),
    ('OD-98425', 'Global Markets',   '19 Mar, 12:40 PM', 'Noah Bennett',  '₹1,99,000', 'Completed', Color(0xFF10B981), Colors.teal),
  ];

  @override
  Widget build(BuildContext context) {
    return DashboardCard(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text("Recent Orders", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: textPrimaryColor)),
              _HoverChip(label: "View All", color: primaryColor),
            ],
          ),
          const SizedBox(height: 20),
          if (!Responsive.isMobile(context))
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
              child: Row(
                children: [
                  Expanded(flex: 2, child: _hdr("ORDER ID")),
                  Expanded(flex: 4, child: _hdr("DISTRIBUTOR")),
                  Expanded(flex: 3, child: _hdr("DATE")),
                  Expanded(flex: 3, child: _hdr("REP")),
                  Expanded(flex: 2, child: _hdr("AMOUNT")),
                  Expanded(flex: 2, child: _hdr("STATUS")),
                ],
              ),
            ),
          ..._orders.asMap().entries.map((e) => _AnimatedOrderRow(
            index: e.key,
            data: e.value,
          )),
        ],
      ),
    );
  }

  Widget _hdr(String t) => Text(t, style: TextStyle(color: Colors.grey[400], fontSize: 10, fontWeight: FontWeight.w800, letterSpacing: 0.5));
}

class _AnimatedOrderRow extends StatefulWidget {
  final int index;
  final (String, String, String, String, String, String, Color, Color) data;
  const _AnimatedOrderRow({required this.index, required this.data});
  @override
  State<_AnimatedOrderRow> createState() => _AnimatedOrderRowState();
}

class _AnimatedOrderRowState extends State<_AnimatedOrderRow> with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;
  late Animation<Offset> _slide;
  late Animation<double> _fade;
  bool _hovered = false;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(vsync: this, duration: const Duration(milliseconds: 400));
    _slide = Tween<Offset>(begin: const Offset(0, 0.3), end: Offset.zero)
        .animate(CurvedAnimation(parent: _ctrl, curve: Curves.easeOutCubic));
    _fade = CurvedAnimation(parent: _ctrl, curve: Curves.easeOut);
    Future.delayed(Duration(milliseconds: 100 + widget.index * 80), () { if (mounted) _ctrl.forward(); });
  }

  @override
  void dispose() { _ctrl.dispose(); super.dispose(); }

  @override
  Widget build(BuildContext context) {
    final d = widget.data;
    final isMobile = Responsive.isMobile(context);
    return FadeTransition(
      opacity: _fade,
      child: SlideTransition(
        position: _slide,
        child: Padding(
          padding: const EdgeInsets.only(bottom: 10),
          child: MouseRegion(
            onEnter: (_) => setState(() => _hovered = true),
            onExit:  (_) => setState(() => _hovered = false),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
              decoration: BoxDecoration(
                color: _hovered ? const Color(0xFFF8FAFC) : Colors.white,
                borderRadius: BorderRadius.circular(18),
                border: Border.all(color: _hovered ? d.$7.withOpacity(0.25) : Colors.grey.withOpacity(0.08)),
                boxShadow: _hovered
                    ? [BoxShadow(color: d.$7.withOpacity(0.08), blurRadius: 20, offset: const Offset(0, 6))]
                    : [BoxShadow(color: Colors.black.withOpacity(0.02), blurRadius: 10, offset: const Offset(0, 3))],
              ),
              child: isMobile ? _buildMobileRow(d) : _buildDesktopRow(d),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDesktopRow(dynamic d) {
    return Row(
      children: [
        Expanded(flex: 2, child: _idCol(d.$1)),
        Expanded(flex: 4, child: _nameCol(d.$2, d.$8)),
        Expanded(flex: 3, child: _dateCol(d.$3)),
        Expanded(flex: 3, child: _repCol(d.$4)),
        Expanded(flex: 2, child: _amtCol(d.$5)),
        Expanded(flex: 2, child: _statusCol(d.$6, d.$7)),
      ],
    );
  }

  Widget _buildMobileRow(dynamic d) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _nameCol(d.$2, d.$8),
            _statusCol(d.$6, d.$7),
          ],
        ),
        const SizedBox(height: 6),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _idCol(d.$1),
            _amtCol(d.$5),
          ],
        ),
        const SizedBox(height: 4),
        _dateCol(d.$3),
      ],
    );
  }

  Widget _idCol(String id) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text("ORDER ID", style: TextStyle(color: Colors.grey[400], fontSize: 9, fontWeight: FontWeight.bold)),
      const SizedBox(height: 3),
      Text(id, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12, color: Colors.blueAccent)),
    ],
  );

  Widget _nameCol(String name, Color color) => Row(
    children: [
      Container(
        width: 34, height: 34,
        decoration: BoxDecoration(color: color.withOpacity(0.12), shape: BoxShape.circle),
        child: Center(child: Text(name[0], style: TextStyle(color: color, fontWeight: FontWeight.bold, fontSize: 13))),
      ),
      const SizedBox(width: 10),
      Flexible(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(name, style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 13), overflow: TextOverflow.ellipsis),
            Text("Distributor", style: TextStyle(color: Colors.grey[400], fontSize: 10)),
          ],
        ),
      ),
    ],
  );

  Widget _dateCol(String date) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text("PROCESSED", style: TextStyle(color: Colors.grey[400], fontSize: 9, fontWeight: FontWeight.bold)),
      const SizedBox(height: 3),
      Text(date, style: TextStyle(color: Colors.grey[600], fontSize: 11, fontWeight: FontWeight.w600)),
    ],
  );

  Widget _repCol(String rep) => Row(
    children: [
      CircleAvatar(radius: 11, backgroundColor: Colors.grey[100],
        child: Text(rep[0], style: const TextStyle(fontSize: 9, fontWeight: FontWeight.bold))),
      const SizedBox(width: 8),
      Expanded(child: Text(rep, style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 12), overflow: TextOverflow.ellipsis)),
    ],
  );

  Widget _amtCol(String amt) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text("TOTAL", style: TextStyle(color: Colors.grey[400], fontSize: 9, fontWeight: FontWeight.bold)),
      const SizedBox(height: 3),
      Text(amt, style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 14), overflow: TextOverflow.ellipsis),
    ],
  );

  Widget _statusCol(String status, Color color) => Row(
    mainAxisAlignment: MainAxisAlignment.end,
    children: [
      Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        decoration: BoxDecoration(color: color.withOpacity(0.1), borderRadius: BorderRadius.circular(20)),
        child: Text(status, style: TextStyle(color: color, fontSize: 10, fontWeight: FontWeight.w900)),
      ),
    ],
  );
}

// ─── Top Market ───────────────────────────────────────────────
class _TopMarket extends StatelessWidget {
  const _TopMarket();

  @override
  Widget build(BuildContext context) {
    return DashboardCard(
      child: Column(
        children: [
          _CardHeader(icon: Icons.public, title: "Top Territories"),
          const SizedBox(height: 20),
          _AnimatedMarketItem(icon: Icons.location_city_rounded, name: "Maharashtra", value: "₹6.2M", percent: "40%", isTop: true, delay: 0),
          const SizedBox(height: 10),
          _AnimatedMarketItem(icon: Icons.location_city_rounded, name: "Karnataka",   value: "₹2.4M", percent: "25%", isTop: false, delay: 100),
          const SizedBox(height: 10),
          _AnimatedMarketItem(icon: Icons.location_city_rounded, name: "Delhi NCR",   value: "₹1.5M", percent: "10%", isTop: false, delay: 200),
        ],
      ),
    );
  }
}

class _AnimatedMarketItem extends StatefulWidget {
  final IconData icon;
  final String name, value, percent;
  final bool isTop;
  final int delay;
  const _AnimatedMarketItem({required this.icon, required this.name, required this.value, required this.percent, required this.isTop, required this.delay});
  @override
  State<_AnimatedMarketItem> createState() => _AnimatedMarketItemState();
}

class _AnimatedMarketItemState extends State<_AnimatedMarketItem> with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;
  bool _hovered = false;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(vsync: this, duration: const Duration(milliseconds: 500));
    Future.delayed(Duration(milliseconds: widget.delay), () { if (mounted) _ctrl.forward(); });
  }
  @override
  void dispose() { _ctrl.dispose(); super.dispose(); }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: CurvedAnimation(parent: _ctrl, curve: Curves.easeOut),
      child: SlideTransition(
        position: Tween<Offset>(begin: const Offset(-0.2, 0), end: Offset.zero)
            .animate(CurvedAnimation(parent: _ctrl, curve: Curves.easeOutCubic)),
        child: MouseRegion(
          onEnter: (_) => setState(() => _hovered = true),
          onExit:  (_) => setState(() => _hovered = false),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: _hovered ? (widget.isTop ? primaryColor.withOpacity(0.07) : const Color(0xFFF8FAFC)) : Colors.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: widget.isTop
                    ? (_hovered ? primaryColor : primaryColor.withOpacity(0.5))
                    : (_hovered ? Colors.grey.withOpacity(0.3) : Colors.grey.withOpacity(0.15)),
                width: 1.5,
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Icon(widget.icon, color: widget.isTop ? primaryColor : Colors.grey[500], size: 18),
                    const SizedBox(width: 10),
                    Text(widget.name, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                  ],
                ),
                Row(
                  children: [
                    Text(widget.value, style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 13)),
                    const SizedBox(width: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                      decoration: BoxDecoration(color: primaryColor, borderRadius: BorderRadius.circular(10)),
                      child: Text(widget.percent, style: const TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold)),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// ─── Top Products ─────────────────────────────────────────────
class _TopProducts extends StatelessWidget {
  const _TopProducts();
  @override
  Widget build(BuildContext context) {
    return DashboardCard(
      child: Column(
        children: [
          _CardHeader(icon: Icons.inventory_2_outlined, title: "Top Products"),
          const SizedBox(height: 20),
          Row(
            children: [
              Expanded(child: _ProductCard(
                bg: Colors.black,
                icon: Icons.coffee_rounded,
                iconBg: Colors.white12,
                iconColor: Colors.white,
                title: "Taj Supreme Tea",
                subtitle: "10K sales +17%",
                titleColor: Colors.white,
                subtitleColor: Colors.white54,
              )),
              const SizedBox(width: 12),
              Expanded(child: _ProductCard(
                bg: const Color(0xFFF0FDF4),
                icon: Icons.fastfood_rounded,
                iconBg: Colors.white,
                iconColor: primaryColor,
                title: "Taj Snacks 500g",
                subtitle: "7K sales +6%",
                titleColor: Colors.black,
                subtitleColor: primaryColor,
                border: Border.all(color: primaryColor.withOpacity(0.15)),
              )),
            ],
          ),
        ],
      ),
    );
  }
}

class _ProductCard extends StatefulWidget {
  final Color bg, iconBg, iconColor, titleColor, subtitleColor;
  final IconData icon;
  final String title, subtitle;
  final BoxBorder? border;
  const _ProductCard({required this.bg, required this.icon, required this.iconBg, required this.iconColor, required this.title, required this.subtitle, required this.titleColor, required this.subtitleColor, this.border});
  @override
  State<_ProductCard> createState() => _ProductCardState();
}

class _ProductCardState extends State<_ProductCard> {
  bool _hovered = false;
  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _hovered = true),
      onExit:  (_) => setState(() => _hovered = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        height: 120,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: widget.bg,
          borderRadius: BorderRadius.circular(20),
          border: widget.border,
          boxShadow: _hovered
              ? [BoxShadow(color: widget.iconColor.withOpacity(0.2), blurRadius: 16, offset: const Offset(0, 6))]
              : [],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: _hovered ? widget.iconColor.withOpacity(0.2) : widget.iconBg,
                shape: BoxShape.circle,
              ),
              child: Icon(widget.icon, color: widget.iconColor, size: 18),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(widget.title, style: TextStyle(color: widget.titleColor, fontWeight: FontWeight.bold, fontSize: 13)),
                Text(widget.subtitle, style: TextStyle(color: widget.subtitleColor, fontSize: 10, fontWeight: FontWeight.w600)),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

// ─── Payment Analytics ────────────────────────────────────────
class _PaymentAnalytics extends StatefulWidget {
  const _PaymentAnalytics();
  @override
  State<_PaymentAnalytics> createState() => _PaymentAnalyticsState();
}

class _PaymentAnalyticsState extends State<_PaymentAnalytics> with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;
  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(vsync: this, duration: const Duration(milliseconds: 1000));
    Future.delayed(const Duration(milliseconds: 400), () { if (mounted) _ctrl.forward(); });
  }
  @override
  void dispose() { _ctrl.dispose(); super.dispose(); }

  @override
  Widget build(BuildContext context) {
    return DashboardCard(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text("Payments", style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
          const SizedBox(height: 20),
          _buildItem("Collected", "₹4.2M", const Color(0xFF10B981), 0.8),
          const SizedBox(height: 14),
          _buildItem("Pending",   "₹1.1M", const Color(0xFF3B82F6), 0.4),
          const SizedBox(height: 14),
          _buildItem("Overdue",   "₹0.3M", const Color(0xFFEF4444), 0.1),
        ],
      ),
    );
  }

  Widget _buildItem(String label, String value, Color color, double progress) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(label, style: TextStyle(fontSize: 12, color: Colors.grey[500], fontWeight: FontWeight.w600)),
            Text(value, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold)),
          ],
        ),
        const SizedBox(height: 8),
        AnimatedBuilder(
          animation: _ctrl,
          builder: (_, __) => ClipRRect(
            borderRadius: BorderRadius.circular(6),
            child: LinearProgressIndicator(
              value: progress * _ctrl.value,
              backgroundColor: color.withOpacity(0.08),
              valueColor: AlwaysStoppedAnimation<Color>(color),
              minHeight: 7,
            ),
          ),
        ),
      ],
    );
  }
}

// ─── Team Performance ─────────────────────────────────────────
class _TeamPerformance extends StatelessWidget {
  const _TeamPerformance();
  @override
  Widget build(BuildContext context) {
    const members = [
      ('Ethan Clarke', '₹1.2M', '+12%', Colors.orange),
      ('Ava Mitchell',  '₹0.9M', '+8%',  Colors.blue),
      ('Liam Parker',   '₹0.8M', '+15%', Colors.purple),
    ];
    return DashboardCard(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text("Top Performers", style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
          const SizedBox(height: 18),
          ...members.asMap().entries.map((e) => Padding(
            padding: EdgeInsets.only(bottom: e.key < members.length - 1 ? 12 : 0),
            child: _TeamMemberRow(name: e.value.$1, sales: e.value.$2, growth: e.value.$3, color: e.value.$4, delay: e.key * 100),
          )),
        ],
      ),
    );
  }
}

class _TeamMemberRow extends StatefulWidget {
  final String name, sales, growth;
  final Color color;
  final int delay;
  const _TeamMemberRow({required this.name, required this.sales, required this.growth, required this.color, required this.delay});
  @override
  State<_TeamMemberRow> createState() => _TeamMemberRowState();
}

class _TeamMemberRowState extends State<_TeamMemberRow> with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;
  bool _hovered = false;
  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(vsync: this, duration: const Duration(milliseconds: 400));
    Future.delayed(Duration(milliseconds: widget.delay), () { if (mounted) _ctrl.forward(); });
  }
  @override
  void dispose() { _ctrl.dispose(); super.dispose(); }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: CurvedAnimation(parent: _ctrl, curve: Curves.easeOut),
      child: MouseRegion(
        onEnter: (_) => setState(() => _hovered = true),
        onExit:  (_) => setState(() => _hovered = false),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
          decoration: BoxDecoration(
            color: _hovered ? widget.color.withOpacity(0.06) : Colors.transparent,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            children: [
              AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                width: 32, height: 32,
                decoration: BoxDecoration(
                  color: _hovered ? widget.color : widget.color.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: Center(child: Text(widget.name[0],
                  style: TextStyle(color: _hovered ? Colors.white : widget.color, fontSize: 12, fontWeight: FontWeight.bold))),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(widget.name, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold)),
                    Text(widget.sales, style: TextStyle(fontSize: 11, color: Colors.grey[500])),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
                decoration: BoxDecoration(color: primaryColor.withOpacity(0.1), borderRadius: BorderRadius.circular(6)),
                child: Text(widget.growth, style: const TextStyle(color: primaryColor, fontSize: 10, fontWeight: FontWeight.bold)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ─── Regional Growth Chart ────────────────────────────────────
class _RegionalGrowthChart extends StatefulWidget {
  const _RegionalGrowthChart();
  @override
  State<_RegionalGrowthChart> createState() => _RegionalGrowthChartState();
}

class _RegionalGrowthChartState extends State<_RegionalGrowthChart> with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;
  int _touchedIndex = -1;
  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(vsync: this, duration: const Duration(milliseconds: 900));
    Future.delayed(const Duration(milliseconds: 250), () { if (mounted) _ctrl.forward(); });
  }
  @override
  void dispose() { _ctrl.dispose(); super.dispose(); }

  @override
  Widget build(BuildContext context) {
    return DashboardCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Expanded(child: Text("Monthly Growth", style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold), overflow: TextOverflow.ellipsis)),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                decoration: BoxDecoration(color: const Color(0xFFF1F5F9), borderRadius: BorderRadius.circular(10)),
                child: const Text("2026", style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold)),
              ),
            ],
          ),
          const SizedBox(height: 22),
          AnimatedBuilder(
            animation: _ctrl,
            builder: (_, __) => SizedBox(
              height: 200,
              child: BarChart(BarChartData(
                alignment: BarChartAlignment.spaceAround,
                maxY: 100,
                barTouchData: BarTouchData(
                  enabled: true,
                  touchCallback: (event, response) {
                    setState(() => _touchedIndex = response?.spot?.touchedBarGroupIndex ?? -1);
                  },
                  touchTooltipData: BarTouchTooltipData(
                    getTooltipColor: (_) => Colors.black87,
                    getTooltipItem: (g, _, rod, __) => BarTooltipItem(
                      '${rod.toY.toInt()}%',
                      const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 12),
                    ),
                  ),
                ),
                gridData: FlGridData(show: true, drawVerticalLine: false, horizontalInterval: 25,
                  getDrawingHorizontalLine: (_) => FlLine(color: Colors.grey.withOpacity(0.08), strokeWidth: 1)),
                titlesData: FlTitlesData(
                  topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  leftTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  bottomTitles: AxisTitles(sideTitles: SideTitles(
                    showTitles: true,
                    getTitlesWidget: (v, _) {
                      const months = ["Jan", "Feb", "Mar", "Apr", "May", "Jun"];
                      return Padding(padding: const EdgeInsets.only(top: 8),
                        child: Text(months[v.toInt()], style: TextStyle(color: Colors.grey[400], fontWeight: FontWeight.bold, fontSize: 10)));
                    },
                  )),
                ),
                borderData: FlBorderData(show: false),
                barGroups: [45.0, 60.0, 50.0, 85.0, 55.0, 75.0].asMap().entries.map((e) {
                  final isActive = e.key == 3 || e.key == _touchedIndex;
                  return BarChartGroupData(x: e.key, barRods: [
                    BarChartRodData(
                      toY: e.value * _ctrl.value,
                      color: isActive ? primaryColor : const Color(0xFFCBD5E1),
                      width: 22,
                      borderRadius: const BorderRadius.vertical(top: Radius.circular(8)),
                      backDrawRodData: BackgroundBarChartRodData(show: true, toY: 100, color: const Color(0xFFF1F5F9)),
                    ),
                  ]);
                }).toList(),
              )),
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Shared Widgets ───────────────────────────────────────────
class _CardHeader extends StatelessWidget {
  final IconData icon;
  final String title;
  const _CardHeader({required this.icon, required this.title});
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(color: const Color(0xFFF1F5F9), borderRadius: BorderRadius.circular(10)),
              child: Icon(icon, size: 18, color: textPrimaryColor),
            ),
            const SizedBox(width: 12),
            Text(title, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
          ],
        ),
        Container(
          padding: const EdgeInsets.all(6),
          decoration: BoxDecoration(color: const Color(0xFFF1F5F9), shape: BoxShape.circle),
          child: const Icon(Icons.more_horiz, size: 16),
        ),
      ],
    );
  }
}

class _HoverChip extends StatefulWidget {
  final String label;
  final Color color;
  const _HoverChip({required this.label, this.color = Colors.black87});
  @override
  State<_HoverChip> createState() => _HoverChipState();
}

class _HoverChipState extends State<_HoverChip> {
  bool _hover = false;
  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _hover = true),
      onExit:  (_) => setState(() => _hover = false),
      cursor: SystemMouseCursors.click,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
        decoration: BoxDecoration(
          color: _hover ? widget.color.withOpacity(0.1) : const Color(0xFFF1F5F9),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: _hover ? widget.color.withOpacity(0.3) : Colors.transparent),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(widget.label, style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: _hover ? widget.color : Colors.black87)),
            const SizedBox(width: 4),
            Icon(Icons.arrow_drop_down, size: 16, color: _hover ? widget.color : Colors.black54),
          ],
        ),
      ),
    );
  }
}

// ─── India Market Map ──────────────────────────────────────────
class _MarketMap extends StatelessWidget {
  const _MarketMap();

  Widget build(BuildContext context) {
    bool isMobile = Responsive.isMobile(context);
    
    return Column(
      children: [
        DashboardCard(
          padding: const EdgeInsets.all(0),
          child: Container(
            height: isMobile ? 320 : 520,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(24),
              color: Colors.white,
            ),
            clipBehavior: Clip.antiAlias,
            child: Stack(
              children: [
                // The Real Map (Centered and Zoomed on India)
                FlutterMap(
                  options: MapOptions(
                    initialCenter: const LatLng(21.5000, 78.9629),
                    initialZoom: isMobile ? 4.1 : 5.2,
                    interactionOptions: const InteractionOptions(
                      flags: InteractiveFlag.all & ~InteractiveFlag.rotate,
                    ),
                  ),
                  children: [
                    TileLayer(
                      urlTemplate: 'https://{s}.basemaps.cartocdn.com/light_all/{z}/{x}/{y}{r}.png',
                      subdomains: const ['a', 'b', 'c', 'd'],
                      userAgentPackageName: 'com.tajpro.app',
                    ),
                    MarkerLayer(
                      markers: [
                        _buildMapMarker(context, const LatLng(19.0760, 72.8777), "Mumbai Cluster", "₹ 42.5L", isHighlighted: true),
                        _buildMapMarker(context, const LatLng(28.6139, 77.2090), "Delhi NCR Hub", "₹ 38.2L", isHighlighted: true),
                        _buildMapMarker(context, const LatLng(12.9716, 77.5946), "Bangalore Hub", "₹ 24.8L", isHighlighted: true),
                        _buildMapMarker(context, const LatLng(22.5726, 88.3639), "Kolkata Cluster", "₹ 18.4L", isHighlighted: true),
                        _buildMapMarker(context, const LatLng(13.0827, 80.2707), "Chennai Hub", "₹ 15.2L"),
                        _buildMapMarker(context, const LatLng(17.3850, 78.4867), "Hyderabad Cluster", "₹ 12.8L"),
                      ],
                    ),
                  ],
                ),
                
                // Stats Overlay (Desktop only as overlay)
                if (!isMobile)
                  Positioned(
                    left: 20,
                    top: 20,
                    child: _buildStatsContainer(context, isMobile),
                  ),
                
                // Market Filters (Right Side)
                Positioned(
                  right: 20,
                  top: 20,
                  child: Row(
                    children: [
                      _buildMapChip("India Market"),
                      const SizedBox(width: 8),
                      _buildMapChip("All Products"),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        if (isMobile) ...[
          const SizedBox(height: 16),
          _buildStatsContainer(context, isMobile),
        ],
      ],
    );
  }

  Widget _buildStatsContainer(BuildContext context, bool isMobile) {
    return Container(
      padding: const EdgeInsets.all(24),
      width: isMobile ? double.infinity : 280,
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(isMobile ? 1.0 : 0.9),
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.08), blurRadius: 20, offset: const Offset(0, 4)),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text("Market Distribution", style: TextStyle(fontSize: 16, fontWeight: FontWeight.w900, color: textPrimaryColor)),
          const Text("Live supply chain tracking", style: TextStyle(fontSize: 10, color: Colors.grey, fontWeight: FontWeight.bold)),
          const SizedBox(height: 28),
          if (isMobile)
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildMapStat("Primary Market", "₹ 1.25 Cr", "Maharashtra"),
                _buildMapStat("Market Growth", "+34.5%", "North Region"),
                _buildMapStat("Active Hubs", "12 Hubs", "Across India"),
              ],
            )
          else ...[
            _buildMapStat("Primary Market", "₹ 1.25 Cr", "Maharashtra"),
            const SizedBox(height: 20),
            _buildMapStat("Market Growth", "+34.5%", "North Region"),
            const SizedBox(height: 20),
            _buildMapStat("Active Hubs", "12 Hubs", "Across India"),
          ],
        ],
      ),
    );
  }

  Marker _buildMapMarker(BuildContext context, LatLng point, String title, String val, {bool isHighlighted = false}) {
    return Marker(
      point: point,
      width: 150,
      height: 70,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: isHighlighted ? const Color(0xFF0F172A) : const Color(0xFF334155),
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.4),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                )
              ],
              border: isHighlighted ? Border.all(color: primaryColor.withOpacity(0.5), width: 1) : null,
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 24, height: 24,
                  decoration: BoxDecoration(
                    color: isHighlighted ? primaryColor : Colors.white,
                    shape: BoxShape.circle,
                  ),
                  child: Center(
                    child: Icon(
                      Icons.location_on_rounded,
                      color: isHighlighted ? Colors.white : primaryColor,
                      size: 14,
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start, mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(title, style: TextStyle(color: Colors.white.withOpacity(0.7), fontSize: 9, fontWeight: FontWeight.bold)),
                    Text(val, style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.w900)),
                  ],
                ),
              ],
            ),
          ),
          Positioned(
            bottom: 5,
            child: Container(width: 2, height: 8, color: isHighlighted ? const Color(0xFF0F172A) : const Color(0xFF334155)),
          ),
        ],
      ),
    );
  }

  Widget _buildMapStat(String label, String val, String sub) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: TextStyle(color: Colors.grey[500], fontSize: 10, fontWeight: FontWeight.bold)),
        const SizedBox(height: 2),
        Text(val, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w900, color: textPrimaryColor, letterSpacing: -1)),
        Text(sub, style: TextStyle(color: primaryColor, fontSize: 10, fontWeight: FontWeight.bold)),
      ],
    );
  }

  Widget _buildMapChip(String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.06), blurRadius: 10)],
      ),
      child: Row(
        children: [
          Text(label, style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w800)),
          const SizedBox(width: 4),
          const Icon(Icons.keyboard_arrow_down_rounded, size: 16, color: Colors.blueAccent),
        ],
      ),
    );
  }
}