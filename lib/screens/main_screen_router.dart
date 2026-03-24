import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/user_provider.dart';
import 'stockist/super_stockist_main_screen.dart';
import 'main_screen.dart';

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
       return const AdminMainScreen();
    }
  }
}

// Keep the file clean by removing redundant stubs
