import 'package:equatable/equatable.dart';

class TaskEntity extends Equatable {
  String? runnerId;
  String? id;
  String? name;
  String? clientId;
  String? taskType;
  AddressEntity? pickupAddress;
  AddressEntity? dropoffAddress;
  String? description;
  int? budget;
  String? paymentMethod;
  String? specialInstructions;
  String? additionalNotes;
  String? categoryId;
  TaskEntity({
    this.name,
    this.runnerId,
    this.clientId,
    this.taskType,
    this.pickupAddress,
    this.dropoffAddress,
    this.description,
    this.budget,
    this.paymentMethod,
    this.specialInstructions,
    this.additionalNotes,
    this.categoryId,
    this.id,
  });

  @override
  List<Object?> get props => throw UnimplementedError();
}

class AddressEntity extends Equatable {
  final String? addressLine1;
  final String? addressLine2;
  final String? city;
  final String? state;
  final String? postalCode;
  final String country;
  final String? countryCode;
  final double? latitude;
  final double? longitude;
  final bool? isDefault;
  final String? label;

  const AddressEntity({
    required this.addressLine1,
    this.addressLine2,
    required this.city,
    required this.state,
    required this.postalCode,
    required this.country,
    this.countryCode,
    required this.latitude,
    required this.longitude,
    required this.isDefault,
    this.label,
  });

  @override
  List<Object?> get props => [
        addressLine1,
        addressLine2,
        city,
        state,
        postalCode,
        country,
        countryCode,
        latitude,
        longitude,
        isDefault,
        label,
      ];
}
