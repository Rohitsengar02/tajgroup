import 'package:firebase_auth/firebase_auth.dart';
import 'mongo_service.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  /// Sign in with email and password (Firebase)
  Future<UserCredential> signIn(String email, String password) async {
    try {
      final credential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return credential;
    } catch (e) {
      rethrow;
    }
  }

  /// Sign out
  Future<void> signOut() async {
    await _auth.signOut();
  }

  /// Get current user role from MongoDB
  Future<String?> getUserRole(String firebaseUid) async {
    try {
      final collection = MongoService.db.collection('users');
      final user = await collection.findOne({'uid': firebaseUid});
      return user?['role'] as String?;
    } catch (e) {
      print("Error fetching role from MongoDB: $e");
      return null;
    }
  }

  /// Seed Admin User in MongoDB
  Future<void> seedAdminUserInMongo(String firebaseUid, String email) async {
    final collection = MongoService.db.collection('users');
    await collection.update(
      {'uid': firebaseUid},
      {
        'uid': firebaseUid,
        'email': email,
        'full_name': 'System Administrator',
        'role': 'Admin',
        'created_at': DateTime.now().toIso8601String(),
      },
      upsert: true,
    );
  }

  /// Check if user is logged in
  User? get currentUser => _auth.currentUser;
  Stream<User?> get authStateChanges => _auth.authStateChanges();
}
