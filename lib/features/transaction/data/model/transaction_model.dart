import 'package:pikquick/features/transaction/domain/entities/transaction_entity.dart';

class TransactionModel extends TransactionEntity {
  const TransactionModel({
    super.id,
    super.referenceId,
    super.idempotencyKey,
    super.userId,
    super.walletId,
    super.amount,
    super.feeAmount,
    super.netAmount,
    super.currencyCode,
    super.paymentMethod,
    super.type,
    super.status,
    super.failureReason,
    super.metadata,
    super.createdAt,
    super.processedAt,
  });

  factory TransactionModel.fromJson(Map<String, dynamic> json) {
    return TransactionModel(
      id: json['id'],
      referenceId: json['reference_id'],
      idempotencyKey: json['idempotency_key'],
      userId: json['user_id'],
      walletId: json['wallet_id'],
      amount: json['amount']?.toString(),
      feeAmount: json['fee_amount']?.toString(),
      netAmount: json['net_amount']?.toString(),
      currencyCode: json['currency_code'],
      paymentMethod: json['payment_method'],
      type: json['type'],
      status: json['status'],
      failureReason: json['failure_reason'],
      metadata: json['metadata']?.toString(), // force to string or null
      createdAt: json['created_at'] != null
          ? DateTime.tryParse(json['created_at'])
          : null,
      processedAt: json['processed_at'] != null
          ? DateTime.tryParse(json['processed_at'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'reference_id': referenceId,
      'idempotency_key': idempotencyKey,
      'user_id': userId,
      'wallet_id': walletId,
      'amount': amount,
      'fee_amount': feeAmount,
      'net_amount': netAmount,
      'currency_code': currencyCode,
      'payment_method': paymentMethod,
      'type': type,
      'status': status,
      'failure_reason': failureReason,
      'metadata': metadata,
      'created_at': createdAt?.toIso8601String(),
      'processed_at': processedAt?.toIso8601String(),
    };
  }
}
