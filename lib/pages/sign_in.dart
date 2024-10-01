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
          setUid: (_) => Navigator.of(context).pushReplacementNamed("/"),
        ),
      ),
    );
  }
}

class Auth extends StatefulWidget {
  final Function(String? uid) setUid;

  const Auth({super.key, required this.setUid});

  @override
  AuthState createState() {
    return AuthState();
  }
}

class AuthState extends State<Auth> {
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final setUid = super.widget.setUid;

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        TextButton(
          onPressed: () => signInWithGoogle().then((cred) {
            setUid(cred.user?.uid);
          }),
          child: const Text("Sign In With Google"),
        ),
        Form(
          key: _formKey,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16.0, 0.0, 16.0, 0.0),
            child: Column(
              children: <Widget>[
                // Add TextFormFields and ElevatedButton here.
                TextFormField(
                  autocorrect: false,
                ),
                TextFormField(
                  autocorrect: false,
                  obscureText: true,
                  enableSuggestions: false,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  child: ElevatedButton(
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Signing In')),
                        );
                      }
                    },
                    child: const Text('Sign In'),
                  ),
                ),
                Text("or"),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  child: ElevatedButton(
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Signing In')),
                        );
                      }
                    },
                    child: const Text('Skip'),
                  ),
                ),
              ],
            ),
          ),
        )
      ],
    );
  }
}
