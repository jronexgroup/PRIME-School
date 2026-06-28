import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../data/models/user_model.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  User? get currentUser => _auth.currentUser;
  Stream<User?> get authStateChanges => _auth.authStateChanges();

  Future<UserModel> registerWithEmail(String email, String password, String name) async {
    final userCredential = await _auth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );
    final user = userCredential.user!;

    await user.updateDisplayName(name);

    final newUser = UserModel(
      uid: user.uid,
      name: name,
      email: email,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );
    await _firestore.collection('users').doc(user.uid).set(newUser.toMap());
    return newUser;
  }

  Future<UserModel> signInWithEmail(String email, String password) async {
    final userCredential = await _auth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
    final user = userCredential.user!;

    final doc = await _firestore.collection('users').doc(user.uid).get();
    if (!doc.exists) {
      final existingUser = UserModel(
        uid: user.uid,
        name: user.displayName ?? 'Supreme Prime',
        email: email,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );
      await _firestore.collection('users').doc(user.uid).set(existingUser.toMap());
      return existingUser;
    }
    return UserModel.fromMap(doc.data()!);
  }

  Future<UserModel?> getCurrentUser() async {
    final user = _auth.currentUser;
    if (user == null) return null;

    final doc = await _firestore.collection('users').doc(user.uid).get();
    if (!doc.exists) return null;
    return UserModel.fromMap(doc.data()!);
  }

  Future<void> signOut() async {
    await _auth.signOut();
  }
}
