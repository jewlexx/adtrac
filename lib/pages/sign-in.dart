import 'package:flutter/material.dart';

import '../auth.dart';

class SignIn extends StatefulWidget {
  const SignIn({Key? key}) : super(key: key);

  @override
  _SignInState createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
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
