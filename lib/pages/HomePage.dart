import 'package:blurrycontainer/blurrycontainer.dart';
import 'package:flutter/material.dart';
import 'package:segfaultersloc/pages/ListPage.dart';
import 'package:segfaultersloc/pages/MainPage.dart';
import 'package:segfaultersloc/pages/ProfilePage.dart';

class Homepage extends StatefulWidget {
  const Homepage({super.key});

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  final PageController _pageController = PageController();
  int _currentIndex = 0;

  void _navigateToPage(int index) {
    setState(() {
      _currentIndex = index;
    });
    _pageController.animateToPage(
      index,
      duration: const Duration(milliseconds: 500),
      curve: Curves.easeInOut,
    );
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.asset('assets/landingpage.png', fit: BoxFit.cover),
          ),
          PageView(
            controller: _pageController,
            physics: NeverScrollableScrollPhysics(), 
            children: const [
              MainPage(),
              ListsPage(),
              ProfilePage(),
            ],
          ),
          Positioned(
            top: 50,
            left: MediaQuery.of(context).size.width * 0.3,
            child: _buildNavBar(),
          ),
        ],
      ),
    );
  }

  Widget _buildNavBar() {
    return Center(
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(color: Colors.white.withOpacity(0.3), width: 1),
          borderRadius: BorderRadius.circular(20),
        ),
        child: BlurryContainer(
          blur: 5,
          elevation: 10,
          borderRadius: BorderRadius.circular(20),
          height: 60,
          width: MediaQuery.of(context).size.width * 0.4,
          padding: const EdgeInsets.symmetric(horizontal: 20),
          color: Colors.white.withOpacity(0.1),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _navItem("Home", 0),
              _navItem("Lists", 1),
              _navItem("Profile", 2),
            ],
          ),
        ),
      ),
    );
  }

  Widget _navItem(String label, int index) {
    return InkWell(
      onTap: () => _navigateToPage(index),
      child: Text(
        label,
        style: TextStyle(
          fontFamily: 'PixelyB',
          color: _currentIndex == index ? Colors.white : Colors.white70,
          fontSize: 18,
        ),
      ),
    );
  }
}


class PageBackground extends StatelessWidget {
  final Widget child;
  final Color overlayColor;

  const PageBackground({super.key, required this.child, required this.overlayColor});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned.fill(
          child: Container(
            color: overlayColor.withOpacity(0.5),
          ),
        ),
        Positioned.fill(
          child: Center(child: child),
        ),
      ],
    );
  }
}
