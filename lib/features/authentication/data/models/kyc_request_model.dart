import 'package:equatable/equatable.dart';
import 'package:pikquick/features/authentication/domain/entities/kyc_request_entity.dart';

// KycRequestEntity
class KycRequestModel extends KycRequestEntity {
  // final String documentTypeId;
  // final String documentNumber;
  // final String documentName;

  // // final String password;
  // final String expiryDate;

  // final String file;
  // final String password;

  KycRequestModel({
    super.documentTypeId,
    super.documentNumber,
    super.documentName,
    super.expiryDate,
    super.file,
  });

  factory KycRequestModel.fromJson(Map<String, dynamic> json) {
    return KycRequestModel(
      documentTypeId: json['document_type_id'],
      documentNumber: json['document_number'],
      documentName: json['document_name'],
      expiryDate: json['expiry_date'],
      file: json['file'],
    );
  }
  KycRequestModel? fromEntity(KycRequestEntity? kycRequestEntity) {
    if (kycRequestEntity == null) return null;

    return KycRequestModel(
      documentTypeId: kycRequestEntity.documentTypeId,
      documentNumber: kycRequestEntity.documentNumber,
      documentName: kycRequestEntity.documentName,
      expiryDate: kycRequestEntity.expiryDate,
      file: kycRequestEntity.file,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'document_type_id':
          documentTypeId ?? "123e4567-e89b-12d3-a456-426614174000",
      'document_number': documentNumber ?? "DL123456789",
      'document_name': documentName ?? "My Driver License",
      'expiry_date': expiryDate ?? "2025-12-31",
      'file': file,
    };
  }
}
