import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart'
    show FirebaseAuth, GoogleAuthProvider, UserCredential;
import 'package:google_sign_in/google_sign_in.dart'
    show GoogleSignIn, GoogleSignInAccount, GoogleSignInAuthentication;

Future<UserCredential> signInWithGoogle() async {
  // final googleUser = await GoogleSignIn(
  //   signInOption: SignInOption.games,
  // ).signIn();

  // final googleAuth = await googleUser?.authentication;

  // if (googleAuth != null) {
  //   final credential = GoogleAuthProvider.credential(
  //     accessToken: googleAuth.accessToken,
  //     idToken: googleAuth.idToken,
  //   );

  //   return FirebaseAuth.instance.signInWithCredential(credential);
  // } else {
  final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

  final GoogleSignInAuthentication? googleAuth =
      await googleUser?.authentication;

  // if (googleAuth == null) {
  //   throw Exception("Missing Auth");
  // }

  final credential = GoogleAuthProvider.credential(
    accessToken: googleAuth?.accessToken,
    idToken: googleAuth?.idToken,
  );

  return FirebaseAuth.instance.signInWithCredential(credential);
  // }
}

// Define a custom Form widget.
class SignIn extends StatefulWidget {
  final Function(String? uid) setUid;

  const SignIn({super.key, required this.setUid});

  @override
  SignInState createState() {
    return SignInState();
  }
}

// Define a corresponding State class.
// This class holds data related to the form.
class SignInState extends State<SignIn> {
  // Create a global key that uniquely identifies the Form widget
  // and allows validation of the form.
  //
  // Note: This is a `GlobalKey<FormState>`,
  // not a GlobalKey<MyCustomFormState>.
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final setUid = super.widget.setUid;

    // Build a Form widget using the _formKey created above.
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        TextButton(
          onPressed: () => signInWithGoogle().then((cred) {
            print("Signed in");
            setUid(cred.user?.uid);
          }).catchError(print),
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
                      // Validate returns true if the form is valid, or false otherwise.
                      if (_formKey.currentState!.validate()) {
                        // If the form is valid, display a snackbar. In the real world,
                        // you'd often call a server or save the information in a database.
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Signing In')),
                        );
                      }
                    },
                    child: const Text('Sign In'),
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
