import 'package:pikquick/features/transaction/domain/entities/bid_history_entities.dart';

class BidHistoryModel extends BidHistoryEntity {
  const BidHistoryModel({
    super.success,
    super.id,
    super.taskId,
    super.userId,
    super.previousBidId,
    super.roundNumber,
    super.amount,
    super.role,
    super.status,
    super.message,
    super.isFinalOffer,
    super.createdAt,
    super.updatedAt,
    super.expiresAt,
    super.statusType,
    super.canCounter,
    super.maxDepthReached,
    super.timestamp,
  });

  factory BidHistoryModel.fromJson(Map<String, dynamic> json) {
    final data = json['data'] as Map<String, dynamic>? ?? {};
    final currentBid = data['currentBid'] as Map<String, dynamic>? ?? {};

    return BidHistoryModel(
      success: json['success'] as bool?,
      id: currentBid['id'] as String?,
      taskId: currentBid['task_id'] as String?,
      userId: currentBid['user_id'] as String?,
      previousBidId: currentBid['previous_bid_id'] as String?,
      roundNumber: currentBid['round_number'] as int?,
      amount: currentBid['amount'] as String?,
      role: currentBid['role'] as String?,
      status: currentBid['status'] as String?,
      message: currentBid['message'] as String?,
      isFinalOffer: currentBid['is_final_offer'] as int?,
      createdAt: currentBid['created_at'] as String?,
      updatedAt: currentBid['updated_at'] as String?,
      expiresAt: currentBid['expires_at'] as String?,
      statusType: data['status'] as String?,
      canCounter: data['canCounter'] as bool?,
      maxDepthReached: data['maxDepthReached'] as bool?,
      timestamp: json['timestamp'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "success": success,
      "data": {
        "currentBid": {
          "id": id,
          "task_id": taskId,
          "user_id": userId,
          "previous_bid_id": previousBidId,
          "round_number": roundNumber,
          "amount": amount,
          "role": role,
          "status": status,
          "message": message,
          "is_final_offer": isFinalOffer,
          "created_at": createdAt,
          "updated_at": updatedAt,
          "expires_at": expiresAt,
        },
        "status": statusType,
        "canCounter": canCounter,
        "maxDepthReached": maxDepthReached,
      },
      "timestamp": timestamp,
    };
  }
}
