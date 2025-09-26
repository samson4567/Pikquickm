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
  double? budget;
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
  List<Object?> get props => [
        name,
        runnerId,
        clientId,
        taskType,
        pickupAddress,
        dropoffAddress,
        description,
        budget,
        paymentMethod,
        specialInstructions,
        additionalNotes,
        categoryId,
        id,
      ];
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

Map f = {
  "runner_id": null,
  "client_id": "933b013b-234e-4f8b-a15b-bd210d823f8b",
  "task_type": "Helping hand",
  "pickup_address": {
    "addressLine1": "Ife",
    "addressLine2": null,
    "city": "Ife",
    "state": "Osun",
    "postalCode": "     ",
    "country": "Nigeria",
    "countryCode": "Nigeria",
    "latitude": 7.490462,
    "longitude": 4.5521274,
    "isDefault": false,
    "description": null
  },
  "dropoff_address": {
    "addressLine1": "     ",
    "city": "     ",
    "state": "     ",
    "postalCode": 000000,
    "country": "     ",
    "latitude": 6.5245,
    "longitude": 3.3793,
    "isDefault": false
  },
  "description": "Hire someone to help in moving heavy weight item.",
  "budget": 21000,
  "payment_method": "wallet",
  "special_instructions": null,
  "additional_notes": null,
  "category_id": "455a8eed-729e-11f0-8703-00163cbf7aa3",
  "name": "Helping hand",
  "bidding_end_time": "2025-09-27T10:43:37.508163"
};
// {
//   "runner_id": null,
//   "client_id": null,
//   "task_type": "Helping hand",
//   "pickup_address": {
//     "addressLine1": "Ife",
//     "addressLine2": null,
//     "city": "Ife",
//     "state": "Osun",
//     "postalCode": "",
//     "country": "Nigeria",
//     "countryCode": "Nigeria",
//     "latitude": 7.490462,
//     "longitude": 4.5521274,
//     "isDefault": false,
//     "description": null
//   },
//   "dropoff_address": null,
//   "description": "Hire someone to help in moving heavy weight item.",
//   "budget": 20000,
//   "payment_method": "wallet",
//   "special_instructions": null,
//   "additional_notes": null,
//   "category_id": "455a8eed-729e-11f0-8703-00163cbf7aa3",
//   "name": "Helping hand",
//   "id": null
// };
