// Main application shell with responsive navigation
import 'package:flutter/material.dart';
import '../constants.dart';
import '../responsive.dart';
import 'components/side_menu.dart';
import 'components/bottom_nav_bar.dart';
import 'orders/orders_screen.dart';
import 'dashboard/dashboard_screen.dart';
import 'team/team_screen.dart';
import 'network/network_screen.dart';
import 'customers/customers_screen.dart';
import 'distribution/distribution_screen.dart';
import 'routes/routes_screen.dart';
import 'beats/beats_screen.dart';
import 'performance/growth_tracking_screen.dart';
import 'quotations/quotations_screen.dart';
import 'proforma/proforma_invoice_screen.dart';
import 'payments/payments_screen.dart';
import 'delivery/delivery_challan_screen.dart';
import 'returns/returns_screen.dart';
import 'sales/secondary_sales_screen.dart';
import 'sales/primary_sales_screen.dart';
import 'performance/loyalty_screen.dart';
import 'performance/schemes_screen.dart';
import 'performance/target_screen.dart';
import 'performance/attendance_screen.dart';
import 'reports/reports_screen.dart';
import 'payroll/payroll_screen.dart';
import 'settings/settings_screen.dart';
import 'products/products_screen.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  int _currentScreenIndex = 0; // 0 for Dashboard, 1 for Orders

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      drawer: SideMenu(
        onIndexChanged: (index) {
          setState(() {
            _currentScreenIndex = index;
          });
          if (Responsive.isMobile(context) || Responsive.isTablet(context)) {
            _scaffoldKey.currentState?.closeDrawer();
          }
        },
      ),
      bottomNavigationBar: Responsive.isMobile(context)
          ? CustomBottomNavBar(
              selectedIndex: _currentScreenIndex,
              onIndexChanged: (index) {
                setState(() {
                  _currentScreenIndex = index;
                });
              },
            )
          : null,
      body: Stack(
        children: [
          SafeArea(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (Responsive.isDesktop(context))
                  SizedBox(
                    width: 280,
                    child: SideMenu(
                      onIndexChanged: (index) {
                        setState(() {
                          _currentScreenIndex = index;
                        });
                      },
                    ),
                  ),
                Expanded(
                  flex: 5,
                  child: _buildCurrentScreen(),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCurrentScreen() {
    switch (_currentScreenIndex) {
      case 0:
        return DashboardLoader(
          onIndexChanged: (index) {
            setState(() {
              _currentScreenIndex = index;
            });
          },
        );
      case 1:
        return const OrdersScreen();
      case 2:
        return const QuotationsScreen();
      case 3:
        return const ProformaInvoiceScreen();
      case 4:
        return const PaymentsScreen();
      case 5:
        return const DeliveryChallanScreen();
      case 6:
        return const SalesReturnScreen();
      case 7:
        return const SecondarySalesScreen();
      case 8:
        return const PrimarySalesScreen();
      case 9:
        return const CustomersScreen();
      case 10:
        return const DistributionScreen();
      case 11:
        return const TeamScreen();
      case 12:
        return const BeatsScreen();
      case 13:
        return const RoutesScreen();
      case 14:
        return const NetworkScreen();
      case 15:
        return const ProductsScreen();
      case 16:
        return const GrowthTrackingScreen();
      case 17:
        return const LoyaltyScreen();
      case 18:
        return const SchemesScreen();
      case 19:
        return const TargetScreen();
      case 20:
        return const AttendanceScreen();
      case 21:
        return const PayrollScreen();
      case 22:
        return const ReportsScreen();
      case 23:
        return const SettingsScreen();
      default:
        // Placeholder for unimplemented screens
        return Scaffold(
          backgroundColor: bgColor,
          body: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.construction_rounded, size: 64, color: textSecondaryColor.withValues(alpha: 0.5)),
                const SizedBox(height: 16),
                const Text(
                  "Screen Under Development",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: textPrimaryColor),
                ),
                const SizedBox(height: 8),
                const Text(
                  "We're currently building this feature for you.",
                  style: TextStyle(color: textSecondaryColor),
                ),
              ],
            ),
          ),
        );
    }
  }

  void _showGlobalQuickAccess(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) => Container(
        height: MediaQuery.of(context).size.height * 0.45,
        decoration: const BoxDecoration(
          color: surfaceColor,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(30),
            topRight: Radius.circular(30),
          ),
          boxShadow: [
            BoxShadow(color: Colors.black26, blurRadius: 20, spreadRadius: 5)
          ]
        ),
        child: Column(
          children: [
            const SizedBox(height: 12),
            Container(
              width: 50,
              height: 5,
              decoration: BoxDecoration(
                color: textSecondaryColor.withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(5),
              ),
            ),
            const SizedBox(height: 24),
            const Text(
              "Management Hub",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: textPrimaryColor,
              ),
            ),
            const SizedBox(height: 24),
            Expanded(
              child: GridView.count(
                crossAxisCount: 3,
                padding: const EdgeInsets.symmetric(horizontal: 20),
                mainAxisSpacing: 20,
                crossAxisSpacing: 20,
                children: [
                  _buildMenuIcon(Icons.add_shopping_cart, "Order", primaryColor),
                  _buildMenuIcon(Icons.person_add_outlined, "Customer", successColor),
                  _buildMenuIcon(Icons.route_outlined, "Route", const Color(0xFFFF7A18)),
                  _buildMenuIcon(Icons.payments_outlined, "Payment", const Color(0xFFEE5D50)),
                  _buildMenuIcon(Icons.inventory_2_outlined, "Inventory", const Color(0xFF9333EA)),
                  _buildMenuIcon(Icons.analytics_outlined, "Report", const Color(0xFF0EA5E9)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMenuIcon(IconData icon, String label, Color color) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.1),
            shape: BoxShape.circle,
          ),
          child: Icon(icon, color: color, size: 28),
        ),
        const SizedBox(height: 8),
        Text(
          label,
          textAlign: TextAlign.center,
          style: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: textPrimaryColor,
          ),
        ),
      ],
    );
  }
}

class DashboardLoader extends StatelessWidget {
  final Function(int) onIndexChanged;
  const DashboardLoader({super.key, required this.onIndexChanged});

  @override
  Widget build(BuildContext context) {
    return DashboardScreen(
      onIndexChanged: onIndexChanged,
      openDrawer: () {
        Scaffold.of(context).openDrawer();
      },
    );
  }
}
