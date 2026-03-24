import 'package:flutter/material.dart';
import '../../constants.dart';
import '../../responsive.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    bool isMobile = Responsive.isMobile(context);
    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(defaultPadding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const _Header(),
            const SizedBox(height: defaultPadding * 1.5),
            if (isMobile) ...[
              const _SettingsNav(),
              const SizedBox(height: defaultPadding),
              const _SettingsContent(),
            ] else
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  Expanded(
                    flex: 2,
                    child: _SettingsNav(),
                  ),
                  SizedBox(width: defaultPadding),
                  Expanded(
                    flex: 5,
                    child: _SettingsContent(),
                  ),
                ],
              ),
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
          "Settings",
          style: TextStyle(fontSize: isMobile ? 24 : 32, fontWeight: FontWeight.bold, color: textPrimaryColor),
        ),
        const SizedBox(height: 4),
        Text(
          isMobile ? "Preferences & configuration" : "Manage your account preferences and system configuration",
          style: TextStyle(fontSize: isMobile ? 12 : 14, color: textSecondaryColor, fontWeight: FontWeight.w500),
        ),
      ],
    );
  }
}
class _SettingsNav extends StatelessWidget {
  const _SettingsNav();

  @override
  Widget build(BuildContext context) {
    bool isMobile = Responsive.isMobile(context);
    List<Map<String, dynamic>> items = [
      {"title": "Profile", "icon": Icons.person_outline_rounded},
      {"title": "Account", "icon": Icons.manage_accounts_outlined},
      {"title": "Notifications", "icon": Icons.notifications_none_rounded},
      {"title": "Security", "icon": Icons.shield_outlined},
      {"title": "Appearance", "icon": Icons.palette_outlined},
      {"title": "System", "icon": Icons.settings_input_component_outlined},
      {"title": "Support", "icon": Icons.help_outline_rounded},
    ];

    if (isMobile) {
      return SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: items.map((item) {
            bool isActive = item["title"] == "Profile";
            return Container(
              margin: const EdgeInsets.only(right: 8),
              child: ChoiceChip(
                label: Text(item["title"]),
                selected: isActive,
                onSelected: (_) {},
                backgroundColor: surfaceColor,
                selectedColor: primaryColor.withValues(alpha: 0.1),
                labelStyle: TextStyle(
                  color: isActive ? primaryColor : textSecondaryColor,
                  fontSize: 12,
                  fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
                ),
                side: BorderSide(
                  color: isActive ? primaryColor : textSecondaryColor.withValues(alpha: 0.1),
                ),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              ),
            );
          }).toList(),
        ),
      );
    }

    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: surfaceColor,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(color: Colors.black.withValues(alpha: 0.02), blurRadius: 10, offset: const Offset(0, 5))
        ],
      ),
      child: Column(
        children: items.map((item) {
          bool isActive = item["title"] == "Profile";
          return _buildNavItem(item["title"], item["icon"], isActive);
        }).toList(),
      ),
    );
  }

  Widget _buildNavItem(String title, IconData icon, bool isActive) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 4),
      decoration: BoxDecoration(
        color: isActive ? primaryColor.withValues(alpha: 0.1) : Colors.transparent,
        borderRadius: BorderRadius.circular(12),
      ),
      child: ListTile(
        onTap: () {},
        leading: Icon(icon, color: isActive ? primaryColor : textSecondaryColor, size: 22),
        title: Text(
          title,
          style: TextStyle(
            color: isActive ? primaryColor : textPrimaryColor,
            fontWeight: isActive ? FontWeight.bold : FontWeight.w500,
            fontSize: 14,
          ),
        ),
        trailing: isActive ? Container(width: 4, height: 20, decoration: BoxDecoration(color: primaryColor, borderRadius: BorderRadius.circular(2))) : null,
      ),
    );
  }
}

class _SettingsContent extends StatelessWidget {
  const _SettingsContent();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const _ProfileSection(),
        const SizedBox(height: defaultPadding),
        const _NotificationPreferences(),
        const SizedBox(height: defaultPadding),
        const _AppearanceSection(),
      ],
    );
  }
}

class _ProfileSection extends StatelessWidget {
  const _ProfileSection();

