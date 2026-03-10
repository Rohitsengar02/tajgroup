import 'package:flutter/material.dart';
import '../../constants.dart';
import '../../responsive.dart';
import '../auth/role_selection_screen.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  final List<OnboardingItem> _items = [
    OnboardingItem(
      title: "Streamline Your Inventory",
      description: "Manage your stock across multiple locations with real-time tracking and automated restock alerts.",
      icon: Icons.inventory_2_rounded,
      color: primaryColor,
      gradient: const LinearGradient(colors: [Color(0xFF6C5CE7), Color(0xFF3B82F6)]),
    ),
    OnboardingItem(
      title: "Global Distribution Network",
      description: "Connect with distributors and retailers seamlessly through our unified supply chain platform.",
      icon: Icons.hub_rounded,
      color: secondaryColor,
      gradient: const LinearGradient(colors: [Color(0xFF3B82F6), Color(0xFF10B981)]),
    ),
    OnboardingItem(
      title: "Data-Driven Decisions",
      description: "Gain powerful insights into your sales performance with advanced analytics and territory maps.",
      icon: Icons.insights_rounded,
      color: successColor,
      gradient: const LinearGradient(colors: [Color(0xFF10B981), Color(0xFFF59E0B)]),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    bool isDesktop = Responsive.isDesktop(context);
    
    return Scaffold(
      backgroundColor: Colors.white,
      body: isDesktop ? _buildDesktopLayout() : _buildMobileLayout(),
    );
  }

  Widget _buildDesktopLayout() {
    return Row(
      children: [
        // Left Side: Visuals & Branding (Animated Background)
        Expanded(
          flex: 1,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 600),
            decoration: BoxDecoration(
              gradient: _items[_currentPage].gradient,
            ),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  TweenAnimationBuilder(
                    key: ValueKey(_currentPage),
                    tween: Tween<double>(begin: 0.8, end: 1.0),
                    duration: const Duration(milliseconds: 500),
                    builder: (context, value, child) => Transform.scale(
                      scale: value,
                      child: Icon(_items[_currentPage].icon, size: 240, color: Colors.white.withOpacity(0.9)),
                    ),
                  ),
                  const SizedBox(height: 48),
                  const Text(
                    "TAJNOVA",
                    style: TextStyle(color: Colors.white, fontSize: 40, fontWeight: FontWeight.w900, letterSpacing: 8),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    "ENTERPRISE SOLUTIONS",
                    style: TextStyle(color: Colors.white.withOpacity(0.7), fontSize: 14, fontWeight: FontWeight.bold, letterSpacing: 2),
                  ),
                ],
              ),
            ),
          ),
        ),
        
        // Right Side: Content & Actions
        Expanded(
          flex: 1,
          child: Container(
            padding: const EdgeInsets.all(80),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  "GETTING STARTED",
                  style: TextStyle(color: Colors.grey, fontWeight: FontWeight.w900, fontSize: 12, letterSpacing: 2),
                ),
                const SizedBox(height: 40),
                AnimatedSwitcher(
                  duration: const Duration(milliseconds: 500),
                  child: Column(
                    key: ValueKey(_currentPage),
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        _items[_currentPage].title,
                        style: const TextStyle(
                          fontSize: 48,
                          fontWeight: FontWeight.w900,
                          color: textPrimaryColor,
                          letterSpacing: -2,
                          height: 1.1,
                        ),
                      ),
                      const SizedBox(height: 24),
                      Text(
                        _items[_currentPage].description,
                        style: const TextStyle(
                          fontSize: 18,
                          color: textSecondaryColor,
                          height: 1.6,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 60),
                Row(
                  children: List.generate(
                    _items.length,
                    (index) => _buildIndicator(index == _currentPage),
                  ),
                ),
                const SizedBox(height: 60),
                SizedBox(
                  height: 60,
                  width: 200,
                  child: ElevatedButton(
                    onPressed: () {
                      if (_currentPage < _items.length - 1) {
                        setState(() => _currentPage++);
                      } else {
                        Navigator.push(context, MaterialPageRoute(builder: (_) => const RoleSelectionScreen()));
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.black,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                      elevation: 0,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          _currentPage == _items.length - 1 ? "GET STARTED" : "NEXT STEP",
                          style: const TextStyle(fontWeight: FontWeight.w800, letterSpacing: 1),
                        ),
                        const SizedBox(width: 8),
                        const Icon(Icons.arrow_forward_rounded, size: 18),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildMobileLayout() {
    return Stack(
      children: [
        PageView.builder(
          controller: _pageController,
          itemCount: _items.length,
          onPageChanged: (index) => setState(() => _currentPage = index),
          itemBuilder: (context, index) => _buildMobilePage(_items[index]),
        ),
        Positioned(
          bottom: 40,
          left: 24,
          right: 24,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(children: List.generate(_items.length, (index) => _buildIndicator(index == _currentPage))),
              _currentPage == _items.length - 1
                  ? ElevatedButton(
                      onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const RoleSelectionScreen())),
                      style: ElevatedButton.styleFrom(backgroundColor: Colors.black, foregroundColor: Colors.white, padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16))),
                      child: const Text("Get Started", style: TextStyle(fontWeight: FontWeight.bold)),
                    )
                  : FloatingActionButton(
                      onPressed: () => _pageController.nextPage(duration: const Duration(milliseconds: 300), curve: Curves.easeInOut),
                      backgroundColor: Colors.black,
                      foregroundColor: Colors.white,
                      elevation: 0,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                      child: const Icon(Icons.arrow_forward_rounded),
                    ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildMobilePage(OnboardingItem item) {
    return Padding(
      padding: const EdgeInsets.all(40),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(width: 200, height: 200, decoration: BoxDecoration(color: item.color.withOpacity(0.1), shape: BoxShape.circle), child: Center(child: Icon(item.icon, size: 80, color: item.color))),
          const SizedBox(height: 60),
          Text(item.title, textAlign: TextAlign.center, style: const TextStyle(fontSize: 24, fontWeight: FontWeight.w900, color: textPrimaryColor, letterSpacing: -1)),
          const SizedBox(height: 20),
          Padding(padding: const EdgeInsets.symmetric(horizontal: 20), child: Text(item.description, textAlign: TextAlign.center, style: const TextStyle(fontSize: 14, color: textSecondaryColor, height: 1.5, fontWeight: FontWeight.w500))),
        ],
      ),
    );
  }

  Widget _buildIndicator(bool isActive) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      margin: const EdgeInsets.symmetric(horizontal: 4),
      height: 6,
      width: isActive ? 32 : 8,
      decoration: BoxDecoration(color: isActive ? Colors.black : Colors.grey[300], borderRadius: BorderRadius.circular(4)),
    );
  }
}

class OnboardingItem {
  final String title;
  final String description;
  final IconData icon;
  final Color color;
  final LinearGradient gradient;

  OnboardingItem({required this.title, required this.description, required this.icon, required this.color, required this.gradient});
}
