import 'package:equatable/equatable.dart';

class ActiveTaskPendingEntity extends Equatable {
  final String? id;
  final String? taskId;
  final String? bidId;
  final String? runnerId;
  final String? status;
  final String? assignedAt;
  final String? createdAt;
  final String? updatedAt;
  final String? reason;
  final String? taskDescription;
  final String? taskBudget;
  final String? runnerFullName;
  final String? clientId;
  final String? clientName;
  final String? clientEmail;
  final String? runnerName;
  final String? pickupAddress;
  final String? dropOffAddress;

  const ActiveTaskPendingEntity({
    this.id,
    this.taskId,
    this.bidId,
    this.runnerId,
    this.status,
    this.assignedAt,
    this.createdAt,
    this.updatedAt,
    this.reason,
    this.taskDescription,
    this.taskBudget,
    this.runnerFullName,
    this.clientId,
    this.clientName,
    this.clientEmail,
    this.runnerName,
    this.pickupAddress,
    this.dropOffAddress,
  });

  @override
  List<Object?> get props => [
        id,
        taskId,
        bidId,
        runnerId,
        status,
        assignedAt,
        createdAt,
        updatedAt,
        reason,
        taskDescription,
        taskBudget,
        runnerFullName,
        clientId,
        clientName,
        clientEmail,
        runnerName,
        pickupAddress,
        dropOffAddress,
      ];
}
