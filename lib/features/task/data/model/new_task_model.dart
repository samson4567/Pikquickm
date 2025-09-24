import 'package:pikquick/features/task/domain/entitties/new_task_entity.dart';

class NewTaskModel extends NewTaskEntity {
  const NewTaskModel({
    super.clientName,
    super.clientPhoneNumber,
    super.clientMail,
    super.id,
    super.description,
    super.budget,
    super.taskType,
    super.status,
    super.clientId,
    super.runnerId,
    super.runnerName,
    super.specialInstructions,
    super.additionalNotes,
    super.biddingEnabled,
    super.createdAt,
    super.updatedAt,
    super.paymentMethod,
    super.isBiddingActive,
    super.canAcceptBid,
  });

  factory NewTaskModel.fromJson(Map<String, dynamic> json) {
    return NewTaskModel(
      id: json['id'],
      description: json['description'],
      budget: json['budget'],
      taskType: json['task_type'],
      status: json['status'],
      clientId: json['client_id'],
      clientName: json['client_name'],
      clientMail: json['client_email'],
      clientPhoneNumber: json['client_phone'],
      runnerId: json['runner_id'],
      runnerName: json['runner_name'],
      specialInstructions: json['special_instructions'],
      additionalNotes: json['additional_notes'],
      biddingEnabled: json['bidding_enabled'],
      createdAt: json['created_at'] != null
          ? DateTime.tryParse(json['created_at'])
          : null,
      updatedAt: json['updated_at'] != null
          ? DateTime.tryParse(json['updated_at'])
          : null,
      paymentMethod: json['payment_method'],
      isBiddingActive: json['isBiddingActive'],
      canAcceptBid: json['canAcceptBid'],
    );
  }
}
