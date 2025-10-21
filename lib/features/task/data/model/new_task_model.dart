import 'package:equatable/equatable.dart';
import 'package:pikquick/features/task/domain/entitties/new_task_entity.dart';

class NewTaskModel extends NewTaskEntity {
  const NewTaskModel({
    super.id,
    super.description,
    super.budget,
    super.taskType,
    super.status,
    super.clientId,
    super.clientName,
    super.clientPhoneNumber,
    super.clientMail,
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
    super.pickupAddressId,
    super.pickupUserId,
    super.pickupAddressLine1,
    super.pickupCity,
    super.pickupState,
    super.pickupPostalCode,
    super.pickupCountry,
    super.pickupLatitude,
    super.pickupLongitude,
    super.pickupIsDefault,
    super.pickupCreatedAt,
    super.pickupUpdatedAt,
    super.dropoffAddressId,
    super.dropoffUserId,
    super.dropoffAddressLine1,
    super.dropoffCity,
    super.dropoffState,
    super.dropoffPostalCode,
    super.dropoffCountry,
    super.dropoffLatitude,
    super.dropoffLongitude,
    super.dropoffIsDefault,
    super.dropoffCreatedAt,
    super.dropoffUpdatedAt,
  });

  factory NewTaskModel.fromJson(Map<String, dynamic> json) {
    final pickup = json['pickup_address'] ?? {};
    final dropoff = json['dropoff_address'] ?? {};

    return NewTaskModel(
      id: json['id'],
      description: json['description'],
      budget: json['budget'],
      taskType: json['task_type'],
      status: json['status'],
      clientId: json['client_id'],
      clientName: json['client_name'],
      clientPhoneNumber: json['client_phone'],
      clientMail: json['client_email'],
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

      // Pickup address fields
      pickupAddressId: pickup['id'],
      pickupUserId: pickup['userId'],
      pickupAddressLine1: pickup['addressLine1'],
      pickupCity: pickup['city'],
      pickupState: pickup['state'],
      pickupPostalCode: pickup['postalCode'],
      pickupCountry: pickup['country'],
      pickupLatitude: (pickup['latitude'] ?? 0).toDouble(),
      pickupLongitude: (pickup['longitude'] ?? 0).toDouble(),
      pickupIsDefault: pickup['isDefault'] ?? false,
      pickupCreatedAt: pickup['createdAt'] != null
          ? DateTime.tryParse(pickup['createdAt'])
          : null,
      pickupUpdatedAt: pickup['updatedAt'] != null
          ? DateTime.tryParse(pickup['updatedAt'])
          : null,

      // Dropoff address fields
      dropoffAddressId: dropoff['id'],
      dropoffUserId: dropoff['userId'],
      dropoffAddressLine1: dropoff['addressLine1'],
      dropoffCity: dropoff['city'],
      dropoffState: dropoff['state'],
      dropoffPostalCode: dropoff['postalCode'],
      dropoffCountry: dropoff['country'],
      dropoffLatitude: (dropoff['latitude'] ?? 0).toDouble(),
      dropoffLongitude: (dropoff['longitude'] ?? 0).toDouble(),
      dropoffIsDefault: dropoff['isDefault'] ?? false,
      dropoffCreatedAt: dropoff['createdAt'] != null
          ? DateTime.tryParse(dropoff['createdAt'])
          : null,
      dropoffUpdatedAt: dropoff['updatedAt'] != null
          ? DateTime.tryParse(dropoff['updatedAt'])
          : null,
    );
  }
}
