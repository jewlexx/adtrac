import 'package:flutter/material.dart';

const String title = 'Addiction Tracker';

class NavigationBottomBar extends StatefulWidget {
  const NavigationBottomBar({super.key, required this.selectedPage});

  final int selectedPage;

  @override
  State<NavigationBottomBar> createState() => _NavigationBottomBarState();
}

class _NavigationBottomBarState extends State<NavigationBottomBar> {
  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      currentIndex: super.widget.selectedPage,
      type: BottomNavigationBarType.fixed,
      items: const [
        BottomNavigationBarItem(
          icon: Icon(Icons.numbers),
          label: "Today's Count",
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.calendar_today),
          label: 'Past Counts',
        ),
      ],
      onTap: (value) => setState(
        () {
          if (value != super.widget.selectedPage) {
            String name;

            switch (value) {
              case 1:
                name = "/historical";
                break;
              // Generally will trigger when value is 0,
              // But in bug cases we don't necessarily want to exit
              default:
                name = "/";
                break;
            }

            Navigator.of(context).pushNamed(name);
            // MaterialPageRoute(
            //   builder: (context) {},
            // ),
          }
        },
      ),
    );
  }
}
