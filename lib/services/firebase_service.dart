import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/user_model.dart';

// ══════════════════════════════════════════════════════════════
// FIREBASE AUTH SERVICE
// ══════════════════════════════════════════════════════════════
class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Stream<User?> get userStream => _auth.authStateChanges();

  User? get currentUser => _auth.currentUser;

  Future<UserCredential?> signInWithEmail(String email, String password) async {
    try {
      return await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
    } on FirebaseAuthException catch (e) {
      throw _handleAuthError(e);
    }
  }

  Future<UserCredential?> signUpWithEmail(
    String email,
    String password,
    String name,
  ) async {
    try {
      final cred = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      await cred.user?.updateDisplayName(name);
      return cred;
    } on FirebaseAuthException catch (e) {
      throw _handleAuthError(e);
    }
  }

  Future<void> signOut() async {
    await _auth.signOut();
  }

  String _handleAuthError(FirebaseAuthException e) {
    switch (e.code) {
      case 'user-not-found': return 'No user found with this email.';
      case 'wrong-password': return 'Incorrect password.';
      case 'email-already-in-use': return 'Email already registered.';
      case 'weak-password': return 'Password is too weak.';
      case 'invalid-email': return 'Invalid email address.';
      default: return 'Authentication failed. Please try again.';
    }
  }
}

// ══════════════════════════════════════════════════════════════
// FIRESTORE SERVICE
// ══════════════════════════════════════════════════════════════
class FirestoreService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  // ── Users ──────────────────────────────────────────────────
  Future<void> createUser(UserModel user) async {
    await _db.collection('users').doc(user.id).set(user.toMap());
  }

  Future<UserModel?> getUser(String userId) async {
    final doc = await _db.collection('users').doc(userId).get();
    if (doc.exists) {
      return UserModel.fromMap({...doc.data()!, 'id': doc.id});
    }
    return null;
  }

  Future<void> updateUser(String userId, Map<String, dynamic> data) async {
    await _db.collection('users').doc(userId).update(data);
  }

  // ── Discover ───────────────────────────────────────────────
  Stream<List<UserModel>> getDiscoverProfiles(String currentUserId) {
    return _db
        .collection('users')
        .where('id', isNotEqualTo: currentUserId)
        .limit(20)
        .snapshots()
        .map((snap) => snap.docs
            .map((d) => UserModel.fromMap({...d.data(), 'id': d.id}))
            .toList());
  }

  // ── Likes & Matches ─────────────────────────────────────────
  Future<bool> likeUser(String fromId, String toId) async {
    await _db.collection('likes').add({
      'from': fromId,
      'to': toId,
      'timestamp': FieldValue.serverTimestamp(),
    });

    // Check mutual like → create match
    final mutual = await _db
        .collection('likes')
        .where('from', isEqualTo: toId)
        .where('to', isEqualTo: fromId)
        .get();

    if (mutual.docs.isNotEmpty) {
      final matchId = [fromId, toId]..sort();
      await _db.collection('matches').doc(matchId.join('_')).set({
        'users': [fromId, toId],
        'timestamp': FieldValue.serverTimestamp(),
        'active': true,
      });
      return true; // It's a match!
    }
    return false;
  }

  Future<void> passUser(String fromId, String toId) async {
    await _db.collection('passes').add({
      'from': fromId,
      'to': toId,
      'timestamp': FieldValue.serverTimestamp(),
    });
  }

  Stream<List<String>> getMatches(String userId) {
    return _db
        .collection('matches')
        .where('users', arrayContains: userId)
        .snapshots()
        .map((snap) => snap.docs
            .map((d) {
              final users = List<String>.from(d['users']);
              return users.firstWhere((id) => id != userId);
            })
            .toList());
  }

  // ── Messages ───────────────────────────────────────────────
  String _chatId(String a, String b) {
    final ids = [a, b]..sort();
    return ids.join('_');
  }

  Stream<List<Map<String, dynamic>>> getMessages(String userId, String otherId) {
    return _db
        .collection('chats')
        .doc(_chatId(userId, otherId))
        .collection('messages')
        .orderBy('timestamp', descending: false)
        .snapshots()
        .map((snap) => snap.docs.map((d) => d.data()).toList());
  }

  Future<void> sendMessage(
    String senderId,
    String receiverId,
    String text,
  ) async {
    final chatId = _chatId(senderId, receiverId);
    await _db
        .collection('chats')
        .doc(chatId)
        .collection('messages')
        .add({
          'senderId': senderId,
          'receiverId': receiverId,
          'text': text,
          'timestamp': FieldValue.serverTimestamp(),
          'isRead': false,
        });

    // Update chat preview
    await _db.collection('chats').doc(chatId).set({
      'participants': [senderId, receiverId],
      'lastMessage': text,
      'lastTimestamp': FieldValue.serverTimestamp(),
      'unread_$receiverId': FieldValue.increment(1),
    }, SetOptions(merge: true));
  }

  Future<void> markMessagesRead(String userId, String otherId) async {
    final chatId = _chatId(userId, otherId);
    await _db.collection('chats').doc(chatId).update({
      'unread_$userId': 0,
    });
  }

  // ── Presence ───────────────────────────────────────────────
  Future<void> setOnlineStatus(String userId, bool isOnline) async {
    await _db.collection('users').doc(userId).update({
      'isOnline': isOnline,
      'lastSeen': FieldValue.serverTimestamp(),
    });
  }
}
