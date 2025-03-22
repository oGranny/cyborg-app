import 'package:cyborg/pages/keys_app.dart';
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
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const GridWidgets(),
              const SizedBox(height: 20),
              Text("Activities",
                  style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold)),
              ListTile(
                leading: Icon(Icons.ac_unit),
                title: Text('Tile '),
                onTap: () {
                  print('Tile clicked');
                },
              ),
              ListTile(
                leading: Icon(Icons.ac_unit),
                title: Text('Tile '),
                onTap: () {
                  print('Tile clicked');
                },
              ),
              ListTile(
                leading: Icon(Icons.ac_unit),
                title: Text('Tile '),
                onTap: () {
                  print('Tile clicked');
                },
              ),
              ListTile(
                leading: Icon(Icons.ac_unit),
                title: Text('Tile '),
                onTap: () {
                  print('Tile clicked');
                },
              ),
              ListTile(
                leading: Icon(Icons.ac_unit),
                title: Text('Tile '),
                onTap: () {
                  print('Tile clicked');
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class GridWidgets extends StatelessWidget {
  const GridWidgets({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return StaggeredGrid.count(
      crossAxisCount: 4,
      mainAxisSpacing: 3,
      crossAxisSpacing: 4,
      children: [
        StaggeredGridTile.count(
          crossAxisCellCount: 2,
          mainAxisCellCount: 3,
          child: TileCustom(
            onClick: () {
              Navigator.push(
                  context, MaterialPageRoute(builder: (context) => KeysPage()));
            },
            icon: Icons.vpn_key_outlined,
            title: "Keys",
            index: 0,
          ),
        ),
        StaggeredGridTile.count(
          crossAxisCellCount: 2,
          mainAxisCellCount: 1,
          child: TileCustomSmall(
              onClick: () {},
              icon: Icons.calendar_month_rounded,
              title: "Calender",
              index: 1),
        ),
        StaggeredGridTile.count(
          crossAxisCellCount: 2,
          mainAxisCellCount: 2,
          child: TileCustom(
              icon: Icons.assignment_outlined,
              onClick: () {},
              title: "Projects",
              index: 2),
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
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(10),
            topRight: Radius.circular(10),
            bottomLeft: Radius.circular(10),
            bottomRight: Radius.circular(10)),
        color: Colors.primaries[index % Colors.primaries.length],
        // color: backgroundColor,
      ),
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

class TileCustom extends StatelessWidget {
  final void Function()? onClick;
  final IconData icon;
  final int index;
  final String title;
  const TileCustom({
    super.key,
    this.onClick,
    required this.icon,
    required this.title,
    required this.index,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onClick,
      child: Container(
        height: 135,
        width: 135,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: Colors.primaries[index % Colors.primaries.length],
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(
                icon,
                // color: Colors.black,
                size: 40,
              ),
              Text(title, style: TextStyle(fontSize: 25)),
            ],
          ),
        ),
      ),
    );
  }
}

class TileCustomSmall extends StatelessWidget {
  final void Function()? onClick;
  final IconData icon;
  final int index;
  final String title;
  const TileCustomSmall({
    super.key,
    this.onClick,
    required this.icon,
    required this.title,
    required this.index,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onClick,
      child: Container(
        // height: 135,
        // width: 135,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: Colors.primaries[index % Colors.primaries.length],
        ),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(12.0, 16.0, 12.0, 16.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Icon(
                icon,
                // color: Colors.black,
                size: 40,
              ),
              Text(title, style: TextStyle(fontSize: 25)),
            ],
          ),
        ),
      ),
    );
  }
}
