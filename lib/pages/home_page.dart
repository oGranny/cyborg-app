import 'package:cyborg/pages/signup_page.dart';
import 'package:cyborg/widgets/drawer.dart';
import 'package:cyborg/widgets/navbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  Future signOut(context) async {
    // _auth.signOut();
    // final googleSignIn = GoogleSignIn();
    // await googleSignIn.signOut();
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => SignUpPage()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: NavigationDrawerWidget(
          // currentUserId: currentUserId,
          ),
      bottomNavigationBar: AnimatedBottomNavbar(),
      appBar: AppBar(
        actions: [
          IconButton(
            icon: const Icon(
              Icons.logout,
              color: Color.fromRGBO(99, 100, 167, 1),
            ),
            onPressed: () {
              signOut(context);
            },
          ),
        ],
        title: Center(child: Text('Cyborg', style: TextStyle(fontSize: 25))),
      ),
      body: Padding(
        padding: const EdgeInsets.all(25.0),
        child: StaggeredGrid.count(
          crossAxisCount: 4,
          mainAxisSpacing: 3,
          crossAxisSpacing: 4,
          children: const [
            StaggeredGridTile.count(
              crossAxisCellCount: 2,
              mainAxisCellCount: 3,
              child: Tile(index: 0),
            ),
            StaggeredGridTile.count(
              crossAxisCellCount: 2,
              mainAxisCellCount: 1,
              child: Tile(index: 1),
            ),
            StaggeredGridTile.count(
              crossAxisCellCount: 2,
              mainAxisCellCount: 2,
              child: Tile(index: 2),
            ),
            // StaggeredGridTile.count(
            //   crossAxisCellCount: 1,
            //   mainAxisCellCount: 1,
            //   child: Tile(index: 3),
            // ),
            // StaggeredGridTile.count(
            //   crossAxisCellCount: 4,
            //   mainAxisCellCount: 2,
            //   child: Tile(index: 4),
            // ),
          ],
        ),
      ),
    );
  }
}

class Tile extends StatelessWidget {
  const Tile({
    Key? key,
    required this.index,
    this.extent,
    this.backgroundColor,
    this.bottomSpace,
  }) : super(key: key);

  final int index;
  final double? extent;
  final double? bottomSpace;
  final Color? backgroundColor;

  @override
  Widget build(BuildContext context) {
    final child = Container(
      color: Colors.primaries[index % Colors.primaries.length],
      height: extent,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.ac_unit,
            size: 50,
          ),
          Text(
            'Tile $index',
            style: TextStyle(fontSize: 20),
          ),
        ],
      ),
    );

    if (bottomSpace == null) {
      return child;
    }

    return Column(
      children: [
        Expanded(child: child),
        Container(
          height: bottomSpace,
          color: Colors.green,
        )
      ],
    );
  }
}

class Tile_custom extends StatelessWidget {
  final void Function()? onClick;
  final IconData icon;
  final String title;
  const Tile_custom({
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
        color: Colors.white,
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
                // color: Colors.black,
                size: 30,
              ),
              Text(title, style: TextStyle(fontSize: 25)),
            ],
          ),
        ),
      ),
    );
  }
}
