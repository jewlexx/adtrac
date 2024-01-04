import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

const String title = 'Addiction Tracker';

int pageToInt(String page) {
  switch (page) {
    case "/historical":
      return 1;
    default:
      return 0;
  }
}

String intToPage(int page) {
  switch (page) {
    case 1:
      return "/historical";
    default:
      return "/";
  }
}

class NavigationBottomBar extends StatefulWidget {
  const NavigationBottomBar({super.key, required this.selectedPage});

  final String selectedPage;

  @override
  State<NavigationBottomBar> createState() => _NavigationBottomBarState();
}

class _NavigationBottomBarState extends State<NavigationBottomBar> {
  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      currentIndex: pageToInt(super.widget.selectedPage),
      type: BottomNavigationBarType.fixed,
      items: const [
        BottomNavigationBarItem(
          icon: Icon(Icons.numbers),
          label: "Today's Count",
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.calendar_today),
          label: "Past Counts",
        ),
      ],
      onTap: (value) => setState(
        () {
          if (value != pageToInt(super.widget.selectedPage)) {
            context.go(intToPage(value));
          }
        },
      ),
    );
  }
}
