import 'package:pikquick/features/task/domain/entitties/active_task_entity.dart';

class ActiveTaskPendingModel extends ActiveTaskPendingEntity {
  const ActiveTaskPendingModel({
    super.id,
    super.taskId,
    super.bidId,
    super.runnerId,
    super.status,
    super.assignedAt,
    super.createdAt,
    super.updatedAt,
    super.reason,
    super.taskDescription,
    super.taskBudget,
    super.runnerFullName,
    super.clientId,
    super.clientName,
    super.clientEmail,
    super.runnerName,
    super.pickupAddress,
    super.dropOffAddress,
  });

  factory ActiveTaskPendingModel.fromJson(Map<String, dynamic> json) {
    return ActiveTaskPendingModel(
        id: json["id"] as String?,
        taskId: json["task_id"] as String?,
        bidId: json["bid_id"] as String?,
        runnerId: json["runner_id"] as String?,
        status: json["status"] as String?,
        assignedAt: json["assigned_at"] as String?,
        createdAt: json["created_at"] as String?,
        updatedAt: json["updated_at"] as String?,
        reason: json["reason"] as String?,
        taskDescription: json["task_description"] as String?,
        taskBudget: json["task_budget"] as String?,
        runnerFullName: json["runner_full_name"] as String?,
        clientId: json["client_id"] as String?,
        clientName: json["client_name"] as String?,
        clientEmail: json["client_email"] as String?,
        runnerName: json["runner_name"] as String?,
        pickupAddress: json["pickup_address"] as String?,
        dropOffAddress: json["dropoff_address"] as String?);
  }

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "task_id": taskId,
      "bid_id": bidId,
      "runner_id": runnerId,
      "status": status,
      "assigned_at": assignedAt,
      "created_at": createdAt,
      "updated_at": updatedAt,
      "reason": reason,
      "task_description": taskDescription,
      "task_budget": taskBudget,
      "runner_full_name": runnerFullName,
      "client_id": clientId,
      "client_name": clientName,
      "client_email": clientEmail,
      "runner_name": runnerName,
      "pickup_address": pickupAddress,
      "dropoff_address": dropOffAddress
    };
  }
}
