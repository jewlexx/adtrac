import 'package:flutter/material.dart';

import '../auth.dart';

class SignInPage extends StatefulWidget {
  const SignInPage({super.key});

  @override
  State<SignInPage> createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Auth(
          setUid: (_) => Navigator.of(context).pushNamed("/"),
        ),
      ),
      // bottomNavigationBar: const NavigationBottomBar(selectedPage: 0),
    );
  }
}
