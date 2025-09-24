import 'package:equatable/equatable.dart';

class TransactionEntity extends Equatable {
  final String? id;
  final String? referenceId;
  final String? idempotencyKey;
  final String? userId;
  final String? walletId;
  final String? amount;
  final String? feeAmount;
  final String? netAmount;
  final String? currencyCode;
  final String? paymentMethod;
  final String? type;
  final String? status;
  final String? failureReason;
  final dynamic metadata;
  final DateTime? createdAt;
  final DateTime? processedAt;

  const TransactionEntity({
    this.id,
    this.referenceId,
    this.idempotencyKey,
    this.userId,
    this.walletId,
    this.amount,
    this.feeAmount,
    this.netAmount,
    this.currencyCode,
    this.paymentMethod,
    this.type,
    this.status,
    this.failureReason,
    this.metadata,
    this.createdAt,
    this.processedAt,
  });

  @override
  List<Object?> get props => [
        id,
        referenceId,
        idempotencyKey,
        userId,
        walletId,
        amount,
        feeAmount,
        netAmount,
        currencyCode,
        paymentMethod,
        type,
        status,
        failureReason,
        metadata,
        createdAt,
        processedAt,
      ];
}
