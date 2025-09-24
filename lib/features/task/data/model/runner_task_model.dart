import 'package:pikquick/features/task/domain/entitties/runner_task_entity.dart';

class RunnerTaskOverviewgModel extends RunnerTaskOverviewEntity {
  const RunnerTaskOverviewgModel({
    super.id,
    super.description,
    super.budget,
    super.taskType,
    super.status,
    super.clientId,
    super.clientName,
    super.clientPhone,
    super.clientEmail,
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

  factory RunnerTaskOverviewgModel.fromJson(Map<String, dynamic> json) {
    return RunnerTaskOverviewgModel(
      id: json['id'],
      description: json['description'],
      budget: json['budget'],
      taskType: json['task_type'],
      status: json['status'],
      clientId: json['client_id'],
      clientName: json['client_name'],
      clientPhone: json['client_phone'],
      clientEmail: json['client_email'],
      runnerId: json['runner_id'],
      runnerName: json['runner_name'],
      specialInstructions: json['special_instructions'],
      additionalNotes: json['additional_notes'],
      biddingEnabled: json['bidding_enabled'],
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
      paymentMethod: json['payment_method'],
      isBiddingActive: json['isBiddingActive'],
      canAcceptBid: json['canAcceptBid'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "description": description,
      "budget": budget,
      "task_type": taskType,
      "status": status,
      "client_id": clientId,
      "client_name": clientName,
      "client_phone": clientPhone,
      "client_email": clientEmail,
      "runner_id": runnerId,
      "runner_name": runnerName,
      "special_instructions": specialInstructions,
      "additional_notes": additionalNotes,
      "bidding_enabled": biddingEnabled,
      "created_at": createdAt,
      "updated_at": updatedAt,
      "payment_method": paymentMethod,
      "isBiddingActive": isBiddingActive,
      "canAcceptBid": canAcceptBid,
    };
  }
}
