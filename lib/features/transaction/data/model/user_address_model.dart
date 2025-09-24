import 'package:pikquick/features/transaction/domain/entities/user_address_enties.dart';

class PickupDropoffModel extends PickupDropoffEntity {
  const PickupDropoffModel({
    required super.pickupId,
    required super.pickupTaskId,
    required super.pickupAddressId,
    required super.pickupLocationType,
    required super.pickupOrder,
    super.pickupArrivalTime,
    required super.pickupAddressLine1,
    required super.pickupCity,
    required super.pickupState,
    required super.pickupPostalCode,
    required super.pickupCountry,
    required super.pickupLabel,
    required super.pickupLatitude,
    required super.pickupLongitude,
    required super.pickupIsDefault,
    required super.dropoffId,
    required super.dropoffTaskId,
    required super.dropoffAddressId,
    required super.dropoffLocationType,
    required super.dropoffOrder,
    super.dropoffArrivalTime,
    required super.dropoffAddressLine1,
    required super.dropoffCity,
    required super.dropoffState,
    required super.dropoffPostalCode,
    required super.dropoffCountry,
    required super.dropoffLabel,
    required super.dropoffLatitude,
    required super.dropoffLongitude,
    required super.dropoffIsDefault,
  });

  factory PickupDropoffModel.fromJson(Map<String, dynamic> json) {
    final pickup = json['pickup'] ?? {};
    final pickupAddress = pickup['address'] ?? {};
    final dropoff = json['dropoff'] ?? {};
    final dropoffAddress = dropoff['address'] ?? {};

    return PickupDropoffModel(
      pickupId: pickup['id'] ?? '',
      pickupTaskId: pickup['task_id'] ?? '',
      pickupAddressId: pickup['address_id'] ?? '',
      pickupLocationType: pickup['location_type'] ?? '',
      pickupOrder: pickup['order'] ?? 0,
      pickupArrivalTime: pickup['arrival_time'],
      pickupAddressLine1: pickupAddress['addressLine1'] ?? '',
      pickupCity: pickupAddress['city'] ?? '',
      pickupState: pickupAddress['state'] ?? '',
      pickupPostalCode: pickupAddress['postalCode'] ?? '',
      pickupCountry: pickupAddress['country'] ?? '',
      pickupLabel: pickupAddress['label'] ?? '',
      pickupLatitude: pickupAddress['latitude'] ?? '',
      pickupLongitude: pickupAddress['longitude'] ?? '',
      pickupIsDefault: pickupAddress['isDefault'] ?? false,
      dropoffId: dropoff['id'] ?? '',
      dropoffTaskId: dropoff['task_id'] ?? '',
      dropoffAddressId: dropoff['address_id'] ?? '',
      dropoffLocationType: dropoff['location_type'] ?? '',
      dropoffOrder: dropoff['order'] ?? 0,
      dropoffArrivalTime: dropoff['arrival_time'],
      dropoffAddressLine1: dropoffAddress['addressLine1'] ?? '',
      dropoffCity: dropoffAddress['city'] ?? '',
      dropoffState: dropoffAddress['state'] ?? '',
      dropoffPostalCode: dropoffAddress['postalCode'] ?? '',
      dropoffCountry: dropoffAddress['country'] ?? '',
      dropoffLabel: dropoffAddress['label'] ?? '',
      dropoffLatitude: dropoffAddress['latitude'] ?? '',
      dropoffLongitude: dropoffAddress['longitude'] ?? '',
      dropoffIsDefault: dropoffAddress['isDefault'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'pickup': {
        'id': pickupId,
        'task_id': pickupTaskId,
        'address_id': pickupAddressId,
        'location_type': pickupLocationType,
        'order': pickupOrder,
        'arrival_time': pickupArrivalTime,
        'address': {
          'addressLine1': pickupAddressLine1,
          'city': pickupCity,
          'state': pickupState,
          'postalCode': pickupPostalCode,
          'country': pickupCountry,
          'label': pickupLabel,
          'latitude': pickupLatitude,
          'longitude': pickupLongitude,
          'isDefault': pickupIsDefault,
        }
      },
      'dropoff': {
        'id': dropoffId,
        'task_id': dropoffTaskId,
        'address_id': dropoffAddressId,
        'location_type': dropoffLocationType,
        'order': dropoffOrder,
        'arrival_time': dropoffArrivalTime,
        'address': {
          'addressLine1': dropoffAddressLine1,
          'city': dropoffCity,
          'state': dropoffState,
          'postalCode': dropoffPostalCode,
          'country': dropoffCountry,
          'label': dropoffLabel,
          'latitude': dropoffLatitude,
          'longitude': dropoffLongitude,
          'isDefault': dropoffIsDefault,
        }
      }
    };
  }
}
