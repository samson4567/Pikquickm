import 'package:equatable/equatable.dart';

class RunnerTaskOverviewEntity extends Equatable {
  final String? id;
  final String? description;
  final String? budget;
  final String? taskType;
  final String? status;
  final String? clientId;
  final String? clientName;
  final String? clientPhone;
  final String? clientEmail;
  final String? runnerId;
  final String? runnerName;
  final String? specialInstructions;
  final String? additionalNotes;
  final bool? biddingEnabled;
  final String? createdAt;
  final String? updatedAt;
  final String? paymentMethod;
  final bool? isBiddingActive;
  final bool? canAcceptBid;

  const RunnerTaskOverviewEntity({
    this.id,
    this.description,
    this.budget,
    this.taskType,
    this.status,
    this.clientId,
    this.clientName,
    this.clientPhone,
    this.clientEmail,
    this.runnerId,
    this.runnerName,
    this.specialInstructions,
    this.additionalNotes,
    this.biddingEnabled,
    this.createdAt,
    this.updatedAt,
    this.paymentMethod,
    this.isBiddingActive,
    this.canAcceptBid,
  });

  @override
  List<Object?> get props => [
        id,
        description,
        budget,
        taskType,
        status,
        clientId,
        clientName,
        clientPhone,
        clientEmail,
        runnerId,
        runnerName,
        specialInstructions,
        additionalNotes,
        biddingEnabled,
        createdAt,
        updatedAt,
        paymentMethod,
        isBiddingActive,
        canAcceptBid,
      ];
}
