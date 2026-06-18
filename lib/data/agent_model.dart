import 'package:cloud_firestore/cloud_firestore.dart';

class AgentModel {
  final String publicKey;
  final String displayName;
  final String phoneNumber;
  final String mobileMoneyProvider;
  final int rate;
  final bool isAvailable;
  final double reputationScore;
  final int completedSwaps;

  const AgentModel({
    required this.publicKey,
    required this.displayName,
    required this.phoneNumber,
    required this.mobileMoneyProvider,
    required this.rate,
    required this.isAvailable,
    required this.reputationScore,
    required this.completedSwaps,
  });

  factory AgentModel.fromFirestore(DocumentSnapshot doc) {
    final d = doc.data() as Map<String, dynamic>? ?? {};
    return AgentModel(
      publicKey: doc.id,
      displayName: d['displayName'] as String? ?? '',
      phoneNumber: d['phoneNumber'] as String? ?? '',
      mobileMoneyProvider: d['mobileMoneyProvider'] as String? ?? '',
      rate: (d['rate'] as num?)?.toInt() ?? 1700,
      isAvailable: d['isAvailable'] as bool? ?? false,
      reputationScore: (d['reputationScore'] as num?)?.toDouble() ?? 0.0,
      completedSwaps: (d['completedSwaps'] as num?)?.toInt() ?? 0,
    );
  }

  factory AgentModel.fromMock(Map<String, dynamic> map) {
    return AgentModel(
      publicKey: '',
      displayName: map['name'] as String? ?? '',
      phoneNumber: '',
      mobileMoneyProvider: map['provider'] as String? ?? '',
      rate: (map['rate'] as num?)?.toInt() ?? 1700,
      isAvailable: map['available'] as bool? ?? true,
      reputationScore: (map['stars'] as num?)?.toDouble() ?? 4.8,
      completedSwaps: (map['swaps'] as num?)?.toInt() ?? 0,
    );
  }
}
