import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
 User? get currentUser => _auth.currentUser;

  Future<UserCredential> login(String email, String password) async {
    final credential = _auth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
    return credential;
  }

  Future<UserCredential> create(String email, String password) async {
    final credential = _auth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );
    return credential;
  }

  Future<void> signOut() async {
    await _auth.signOut();
  }
}
