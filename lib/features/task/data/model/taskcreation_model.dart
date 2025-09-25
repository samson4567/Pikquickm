import 'package:pikquick/features/task/domain/entitties/taskcreation_entity.dart';

class TaskModel extends TaskEntity {
  TaskModel({
    super.runnerId,
    super.clientId,
    super.taskType,
    super.pickupAddress,
    super.dropoffAddress,
    super.description,
    super.budget,
    super.paymentMethod,
    super.specialInstructions,
    super.additionalNotes,
    super.categoryId,
    super.name,
    super.id,
  });

  factory TaskModel.fromJson(Map<String, dynamic> json) {
    return TaskModel(
      runnerId: json['runner_id'] ?? "",
      clientId: json['client_id'] ?? "",
      taskType: json['task_type'] ?? "",
      pickupAddress: (json['pickup_address'] == null)
          ? null
          : AddressModel.fromJson(json['pickup_address'] ?? {}),
      dropoffAddress: (json['dropoff_address'] == null)
          ? null
          : AddressModel.fromJson(json['dropoff_address'] ?? {}),
      description: json['description'] ?? "",
      budget: double.tryParse(json['budget'] ?? "") ?? 0,
      paymentMethod: json['payment_method'] ?? "",
      specialInstructions: json['special_instructions'] ?? "",
      additionalNotes: json['additional_notes'] ?? "",
      categoryId: json['category_id'] ?? "",
      // name: json['name'] ?? "",
      id: json['id'] ?? "",
    );
  }
  factory TaskModel.fromTaskEntity(TaskEntity taskEntity) {
    return TaskModel(
      runnerId: taskEntity.runnerId,
      clientId: taskEntity.clientId,
      taskType: taskEntity.taskType,
      pickupAddress: taskEntity.pickupAddress,
      dropoffAddress: taskEntity.dropoffAddress,
      description: taskEntity.description,
      budget: taskEntity.budget,
      paymentMethod: taskEntity.paymentMethod,
      specialInstructions: taskEntity.specialInstructions,
      additionalNotes: taskEntity.additionalNotes,
      categoryId: taskEntity.categoryId,
      name: taskEntity.name,
      id: taskEntity.id,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'runner_id': runnerId,
      'client_id': clientId,
      'task_type': taskType,
      'pickup_address': (pickupAddress as AddressModel).toJson(),
      'dropoff_address': (dropoffAddress as AddressModel?)?.toJson() ??
          {
            "addressLine1": "    ",
            "city": "    ",
            "state": "    ",
            "postalCode": "000000",
            "country": "    ",
            "latitude": 6.5245,
            "longitude": 3.3793,
            "isDefault": false
          },
      'description': description ?? "",
      'budget': budget,
      'payment_method': paymentMethod,
      'special_instructions': specialInstructions,
      'additional_notes': additionalNotes,
      'category_id': categoryId,
      // 'name': name,
      // 'id': id,
      "bidding_end_time": DateTime.now()
          .add(
            Duration(
              hours: 48,
            ),
          )
          .toIso8601String()
    };
  }

  factory TaskModel.empty() {
    return TaskModel.fromJson({});
  }
  @override
  toString() {
    // return super.toString() + "with";
    return ">>${toJson()}";
  }
}

class AddressModel extends AddressEntity {
  const AddressModel({
    required super.addressLine1,
    super.addressLine2,
    required super.city,
    required super.state,
    required super.postalCode,
    required super.country,
    super.countryCode,
    required super.latitude,
    required super.longitude,
    required super.isDefault,
    this.description = '',
    super.label,
  });

  final String description;

  factory AddressModel.fromJson(Map<String, dynamic> json) {
    return AddressModel(
      addressLine1: json['addressLine1'] ?? "",
      addressLine2: json['addressLine2'] ?? "",
      city: json['city'] ?? "",
      state: json['state'] ?? "",
      postalCode: json['postalCode'] ?? "000000",
      country: json['country'] ?? "",
      countryCode: null,
      //  json['countryCode'] ?? "",
      latitude: json['latitude'] ?? 0,
      longitude: json['longitude'] ?? 0,
      isDefault: json['isDefault'] ?? false,
      label: json['label'] ?? "",
      // description: json['description'] ?? "",
    );
  }
  static AddressModel? fromEntity(AddressEntity? addressEntity) {
    if (addressEntity == null) {
      return null;
    }
    // addressEntity!;
    return AddressModel(
      addressLine1: addressEntity.addressLine1 ?? "",
      addressLine2: addressEntity.addressLine2 ?? "",
      city: addressEntity.city ?? "",
      state: addressEntity.state ?? "",
      postalCode: addressEntity.postalCode ?? "000000",
      country: addressEntity.country ?? "",
      countryCode: null,
      //  json['countryCode'] ?? "",
      latitude: addressEntity.latitude ?? 0,
      longitude: addressEntity.longitude ?? 0,
      isDefault: addressEntity.isDefault ?? false,
      label: addressEntity.label ?? "",
      // description: json['description'] ?? "",
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'addressLine1': addressLine1,
      'addressLine2': addressLine2,
      'city': city,
      'state': state,
      'postalCode':
          (postalCode?.isEmpty ?? true) ? "000000" : postalCode.toString(),
      'country': country,
      'countryCode': countryCode,
      'latitude': latitude,
      'longitude': longitude,
      'isDefault': isDefault,
      // 'description': label,
    };
  }

  String get fullAddress => ' ${addressLine1}, ${city}, ${country}';
  @override
  toString() {
    // return super.toString() + "with";
    return "${toJson()}";
  }
}
