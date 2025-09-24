class PickupDropoffEntity {
  final String pickupId;
  final String pickupTaskId;
  final String pickupAddressId;
  final String pickupLocationType;
  final int pickupOrder;
  final String? pickupArrivalTime;
  final String pickupAddressLine1;
  final String pickupCity;
  final String pickupState;
  final String pickupPostalCode;
  final String pickupCountry;
  final String pickupLabel;
  final String pickupLatitude;
  final String pickupLongitude;
  final bool pickupIsDefault;

  final String dropoffId;
  final String dropoffTaskId;
  final String dropoffAddressId;
  final String dropoffLocationType;
  final int dropoffOrder;
  final String? dropoffArrivalTime;
  final String dropoffAddressLine1;
  final String dropoffCity;
  final String dropoffState;
  final String dropoffPostalCode;
  final String dropoffCountry;
  final String dropoffLabel;
  final String dropoffLatitude;
  final String dropoffLongitude;
  final bool dropoffIsDefault;

  const PickupDropoffEntity({
    required this.pickupId,
    required this.pickupTaskId,
    required this.pickupAddressId,
    required this.pickupLocationType,
    required this.pickupOrder,
    this.pickupArrivalTime,
    required this.pickupAddressLine1,
    required this.pickupCity,
    required this.pickupState,
    required this.pickupPostalCode,
    required this.pickupCountry,
    required this.pickupLabel,
    required this.pickupLatitude,
    required this.pickupLongitude,
    required this.pickupIsDefault,
    required this.dropoffId,
    required this.dropoffTaskId,
    required this.dropoffAddressId,
    required this.dropoffLocationType,
    required this.dropoffOrder,
    this.dropoffArrivalTime,
    required this.dropoffAddressLine1,
    required this.dropoffCity,
    required this.dropoffState,
    required this.dropoffPostalCode,
    required this.dropoffCountry,
    required this.dropoffLabel,
    required this.dropoffLatitude,
    required this.dropoffLongitude,
    required this.dropoffIsDefault,
  });
}
