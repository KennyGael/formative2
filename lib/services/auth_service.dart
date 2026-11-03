import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/app_user.dart';

class AuthService {
  final _auth = FirebaseAuth.instance;
  final _db = FirebaseFirestore.instance;

  Future<AppUser> register(String name, String email, String password) async {
    final cred = await _auth.createUserWithEmailAndPassword(email: email, password: password);
    // Role is always 'student' here. Staff are set manually in the console.
    await _db.collection('users').doc(cred.user!.uid).set({
      'name': name,
      'email': email,
      'role': 'student',
      'createdAt': FieldValue.serverTimestamp(),
    });
    return AppUser(uid: cred.user!.uid, name: name, email: email, role: 'student');
  }

  Future<AppUser> login(String email, String password) async {
    final cred = await _auth.signInWithEmailAndPassword(email: email, password: password);
    return fetchUser(cred.user!.uid);
  }

  Future<AppUser> fetchUser(String uid) async {
    final doc = await _db.collection('users').doc(uid).get();
    return AppUser.fromMap(uid, doc.data() ?? {});
  }

  Future<void> logout() => _auth.signOut();

  User? get currentFirebaseUser => _auth.currentUser;
}
