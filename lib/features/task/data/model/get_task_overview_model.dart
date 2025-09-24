import 'package:pikquick/features/task/domain/entitties/get_task_overview_entity.dart';

class GetTaskOverviewModel extends GetTaskOverviewEntity {
  const GetTaskOverviewModel({
    super.id,
    super.description,
    super.runnerName,
    super.budget,
    super.taskType,
    super.status,
    super.clientId,
    super.runnerId,
    super.specialInstructions,
    super.additionalNotes,
    super.biddingEnabled,
    super.createdAt,
    super.updatedAt,
    super.paymentMethod,
    super.isBiddingActive,
    super.canAcceptBid,
  });

  factory GetTaskOverviewModel.fromJson(Map<String, dynamic> json) {
    return GetTaskOverviewModel(
      runnerName: json['runner_name'] as String,
      id: json['id'] as String?,
      description: json['description'] as String?,
      budget: json['budget'] as String?,
      taskType: json['task_type'] as String?,
      status: json['status'] as String?,
      clientId: json['client_id'] as String?,
      runnerId: json['runner_id'] as String?,
      specialInstructions: json['special_instructions'] as String?,
      additionalNotes: json['additional_notes'] as String?,
      biddingEnabled: json['bidding_enabled'] as bool?,
      createdAt: json['created_at'] as String?,
      updatedAt: json['updated_at'] as String?,
      paymentMethod: json['payment_method'] as String?,
      isBiddingActive: json['isBiddingActive'] as bool?,
      canAcceptBid: json['canAcceptBid'] as bool?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'description': description,
      'budget': budget,
      'task_type': taskType,
      'status': status,
      'client_id': clientId,
      'runner_id': runnerId,
      'special_instructions': specialInstructions,
      'additional_notes': additionalNotes,
      'bidding_enabled': biddingEnabled,
      'created_at': createdAt,
      'updated_at': updatedAt,
      'payment_method': paymentMethod,
      'isBiddingActive': isBiddingActive,
      'canAcceptBid': canAcceptBid,
    };
  }
}
