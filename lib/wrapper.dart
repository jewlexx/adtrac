import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'common.dart';

class PageWrapper extends StatelessWidget {
  final Widget child;

  const PageWrapper({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: child,
      bottomNavigationBar: NavigationBottomBar(
        selectedPage: GoRouterState.of(context).matchedLocation,
      ),
    );
  }
}
