import 'package:equatable/equatable.dart';

class NewTaskEntity extends Equatable {
  final String? id;
  final String? description;
  final String? budget;
  final String? taskType;
  final String? status;
  final String? clientId;
  final String? clientName;
  final String? clientPhoneNumber;
  final String? clientMail;
  final String? runnerId;
  final String? runnerName;
  final String? specialInstructions;
  final String? additionalNotes;
  final bool? biddingEnabled;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final String? paymentMethod;
  final bool? isBiddingActive;
  final bool? canAcceptBid;

  // Pickup address fields
  final String? pickupAddressId;
  final String? pickupUserId;
  final String? pickupAddressLine1;
  final String? pickupCity;
  final String? pickupState;
  final String? pickupPostalCode;
  final String? pickupCountry;
  final double? pickupLatitude;
  final double? pickupLongitude;
  final bool? pickupIsDefault;
  final DateTime? pickupCreatedAt;
  final DateTime? pickupUpdatedAt;

  // Dropoff address fields
  final String? dropoffAddressId;
  final String? dropoffUserId;
  final String? dropoffAddressLine1;
  final String? dropoffCity;
  final String? dropoffState;
  final String? dropoffPostalCode;
  final String? dropoffCountry;
  final double? dropoffLatitude;
  final double? dropoffLongitude;
  final bool? dropoffIsDefault;
  final DateTime? dropoffCreatedAt;
  final DateTime? dropoffUpdatedAt;

  const NewTaskEntity({
    this.id,
    this.description,
    this.budget,
    this.taskType,
    this.status,
    this.clientId,
    this.clientName,
    this.clientPhoneNumber,
    this.clientMail,
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
    this.pickupAddressId,
    this.pickupUserId,
    this.pickupAddressLine1,
    this.pickupCity,
    this.pickupState,
    this.pickupPostalCode,
    this.pickupCountry,
    this.pickupLatitude,
    this.pickupLongitude,
    this.pickupIsDefault,
    this.pickupCreatedAt,
    this.pickupUpdatedAt,
    this.dropoffAddressId,
    this.dropoffUserId,
    this.dropoffAddressLine1,
    this.dropoffCity,
    this.dropoffState,
    this.dropoffPostalCode,
    this.dropoffCountry,
    this.dropoffLatitude,
    this.dropoffLongitude,
    this.dropoffIsDefault,
    this.dropoffCreatedAt,
    this.dropoffUpdatedAt,
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
        clientPhoneNumber,
        clientMail,
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
        pickupAddressId,
        pickupUserId,
        pickupAddressLine1,
        pickupCity,
        pickupState,
        pickupPostalCode,
        pickupCountry,
        pickupLatitude,
        pickupLongitude,
        pickupIsDefault,
        pickupCreatedAt,
        pickupUpdatedAt,
        dropoffAddressId,
        dropoffUserId,
        dropoffAddressLine1,
        dropoffCity,
        dropoffState,
        dropoffPostalCode,
        dropoffCountry,
        dropoffLatitude,
        dropoffLongitude,
        dropoffIsDefault,
        dropoffCreatedAt,
        dropoffUpdatedAt,
      ];
}
