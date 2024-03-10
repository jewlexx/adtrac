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
