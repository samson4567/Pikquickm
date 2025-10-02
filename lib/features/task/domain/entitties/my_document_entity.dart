import 'package:equatable/equatable.dart';

class MyDocumentEntity extends Equatable {
  final String id;
  final String runnerId;
  final String documentTypeId;
  final String isRequired;
  final String documentNumber;
  final String documentName;
  final String verificationStatus;

  final String submittedAt;
  final String createdAt;
  final String updatedAt;

  const MyDocumentEntity({
    required this.id,
    required this.runnerId,
    required this.documentTypeId,
    required this.isRequired,
    required this.documentNumber,
    required this.documentName,
    required this.verificationStatus,
    required this.submittedAt,
    required this.createdAt,
    required this.updatedAt,
  });

  @override
  List<Object?> get props => [
        id,
        runnerId,
        documentTypeId,
        isRequired,
        documentNumber,
        documentName,
        verificationStatus,
        submittedAt,
        createdAt,
        updatedAt,
      ];
}
