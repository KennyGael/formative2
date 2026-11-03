import 'package:flutter/foundation.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/app_user.dart';
import '../services/auth_service.dart';

class AuthProvider extends ChangeNotifier {
  final AuthService _service = AuthService();

  AppUser? user;
  bool loading = false;
  String? error;

  bool get isLoggedIn => user != null;
  bool get isStaff => user?.isStaff ?? false;

  // Restores the session when the app restarts
  Future<void> tryRestoreSession() async {
    final fbUser = _service.currentFirebaseUser;
    if (fbUser != null) {
      user = await _service.fetchUser(fbUser.uid);
      notifyListeners();
    }
  }

  Future<bool> login(String email, String password) =>
      _run(() async => user = await _service.login(email, password));

  Future<bool> register(String name, String email, String password) =>
      _run(() async => user = await _service.register(name, email, password));

  Future<void> logout() async {
    await _service.logout();
    user = null;
    notifyListeners();
  }

  Future<bool> _run(Future<void> Function() action) async {
    loading = true;
    error = null;
    notifyListeners();
    try {
      await action();
      return true;
    } on FirebaseAuthException catch (e) {
      error = e.message ?? 'Authentication failed';
      return false;
    } finally {
      loading = false;
      notifyListeners();
    }
  }
}
