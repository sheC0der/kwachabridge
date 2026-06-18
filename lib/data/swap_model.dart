import 'package:cloud_firestore/cloud_firestore.dart';

class SwapModel {
  final String swapId;
  final String agentId;
  final String customerId;
  final int mkAmount;
  final int satsAmount;
  final String status;
  final String agentPhone;
  final String customerName;
  final String customerPhone;
  final DateTime? createdAt;

  const SwapModel({
    required this.swapId,
    required this.agentId,
    required this.customerId,
    required this.mkAmount,
    required this.satsAmount,
    required this.status,
    required this.agentPhone,
    required this.customerName,
    required this.customerPhone,
    this.createdAt,
  });

  factory SwapModel.fromFirestore(DocumentSnapshot doc) {
    final d = doc.data() as Map<String, dynamic>? ?? {};
    return SwapModel(
      swapId: doc.id,
      agentId: d['agentId'] as String? ?? '',
      customerId: d['customerId'] as String? ?? '',
      mkAmount: (d['mkAmount'] as num?)?.toInt() ?? 0,
      satsAmount: (d['satsAmount'] as num?)?.toInt() ?? 0,
      status: d['status'] as String? ?? 'pending',
      agentPhone: d['agentPhone'] as String? ?? '',
      customerName: d['customerName'] as String? ?? '',
      customerPhone: d['customerPhone'] as String? ?? '',
      createdAt: (d['createdAt'] as Timestamp?)?.toDate(),
    );
  }
}
