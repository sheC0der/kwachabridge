import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import '../data/agent_model.dart';
import '../data/swap_model.dart';

class FirebaseService {
  static final FirebaseFirestore _db = FirebaseFirestore.instance;
  static final FirebaseStorage _storage = FirebaseStorage.instance;

  // ── Profile photos ────────────────────────────────────────────────────────

  static Future<String?> uploadProfilePhoto(String publicKey, File photo) async {
    try {
      final ref = _storage.ref().child('profile_photos/$publicKey.jpg');
      await ref.putFile(photo, SettableMetadata(contentType: 'image/jpeg'));
      return await ref.getDownloadURL();
    } catch (_) {
      return null;
    }
  }

  // ── User profiles ─────────────────────────────────────────────────────────

  static Future<void> saveAgentProfile({
    required String publicKey,
    required String displayName,
    required String phoneNumber,
    required String mobileMoneyProvider,
    required String nationalId,
    String? photoUrl,
  }) async {
    await _db.collection('users').doc(publicKey).set({
      'displayName': displayName,
      'phoneNumber': phoneNumber,
      'mobileMoneyProvider': mobileMoneyProvider,
      'nationalId': nationalId,
      'photoUrl': photoUrl,
      'role': 'agent',
      'createdAt': FieldValue.serverTimestamp(),
    });
  }

  static Future<void> saveAgentDiscoveryProfile({
    required String publicKey,
    required String displayName,
    required String phoneNumber,
    required String mobileMoneyProvider,
    int rate = 1700,
  }) async {
    await _db.collection('agents').doc(publicKey).set({
      'displayName': displayName,
      'phoneNumber': phoneNumber,
      'mobileMoneyProvider': mobileMoneyProvider,
      'rate': rate,
      'isAvailable': true,
      'reputationScore': 0.0,
      'completedSwaps': 0,
      'createdAt': FieldValue.serverTimestamp(),
    });
  }

  static Future<void> saveCustomerProfile({
    required String publicKey,
    required String displayName,
    required String phoneNumber,
    required String nationalId,
    String? photoUrl,
  }) async {
    await _db.collection('users').doc(publicKey).set({
      'displayName': displayName,
      'phoneNumber': phoneNumber,
      'nationalId': nationalId,
      'photoUrl': photoUrl,
      'role': 'customer',
      'createdAt': FieldValue.serverTimestamp(),
    });
  }

  // ── Agent discovery ───────────────────────────────────────────────────────

  static Stream<List<AgentModel>> availableAgentsStream() {
    return _db
        .collection('agents')
        .where('isAvailable', isEqualTo: true)
        .orderBy('rate')
        .snapshots()
        .map((s) => s.docs.map(AgentModel.fromFirestore).toList());
  }

  static Stream<DocumentSnapshot> agentDocStream(String publicKey) {
    return _db.collection('agents').doc(publicKey).snapshots();
  }

  static Future<void> updateRate({
    required String publicKey,
    required int rate,
    required bool isAvailable,
  }) async {
    await _db.collection('agents').doc(publicKey).update({
      'rate': rate,
      'isAvailable': isAvailable,
    });
  }

  // ── Swaps ─────────────────────────────────────────────────────────────────

  static Future<String> createSwap({
    required String agentId,
    required String customerId,
    required int mkAmount,
    required int satsAmount,
    required String agentPhone,
    required String customerName,
    required String customerPhone,
  }) async {
    final doc = await _db.collection('swaps').add({
      'agentId': agentId,
      'customerId': customerId,
      'mkAmount': mkAmount,
      'satsAmount': satsAmount,
      'status': 'pending',
      'agentPhone': agentPhone,
      'customerName': customerName,
      'customerPhone': customerPhone,
      'createdAt': FieldValue.serverTimestamp(),
    });
    return doc.id;
  }

  static Stream<List<SwapModel>> pendingSwapsForAgentStream(String agentId) {
    return _db
        .collection('swaps')
        .where('agentId', isEqualTo: agentId)
        .where('status', isEqualTo: 'pending')
        .snapshots()
        .map((s) => s.docs.map(SwapModel.fromFirestore).toList());
  }

  static Stream<DocumentSnapshot> swapDocStream(String swapId) {
    return _db.collection('swaps').doc(swapId).snapshots();
  }

  static Future<SwapModel?> getSwap(String swapId) async {
    final doc = await _db.collection('swaps').doc(swapId).get();
    if (!doc.exists) return null;
    return SwapModel.fromFirestore(doc);
  }

  static Future<void> updateSwapStatus(String swapId, String status) async {
    await _db.collection('swaps').doc(swapId).update({'status': status});
  }

  static Future<void> completeSwap(String swapId, String agentId) async {
    final batch = _db.batch();
    batch.update(_db.collection('swaps').doc(swapId), {
      'status': 'completed',
      'completedAt': FieldValue.serverTimestamp(),
    });
    batch.update(_db.collection('agents').doc(agentId), {
      'completedSwaps': FieldValue.increment(1),
    });
    await batch.commit();
  }
}
