import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:todo/services/auth_service.dart';

class AuthViewModel extends ChangeNotifier {
  final AuthService _authService = AuthService();

 User? get user => _authService.currentUser;
  bool get isLogged  => user!=null ;
  String? get userId => user!.uid;

  Future<String?> login(String email, String password) async {
    try {
      await _authService.login(email, password);
      notifyListeners();
      return null;
    } on FirebaseAuthException catch (e) {
      return e.message!;
    }
  }

  Future<String?> create(String email,String password) async{
     try {
      await _authService.create(email, password);
      notifyListeners();
      return null;
    } on FirebaseAuthException catch (e) {
      return e.message;
    }
  }

  Future<void> logout() async {
    await _authService.signOut();
    notifyListeners();
  }
}
