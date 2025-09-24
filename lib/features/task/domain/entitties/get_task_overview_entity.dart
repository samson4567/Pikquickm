import 'package:equatable/equatable.dart';

class GetTaskOverviewEntity extends Equatable {
  final String? id;
  final String? description;
  final String? budget;
  final String? taskType;
  final String? runnerName;
  final String? status;
  final String? clientId;
  final String? runnerId;
  final String? specialInstructions;
  final String? additionalNotes;
  final bool? biddingEnabled;
  final String? createdAt;
  final String? updatedAt;
  final String? paymentMethod;
  final bool? isBiddingActive;
  final bool? canAcceptBid;

  const GetTaskOverviewEntity({
    this.runnerName,
    this.id,
    this.description,
    this.budget,
    this.taskType,
    this.status,
    this.clientId,
    this.runnerId,
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
        runnerId,
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
