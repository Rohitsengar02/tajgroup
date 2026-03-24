import 'package:flutter/material.dart';
import '../../constants.dart';
import '../../responsive.dart';
import '../components/stockist_side_menu.dart';
import 'dashboard/stockist_dashboard_screen.dart';
import '../orders/stockist_orders_screen.dart';
import '../inventory/stockist_inventory_screen.dart';
import '../distributors/stockist_distributors_screen.dart';
import '../reports/stockist_reports_screen.dart';
import '../payments/stockist_payments_screen.dart';
import '../delivery/stockist_delivery_screen.dart';

class SuperStockistMainScreen extends StatefulWidget {
  const SuperStockistMainScreen({super.key});

  @override
  State<SuperStockistMainScreen> createState() => _SuperStockistMainScreenState();
}

class _SuperStockistMainScreenState extends State<SuperStockistMainScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  int _currentScreenIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      drawer: StockistSideMenu(
        onIndexChanged: (index) {
          setState(() {
            _currentScreenIndex = index;
          });
          if (Responsive.isMobile(context) || Responsive.isTablet(context)) {
            _scaffoldKey.currentState?.closeDrawer();
          }
        },
      ),
      body: SafeArea(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (Responsive.isDesktop(context))
              SizedBox(
                width: 280,
                child: StockistSideMenu(
                  onIndexChanged: (index) {
                    setState(() {
                      _currentScreenIndex = index;
                    });
                  },
                ),
              ),
            Expanded(
              child: _buildCurrentScreen(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCurrentScreen() {
    switch (_currentScreenIndex) {
      case 0:
        return StockistDashboardScreen(onIndexChanged: (index) => setState(() => _currentScreenIndex = index));
      case 1:
        return const StockistOrdersScreen();
      case 2:
        return const StockistInventoryScreen();
      case 3:
        return const StockistDistributorsScreen();
      case 4:
        return const StockistReportsScreen();
      case 5:
        return const StockistPaymentsScreen();
      case 6:
        return const StockistDeliveryScreen();
      default:
        return const StockistDashboardScreen();
    }
  }
}
