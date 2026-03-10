import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../constants.dart';
import 'package:tajpro/responsive.dart';
import 'package:tajpro/providers/user_provider.dart';
import 'package:tajpro/screens/components/side_menu.dart';
import 'package:tajpro/screens/components/bottom_nav_bar.dart';
import 'package:tajpro/screens/orders/orders_screen.dart';
import 'package:tajpro/screens/dashboard/dashboard_screen.dart';
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
import 'stockist/super_stockist_main_screen.dart';

class MainScreen extends StatelessWidget {
  const MainScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context);
    
    // Role-based Router
    if (userProvider.currentRole == UserRole.superStockist) {
      return const SuperStockistMainScreen();
    }
    
    // Default to the Original System Admin Dashboard
    return const AdminMainScreen();
  }
}

class AdminMainScreen extends StatefulWidget {
  const AdminMainScreen({super.key});

  @override
  State<AdminMainScreen> createState() => _AdminMainScreenState();
}

class _AdminMainScreenState extends State<AdminMainScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  int _currentScreenIndex = 0;

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
        return const Scaffold(body: Center(child: Text("Development Placeholder")));
    }
  }
}

class DashboardLoader extends StatelessWidget {
  final Function(int) onIndexChanged;
  const DashboardLoader({super.key, required this.onIndexChanged});

  @override
  Widget build(BuildContext context) {
    return DashboardScreen(
      onIndexChanged: onIndexChanged,
      selectedIndex: 0, // Initial index for the dashboard
      openDrawer: () {
        Scaffold.of(context).openDrawer();
      },
    );
  }
}
