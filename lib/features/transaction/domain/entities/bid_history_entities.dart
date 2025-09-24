import 'package:equatable/equatable.dart';

class BidHistoryEntity extends Equatable {
  final bool? success;
  final String? id;
  final String? taskId;
  final String? userId;
  final String? previousBidId;
  final int? roundNumber;
  final String? amount;
  final String? role;
  final String? status;
  final String? message;
  final int? isFinalOffer;
  final String? createdAt;
  final String? updatedAt;
  final String? expiresAt;
  final String? statusType; // from "status" in data
  final bool? canCounter;
  final bool? maxDepthReached;
  final String? timestamp;

  const BidHistoryEntity({
    this.success,
    this.id,
    this.taskId,
    this.userId,
    this.previousBidId,
    this.roundNumber,
    this.amount,
    this.role,
    this.status,
    this.message,
    this.isFinalOffer,
    this.createdAt,
    this.updatedAt,
    this.expiresAt,
    this.statusType,
    this.canCounter,
    this.maxDepthReached,
    this.timestamp,
  });

  @override
  List<Object?> get props => [
        success,
        id,
        taskId,
        userId,
        previousBidId,
        roundNumber,
        amount,
        role,
        status,
        message,
        isFinalOffer,
        createdAt,
        updatedAt,
        expiresAt,
        statusType,
        canCounter,
        maxDepthReached,
        timestamp,
      ];
}
