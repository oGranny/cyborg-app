import 'package:cyborg_main_app/widgets/navbar.dart';
import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: AnimatedBottomNavbar(),
      appBar: AppBar(
        title: Center(child: Text('Cyborg', style: TextStyle(fontSize: 25))),
      ),
      body: Padding(
        padding: const EdgeInsets.all(25.0),
        child: GridView.count(
          crossAxisCount: 2,
          crossAxisSpacing: 22,
          mainAxisSpacing: 22,
          children: [
            Tile(
              onClick: () {},
              icon: Icons.vpn_key_outlined,
              title: "Keys",
            ),
            Tile(
              onClick: () {},
              icon: Icons.calendar_month_rounded,
              title: "Calander",
            ),
            Tile(
              icon: Icons.assignment_outlined,
              onClick: () {},
              title: "Assignment",
            ),
            Tile(
              onClick: () {},
              icon: Icons.badge,
              title: "Team",
            ),
            Tile(
              onClick: () {},
              icon: Icons.work_outline,
              title: "Projects",
            ),
          ],
        ),
      ),
    );
  }
}

class Tile extends StatelessWidget {
  final void Function()? onClick;
  final IconData icon;
  final String title;
  const Tile({
    super.key,
    this.onClick,
    required this.icon,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 135,
      width: 135,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: Colors.grey[900],
      ),
      child: GestureDetector(
        onTap: onClick,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(
                icon,
                color: Colors.white,
                size: 40,
              ),
              Text(title, style: TextStyle(fontSize: 25, color: Colors.white)),
            ],
          ),
        ),
      ),
    );
  }
}
