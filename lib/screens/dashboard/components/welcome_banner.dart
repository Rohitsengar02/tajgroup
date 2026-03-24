import 'package:flutter/material.dart';
import 'package:carousel_slider_plus/carousel_slider_plus.dart';
import '../../../constants.dart';

class WelcomeBanner extends StatelessWidget {
  const WelcomeBanner({super.key});

  @override
  Widget build(BuildContext context) {
    return CarouselSlider(
      options: CarouselOptions(
        height: 160.0,
        autoPlay: true,
        enlargeCenterPage: true,
        viewportFraction: 1.0,
      ),
      items: [
        _buildBanner(
          title: "Good Morning, John!",
          subtitle: "Here is what's happening with your store today.",
          gradient: primaryGradient,
          icon: Icons.waving_hand,
        ),
        _buildBanner(
          title: "Sales Target Reached \uD83C\uDF89",
          subtitle: "You have completed 115% of your sales goal for October.",
          gradient: successGradient,
          icon: Icons.trending_up,
        ),
        _buildBanner(
          title: "Inventory Alert",
          subtitle: "20 top products are running low on stock.",
          gradient: secondaryGradient,
          icon: Icons.warning_amber_rounded,
        ),
      ],
    );
  }

  Widget _buildBanner({required String title, required String subtitle, required LinearGradient gradient, required IconData icon}) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(defaultPadding * 2),
      decoration: BoxDecoration(
        gradient: gradient,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: gradient.colors.first.withOpacity(0.3),
            blurRadius: 15,
            offset: const Offset(0, 10),
          )
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  subtitle,
                  style: const TextStyle(
                    fontSize: 16,
                    color: Colors.white70,
                  ),
                ),
              ],
            ),
          ),
          Icon(
            icon,
            size: 64,
            color: Colors.white.withOpacity(0.8),
          ),
        ],
      ),
    );
  }
}
