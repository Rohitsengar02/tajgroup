import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../constants.dart';
import '../../responsive.dart';
import '../../providers/user_provider.dart';
import 'login_screen.dart';

class RoleSelectionScreen extends StatelessWidget {
  const RoleSelectionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    bool isDesktop = Responsive.isDesktop(context);
    
    return Scaffold(
      backgroundColor: bgColor,
      body: isDesktop ? _buildDesktopLayout(context) : _buildMobileLayout(context),
    );
  }

  Widget _buildDesktopLayout(BuildContext context) {
    return Row(
      children: [
        // Left Side: Branding
        Expanded(
          flex: 4,
          child: Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFF2B3674), Color(0xFF1B254B)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: Center(
              child: Padding(
                padding: const EdgeInsets.all(60.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Icon(Icons.workspace_premium_rounded, size: 80, color: Colors.white),
                    const SizedBox(height: 48),
                    const Text(
                      "Secure Access to\nYour Specialized Portal",
                      style: TextStyle(
                        fontSize: 48,
                        fontWeight: FontWeight.w900,
                        color: Colors.white,
                        letterSpacing: -2,
                        height: 1.1,
                      ),
                    ),
                    const SizedBox(height: 24),
                    Text(
                      "Choose your professional role to continue to your personalized dashboard.",
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.white.withOpacity(0.7),
                        height: 1.6,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
        
        // Right Side: Role Selection Grid (Non-Scrollable)
        Expanded(
          flex: 6,
          child: Container(
            color: bgColor,
            padding: const EdgeInsets.all(60),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  "CHOOSE YOUR PANEL",
                  style: TextStyle(color: Colors.grey, fontWeight: FontWeight.w900, fontSize: 12, letterSpacing: 2),
                ),
                const SizedBox(height: 40),
                // Using Wrap to create a grid-like layout that doesn't scroll
                Center(
                  child: Wrap(
                    spacing: 24,
                    runSpacing: 24,
                    alignment: WrapAlignment.center,
                    children: [
                      _buildGridCard(context, "Admin Panel", Icons.admin_panel_settings_rounded, const Color(0xFF1E293B)),
                      _buildGridCard(context, "Super Stockist Panel", Icons.warehouse_rounded, const Color(0xFF6C5CE7)),
                      _buildGridCard(context, "Distributor Panel", Icons.local_shipping_rounded, const Color(0xFF3B82F6)),
                      _buildGridCard(context, "Sales Person Panel", Icons.person_pin_circle_rounded, const Color(0xFFF59E0B)),
                      _buildGridCard(context, "Retailer / Customer Panel", Icons.storefront_rounded, const Color(0xFF10B981)),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildMobileLayout(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 48),
            const Icon(Icons.workspace_premium_rounded, size: 48, color: Colors.black),
            const SizedBox(height: 24),
            const Text("Select Your Account Type", style: TextStyle(fontSize: 28, fontWeight: FontWeight.w900, color: textPrimaryColor, letterSpacing: -1)),
            const SizedBox(height: 8),
            const Text("Choose your professional role within the ecosystem.", style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: textSecondaryColor, height: 1.5)),
            const SizedBox(height: 40),
            Expanded(
              child: ListView(
                children: [
                  _buildListCard(context, "Admin Panel", Icons.admin_panel_settings_rounded, const Color(0xFF1E293B)),
                  const SizedBox(height: 16),
                  _buildListCard(context, "Super Stockist Panel", Icons.warehouse_rounded, const Color(0xFF6C5CE7)),
                  const SizedBox(height: 16),
                  _buildListCard(context, "Distributor Panel", Icons.local_shipping_rounded, const Color(0xFF3B82F6)),
                  const SizedBox(height: 16),
                  _buildListCard(context, "Sales Person Panel", Icons.person_pin_circle_rounded, const Color(0xFFF59E0B)),
                  const SizedBox(height: 16),
                  _buildListCard(context, "Retailer / Customer Panel", Icons.storefront_rounded, const Color(0xFF10B981)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Desktop Grid Card (Boxy)
  Widget _buildGridCard(BuildContext context, String title, IconData icon, Color color) {
    return InkWell(
      onTap: () {
        // Set the role in the provider
        try {
          final userProvider = Provider.of<UserProvider>(context, listen: false);
          userProvider.setRole(title);
        } catch (e) {
          // Fallback if provider fails
        }
        Navigator.push(context, MaterialPageRoute(builder: (_) => LoginScreen(role: title)));
      },
      borderRadius: BorderRadius.circular(24),
      child: Container(
        width: 180,
        height: 180,
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: surfaceColor,
          borderRadius: BorderRadius.circular(24),
          border: Border.all(color: Colors.grey.withOpacity(0.08)),
          boxShadow: [
            BoxShadow(color: Colors.black.withOpacity(0.02), blurRadius: 20, offset: const Offset(0, 10)),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(color: color.withOpacity(0.1), shape: BoxShape.circle),
              child: Icon(icon, color: color, size: 32),
            ),
            const SizedBox(height: 16),
            Text(
              title,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: textPrimaryColor, height: 1.2),
            ),
          ],
        ),
      ),
    );
  }

  // Mobile List Card (Horizontal)
  Widget _buildListCard(BuildContext context, String title, IconData icon, Color color) {
    return InkWell(
      onTap: () {
        try {
          final userProvider = Provider.of<UserProvider>(context, listen: false);
          userProvider.setRole(title);
        } catch (e) {}
        Navigator.push(context, MaterialPageRoute(builder: (_) => LoginScreen(role: title)));
      },
      borderRadius: BorderRadius.circular(24),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: surfaceColor,
          borderRadius: BorderRadius.circular(24),
          border: Border.all(color: Colors.grey.withOpacity(0.08)),
        ),
        child: Row(
          children: [
            Container(padding: const EdgeInsets.all(10), decoration: BoxDecoration(color: color.withOpacity(0.1), shape: BoxShape.circle), child: Icon(icon, color: color, size: 24)),
            const SizedBox(width: 16),
            Expanded(child: Text(title, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: textPrimaryColor))),
            const Icon(Icons.chevron_right_rounded, color: Colors.grey, size: 20),
          ],
        ),
      ),
    );
  }
}
