import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../constants.dart';
import '../../providers/user_provider.dart';
import '../dashboard/dashboard_screen.dart';
import '../stockist/dashboard/stockist_dashboard_screen.dart';

class MainScreenLoader extends StatelessWidget {
  const MainScreenLoader({super.key});

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context);
    
    // Route based on role
    if (userProvider.currentRole == UserRole.superStockist) {
       return const SuperStockistMainScreen();
    } else {
       // Default to Admin/Original Dashboard for now
       return const OriginalMainScreen();
    }
  }
}

// Rename current MainScreen to OriginalMainScreen
class OriginalMainScreen extends StatefulWidget {
  const OriginalMainScreen({super.key});

  @override
  State<OriginalMainScreen> createState() => _OriginalMainScreenState();
}

// ... original MainScreen implementation here ...