  @override
  Widget build(BuildContext context) {
    bool isMobile = Responsive.isMobile(context);
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: surfaceColor,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(color: Colors.black.withValues(alpha: 0.02), blurRadius: 10, offset: const Offset(0, 5))
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text("Public Profile", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: textPrimaryColor)),
          const SizedBox(height: 24),
          if (isMobile) ...[
            Center(
              child: Stack(
                children: [
                  const CircleAvatar(
                    radius: 60,
                    backgroundImage: NetworkImage("https://images.unsplash.com/photo-1472099645785-5658abf4ff4e?q=80&w=200&auto=format&fit=crop"),
                  ),
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: const BoxDecoration(color: primaryColor, shape: BoxShape.circle),
                      child: const Icon(Icons.camera_alt_rounded, color: Colors.white, size: 18),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: const [
                Text("Rohit Sharma", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: textPrimaryColor)),
              ],
            ),
            const Center(
              child: Text("Senior Sales Manager • TAJ Group", style: TextStyle(fontSize: 14, color: textSecondaryColor)),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _SocialBadge(icon: Icons.link_rounded, label: "Portfolio"),
                const SizedBox(width: 8),
                _SocialBadge(icon: Icons.alternate_email_rounded, label: "Twitter"),
              ],
            ),
          ] else
            Row(
              children: [
                Stack(
                  children: [
                    const CircleAvatar(
                      radius: 50,
                      backgroundImage: NetworkImage("https://images.unsplash.com/photo-1472099645785-5658abf4ff4e?q=80&w=200&auto=format&fit=crop"),
                    ),
                    Positioned(
                      bottom: 0,
                      right: 0,
                      child: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: const BoxDecoration(color: primaryColor, shape: BoxShape.circle),
                        child: const Icon(Icons.camera_alt_rounded, color: Colors.white, size: 16),
                      ),
                    ),
                  ],
                ),
                const SizedBox(width: 24),
                const Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Rohit Sharma", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: textPrimaryColor)),
                      Text("Senior Sales Manager • TAJ Group", style: TextStyle(fontSize: 14, color: textSecondaryColor)),
                      SizedBox(height: 12),
                      Row(
                        children: [
                          _SocialBadge(icon: Icons.link_rounded, label: "Portfolio"),
                          SizedBox(width: 8),
                          _SocialBadge(icon: Icons.alternate_email_rounded, label: "Twitter"),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          const SizedBox(height: 32),
          if (isMobile) ...[
            const _SettingsTextField(label: "Full Name", hintText: "Rohit Sharma"),
            const SizedBox(height: 20),
            const _SettingsTextField(label: "Job Title", hintText: "Senior Sales Manager"),
          ] else
            const Row(
              children: [
                Expanded(child: _SettingsTextField(label: "Full Name", hintText: "Rohit Sharma")),
                SizedBox(width: 16),
                Expanded(child: _SettingsTextField(label: "Job Title", hintText: "Senior Sales Manager")),
              ],
            ),
          const SizedBox(height: 20),
          const _SettingsTextField(label: "Bio", hintText: "Managing zonal sales and retail distributions across Maharashtra...", maxLines: 3),
        ],
      ),
    );
  }
}

class _SocialBadge extends StatelessWidget {
  final IconData icon;
  final String label;
  const _SocialBadge({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: const Color(0xFFF1F5F9),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: textSecondaryColor),
          const SizedBox(width: 6),
          Text(label, style: const TextStyle(fontSize: 12, color: textSecondaryColor, fontWeight: FontWeight.w600)),
        ],
      ),
    );
  }
}

class _NotificationPreferences extends StatelessWidget {
  const _NotificationPreferences();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: surfaceColor,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(color: Colors.black.withValues(alpha: 0.02), blurRadius: 10, offset: const Offset(0, 5))
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text("Notification Settings", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: textPrimaryColor)),
          const SizedBox(height: 16),
          _buildToggleTile("Email Notifications", "Get updates via email", true),
          const Divider(height: 32),
          _buildToggleTile("Browser Push", "Desktop notifications for alerts", true),
          const Divider(height: 32),
          _buildToggleTile("Weekly Digest", "Summary of last week's performance", false),
        ],
      ),
    );
  }

  Widget _buildToggleTile(String title, String subtitle, bool value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: textPrimaryColor)),
            Text(subtitle, style: const TextStyle(fontSize: 12, color: textSecondaryColor)),
          ],
        ),
        Switch(
          value: value,
          onChanged: (v) {},
          activeColor: primaryColor,
          activeTrackColor: primaryColor.withValues(alpha: 0.2),
        ),
      ],
    );
  }
}

class _AppearanceSection extends StatelessWidget {
  const _AppearanceSection();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: surfaceColor,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(color: Colors.black.withValues(alpha: 0.02), blurRadius: 10, offset: const Offset(0, 5))
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text("Appearance", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: textPrimaryColor)),
          const SizedBox(height: 24),
          const Text("Theme Mode", style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: textSecondaryColor)),
          const SizedBox(height: 16),
          Responsive.isMobile(context) 
           ? Column(
             children: [
               _buildThemeCard("Light", Icons.light_mode_rounded, true, isFullWidth: true),
               const SizedBox(height: 12),
               _buildThemeCard("Dark", Icons.dark_mode_rounded, false, isFullWidth: true),
               const SizedBox(height: 12),
               _buildThemeCard("System", Icons.settings_brightness_rounded, false, isFullWidth: true),
             ],
           )
           : Row(
              children: [
                _buildThemeCard("Light", Icons.light_mode_rounded, true),
                const SizedBox(width: 16),
                _buildThemeCard("Dark", Icons.dark_mode_rounded, false),
                const SizedBox(width: 16),
                _buildThemeCard("System", Icons.settings_brightness_rounded, false),
              ],
            ),
        ],
      ),
    );
  }

  Widget _buildThemeCard(String label, IconData icon, bool isActive, {bool isFullWidth = false}) {
    return Container(
      width: isFullWidth ? double.infinity : 100,
      padding: const EdgeInsets.symmetric(vertical: 20),
      decoration: BoxDecoration(
        color: isActive ? primaryColor.withValues(alpha: 0.05) : const Color(0xFFF8FAFC),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: isActive ? primaryColor : Colors.transparent, width: 2),
      ),
      child: Column(
        children: [
          Icon(icon, color: isActive ? primaryColor : textSecondaryColor, size: 24),
          const SizedBox(height: 8),
          Text(label, style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: isActive ? primaryColor : textPrimaryColor)),
        ],
      ),
    );
  }
}

class _SettingsTextField extends StatelessWidget {
  final String label, hintText;
  final int maxLines;
  const _SettingsTextField({required this.label, required this.hintText, this.maxLines = 1});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: textSecondaryColor)),
        const SizedBox(height: 8),
        TextField(
          maxLines: maxLines,
          decoration: InputDecoration(
            hintText: hintText,
            hintStyle: const TextStyle(color: textSecondaryColor, fontSize: 13),
            filled: true,
            fillColor: const Color(0xFFF8FAFC),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          ),
        ),
      ],
    );
  }
}
