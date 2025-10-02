import 'package:equatable/equatable.dart';
import 'package:pikquick/features/task/domain/entitties/my_document_entity.dart';

// MyDocumentEntity
class MyDocumentModel extends MyDocumentEntity {
  // final String id;
  // final String runnerId;
  // final String documentTypeId;
  // final String isRequired;
  // final String documentNumber;
  // final String documentName;
  // final String verificationStatus;

  // final String submittedAt;
  // final String createdAt;
  // final String updatedAt;

  const MyDocumentModel({
    required super.id,
    required super.runnerId,
    required super.documentTypeId,
    required super.isRequired,
    required super.documentNumber,
    required super.documentName,
    required super.verificationStatus,
    required super.submittedAt,
    required super.createdAt,
    required super.updatedAt,
  });

  factory MyDocumentModel.fromJson(Map<String, dynamic> json) {
    return MyDocumentModel(
      id: json['id'],
      runnerId: json['runner_id'],
      documentTypeId: json['document_type_id'],
      isRequired: "",
      documentNumber: json['document_number'],
      documentName: json['document_name'],
      verificationStatus: json['verification_status'],
      submittedAt: json['submitted_at'],
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
    );
    // (
    //   runnerName: json['runner_name'] as String?,
    //   id: json['id'] as String?,
    //   description: json['description'] as String?,
    //   budget: json['budget'] as String?,
    //   taskType: json['task_type'] as String?,
    //   status: json['status'] as String?,
    //   clientId: json['client_id'] as String?,
    //   runnerId: json['runner_id'] as String?,
    //   specialInstructions: json['special_instructions'] as String?,
    //   additionalNotes: json['additional_notes'] as String?,
    //   biddingEnabled: json['bidding_enabled'] as bool?,
    //   createdAt: json['created_at'] != null
    //       ? DateTime.tryParse(json['created_at'])
    //       : null,
    //   updatedAt: json['updated_at'] != null
    //       ? DateTime.tryParse(json['updated_at'])
    //       : null,
    //   paymentMethod: json['payment_method'] as String?,
    //   isBiddingActive: json['isBiddingActive'] as bool?,
    //   canAcceptBid: json['canAcceptBid'] as bool?,
    // );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'runner_id': runnerId,
      'document_type_id': documentTypeId,
      'is_required': isRequired,
      'document_number': documentNumber,
      'document_name': documentName,
      'verification_status': verificationStatus,
      'submitted_at': submittedAt,
      'created_at': createdAt,
      'updated_at': updatedAt,
    };
  }
}
