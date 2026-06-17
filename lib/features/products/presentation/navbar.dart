import 'package:flutter/material.dart';
import 'feed_screen.dart';
import 'product_screen.dart';
import 'profile_screen.dart';

class MainNavigationShell extends StatefulWidget {
  const MainNavigationShell({super.key});

  @override
  State<MainNavigationShell> createState() => _MainNavigationShellState();
}

class _MainNavigationShellState extends State<MainNavigationShell> {
  int _currentIndex = 0;

  // These are the screens the navbar will switch between
  final List<Widget> _screens = [
    const FeedScreen(),         
    const ProductScreen(),    
    const ProfileScreen(),     
    const Center(child: Text('Settings Page', style: TextStyle(color: Colors.white))),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true, // Crucial: lets the body flow behind the floating navbar
      body: _screens[_currentIndex],
      bottomNavigationBar: SafeArea(
        child: Container(
          height: 64,
          margin: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          decoration: BoxDecoration(
            color: const Color(0xFF121212),
            borderRadius: BorderRadius.circular(32),
            border: Border.all(color: Colors.grey.shade900, width: 1),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildNavIcon(Icons.layers_outlined, 0),        // Feed
              _buildNavIcon(Icons.inventory_2_outlined, 1),   // Products
              _buildCenterActionButton(),                     // Center (no screen)
              _buildNavIcon(Icons.person_outline, 2), 
              _buildNavIcon(Icons.settings_outlined, 3),        // Profile (Index 2)
              // Remove the settings icon, as you have no screen 4!
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNavIcon(IconData icon, int index) {
    final bool isSelected = _currentIndex == index;
    return GestureDetector(
      onTap: () => setState(() => _currentIndex = index),
      child: Icon(
        icon,
        color: isSelected ? Colors.white : Colors.grey.shade600,
        size: 26,
      ),
    );
  }

  Widget _buildCenterActionButton() {
    return GestureDetector(
      onTap: () {
        // Future: Open camera/post creator
      },
      child: Container(
        width: 44,
        height: 44,
        decoration: const BoxDecoration(
          color: Colors.white,
          shape: BoxShape.circle,
        ),
        child: const Icon(Icons.add, color: Colors.black, size: 24),
      ),
    );
  }
}