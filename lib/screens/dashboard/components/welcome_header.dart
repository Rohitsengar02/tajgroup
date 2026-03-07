import 'package:flutter/material.dart';
import '../../../../constants.dart';
import '../../../../responsive.dart';

class WelcomeHeader extends StatelessWidget {
  final VoidCallback openDrawer;
  const WelcomeHeader({super.key, required this.openDrawer});

  @override
  Widget build(BuildContext context) {
    if (Responsive.isMobile(context)) {
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: defaultPadding, vertical: 12),
        decoration: BoxDecoration(
          color: surfaceColor,
          border: Border(bottom: BorderSide(color: textSecondaryColor.withValues(alpha: 0.05))),
        ),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Container(
                      width: 32,
                      height: 32,
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [Color(0xFF2D3142), Color(0xFF1A1D29)],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: const Center(
                        child: Icon(Icons.diamond_outlined, color: Colors.amberAccent, size: 18),
                      ),
                    ),
                    const SizedBox(width: 10),
                    const Text(
                      "TAJ GROUP",
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w900,
                        color: Color(0xFF1E293B),
                        letterSpacing: 1.0,
                      ),
                    ),
                  ],
                ),
                _buildHeaderIconButton(
                  icon: Icons.menu_rounded,
                  onTap: openDrawer,
                  isPrimary: true,
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(2),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(color: primaryColor.withValues(alpha: 0.2), width: 2),
                      ),
                      child: const CircleAvatar(
                        radius: 20,
                        backgroundImage: NetworkImage("https://i.pravatar.cc/150?img=11"),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: const [
                        Text(
                          "Good Morning",
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w500,
                            color: textSecondaryColor,
                          ),
                        ),
                        Text(
                          "Rohit Kumar",
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                            color: textPrimaryColor,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                _buildHeaderIconButton(
                  icon: Icons.notifications_outlined,
                  onTap: () {},
                  hasBadge: true,
                ),
              ],
            ),
          ],
        ),
      );
    }

    return Container(
      padding: const EdgeInsets.all(defaultPadding),
      decoration: BoxDecoration(
        color: surfaceColor,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.02),
            blurRadius: 10,
            offset: const Offset(0, 5),
          )
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Text(
                      "Hello Rohit \uD83D\uDC4B",
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: textPrimaryColor,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: successColor.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: const Text(
                        "Administrator",
                        style: TextStyle(color: successColor, fontSize: 10, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                const Text(
                  "Today is October 24, 2026. Here is an overview of your business.",
                  style: TextStyle(
                    fontSize: 14,
                    color: textSecondaryColor,
                  ),
                ),
              ],
            ),
          ),
          Row(
            children: [
              _buildQuickAction(Icons.add_shopping_cart, "Order", primaryColor),
              const SizedBox(width: 8),
              _buildQuickAction(Icons.person_add_alt_1_outlined, "Customer", successColor),
              const SizedBox(width: 8),
              _buildQuickAction(Icons.route_outlined, "Route", const Color(0xFFFF7A18)),
              const SizedBox(width: 20),
              Container(width: 1, height: 35, color: textSecondaryColor.withValues(alpha: 0.1)),
              const SizedBox(width: 20),
              _buildHeaderIconButton(
                icon: Icons.notifications_none_rounded,
                onTap: () {},
                hasBadge: true,
              ),
              const SizedBox(width: 12),
              _buildHeaderIconButton(
                icon: Icons.settings_outlined,
                onTap: () {},
              ),
              const SizedBox(width: 20),
              Row(
                children: [
                  const Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text("Rohit Kumar", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                      Text("Admin", style: TextStyle(color: textSecondaryColor, fontSize: 12)),
                    ],
                  ),
                  const SizedBox(width: 12),
                  Container(
                    padding: const EdgeInsets.all(2),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: primaryColor.withValues(alpha: 0.1), width: 2),
                    ),
                    child: const CircleAvatar(
                      radius: 20,
                      backgroundImage: NetworkImage("https://i.pravatar.cc/150?img=11"),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildHeaderIconButton({
    required IconData icon,
    required VoidCallback onTap,
    bool hasBadge = false,
    bool isPrimary = false,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: isPrimary ? primaryColor : surfaceColor,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isPrimary ? primaryColor : textSecondaryColor.withValues(alpha: 0.1),
          ),
          boxShadow: isPrimary
              ? [
                  BoxShadow(
                    color: primaryColor.withValues(alpha: 0.3),
                    blurRadius: 8,
                    offset: const Offset(0, 4),
                  )
                ]
              : null,
        ),
        child: Stack(
          alignment: Alignment.center,
          children: [
            Icon(
              icon,
              color: isPrimary ? Colors.white : textPrimaryColor,
              size: 20,
            ),
            if (hasBadge)
              Positioned(
                right: 0,
                top: 0,
                child: Container(
                  width: 8,
                  height: 8,
                  decoration: BoxDecoration(
                    color: errorColor,
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.white, width: 1.5),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildQuickAction(IconData icon, String label, Color color) {
    return ElevatedButton.icon(
      style: ElevatedButton.styleFrom(
        backgroundColor: color.withValues(alpha: 0.08),
        foregroundColor: color,
        elevation: 0,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
      onPressed: () {},
      icon: Icon(icon, size: 18),
      label: Text(label, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
    );
  }
}
