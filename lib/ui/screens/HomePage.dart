import 'package:flutter/material.dart';
import 'package:salomon_bottom_bar/salomon_bottom_bar.dart';

// Import your other screen files
import 'CartScreen.dart';
import 'profileScreen.dart';
import 'HomeContent.dart';
import 'FavScreen.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _currentIndex = 0;

  final List<Widget> _screens = [
    HomeContent(),
    CartScreen(),
    FavScreen(),
    ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      body: _screens[_currentIndex],
      bottomNavigationBar: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(24),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.1),
                spreadRadius: 1,
                blurRadius: 10,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: SalomonBottomBar(
            currentIndex: _currentIndex,
            onTap: (index) {
              setState(() {
                _currentIndex = index;
              });
            },
            selectedItemColor: const Color(0xFF70B9BE),
            unselectedItemColor: Colors.grey,
            margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            items: [
              SalomonBottomBarItem(
                icon: const Icon(Icons.home_outlined),
                title: const Text("Accueil"),
                selectedColor: const Color(0xFF70B9BE),
              ),
              SalomonBottomBarItem(
                icon: const Icon(Icons.shopping_bag_outlined),
                title: const Text("Carte"),
                selectedColor: const Color(0xFF70B9BE),
              ),
              SalomonBottomBarItem(
                icon: const Icon(Icons.favorite_border_outlined),
                title: const Text("favoris"),
                selectedColor: const Color(0xFF70B9BE),
              ),
              SalomonBottomBarItem(
                icon: const Icon(Icons.person_2_outlined),
                title: const Text("Profile"),
                selectedColor: const Color(0xFF70B9BE),
              ),
              
            ],
          ),
        ),
      ),
      extendBody: true,
    );
  }
}