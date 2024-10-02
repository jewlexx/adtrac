import 'package:firebase_auth/firebase_auth.dart';

class UserInfo {
  String _uid;
  String? _photoURL;
  String? _displayName;
  String? _email;
  bool _emailVerified;

  get uid => _uid;

  get photoURL => _photoURL;

  get displayName => _displayName;

  get email => _email;

  get emailVerified => _emailVerified;

  UserInfo({
    required uid,
    photoURL,
    displayName,
    email,
    emailVerified = false,
  })  : _uid = uid,
        _emailVerified = emailVerified,
        _photoURL = photoURL,
        _displayName = displayName,
        _email = email;

  factory UserInfo.fromFirebase(User user) {
    return UserInfo(
      uid: user.uid,
      photoURL: user.photoURL,
      displayName: user.displayName,
      email: user.email,
      emailVerified: user.emailVerified,
    );
  }

  factory UserInfo.defaultUser() {
    return UserInfo(
      uid: "default",
      photoURL: "https://api.dicebear.com/8.x/pixel-art/svg?seed=default",
      displayName: "Default User",
      email: "default@example.com",
      emailVerified: true,
    );
  }

  factory UserInfo.fromFirebaseOrDefault() {
    final user = FirebaseAuth.instance.currentUser;

    if (user == null) {
      return UserInfo.defaultUser();
    } else {
      return UserInfo.fromFirebase(user);
    }
  }

  void updateFromFirebase(User user) {
    _uid = user.uid;
    _photoURL = user.photoURL;
    _displayName = user.displayName;
    _email = user.email;
    _emailVerified = user.emailVerified;
  }

  bool isFirebase() {
    return FirebaseAuth.instance.currentUser != null;
  }

  User? toFirebase() {
    return FirebaseAuth.instance.currentUser;
  }
}
