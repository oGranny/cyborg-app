import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class AnimatedBottomNavbar extends StatefulWidget {
  const AnimatedBottomNavbar({super.key});

  @override
  State<AnimatedBottomNavbar> createState() => _AnimatedBottomNavbarState();
}

class _AnimatedBottomNavbarState extends State<AnimatedBottomNavbar>
    with TickerProviderStateMixin {
  int _selectedIndex = 0;
  late final List<AnimationController?> _controllers;

  @override
  void initState() {
    super.initState();
    _controllers = List.generate(3, (_) => null);
    _controllers[0]?.reset(); // Reset to start
    _controllers[1]?.reset(); // Reset to start
    _controllers[2]?.reset(); // Reset to start
  }

  @override
  void dispose() {
    for (var controller in _controllers) {
      controller?.dispose();
    }
    super.dispose();
  }

  void _onTabTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });

    for (var controller in _controllers) {
      controller?.reset();
    }
    _controllers[index]?.forward();
  }

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      type: BottomNavigationBarType.fixed,
      currentIndex: _selectedIndex,
      onTap: _onTabTapped,
      items: [
        BottomNavigationBarItem(
          icon: Lottie.asset(
            animate: false,
            'assets/lottie/home_lottie.json',
            height: 30,
            width: 30,
            controller: _controllers[0],
            onLoaded: (composition) {
              _controllers[0] = AnimationController(
                vsync: this,
                duration: composition.duration,
              );
            },
          ),
          label: 'Home',
        ),
        BottomNavigationBarItem(
          icon: Lottie.asset(
            animate: false,
            'assets/lottie/bell_lottie.json',
            height: 30,
            width: 30,
            controller: _controllers[1],
            onLoaded: (composition) {
              _controllers[1] = AnimationController(
                vsync: this,
                duration: composition.duration,
              );
            },
          ),
          label: 'Activity',
        ),
        BottomNavigationBarItem(
          icon: Lottie.asset(
            animate: false,
            'assets/lottie/chat_lottie.json',
            height: 30,
            width: 30,
            controller: _controllers[2],
            onLoaded: (composition) {
              _controllers[2] = AnimationController(
                vsync: this,
                duration: composition.duration,
              );
            },
          ),
          label: 'Chat',
        ),
      ],
    );
  }
}
